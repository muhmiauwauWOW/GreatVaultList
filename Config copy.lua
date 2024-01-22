GreatVaultAddon = LibStub("AceAddon-3.0"):NewAddon("GreatVault", "AceConsole-3.0", "AceEvent-3.0",  "AceSerializer-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GreatVault")


local PlayerName = UnitName("player")
local PVPActive = false



local headerTable = {
	{key = "class", text = "Class", width = 40, canSort = true, dataType = "number", order = "DESC", offset = 0},
    {key = "character", text = L["Character"], width = 140, canSort = true, dataType = "string", order = "DESC", offset = 0},
    {key = "iLevel", text = L["iLevel"], width = 60, canSort = true, dataType = "string", order = "DESC", offset = 0},
    {key = "Raids", text = L["Raids"], width = 140, canSort = true, dataType = "string", order = "DESC", offset = 0},
    {key = "Activities", text = L["Activities"], width = 240, canSort = true, dataType = "string", order = "DESC", offset = 0}
}

local headerTableConfig  = { "class", "character", "iLevel", "Raids", "Activities" }

if PVPActive then 
	table.insert(headerTableConfig, "PvP")
	table.insert(headerTable, {key = "PvP", text = L["PvP"], width = 240, canSort = true, dataType = "string", order = "DESC", offset = 0})
end


local windowWidth = 0
for _, value in ipairs(headerTable) do
    windowWidth = windowWidth + value.width
end

--frame options
local CONST_WINDOW_WIDTH = windowWidth + 35
local CONST_SCROLL_LINE_HEIGHT = 20
local CONST_SCROLL_LINE_AMOUNT = 12
local CONST_WINDOW_HEIGHT = CONST_SCROLL_LINE_AMOUNT * CONST_SCROLL_LINE_HEIGHT + 70


local backdrop_color = {.2, .2, .2, 0.2}
local backdrop_color_on_enter = {.8, .8, .8, 0.4}
local backdrop_color_inparty = {.5, .5, .8, 0.2}

--namespace
GreatVaultAddon.ScrollFrame = {}

local default_global_data = {
	greatvault_cache = {},
	greatvault_frame = {
		scale = 1,
		position = {},
		header = headerTableConfig
	}
}






function GreatVaultAddon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GreatVaultDB", {}, true)
	C_AddOns.LoadAddOn("Blizzard_WeeklyRewards");
	WeeklyRewardExpirationWarningDialog:Hide()

    -- init saved variabled
	if MuhmiauwauGreatVault == nil then 
		MuhmiauwauGreatVault = default_global_data
	end
	GreatVault = MuhmiauwauGreatVault

	GreatVaultAddon:slashcommand() 
	GreatVaultAddon:createWindow()
end


function GreatVaultAddon:slashcommand() 
	SLASH_GV1 = "/gv"
	SLASH_GV2 = "/greatvault"
	SlashCmdList["GV"] = function(msg)
        if GreatVaultInfoFrame:IsShown() then 
            GreatVaultInfoFrame:Hide()
        else
            GreatVaultInfoFrame:Show()
        end
	end 
end






function tableunique(ta, key)
    local keys = {}
    local out = {}
    -- make unique keys
    local hash = {}
    for k,v in ipairs(ta) do
        if not keys[v[key]] then
            table.insert(out, v)
            keys[v[key]] = true
        end
    end
    
    return out
end


function GreatVaultAddon:addEntry(entry)
	local data = GreatVaultAddon.ScrollFrame.ScollFrame:GetData()
    data = tableunique(data, "character")
    local found = false
    for index, value in ipairs(data) do
        if value.character == entry.character  then
            found = true
            data[index] = entry
        end
    end

    if not found then
        table.insert(data, entry)
    end


    GreatVault.greatvault_cache = data
    GreatVaultAddon.ScrollFrame.ScollFrame:SetData(data)
    GreatVaultAddon:sortEntries("iLevel", "ASC")
	GreatVaultAddon.ScrollFrame.ScollFrame:Refresh()
end 


function GreatVaultAddon:sortEntries(columnIndex, order)
    local data = GreatVaultAddon.ScrollFrame.ScollFrame:GetData()
    table.sort(data, function (k1, k2) 
        if order == "DESC" then
             return k1[columnIndex] < k2[columnIndex]
        else 
            return k1[columnIndex] > k2[columnIndex]
        end
    end)

	GreatVaultAddon.ScrollFrame.ScollFrame:SetData(data)
	GreatVaultAddon.ScrollFrame.ScollFrame:Refresh()
end 




function GreatVaultAddon:createWindow() 

	local f = DetailsFramework:CreateSimplePanel(UIParent, CONST_WINDOW_WIDTH, CONST_WINDOW_HEIGHT, "GreatVault", "GreatVaultInfoFrame")
	f:SetPoint("center", UIParent, "center", 0, 0)

	f:SetScript("OnMouseDown", nil) --disable framework native moving scripts
	f:SetScript("OnMouseUp", nil) --disable framework native moving scripts

	local LibWindow = LibStub("LibWindow-1.1")
	LibWindow.RegisterConfig(f, GreatVault.greatvault_frame.position)
	LibWindow.MakeDraggable(f)
	LibWindow.RestorePosition(f)

	local scaleBar = DetailsFramework:CreateScaleBar(f, GreatVault.greatvault_frame)
	f:SetScale(GreatVault.greatvault_frame.scale)

	local statusBar = DetailsFramework:CreateStatusBar(f)
	statusBar.text = statusBar:CreateFontString(nil, "overlay", "GameFontNormal")
	statusBar.text:SetPoint("left", statusBar, "left", 5, 0)
	statusBar.text:SetText("By Muhmiauwau | Built with Details! Framework")
	DetailsFramework:SetFontSize(statusBar.text, 11)
	DetailsFramework:SetFontColor(statusBar.text, "gray")

	GreatVaultAddon.ScrollFrame.create(f) 
end






function GreatVaultAddon.ScrollFrame.create(f) 

	GreatVaultAddon.ScrollFrame.setHeader(f) 

	local scrollFrame = DetailsFramework:CreateScrollBox(f, "$parentScroll", GreatVaultAddon.ScrollFrame.RefreshScroll, GreatVault.greatvault_cache, CONST_WINDOW_WIDTH, CONST_WINDOW_HEIGHT-70, CONST_SCROLL_LINE_AMOUNT, CONST_SCROLL_LINE_HEIGHT)
	DetailsFramework:ReskinSlider(scrollFrame)
	scrollFrame:CreateLines(GreatVaultAddon.ScrollFrame.CreateScrollLine, CONST_SCROLL_LINE_AMOUNT)
	scrollFrame:SetPoint("topleft", f.Header, "bottomleft", -1, -1)
	scrollFrame:SetPoint("topright", f.Header, "bottomright", 0, -1)

    scrollFrame:Refresh()

	GreatVaultAddon.ScrollFrame.ScollFrame = scrollFrame;

end


function GreatVaultAddon.ScrollFrame.setHeader(f) 


    local headerOnClickCallback = function(headerFrame, columnHeader)
        GreatVaultAddon:sortEntries(columnHeader.key, columnHeader.order)
    end

	local headerOptions = {
		padding = 1,
		header_backdrop_color = {.3, .3, .3, .8},
		header_backdrop_color_selected = {.5, .5, .5, 0.8},
		use_line_separators = true,
		line_separator_color = {.1, .1, .1, .5},
		line_separator_width = 1,
		line_separator_height = CONST_WINDOW_HEIGHT-30,
		line_separator_gap_align = true,
		header_click_callback = headerOnClickCallback,
	}

    

	f.Header = DetailsFramework:CreateHeader(f, headerTable, headerOptions, "GreatVaultInfoFrameHeader")
	f.Header:SetPoint("topleft", f, "topleft", 3, -25)
    f.Header.columnSelected = 2
end

function GreatVaultAddon.ScrollFrame.RefreshScroll(self, data, offset, totalLines) 
	for i = 1, totalLines do
		local index = i + offset
		local data = data[index]
		if(data) then 
			local line = self:GetLine(i)
            if (data.character == PlayerName) then
                line:SetBackdropColor(unpack(backdrop_color_inparty))
            else
                line:SetBackdropColor(unpack(backdrop_color))
            end

			for _, value in pairs(GreatVault.greatvault_frame.header) do
				if value == "class" then
					line.icon:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
					local L, R, T, B = unpack(CLASS_ICON_TCOORDS[data[value]])
					line.icon:SetTexCoord(L+0.02, R-0.02, T+0.02, B-0.02)
				else
					line[value].text = data[value]
				end
			end
		 end
	end
end

function GreatVaultAddon.ScrollFrame.CreateScrollLine(self, lineId)
	local line = CreateFrame("frame", "$parentLine" .. lineId, self, "BackdropTemplate")
	line.lineId = lineId

    line:SetPoint("topleft", self, "topleft", 2, (CONST_SCROLL_LINE_HEIGHT * (lineId - 1) * -1) - 2)
    line:SetPoint("topright", self, "topright", -2, (CONST_SCROLL_LINE_HEIGHT * (lineId - 1) * -1) - 2)
    line:SetHeight(CONST_SCROLL_LINE_HEIGHT)


    line:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
    line:SetBackdropColor(unpack(backdrop_color))

	DetailsFramework:Mixin(line, DetailsFramework.HeaderFunctions)

    line:SetScript("OnEnter", function(self)
        if not (self.character.text == PlayerName) then
            self:SetBackdropColor(unpack(backdrop_color_on_enter))
        end
    end)

	line:SetScript("OnLeave", function(self)
        if not (self.character.text == PlayerName) then
            self:SetBackdropColor(unpack(backdrop_color))
        end
    end)

	local header = self:GetParent().Header

	for _, value in pairs(GreatVault.greatvault_frame.header) do
		if value == "class" then 
			local icon = line:CreateTexture("$parentClassIcon", "overlay")
			icon:SetSize(CONST_SCROLL_LINE_HEIGHT - 2, CONST_SCROLL_LINE_HEIGHT - 2)
			line.icon = icon
			line:AddFrameToHeaderAlignment(icon)
		else
			local obj = DetailsFramework:CreateLabel(line)
			line[value] = obj
			line:AddFrameToHeaderAlignment(obj)
		end
		
	end

	line:AlignWithHeader(header, "left")
	return line
end











local function GetWeeklyQuestResetTime()
	local now = time()
	local region = GetCurrentRegion()
	local dayOffset = { 2, 1, 0, 6, 5, 4, 3 }
	local regionDayOffset = {{ 2, 1, 0, 6, 5, 4, 3 }, { 4, 3, 2, 1, 0, 6, 5 }, { 3, 2, 1, 0, 6, 5, 4 }, { 4, 3, 2, 1, 0, 6, 5 }, { 4, 3, 2, 1, 0, 6, 5 } }
	local nextDailyReset = GetQuestResetTime()
	local utc = date("!*t", now + nextDailyReset)
	local reset = regionDayOffset[region][utc.wday] * 86400 + now + nextDailyReset
	
	return reset
end





local DIFFICULTY_NAMES =
{
	[DifficultyUtil.ID.DungeonNormal] = "nhc",
	[DifficultyUtil.ID.DungeonHeroic] = "HC",
	[DifficultyUtil.ID.Raid10Normal] = "nhc",
	[DifficultyUtil.ID.Raid25Normal] = "nhc",
	[DifficultyUtil.ID.Raid10Heroic] = "HC",
	[DifficultyUtil.ID.Raid25Heroic] = "HC",
	[DifficultyUtil.ID.RaidLFR] = "LFR",
	[DifficultyUtil.ID.DungeonChallenge] = PLAYER_DIFFICULTY_MYTHIC_PLUS,
	[DifficultyUtil.ID.Raid40] = LEGACY_RAID_DIFFICULTY,
	[DifficultyUtil.ID.PrimaryRaidNormal] = "nhc",
	[DifficultyUtil.ID.PrimaryRaidHeroic] = "HC",
	[DifficultyUtil.ID.PrimaryRaidMythic] = "MTH",
	[DifficultyUtil.ID.PrimaryRaidLFR] = "LFR",
	[DifficultyUtil.ID.DungeonMythic] = PLAYER_DIFFICULTY6,
	[DifficultyUtil.ID.DungeonTimewalker] = PLAYER_DIFFICULTY_TIMEWALKER,
	[DifficultyUtil.ID.RaidTimewalker] = PLAYER_DIFFICULTY_TIMEWALKER,
}

function GetDifficultyName(difficultyID)
	return DIFFICULTY_NAMES[difficultyID];
end

local function ShowActivities(activities, lastUpdated)
	local status
	local activityThisWeek = lastUpdated > GetWeeklyQuestResetTime() - 604800

	table.sort(activities, function(a,b) return a.index < b.index end)

    local out = ""

	for _, activity in ipairs(activities) do
		local difficulty

		if activity.progress >= activity.threshold and activityThisWeek then
			if activity.type == Enum.WeeklyRewardChestThresholdType.Activities then
				difficulty = L["Mythic"].." " .. activity.level
			elseif activity.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
				difficulty = PVPUtil.GetTierName(activity.level)
			elseif activity.type == Enum.WeeklyRewardChestThresholdType.Raid then
				difficulty = GetDifficultyName(activity.level)
			end
            

			status = GREEN_FONT_COLOR_CODE .. difficulty .. FONT_COLOR_CODE_CLOSE
		else
			local progress = 0
			if activityThisWeek then
				progress = activity.progress
			end
			status = GRAY_FONT_COLOR_CODE .. progress .. '/' .. activity.threshold .. FONT_COLOR_CODE_CLOSE
		end

        out = out .. "   ".. status
	end

    return out
end






function GreatVaultAddon:GetCharacters()
	local realmInfo = self:GetRealmInfo(GetRealmName())
	local characters = realmInfo.characters or {}

	return characters;
end

function GreatVaultAddon:GetRealmInfo(realmName)
	if not self.db.global.realms then
		self.db.global.realms = {}
	end

	local realmInfo = self.db.global.realms[realmName]

	if not realmInfo then
		realmInfo = {}
		realmInfo.characters = {}
	end

	return realmInfo
end

local function GetActivities(activityType)
	local activities = C_WeeklyRewards.GetActivities(activityType);

	table.sort(activities, function(a,b) return a.index < b.index end)

	for _,activity in pairs(activities) do
		if activity.progress >= activity.threshold then
			local encounterInfo = C_WeeklyRewards.GetActivityEncounterInfo(activityType, activity.index);
			local currentLink, upgradeLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id);

			if encounterInfo then
				activity.encounters = encounterInfo
			end

			activity.currentItemLevel = GetDetailedItemLevelInfo(currentLink);
			if upgradeLink then
				activity.upgradeItemLevel = GetDetailedItemLevelInfo(upgradeLink);			
			end
		end
	end

	return activities
end


local function UpdateStatusForCharacter(currentStatus)
	local now = time()
	local status = currentStatus or {}

    status.lastUpdated = now
    status.activities = {}
    status.activities[Enum.WeeklyRewardChestThresholdType.Activities] = GetActivities(Enum.WeeklyRewardChestThresholdType.Activities)
    status.activities[Enum.WeeklyRewardChestThresholdType.RankedPvP] = GetActivities(Enum.WeeklyRewardChestThresholdType.RankedPvP)
    status.activities[Enum.WeeklyRewardChestThresholdType.Raid] = GetActivities(Enum.WeeklyRewardChestThresholdType.Raid)
	status.hasAvailableRewards = C_WeeklyRewards.HasAvailableRewards();

	return status
end




function GreatVaultAddon:SaveCharacterInfo(info)
	if UnitLevel("player") < 70 then
		return
	end

	local characterInfo = info or self:GetCharacterInfo()
	local characterName = UnitName("player")
	local realmName = GetRealmName()
	local realmInfo = self:GetRealmInfo(realmName)

	realmInfo.characters[characterName]  = characterInfo
	self.db.global.realms[realmName] = realmInfo
end

function GreatVaultAddon:GetCharacterInfo()
	local name = UnitName("player")
	local realmInfo = GreatVaultAddon:GetRealmInfo(GetRealmName())
	local characterInfo = realmInfo.characters[name] or {}
	local _, className = UnitClass("player")

	characterInfo.name = name
	characterInfo.lastUpdate = time()
	characterInfo.class = className
	characterInfo.level = UnitLevel("player")
	characterInfo.averageItemLevel = GetAverageItemLevel();
	characterInfo.faction = UnitFactionGroup("player")
	characterInfo.status = UpdateStatusForCharacter(characterInfo.status)

	return characterInfo
end

local function UpdateStatus()
	GreatVaultAddon:SaveCharacterInfo()

    for _, value in pairs(GreatVaultAddon.db.global.realms or {}) do
        for _, characterInfo in pairs(value.characters) do
            local activities = characterInfo.status.activities
            local e = {
				["class"] = characterInfo.class,
                ["character"] = characterInfo.name,
                ["iLevel"] = string.format("%.1f", characterInfo.averageItemLevel),
                ["Raids"] = ShowActivities(activities[Enum.WeeklyRewardChestThresholdType.Raid], characterInfo.status.lastUpdated),
                ["Activities"] =  ShowActivities(activities[Enum.WeeklyRewardChestThresholdType.Activities], characterInfo.status.lastUpdated),
                ["PvP"] = ShowActivities(activities[Enum.WeeklyRewardChestThresholdType.RankedPvP], characterInfo.status.lastUpdated),
            }
            GreatVaultAddon:addEntry(e)
		end
	end
end




function GreatVaultAddon:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
	if isLogin or isReload then
		C_Timer.After(3, UpdateStatus)
	end
end

function GreatVaultAddon:WEEKLY_REWARDS_UPDATE(event)
	--self:Print(event)
	UpdateStatus()

end

function GreatVaultAddon:WEEKLY_REWARDS_ITEM_CHANGED(event)
	--self:Print(event)
	UpdateStatus()
end


function GreatVaultAddon:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("WEEKLY_REWARDS_UPDATE")
	self:RegisterEvent("WEEKLY_REWARDS_ITEM_CHANGED")
end

function GreatVaultAddon:OnDisable()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("WEEKLY_REWARDS_UPDATE")
	self:UnregisterEvent("WEEKLY_REWARDS_ITEM_CHANGED")
end



function GreatVaultAddon_OnAddonCompartmentClick() 
	if GreatVaultInfoFrame:IsShown() then 
		GreatVaultInfoFrame:Hide()
	else
		GreatVaultInfoFrame:Show()
	end
end

function GreatVaultAddon_OnAddonCompartmentEnter() 
end

function GreatVaultAddon_OnAddonCompartmentLeave() 
end