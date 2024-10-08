local addonName = ...
local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
GreatVaultList = LibStub("AceAddon-3.0"):NewAddon("GreatVaultList", "AceEvent-3.0", "AceBucket-3.0", "AceComm-3.0", "AceSerializer-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GreatVaultList")
local _ = LibStub("LibLodash-1"):Get()
local BlizzMoveAPI = _G.BlizzMoveAPI

function GreatVaultList:GetLibs()
	return L, _
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

	self:slashcommand()
	
	self:DataBrokerInit()
	self:BlizzMove()
	self:ElvUISkin()

	self:InitComm()
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

		GreatVaultList.RegisterdModules[self.key] = {
			active = true,
			index = self.config.defaultIndex,
            id = self.key,
            name = self.config.header.text or ""
		}

		GreatVaultList.db.global.Options.modules[self.key] = GreatVaultList.db.global.Options.modules[self.key] or { 
			active = true,
			index = self.config.defaultIndex,
			id = self.key
		}

		if GreatVaultList.DataCheck then GreatVaultList.DataCheck:Cancel() end

		GreatVaultList.DataCheck = C_Timer.NewTimer(3, function()
			GreatVaultList.DataCheck:Cancel()
			GreatVaultListOptions:init()
			
	
		end)
	end,
	OnEnable = function(self)
		if not GreatVaultList.db.global.Options.modules[self.key].active then return end

		-- register col
		table.insert(GreatVaultList.ModuleColumns, {
			key = self.key,
			DBkey = self.DBkey or self.key,
			index = _.get(GreatVaultList.db.global.Options.modules, { self.key, "index" }, self.config.index),
			defaultIndex = _.get(GreatVaultList.db.global.Options.modules, { self.key, "index" }, self.config.index),
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
			self.config.eventHandle = GreatVaultList:RegisterBucketEvent(self.config.event[1], 0.5, function(event)
				self.config.event[2](self, event)
			end)
		end
	end,
	OnDisable = function(self)
		if GreatVaultList.db.global.Options.modules[self.key].active then return end

		local fidx = _.findIndex(GreatVaultList.ModuleColumns, function(entry) return entry.key == self.key end)
		if fidx > 0 then
			table.remove(GreatVaultList.ModuleColumns, fidx)
		end

		if self.config.eventHandle then
			GreatVaultList:UnregisterBucket(self.config.eventHandle)
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





GreatVaultList.CommAction = {
	request = "request",
	response = "response"
}

function GreatVaultList:InitComm()
	print("initcom")

	-- Menu.ModifyMenu("MENU_UNIT_PLAYER", function(owner, rootDescription, contextData)
	-- 	rootDescription:CreateDivider();
	-- 	rootDescription:CreateTitle("My Addon");
	-- 	rootDescription:CreateButton("Button", function() print("Text here!") end);
	-- end);

	local menuFN = function(owner, rootDescription, contextData)
		rootDescription:CreateDivider();
		rootDescription:CreateTitle(AddOnInfo[2]);
		rootDescription:CreateButton("View Progress", function() 
			-- print("Text here!", contextData.name) 
			local obj = {
				action = GreatVaultList.CommAction.request
			}

			-- self:SendCommMessage(AddOnInfo[1], self:Serialize(obj), "WHISPER", UnitName("player"))
			self:SendComm(contextData.name,  GreatVaultList.CommAction.request)
		end);
	end

	Menu.ModifyMenu("MENU_UNIT_SELF", menuFN)
	Menu.ModifyMenu("MENU_UNIT_PLAYER", menuFN)




	self:RegisterComm(AddOnInfo[1])






	-- self:SendCommMessage(AddOnInfo[1], self:Serialize("test"), "WHISPER", UnitName("player"))
	-- self:SendComm(UnitName("player"), "test")


end

function GreatVaultList:SendComm(recipient, action, payload)
	if not action then return end
	local dataStr = self:Serialize(action, payload)
	if type(dataStr) ~= "string" then return end

	self:SendCommMessage(AddOnInfo[1], dataStr, "WHISPER", recipient)
end


function GreatVaultList:OnCommReceived(commName, data, channel, sender)
	if not data then return end
	local status, action, payload = self:Deserialize(data)
	if not status then return end
	print("####",status, action, payload )
	DevTool:AddData({ action, payload }, "OnCommReceived - payload-")

	if action == GreatVaultList.CommAction.request then
		DevTool:AddData(payload, "OnCommReceived")
		print("GreatVaultList:OnCommReceived", GreatVaultList.CommAction.request)

		self:SendComm(sender, GreatVaultList.CommAction.response, GreatVaultList:BuldCommData())
	elseif action == GreatVaultList.CommAction.response then 
		-- local obj = (data)
		DevTool:AddData(payload, "OnCommReceived response")
		print("GreatVaultList:OnCommReceived response", GreatVaultList.CommAction.response)


		GreatVaultListFrame.Inspect:BuildData(payload)
		GreatVaultList:toggleWindow()


	end




	DevTool:AddData(payload, "OnCommReceived --")
	print("GreatVaultList:OnCommReceived no if")

end



function  GreatVaultList:BuldCommData()

	DevTool:AddData(GreatVaultList.ModuleColumns, "ModuleColumns")

		local ModulesColumns = _.sortBy(CopyTable(GreatVaultList.ModuleColumns), function(a) return a.index end)
		sort(ModulesColumns, function(a, b) return a.index < b.index end)


		
		local charData = {}

		_.forEach(GreatVaultList.db.global.characters, function(entry, char)
			local d = {}
			_.forEach(ModulesColumns, function(module)
				if not entry[module.DBkey] then return end




				if module.config.template == "GreatVaultListTableCellTripleTextTemplate" then 
					-- print("table ", module.DBkey)
					local t = ""
					_.forEach(entry[module.DBkey], function(data, idx)
						local populate = _.get(module, {"config", "populate" }, function(self, e) return e end)

						local text = populate(module, entry[module.DBkey], idx)
						-- print("table ", text)
						if not text then 
							local emptyStr = _.get(module, {"config", "emptyStr", idx}, _.get(module, {"config", "emptyStr"}, "-"))
							text = GRAY_FONT_COLOR:WrapTextInColorCode(emptyStr)
						else
							print("table ", text)
						end
	
						t  = t .. "  " .. text
					end)

					-- print("table ", t)

					table.insert(d, t)

				else
					-- print("not table ", module.DBkey)
					local populate = _.get(module, {"config", "populate" }, function(self, e) return e end)

					local  text = populate(module , entry[module.DBkey])
					if not text then 
						local emptyStr = _.get(module, {"config", "emptyStr", 1}, _.get(module, {"config", "emptyStr"}, "-"))
						text = GRAY_FONT_COLOR:WrapTextInColorCode(emptyStr)
					end

					table.insert(d, text)
				end

				
				-- DevTool:AddData(entry[module.DBkey], module.key)

				-- local populate = _.get(module, {"config", "populate" }, function(self, e) return e end)

				-- local  text = populate(module , entry[module.DBkey])
				-- if not text then 
				-- 	local emptyStr = _.get(module, {"config", "emptyStr", 1}, _.get(module, {"config", "emptyStr"}, "-"))
				-- 	text = GRAY_FONT_COLOR:WrapTextInColorCode(emptyStr)
				-- end
				-- d[module.key] = getText(module)
			end)

			table.insert(charData, d)
		end)

		DevTool:AddData(charData)
		return charData

end