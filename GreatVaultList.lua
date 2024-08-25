---@class GreatVaultList:AceAddon
GreatVaultList = LibStub("AceAddon-3.0"):NewAddon("GreatVaultList", "AceEvent-3.0", "AceBucket-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GreatVaultList")
local _ = LibStub("LibLodash-1"):Get()

function GreatVaultList:GetLibs()
    return L, _
end 


local default_global_data = {
	global = {
		sort = 2,
		greatvault_frame = {
			scale = 1,
			position = {},
			lines = 12
		},
		characters = {},
		view = {
			raid = true,
			activities = true,
			pvp = false
		},
		Options = {
			modules = {}
		}
	}
}


GreatVaultList.data = {}

function GreatVaultList.data:get()
	if self.characterInfo then return self.characterInfo end
	
	local characterInfo = _.find(GreatVaultList.db.global.characters, function(v)
		return v.name == PlayerName
	end)

	if not characterInfo then 
		table.insert(GreatVaultList.db.global.characters, { name = PlayerName })
		characterInfo = _.find(GreatVaultList.db.global.characters, function(v)
			return v.name == PlayerName
		end)
	end

	self.characterInfo = characterInfo

	return characterInfo
end

function GreatVaultList.data:storeAll()
	if UnitLevel("player") < GetMaxLevelForLatestExpansion() then
		return
	end

	local characterInfo = self:get()

	for key, value in pairs(GreatVaultList.colConfig) do
		if value["store"] then 
			local storeFn = value["store"]
			characterInfo = storeFn(characterInfo) 
		end
	end

	characterInfo.lastUpdate = time()
end



function GreatVaultList:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GreatVaultListDB", default_global_data, true)
	GreatVaultList.db.global.columns = GreatVaultList.db.global.columns or {}

	C_AddOns.LoadAddOn("Blizzard_WeeklyRewards");

	GreatVaultList:slashcommand()

	C_Timer.After(3, function()
		GreatVaultList.data:storeAll()
		GreatVaultListOptions:init()
		GreatVaultList:updateData(true)
	end)

end

function GreatVaultList_OnAddonCompartmentClick(addonName, buttonName)
	if buttonName == "RightButton" then 
		Settings.OpenToCategory(GreatVaultList.OptionsID)
	else 
		GreatVaultListFrame:SetShown(not GreatVaultListFrame:IsShown())
	end
end


function GreatVaultList:slashcommand() 
	SLASH_GV1 = "/gv"
	SLASH_GV2 = "/greatvault"
	SlashCmdList["GV"] = function(msg)
        if GreatVaultListFrame:IsShown() then 
            GreatVaultListFrame:Hide()
        else
            GreatVaultListFrame:Show()
        end
	end 
end






GreatVaultList.Table = {}
GreatVaultList.Table.cols = {}

GREATVAULTLIST_COLUMNS = {
    OnEnable = function(self)
		if not GreatVaultList.db.global.Options.modules[self.key] then
			GreatVaultList.db.global.Options.modules[self.key] = {
				active = false,
				index = 0
			}
		end

		if not GreatVaultList.db.global.Options.modules[self.key].active then return end


		table.insert(GreatVaultList.Table.cols, {
			key = self.key,
			index = _.get(GreatVaultList.db.global.Options.modules, {self.key, "index"}, self.index),
			config = self.config
		})


		if not GreatVaultList.db.global.Options.modules[self.key] then
			GreatVaultList.db.global.Options.modules[self.key] = {
				active = false,
				index = 0
			}
		end

		if self.config.event then 
			GreatVaultList:RegisterBucketEvent(self.config.event[1], 0.5, function(event) 
				self.config.event[2](self, event)
			end)
		end
    end,
	OnDisable = function(self)
		local fidx =  _.findIndex(GreatVaultList.Table.cols, function(entry) return entry.key == self.key end)
		--print("OnDisable", self.key, fidx)
		if fidx > 0 then 
			table.remove(GreatVaultList.Table.cols, fidx)
		end
    end 
}



function GreatVaultList:updateData(init)

	 _.map(GreatVaultList.Table.cols, function(entry, key) 
		entry.index = GreatVaultList.db.global.Options.modules[entry.key].index
	end)

	sort(GreatVaultList.Table.cols,function(a, b) return a.index < b.index end)
	local cols = _.map(GreatVaultList.Table.cols, function(entry) return entry.key end)

	local colConfig = {}
	_.forEach(GreatVaultList.Table.cols, function(entry,key) 
		colConfig[entry.key] = entry.config
	end)


	local data = _.map(GreatVaultList.db.global.characters, function(entry, key)
		return  _.map(GreatVaultList.Table.cols, function(cEntry)
			return entry[_.get(cEntry, {"config", "sort", "store"})]
		end)
	end)


	-- DevTool:AddData(data, "data")
	-- DevTool:AddData(cols, "cols")
	-- DevTool:AddData(colConfig, "colConfig")

	if init then
		GreatVaultListFrame.ListFrame:init(cols, data, colConfig)
	else
		GreatVaultListFrame.ListFrame:update(cols, data, colConfig)
	end
end


