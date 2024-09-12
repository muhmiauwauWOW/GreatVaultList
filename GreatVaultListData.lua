local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.Data = {}

function GreatVaultList.Data:init()
	GreatVaultList.db.global.characters = GreatVaultList.db.global.characters or {}
	self.playerName = UnitName("player")
	self.characterInfo = _.get(GreatVaultList.db.global.characters, { self.playerName }, {})
	self.disabled = UnitLevel("player") < GetMaxLevelForPlayerExpansion()
end

function GreatVaultList.Data:get()
	return self.characterInfo
end

function GreatVaultList.Data:write()
	if self.disabled then return end
	self.characterInfo.lastUpdate = time()
	GreatVaultList.db.global.characters[self.playerName] = self.characterInfo
end

function GreatVaultList.Data:store(config, write)
	if self.disabled then return end
	local store = _.get(config, { "store" }, function(e) return e end)
	self.characterInfo = store(self.characterInfo)
	self.characterInfo.lastUpdate = time()
	if write then self:write() end
end

function GreatVaultList.Data:storeAll()
	if self.disabled then return end
	_.forEach(GreatVaultList.ModuleColumns, function(entry, key)
		self:store(entry.config, false)
	end)

	self:write()
end
