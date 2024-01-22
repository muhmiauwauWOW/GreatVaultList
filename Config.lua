---@diagnostic disable: deprecated
GreatVaultAddon = LibStub("AceAddon-3.0"):NewAddon("GreatVault", "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("GreatVault")


local PlayerName = UnitName("player")

local sortConfig  = { 
	["class"] = "class",
	["character"] = "name",
	["iLevel"] = "averageItemLevel",
	["Raids"] = "averageItemLevel",
	["Activities"] = "averageItemLevel"
}


local viewTypes = {
	["raid"] = { "Raid1", "Raid2", "Raid3" },
	["activities"] = { "Activities1", "Activities2", "Activities3" },
	["pvp"] = { "pvp1", "pvp2", "pvp3" }
}

--frame options
local CONST_WINDOW_WIDTH = 0
local CONST_SCROLL_LINE_HEIGHT = 20
local CONST_SCROLL_LINE_AMOUNT = 12
local CONST_WINDOW_HEIGHT = CONST_SCROLL_LINE_AMOUNT * CONST_SCROLL_LINE_HEIGHT + 70

local backdrop_color = {.2, .2, .2, 0.2}
local backdrop_color_on_enter = {.8, .8, .8, 0.4}
local backdrop_color_inparty = {.5, .5, .8, 0.2}


local DIFFICULTY_NAMES = {
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


--namespace
GreatVaultAddon.ScrollFrame = {}

local default_global_data = {
	global = {
		greatvault_frame = {
			scale = 1,
			position = {}
		},
		characters = {},
		view = {
			raid = true,
			activities = true,
			pvp = false
		}
	}
}


local headerTable = {
	{key = "class", text = "", width = 25, canSort = true, dataType = "string", order = "DESC", offset = 0},
	{key = "character", text = L["Character"], width = 140, canSort = true, dataType = "string", order = "DESC", offset = 0},
	{key = "iLevel", text = L["iLevel"], width = 60, canSort = true, dataType = "number", order = "DESC", offset = 0},
}

local headerTableConfig  = { "class", "character", "iLevel" }


local headerOptions = {
	["raid"] = { text = L["Raids"], width = 40, canSort = false, dataType = "string", order = "DESC", offset = 20, align = "center"},
	["activities"] = { text = L["Activities"], width = 50, canSort = false, dataType = "string", order = "DESC", offset = 25, align = "center"},
	["pvp"] = { text = L["PvP"], width = 100, canSort = false, dataType = "string", order = "DESC", offset = 50, align = "center"}
}


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
function GreatVaultAddon:buildColumns()

	for key, items in pairs(viewTypes) do
		for idx, col in ipairs(items) do
			if self.db.global.view[key] then 
				table.insert(headerTableConfig, col)
				local opt = shallowcopy(headerOptions[key])
				opt.key = col
				if idx > 1 then
					opt.text = ""
				end
				table.insert(headerTable, opt)
			end
		end
	end

	local windowWidth = 0
	for _, value in ipairs(headerTable) do
		windowWidth = windowWidth + value.width
	end

	--frame options
	CONST_WINDOW_WIDTH = windowWidth + 30

end


function GreatVaultAddon:OnInitialize()

	print("ok?")
    self.db = LibStub("AceDB-3.0"):New("GreatVaultDB", default_global_data, true)
	self:buildColumns()

	C_AddOns.LoadAddOn("Blizzard_WeeklyRewards");
	WeeklyRewardExpirationWarningDialog:Hide()

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

		if msg == "raid" then 
			GreatVaultAddon.db.global.view.raid = not GreatVaultAddon.db.global.view.raid
			C_UI.Reload()
		elseif msg == "activities" then
			GreatVaultAddon.db.global.view.activities = not GreatVaultAddon.db.global.view.activities
			C_UI.Reload()
		elseif  msg == "pvp" then
			GreatVaultAddon.db.global.view.pvp = not GreatVaultAddon.db.global.view.pvp
			C_UI.Reload()
		end
	end 
end

function GreatVaultAddon:sortEntries(columnIndex, order)
    local data = GreatVaultAddon.ScrollFrame.ScollFrame:GetData()
	columnIndex = sortConfig[columnIndex]
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

	f:SetScript("OnMouseDown", nil)
	f:SetScript("OnMouseUp", nil)

	local LibWindow = LibStub("LibWindow-1.1")
	LibWindow.RegisterConfig(f, GreatVaultAddon.db.global.greatvault_frame.position)
	LibWindow.MakeDraggable(f)
	LibWindow.RestorePosition(f)

	local scaleBar = DetailsFramework:CreateScaleBar(f, GreatVaultAddon.db.global.greatvault_frame)
	f:SetScale(GreatVaultAddon.db.global.greatvault_frame.scale)

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
	local scrollFrame = DetailsFramework:CreateScrollBox(f, "$parentScroll", GreatVaultAddon.ScrollFrame.RefreshScroll, GreatVaultAddon.db.global.characters, CONST_WINDOW_WIDTH, CONST_WINDOW_HEIGHT-70, CONST_SCROLL_LINE_AMOUNT, CONST_SCROLL_LINE_HEIGHT)
	DetailsFramework:ReskinSlider(scrollFrame)
	scrollFrame:CreateLines(GreatVaultAddon.ScrollFrame.CreateScrollLine, CONST_SCROLL_LINE_AMOUNT)
	scrollFrame:SetPoint("topleft", f.Header, "bottomleft", -1, -1)
	scrollFrame:SetPoint("topright", f.Header, "bottomright", 0, -1)
    scrollFrame:Refresh()
	GreatVaultAddon.ScrollFrame.ScollFrame = scrollFrame;
end

function GreatVaultAddon.ScrollFrame.setHeader(f)

	local headerOptions = {
		padding = 0,
		header_backdrop_color = {.3, .3, .3, .8},
		header_backdrop_color_selected = {.5, .5, .5, 0.8},
		use_line_separators = false,
		line_separator_color = {.1, .1, .1, .5},
		line_separator_width = 1,
		line_separator_height = CONST_WINDOW_HEIGHT-30,
		line_separator_gap_align = false,
		header_click_callback = function(headerFrame, columnHeader)
			GreatVaultAddon:sortEntries(columnHeader.key, columnHeader.order)
		end,
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
            if (data.name == PlayerName) then
                line:SetBackdropColor(unpack(backdrop_color_inparty))
            else
                line:SetBackdropColor(unpack(backdrop_color))
            end

			local L, R, T, B = unpack(CLASS_ICON_TCOORDS[data.class])
			line.icon:SetTexCoord(L+0.02, R-0.02, T+0.02, B-0.02)

			line.character.text = data.name
			line.iLevel.text  = string.format("%.2f", data.averageItemLevel)

			for key, items in pairs(viewTypes) do
				for idx, col in ipairs(items) do
					if GreatVaultAddon.db.global.view[key] then 
						line[col].text = GreatVaultAddon:GetVault(data[key][idx], data.lastUpdated)
					end
				end
			end

		end
	end
end

function GreatVaultAddon.ScrollFrame.CreateScrollLine(self, lineId)
	local line = CreateFrame("frame", "$parentLine" .. lineId, self, "BackdropTemplate")
	line.lineId = lineId

    line:SetPoint("TOPLEFT", self, "TOPLEFT", 2, (CONST_SCROLL_LINE_HEIGHT * (lineId - 1) * -1) - 2)
    line:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, (CONST_SCROLL_LINE_HEIGHT * (lineId - 1) * -1) - 2)
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

	for _, value in pairs(headerTableConfig) do
		if value == "class" then 
			local icon = line:CreateTexture("$parentClassIcon", "overlay")
			icon:SetSize(CONST_SCROLL_LINE_HEIGHT - 2, CONST_SCROLL_LINE_HEIGHT - 2)
			icon:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
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
	local regionDayOffset = {{ 2, 1, 0, 6, 5, 4, 3 }, { 4, 3, 2, 1, 0, 6, 5 }, { 3, 2, 1, 0, 6, 5, 4 }, { 4, 3, 2, 1, 0, 6, 5 }, { 4, 3, 2, 1, 0, 6, 5 } }
	local nextDailyReset = GetQuestResetTime()
	local utc = date("!*t", now + nextDailyReset)
	local reset = regionDayOffset[region][utc.wday] * 86400 + now + nextDailyReset
	return reset
end

function GetDifficultyName(difficultyID)
	return DIFFICULTY_NAMES[difficultyID];
end

function GreatVaultAddon:GetVault(activity, lastUpdated)
	if not lastUpdated then
		lastUpdated = time()
	end

	local status
	local activityThisWeek = lastUpdated > GetWeeklyQuestResetTime() - 604800
	local difficulty

	if activity.progress >= activity.threshold and activityThisWeek then
		if activity.type == Enum.WeeklyRewardChestThresholdType.Activities then
			difficulty = " +" .. activity.level .. " "
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
		local spacer = " "
		if activity.type == Enum.WeeklyRewardChestThresholdType.Activities then
			spacer = " "
		end

		status = GRAY_FONT_COLOR_CODE .. spacer .. progress .. '/' .. activity.threshold .. spacer ..  FONT_COLOR_CODE_CLOSE
	end

    return status
end

function GreatVaultAddon:SaveCharacterInfo(info)
	if UnitLevel("player") < 70 then
		return
	end

	local characterInfo = info or self:GetCharacterInfo()
	local characterName = UnitName("player")

	local found = false
    for _, value in ipairs(self.db.global.characters) do
        if value.name == characterName  then
			found = true
			value = characterInfo
        end
    end

	if not found then 
		table.insert(self.db.global.characters, characterInfo)
	end
end

function GreatVaultAddon:GetCharacterInfo()
	local name = UnitName("player")
	local characterInfo = {}
	for _, value in ipairs(self.db.global.characters) do
        if value.name == name  then
			characterInfo = value
        end
    end

	local _, className = UnitClass("player")
	characterInfo.name = name
	characterInfo.lastUpdate = time()
	characterInfo.class = className
	characterInfo.realm = GetRealmName()
	characterInfo.level = UnitLevel("player")
	characterInfo.averageItemLevel = GetAverageItemLevel();

	characterInfo.raid = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Raid)
	characterInfo.activities = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Activities)
	characterInfo.pvp = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.RankedPvP)

	return characterInfo
end

local function UpdateStatus()
	GreatVaultAddon:SaveCharacterInfo()
	GreatVaultAddon:sortEntries("iLevel", "ASC")
end




function GreatVaultAddon:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
	if isLogin or isReload then
		C_Timer.After(3, UpdateStatus)
	end
end

function GreatVaultAddon:WEEKLY_REWARDS_UPDATE(event)
	UpdateStatus()
end

function GreatVaultAddon:WEEKLY_REWARDS_ITEM_CHANGED(event)
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