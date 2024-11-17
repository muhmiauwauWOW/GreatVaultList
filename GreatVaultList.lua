local addonName = ...
local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
-- GreatVaultList = LibStub("AceAddon-3.0"):NewAddon("GreatVaultList", "AceEvent-3.0", "AceBucket-3.0", "AceComm-3.0", "AceSerializer-3.0");
GreatVaultList = LibStub("AceAddon-3.0"):NewAddon("GreatVaultList", "AceEvent-3.0", "AceBucket-3.0");
GreatVaultList.AddOnInfo = AddOnInfo

local L = LibStub("AceLocale-3.0"):GetLocale("GreatVaultList")
local _ = LibStub("LibLodash-1"):Get()
local BlizzMoveAPI = _G.BlizzMoveAPI

DevTool = DevTool or { AddData = function(str, name) end }

function GreatVaultList:GetLibs()
	return L, _, DevTool
end

GVL_OPEN_VAULT = L["OpenVault"]


_G["BINDING_HEADER_GreatVaultList"] = AddOnInfo[2]
_G["BINDING_NAME_GreatVaultList_toggle_window"] = L["Bindings_toggle_window"]





GreatVaultList.config = {
	defaultCellPadding = 6
}



local default_global_data = {
	global = {
		sort = -1,
		sortReverse = false,
		characters = {},
		Options = {
			modules = {},
			position = {},
			scale = 1,
			lines = 12,
			minimap = {
				hide = false,
			},
			columns = {},
			tabs = {
				['*'] = {
					active = true,
					index = nil
				}
			},
			inspect = {
				permissions = {
					BattleNetFriend = true,
					Friend = true,
					Guild = true,
					Group = false,
					Raid = false
				}
			},
			ElvUiSkin = true
		},
	}
}



GreatVaultList.utility = {}
function GreatVaultList.utility:formatActivityProgress(activity)
	return GRAY_FONT_COLOR:WrapTextInColorCode(string.format("%s/%s", activity.progress, activity.threshold))
end



function GreatVaultList:assert(check, fn, text, ...)
	text = ... and string.format(text, ...) or text
	assert(check,
		string.format("%s:%s   %s", WHITE_FONT_COLOR:WrapTextInColorCode("GreatVaultList"),
			GREEN_FONT_COLOR:WrapTextInColorCode("(" .. fn .. ")"), string.format(text, ...)))
	if not check then return end
end






function GreatVaultList:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("GreatVaultList2DB", default_global_data, true)
	self.Data:init()

	self.Inspect:init()

	self:slashcommand()
	
	self:DataBrokerInit()
	self:BlizzMove()
	self.ElvUi:Init()
end

function GreatVaultList:hideWindow()
	GreatVaultListFrame:Hide()
end

function GreatVaultList:showWindow()
	if not WeeklyRewardsFrame then
		WeeklyRewards_LoadUI();
	end

	GreatVaultList.Data:storeAll()
	GreatVaultList:updateData()
	-- GreatVaultList:demoMode()
	GreatVaultListFrame:Show()
end

function GreatVaultList:toggleWindow()
	if GreatVaultListFrame:IsShown() then
		self:hideWindow()
	else
		self:showWindow()
	end
end


function GreatVaultList:slashcommand()
	SLASH_GV1 = "/gv"
	SLASH_GV2 = "/greatvault"
	SlashCmdList["GV"] = function(msg)
		if msg == "reset" then 
			self.db:ResetDB("global")
			C_UI.Reload()
		else
			GreatVaultList:toggleWindow()
		end
	end
end

GreatVaultList.RegisterdModules = {}
GreatVaultList.ModuleColumns = {}

GreatVaultList.DataCheck = nil

GREATVAULTLIST_COLUMNS = {
	OnInitialize = function(self)
		if not WeeklyRewardsFrame then
			WeeklyRewards_LoadUI();
		end


		local defaultState = (self.config.defaultState == nil) and true or self.config.defaultState

		GreatVaultList.RegisterdModules[self.key] = {
			active = defaultState,
			index = self.config.defaultIndex,
            id = self.key,
            name = self.config.header.text or "",
			module = self
		}

		GreatVaultList.db.global.Options.modules[self.key] = GreatVaultList.db.global.Options.modules[self.key] or { 
			active = defaultState,
			index = self.config.defaultIndex,
			id = self.key
		}

		if GreatVaultList.DataCheck then GreatVaultList.DataCheck:Cancel() end

		GreatVaultList.DataCheck = C_Timer.NewTimer(3, function()
			GreatVaultList.DataCheck:Cancel()
			GreatVaultListOptions:init()
			GreatVaultList.Data:storeAll()
		end)
	end,
	OnEnable = function(self)
		if not GreatVaultList.db.global.Options.modules[self.key].active then self:Disable(); return; end

		-- register col
		table.insert(GreatVaultList.ModuleColumns, {
			key = self.key,
			DBkey = self.DBkey or self.key,
			index = _.get(GreatVaultList.db.global.Options.modules, { self.key, "index" }, self.config.index),
			defaultIndex = _.get(GreatVaultList.db.global.Options.modules, { self.key, "index" }, self.config.index),
			config = self.config
		})

		-- register events
		if self.config.event then
			self.config.eventHandle = GreatVaultList:RegisterBucketEvent(self.config.event[1], 0.5, function(event)
				self.config.event[2](self, event)
			end)
		end
	end,
	OnDisable = function(self)
		if GreatVaultList.db.global.Options.modules[self.key].active then self:Enable(); return; end

		local fidx = _.findIndex(GreatVaultList.ModuleColumns, function(entry) return entry.key == self.key end)
		if fidx > 0 then
			table.remove(GreatVaultList.ModuleColumns, fidx)
		end

		if self.config.eventHandle then
			GreatVaultList:UnregisterBucket(self.config.eventHandle)
		end
	end
}









function GreatVaultList:updateModuleConfig()
	GreatVaultList:assert(_.size(GreatVaultList.ModuleColumns) > 0, "GreatVaultListListMixin:init",
		'no "ModuleColumns" found, try to enable modules in the options')
	_.map(GreatVaultList.ModuleColumns, function(entry, key)
		-- fallback for no modules options, should never happen...
		GreatVaultList.db.global.Options.modules[entry.key] = GreatVaultList.db.global.Options.modules[entry.key] or
		{ active = true, index = entry.config.index }
		entry.index = GreatVaultList.db.global.Options.modules[entry.key].index
	end)

	sort(GreatVaultList.ModuleColumns, function(a, b) return a.index < b.index end)

end

function GreatVaultList:getColConfigforTableDisplay()
	local colConfig = {}
	local cols = _.map(GreatVaultList.ModuleColumns, function(entry)
		colConfig[entry.key] = entry.config
		return entry.key
	end)

	return colConfig, cols
end

function GreatVaultList:getCharaterDataforTableDisplay(dataObj, useSelected)
	local data = {}
	_.forEach(dataObj, function(entry, key)
		local d = _.map(GreatVaultList.ModuleColumns, function(cEntry)
			return entry[_.get(cEntry, { "DBkey" })]
		end)

		if entry.enabled == nil then
			entry.enabled = true
		end
		
		d.name = key
		d.enabled = entry.enabled
		d.data = entry
		if useSelected then
			d.selected = (key == UnitName("player")) or (key == UnitGUID("player"))
		end
		
		table.insert(data, d)
	end)

	return data
end

function GreatVaultList:updateData(refresh)
	if _.size(GreatVaultList.db.global.characters) == 0 then return end -- fail silent

	GreatVaultList:updateModuleConfig()

	local colConfig, cols = GreatVaultList:getColConfigforTableDisplay()
	local data = GreatVaultList:getCharaterDataforTableDisplay(GreatVaultList.db.global.characters, true)

	-- DevTool:AddData(data, "data")
	-- DevTool:AddData(cols, "cols")
	-- DevTool:AddData(colConfig, "colConfig")

	GreatVaultListFrame.ListFrame:init(cols, data, colConfig, refresh)
end

function GreatVaultList:demoMode()
	GreatVaultList:updateModuleConfig()
	local colConfig, cols = GreatVaultList:getColConfigforTableDisplay()

	local playerFn = _.get(GreatVaultList.ModuleColumns, {"character", "config", "demo" }, function(e) return e end)
	local demoData = {}
	for i = 1, 10, 1 do
		local d = _.map(GreatVaultList.ModuleColumns, function(cEntry)
			local demoFn = _.get(cEntry, { "config", "demo" }, function(e) return e end)
			return demoFn(i)
		end)

		d.name = playerFn(i)
		d.enabled = true 
		d.selected = false
		table.insert(demoData, d)
	end

	-- DevTool:AddData(demoData, "demoData")
	-- DevTool:AddData(cols, "cols")
	-- DevTool:AddData(colConfig, "colConfig")
	GreatVaultListFrame.ListFrame:init(cols, demoData, colConfig, true)
end







function GreatVaultList:GetVaultState()
	if C_WeeklyRewards.HasAvailableRewards() then
		return "collect";
	end

	local rewardCheck = false
	_.forEach(Enum.WeeklyRewardChestThresholdType, function(type)
		if rewardCheck then return end
		rewardCheck = WeeklyRewardsUtil.HasUnlockedRewards(type)
	end)

	if rewardCheck then
		return "complete";
	end

	return "incomplete";
end