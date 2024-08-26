
local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.Data = {}


function GreatVaultList.Data:init()
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

function GreatVaultList.Data:store(col, write)
	local store = _.get(GreatVaultList.Table.cols, {col, "config", "store"}, function(e) return e end)
	self.characterInfo = store(self.characterInfo)
	self.characterInfo.lastUpdate = time()
	if write then self:write() end
end

function GreatVaultList.Data:storeAll()
	if self.disabled then return end
	_.forEach(GreatVaultList.Table.cols, function(entry) 
		local store = _.get(entry, {"config", "store"}, function(e) return e end)
		self.characterInfo = store(self.characterInfo)
	end)

	self:write()
end


