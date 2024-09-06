---@class GreatVaultList:AceAddon
GreatVaultList = LibStub("AceAddon-3.0"):NewAddon("GreatVaultList", "AceEvent-3.0", "AceBucket-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GreatVaultList")
local _ = LibStub("LibLodash-1"):Get()

local TableBuilderLib = LibStub:GetLibrary("TableBuilderLib")
TableBuilderLib = TableBuilderLib:Setup("GreatVaultList", "GreatVaultListHeaderTemplate", "GreatVaultListLineTemplate", "GreatVaultListTableCellTextTemplate")



function GreatVaultList:GetLibs()
    return L, _, TableBuilderLib
end 


GVL_OPEN_VAULT = L["OpenVault"]


local default_global_data = {
	global = {
		sort = 2,
		characters = {},
		Options = {
			modules = {

			},
			position = {},
			scale = 1,
		}
	}
}


function GreatVaultList:OnEnable()
    self.db = LibStub("AceDB-3.0"):New("GreatVaultList2DB", default_global_data, true)
	C_AddOns.LoadAddOn("Blizzard_WeeklyRewards");
	GreatVaultList:slashcommand()
	GreatVaultList.Data:init()
	GreatVaultList.Data:storeAll()
	GreatVaultListOptions:init()

	GreatVaultList:updateData(true)
	-- GreatVaultList:demoMode()

	-- set Options
	GreatVaultListFrame:SetScale(GreatVaultList.db.global.Options.scale)



	GreatVaultListFrame:SetShown(not GreatVaultListFrame:IsShown())

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
		
		-- init is not found
		if not GreatVaultList.db.global.Options.modules[self.key] then
			GreatVaultList.db.global.Options.modules[self.key] = { active = true }
		end

		-- return if already active
		if not GreatVaultList.db.global.Options.modules[self.key].active then return end


		-- register col
		table.insert(GreatVaultList.Table.cols, {
			key = self.key,
			index = _.get(GreatVaultList.db.global.Options.modules, {self.key, "index"}, self.index),
			config = self.config
		})


		-- register events
		if self.config.event then 
			GreatVaultList:RegisterBucketEvent(self.config.event[1], 0.5, function(event) 
				self.config.event[2](self, event)
			end)
		end
    end,
	OnDisable = function(self)
		local fidx =  _.findIndex(GreatVaultList.Table.cols, function(entry) return entry.key == self.key end)
		if fidx > 0 then 
			table.remove(GreatVaultList.Table.cols, fidx)
		end
    end 
}





function GreatVaultList:updateData(refresh)

	_.map(GreatVaultList.Table.cols, function(entry, key) 
		entry.index = GreatVaultList.db.global.Options.modules[entry.key].index
	end)

	sort(GreatVaultList.Table.cols, function(a, b) return a.index < b.index end)

	local colConfig = _.map(GreatVaultList.Table.cols, function(entry)

		entry.config.id = entry.key
		entry.config.headerText = entry.config.header.text
		entry.config.cellTemplate = entry.config.template
		return entry.config
	end)

	local data = {}
	_.forEach(GreatVaultList.db.global.characters, function(entry,  key)
		local d = {}
		_.forEach(GreatVaultList.Table.cols, function(cEntry, ckey)
			d[cEntry.key] = entry[_.get(cEntry, {"config", "sort", "store"})]
		end)
		table.insert(data, d)
	end)


	DevTool:AddData(data, "data")
	-- DevTool:AddData(cols, "cols")
	DevTool:AddData(colConfig, "colConfig")

	GreatVaultListFrame.ListFrame:init(data, colConfig, refresh)
end



function GreatVaultList:demoMode()
	_.map(GreatVaultList.Table.cols, function(entry, key) 
		entry.index = GreatVaultList.db.global.Options.modules[entry.key].index
	end)

	sort(GreatVaultList.Table.cols, function(a, b) return a.index < b.index end)

	local colConfig = {}
	local cols = _.map(GreatVaultList.Table.cols, function(entry) 
		colConfig[entry.key] =  entry.config

		return entry.key 
	end)

	local demoData = {}
	for i = 1, 10, 1 do
		local d = _.map(GreatVaultList.Table.cols, function(cEntry)
			local demoFn = _.get(cEntry, {"config", "demo"}, function(e) return e end)
			return demoFn(i)
		end)

		table.insert(demoData, d)
	end

	-- DevTool:AddData(demoData, "demoData")
	-- DevTool:AddData(cols, "cols")
	-- DevTool:AddData(colConfig, "colConfig")
	GreatVaultListFrame.ListFrame:init(cols, demoData, colConfig, true)
end