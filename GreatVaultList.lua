---@diagnostic disable: deprecated
---@class GreatVaultList:AceAddon
GreatVaultList = LibStub("AceAddon-3.0"):NewAddon("GreatVaultList", "AceEvent-3.0", "AceBucket-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GreatVaultList")
local _ = LibStub("LibLodash-1"):Get()

function GreatVaultList:GetLibs()
    return L, _
end 

local PlayerName = UnitName("player")

local sortConfig  = {}

--frame options
local CONST_WINDOW_WIDTH = 0
local CONST_SCROLL_LINE_HEIGHT = 20
local CONST_WINDOW_HEIGHT = 0

local backdrop_color = {.2, .2, .2, 0.2}
local backdrop_color_on_enter = {.8, .8, .8, 0.4}
local backdrop_color_inparty = {.5, .5, .8, 0.2}



--namespace
GreatVaultList.ScrollFrame = {}

local default_global_data = {
	global = {
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
		}
	}
}


local headerTable = {}
local headerTableConfig  = {}

GreatVaultList.colConfig = {}

local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GreatVaultList:addColumn(config)
	table.insert(headerTableConfig, config.key)
	table.insert(headerTable, config)
end




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
end

function GreatVaultList_OnAddonCompartmentClick()
	GreatVaultListFrame:SetShown(not GreatVaultListFrame:IsShown()) 
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




GREATVAULTLIST_COLUMNS = {
    OnEnable = function(self)

		GreatVaultList.db.global.columns[self.key] = GreatVaultList.db.global.columns[self.key] or {}
		GreatVaultList.db.global.columns[self.key].key = self.key
		GreatVaultList.db.global.columns[self.key].size =  self.config.subCols or 1
		GreatVaultList.db.global.columns[self.key].position = GreatVaultList.db.global.columns[self.key].position or self.config.index


		if not _.isBoolean(GreatVaultList.db.global.columns[self.key].active) then
			GreatVaultList.db.global.columns[self.key].active =  true
		end

		if GreatVaultList.db.global.columns[self.key].active then 
			GreatVaultList.colConfig[self.key] = self.config
		end

		if self.config.event then 
			GreatVaultList:RegisterBucketEvent(self.config.event[1], 0.5, function(event) 
				self.config.event[2](self, event)
			end)
		end


		self.loaded = true
      	GREATVAULTLIST_COLUMNS__checkModules()
    end,
	OnDisable = function(self)

		if not GreatVaultList.db.global.columns[self.key] then 
			GreatVaultList.db.global.columns[self.key].active = false
		end


        self.loaded = false
        GREATVAULTLIST_COLUMNS__checkModules()
    end 
}


function GREATVAULTLIST_COLUMNS__checkModules()
    local modules = GreatVaultList:IterateModules()
    local check = _.every(modules, function(module)
        return module.loaded
    end)

    if GREATVAULTLIST_COLUMNS__ticker then
        GREATVAULTLIST_COLUMNS__ticker:Cancel()
	end

    if check then
        GREATVAULTLIST_COLUMNS__ticker = C_Timer.NewTimer(0.1, function()
			GREATVAULTLIST_COLUMNS__ticker:Cancel()


			GreatVaultList.db.global.columns = _.forEach(GreatVaultList.db.global.columns, function(col)
				col.loaded = false
				return col
			end)
			for name, module in GreatVaultList:IterateModules() do
				GreatVaultList.db.global.columns[module.key].loaded = true
			end

			--GreatVaultList:Initwindow()

			GreatVaultList:lala()	
			
        end)
    end
end








function GreatVaultList:lala()

	GreatVaultListOptions:init()
	
	
	GreatVaultList.data:storeAll()


	local  data = {}


	_.forEach(GreatVaultList.db.global.characters, function(entry, i)
		table.insert(data, {entry.class, entry.name, entry.averageItemLevel, entry.raid, entry.activities, entry.pvp,  entry.keystone })
	end)

	local cols = { "class", "character",  "ilevel", "raid", "activities", "pvp", "keystone"}
	GreatVaultListFrame.BrowseResultsFrame:init(cols, data, GreatVaultList.colConfig)


end