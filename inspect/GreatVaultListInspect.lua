local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()
GreatVaultList.Inspect = LibStub("AceAddon-3.0"):NewAddon("GreatVaultListInspect", "AceComm-3.0");
local wState = LibStub("wState-1")

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

DevTool = DevTool or { AddData = function() end }


GreatVaultList.Inspect.timeout = {
	sender =  nil,
	receiver = nil
}

GreatVaultList.Inspect.CommAction = {
	request = "REQUEST",
	acceptRequest = "ACCEPT-REQUEST",
	declineRequest = "DECLINE-REQUEST",
	established = "ESTABLISHED",
	response = "RESPONSE",
	sendData = "SEND-DATA"
}


GreatVaultList.Inspect.States = {
	idle = "Idle",
	requestReceived = "RequestReceived",
	requestSent = "RequestSent",
	established = "Established",
	transmitSend = "TransmitSend",
	transmitReceived = "TransmitReceived",
	transmitDone = "TransmitDone",

}

function GreatVaultList.Inspect:InitComm()

	self:RegisterComm(GreatVaultList.AddOnInfo[1])
	self:AddContextMenusEntries()


	local wStateSenderConfig = {
		id = "InspectSender",
		initial = self.States.idle,
		events = {
			SendRequest = {
				from = self.States.idle,
				to = self.States.requestSent
			},
			AcceptedRequest = {
				from = self.States.requestSent,
				to = self.States.established
			},
			DeclinedRequest = {
				from = self.States.requestSent,
				to = self.States.idle
			},
			Timeout = {
				from = self.States.established,
				to = self.States.idle
			},
			ReceiveData = {
				from = self.States.established,
				to = self.States.transmitReceived
			},
			Done = {
				from = self.States.transmitReceived,
				to = self.States.transmitDone
			},
			ToIdle = {
				from = self.States.transmitDone,
				to = self.States.idle
			}
		}
	}

	local wStateReceiverConfig = {
		id = "InspectReceiver",
		initial = self.States.idle,
		events = {
			GetRequest = {
				from = self.States.idle,
				to = self.States.requestReceived
			},
			AcceptRequest =	{
				from = self.States.requestReceived,
				to = self.States.established
			},
			DeclineRequest = {
				from = self.States.requestReceived,
				to = self.States.idle
			},
			Timeout = {
				from = self.States.established,
				to = self.States.idle
			},
			SendData = {
				from = self.States.established,
				to = self.States.transmitSend
			},
			Done = {
				from = self.States.transmitSend,
				to = self.States.transmitDone
			},
			ToIdle = {
				from = self.States.transmitDone,
				to = self.States.idle
			}
		}
	}
	
	
	self.wStateSender = wState.create(self, wStateSenderConfig)
	self.wStateReceiver = wState.create(self, wStateReceiverConfig)

	-- self.wStateSender:SendRequest("Muhmiauwaudh")

end



function GreatVaultList.Inspect:OnStateChange(id, event, ...)
	DevTool:AddData({...}, id .. " OnStateChange " .. event)
	--print(event, "SENDER:", self.wStateSender.current,"RECEIVER:",  self.wStateReceiver.current)
end



function GreatVaultList.Inspect:OnSendRequest(id, event, from, to, recipient)
	-- print("ON SendRequest", recipient)
	self:SendComm(recipient, self.CommAction.request)
	-- TODO: UI state change open window and show loading screen
end


function GreatVaultList.Inspect:OnGetRequest(id, event, from, to, sender)
	-- print("ON GetRequest", sender)
	-- TODO: implement guard here

	local allow = true

	if allow then 
		self.wStateReceiver:AcceptRequest(sender)
	else 
		self.wStateReceiver:DeclinedRequest(sender)
	end
end

function GreatVaultList.Inspect:OnAcceptRequest(id, event, from, to, sender)
	-- print("ON AcceptRequest", sender)
	self:SendComm(sender,  self.CommAction.acceptRequest)
end

function GreatVaultList.Inspect:OnDeclineRequest(id, event, from, to, sender)
	-- print("ON DeclineRequest", sender)
	self:SendComm(sender,  self.CommAction.declineRequest)
end


function GreatVaultList.Inspect:OnAcceptedRequest(id, event, from, to, recipient)
	-- print("ON AcceptedRequest", recipient)
	self:SendComm(recipient, self.CommAction.established)
	-- TODO: UI state change
end

function GreatVaultList.Inspect:OnDeclinedRequest(id, event, from, to, recipient)
	-- print("ON DeclinedRequest", recipient)
	-- TODO: cleanUp UI
end



function GreatVaultList.Inspect:OnEnterStateEstablished(id, event, from, to)
	-- print("On State Established", id)

	if id == self.wStateSender.id then 
		self.timeout.sender = C_Timer.NewTimer(60, function()
			self.wStateSender:Timeout()
		end)
	elseif id == self.wStateReceiver.id then
		self.timeout.receiver = C_Timer.NewTimer(60, function()
			self.wStateReceiver:Timeout()
		end)
	end	
end

function GreatVaultList.Inspect:OnTimeout(id, event, from, to, recipient)
	-- print("ON Timeout")
	self.timeout.sender:Cancel()
	self.timeout.receiver:Cancel()

	-- TODO: cleanUp UI
end


function GreatVaultList.Inspect:OnSendData(id, event, from, to, recipient)
	-- print("ON SendData", recipient)
	--GreatVaultList.db.global.characters

	self:SendComm(recipient, self.CommAction.sendData, GreatVaultList.db.global.characters, function()
		self.wStateReceiver:Done()
	end)

	-- TODO: cleanUp UI
end

function GreatVaultList.Inspect:OnReceiveData(id, event, from, to, sender, data)
	-- print("ON ReceiveData", sender, data)

	self:updateInspectData(sender, data)
	self.InspectFrame:Show()
	self.wStateSender:Done()
	print("GreatVaultList: inspect data recieved from", sender)
end



function GreatVaultList.Inspect:OnDone(id, event, from, to, recipient)
	-- print("ON Done")
	-- TODO: Do Stuff here

	self.wStateReceiver:ToIdle()
	self.wStateSender:ToIdle()
end






function GreatVaultList.Inspect:AddContextMenusEntries()
	local menuFN = function(owner, rootDescription, contextData)
		rootDescription:CreateDivider();
		rootDescription:CreateTitle(GreatVaultList.AddOnInfo[2]);
		rootDescription:CreateButton("View Progress", function()
			self.wStateSender:SendRequest(contextData.name)
		end);
	end

	Menu.ModifyMenu("MENU_UNIT_SELF", menuFN)
	Menu.ModifyMenu("MENU_UNIT_PLAYER", menuFN)
	Menu.ModifyMenu("MENU_UNIT_PARTY", menuFN)
end


function GreatVaultList.Inspect:SendComm(recipient, action, payload, cb)
	if not action then return end

	local serialized = LibSerialize:Serialize({action, payload})
    local compressed = LibDeflate:CompressDeflate(serialized)
    local dataStr = LibDeflate:EncodeForWoWAddonChannel(compressed)


	if type(dataStr) ~= "string" then return end

	local cbFn = function() end

	if action == self.CommAction.sendData then 
		cbFn = function(e, cur, all)
			DevTool:AddData(cur .. "/" .. all, "Transmit progress")
			if cur == all then
				cb()
			end
		end
	end

	self:SendCommMessage(GreatVaultList.AddOnInfo[1], dataStr, "WHISPER", recipient, "NORMAL", cbFn)
end

function GreatVaultList.Inspect:OnCommReceived(commName, data, channel, sender)
	if not data then return end
	local decoded = LibDeflate:DecodeForWoWAddonChannel(data)
    if not decoded then return end
    local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then return end
    local success, data = LibSerialize:Deserialize(decompressed)
	if not success then	return 	end
	local action, payload = table.unpack(data)


	DevTool:AddData(action,"OnCommReceived")


	if action == self.CommAction.request then
		self.wStateReceiver:GetRequest(sender)
	elseif action == self.CommAction.acceptRequest then
		self.wStateSender:AcceptedRequest(sender)
	elseif action == self.CommAction.declineRequest then
		self.wStateSender:DeclinedRequest(sender)
	elseif action == self.CommAction.established then
		if self.wStateReceiver.current == self.States.established then 
			self.wStateReceiver:SendData(sender)
		end
	elseif action == self.CommAction.sendData then
		self.wStateSender:ReceiveData(sender, payload)
	end
end

function GreatVaultList.Inspect:updateInspectData(name, payload)
	self.InspectFrame = self.InspectFrame or _G["GreatVaultListInspectFrame"] 

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


	-- DevTool:AddData(data, "updateInspectData data")
	-- DevTool:AddData(cols, "cols")
	-- DevTool:AddData(colConfig, "colConfig")

	GreatVaultListInspectFrame.InspectText:SetText(name)
	GreatVaultListInspectFrame.ListFrame:init(cols, data, colConfig, true)
end
