local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.Data = {}

function GreatVaultList.Data:init()
	GreatVaultList.db.global.characters = GreatVaultList.db.global.characters or {}
	self.characterInfo = Mixin({}, self:get())
	self.disabled = UnitLevel("player") < GetMaxLevelForPlayerExpansion()
	
	self.skipStore = C_WeeklyRewards.CanClaimRewards()

	-- will not work if user is logged in when C_WeeklyRewards.CanClaimRewards() changes. But who cares? right?
	if not self.skipStore then return end
	GreatVaultList:RegisterEvent("WEEKLY_REWARDS_UPDATE", function()
		if C_WeeklyRewards.CanClaimRewards() then return end
		self.skipStore = false
		self:storeAll()
	end)
end


function GreatVaultList.Data:get()
	local playerGUID  = UnitGUID("player")
	local info = GreatVaultList.db.global.characters[playerGUID]

	-- check for old method
	if not info then 
		local playerName = UnitName("player")
		info = GreatVaultList.db.global.characters[playerName]
		if info then 
			GreatVaultList.db.global.characters[playerName] = nil
		end
	end

	-- new character
	if not info then 
		info = {}
	end
	
	return info
end

function GreatVaultList.Data:write()
	if self.disabled then return end
	self.characterInfo.lastUpdate = time()

	local playerGUID = UnitGUID("player")
	if not playerGUID then return end
	GreatVaultList.db.global.characters[playerGUID] = self.characterInfo
end

function GreatVaultList.Data:store(config, write)
	if self.disabled then return end
	if self.skipStore then return end
	local store = _.get(config, { "store" }, function(e) return e end)
	self.characterInfo = store(self.characterInfo)
	self.characterInfo.lastUpdate = time()
	if write then self:write() end
end

function GreatVaultList.Data:storeAll()
	if self.disabled then return end
	if self.skipStore then return end
	_.forEach(GreatVaultList.ModuleColumns, function(entry, key)
		self:store(entry.config, false)
	end)

	self:write()
end
