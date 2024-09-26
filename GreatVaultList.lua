local addonName = ...
GreatVaultList = LibStub("AceAddon-3.0"):NewAddon("GreatVaultList", "AceEvent-3.0", "AceBucket-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GreatVaultList")
local _ = LibStub("LibLodash-1"):Get()
local BlizzMoveAPI = _G.BlizzMoveAPI

function GreatVaultList:GetLibs()
	return L, _
end

GVL_OPEN_VAULT = L["OpenVault"]


local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
_G["BINDING_HEADER_GreatVaultList"] = AddOnInfo[2]
_G["BINDING_NAME_GreatVaultList_toggle_window"] = L["Bindings_toggle_window"]




function GreatVaultList_OnAddonCompartmentClick(addonName, buttonName)
	if buttonName == "RightButton" then
		Settings.OpenToCategory(GreatVaultList.OptionsID)
	else
		GreatVaultList:toggleWindow()
	end
end


local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
-- add data broker support 
local ldb =  LibStub("LibDataBroker-1.1"):NewDataObject(AddOnInfo[2], {
	type = "data source",
	icon = C_AddOns.GetAddOnMetadata(addonName, "IconTexture"),
	OnClick = GreatVaultList_OnAddonCompartmentClick,
})
GreatVaultList.minimapIcon = LibStub("LibDBIcon-1.0")


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
	GreatVaultList.Data:init()
	GreatVaultList:slashcommand()
	GreatVaultList.minimapIcon:Register(addonName, ldb, self.db.global.Options.minimap)

	if BlizzMoveAPI then 
		GreatVaultListFrame.Drag:Hide()
		BlizzMoveAPI:RegisterAddOnFrames({
			["GreatVaultList"] = { 
				["GreatVaultListFrame"] = {}
			},
		});
	else
		GreatVaultListFrame:SetScale(self.db.global.Options.scale)
	end
end

function GreatVaultList:OnEnable()
	GreatVaultListOptions:init()
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
		GreatVaultList:toggleWindow()
	end
end

GreatVaultList.ModuleColumns = {}

GREATVAULTLIST_COLUMNS = {
	OnEnable = function(self)
		if not WeeklyRewardsFrame then
			WeeklyRewards_LoadUI();
		end
		-- init is not found
		if not GreatVaultList.db.global.Options.modules[self.key] then
			GreatVaultList.db.global.Options.modules[self.key] = { active = true, index = self.config.index }
		end

		-- return if already active
		if not GreatVaultList.db.global.Options.modules[self.key].active then return end

		-- register col
		table.insert(GreatVaultList.ModuleColumns, {
			key = self.key,
			DBkey = self.DBkey or self.key,
			index = _.get(GreatVaultList.db.global.Options.modules, { self.key, "index" }, self.config.index),
			config = self.config
		})

		-- store data 
		if self.config.store then
			C_Timer.After(3, function()
				GreatVaultList.Data:store(self.config, true)
			end)
		end

		-- register events
		if self.config.event then
			GreatVaultList:RegisterBucketEvent(self.config.event[1], 0.5, function(event)
				self.config.event[2](self, event)
			end)
		end
	end,
	OnDisable = function(self)
		local fidx = _.findIndex(GreatVaultList.ModuleColumns, function(entry) return entry.key == self.key end)
		if fidx > 0 then
			table.remove(GreatVaultList.ModuleColumns, fidx)
		end
	end
}


function GreatVaultList:updateData(refresh)
	GreatVaultList:assert(_.size(GreatVaultList.ModuleColumns) > 0, "GreatVaultListListMixin:init",
		'no "ModuleColumns" found, try to enable modules in the options')
	if _.size(GreatVaultList.db.global.characters) == 0 then return end -- fail silent

	_.map(GreatVaultList.ModuleColumns, function(entry, key)
		-- fallback for no modules options, should never happen...
		GreatVaultList.db.global.Options.modules[entry.key] = GreatVaultList.db.global.Options.modules[entry.key] or
		{ active = true, index = entry.config.index }
		entry.index = GreatVaultList.db.global.Options.modules[entry.key].index
	end)

	sort(GreatVaultList.ModuleColumns, function(a, b) return a.index < b.index end)

	local colConfig = {}
	local cols = _.map(GreatVaultList.ModuleColumns, function(entry)
		colConfig[entry.key] = entry.config
		return entry.key
	end)

	local data = {}
	_.forEach(GreatVaultList.db.global.characters, function(entry, key)
		local d = _.map(GreatVaultList.ModuleColumns, function(cEntry)
			return entry[_.get(cEntry, { "DBkey" })]
		end)
		d.name = key
		d.enabled = entry.enabled == nil and true or entry.enabled
		d.data = entry
		d.selected = key == UnitName("player")
		table.insert(data, d)
	end)


	-- DevTool:AddData(data, "data")
	-- DevTool:AddData(cols, "cols")
	-- DevTool:AddData(colConfig, "colConfig")

	GreatVaultListFrame.ListFrame:init(cols, data, colConfig, refresh)
end

function GreatVaultList:demoMode()
	_.map(GreatVaultList.ModuleColumns, function(entry, key)
		entry.index = GreatVaultList.db.global.Options.modules[entry.key].index
	end)

	sort(GreatVaultList.ModuleColumns, function(a, b) return a.index < b.index end)

	local colConfig = {}
	local cols = _.map(GreatVaultList.ModuleColumns, function(entry)
		colConfig[entry.key] = entry.config
		return entry.key
	end)


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
