local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")

local L, _ = GreatVaultList:GetLibs()

GreatVaultList.Inspect = LibStub("AceAddon-3.0"):NewAddon("GreatVaultListInspect", "AceComm-3.0", "AceSerializer-3.0");

local wState = LibStub("wState-1")




GreatVaultList.Inspect.CommAction = {
	request = "request",
	response = "response"
}

GreatVaultList.Inspect.States = {
	green = "green",
	yellow = "yellow",
	red = "red"
}
function GreatVaultList.Inspect:InitComm()

	local wStateConfig = {
		initial = 'green',
		events = {
			warn = {
				from = self.States.green,
				to = self.States.yellow
			},
			panic = {
				from = self.States.yellow,
				to = GreatVaultList.Inspect.States.red
			},
			calm = {
				from = self.States.red,
				to =self.States.yellow
			},
			clear = {
				from = self.States.yellow,
				to = self.States.green
			}
		}
	}
	
	
	self.wState = wState.create(self, wStateConfig)
	-- print(self.wState.current)
	-- self.wState:warn("Ddd")
	-- print(self.wState.current)

	local menuFN = function(owner, rootDescription, contextData)
		rootDescription:CreateDivider();
		rootDescription:CreateTitle(GreatVaultList.AddOnInfo[2]);
		rootDescription:CreateButton("View Progress", function()
			self:SendComm(contextData.name, GreatVaultList.Inspect.CommAction.request)
		end);
	end

	Menu.ModifyMenu("MENU_UNIT_SELF", menuFN)
	Menu.ModifyMenu("MENU_UNIT_PLAYER", menuFN)
	Menu.ModifyMenu("MENU_UNIT_PARTY", menuFN)

	self:RegisterComm(GreatVaultList.AddOnInfo[1])
end

function GreatVaultList.Inspect:OnStateYellow(event, from, to, msg)
	print("is yellow", self, event, from, to, msg)
end

function GreatVaultList.Inspect:OnWarn(event, from, to, msg)
	print("is warn", self, event, from, to, msg)
end

function GreatVaultList.Inspect:SendComm(recipient, action, payload)
	if not action then return end
	local dataStr = self:Serialize(action, payload)
	if type(dataStr) ~= "string" then return end

	self:SendCommMessage(GreatVaultList.AddOnInfo[1], dataStr, "WHISPER", recipient)
end

function GreatVaultList.Inspect:OnCommReceived(commName, data, channel, sender)
	if not data then return end
	local status, action, payload = self:Deserialize(data)
	if not status then return end
	-- print("####",status, action, payload )
	DevTool:AddData({ action, payload }, "OnCommReceived - payload-")

	if action == GreatVaultList.Inspect.CommAction.request then
		-- DevTool:AddData(payload, "OnCommReceived")
		-- print("GreatVaultList:OnCommReceived", GreatVaultList.CommAction.request)

		self:SendComm(sender, GreatVaultList.Inspect.CommAction.response, GreatVaultList.db.global.characters)
	elseif action == GreatVaultList.Inspect.CommAction.response then
		-- -- local obj = (data)
		-- DevTool:AddData(payload, "OnCommReceived response")
		-- print("GreatVaultList:OnCommReceived response", GreatVaultList.CommAction.response)

		self:updateInspectData(sender, payload)
		self.InspectFrame:Show()
		print("GreatVaultList: inspect data recieved from", sender)
	end
end

function GreatVaultList.Inspect:updateInspectData(name, payload)
	self.InspectFrame = self.InspectFrame or
		_G
		["GreatVaultListInspectFrame"] --CreateFrame("Frame", "GreatVaultListInspectFrame", UIParent, "GreatVaultListInspectFrameTemplate")


	GreatVaultList:assert(_.size(GreatVaultList.ModuleColumns) > 0, "GreatVaultListListMixin:init",
		'no "ModuleColumns" found, try to enable modules in the options')
	if _.size(payload) == 0 then return end -- fail silent

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
	_.forEach(payload, function(entry, key)
		local d = _.map(GreatVaultList.ModuleColumns, function(cEntry)
			return entry[_.get(cEntry, { "DBkey" })]
		end)
		d.name = key
		d.enabled = entry.enabled == nil and true or entry.enabled
		d.data = entry
		d.selected = key == UnitName("player")
		table.insert(data, d)
	end)


	DevTool:AddData(data, "updateInspectData data")
	-- DevTool:AddData(cols, "cols")
	-- DevTool:AddData(colConfig, "colConfig")

	GreatVaultListInspectFrame.InspectText:SetText(name)
	GreatVaultListInspectFrame.ListFrame:init(cols, data, colConfig, true)
end
