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



GreatVaultList.List = {
    columns = { "Lala", "Price" ,"Name" },
    data = {}
}


function GreatVaultList:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GreatVaultListDB", default_global_data, true)
	GreatVaultList.db.global.columns = GreatVaultList.db.global.columns or {}
	CONST_WINDOW_HEIGHT = GreatVaultList.db.global.greatvault_frame.lines * CONST_SCROLL_LINE_HEIGHT + 70

	C_AddOns.LoadAddOn("Blizzard_WeeklyRewards");

	GreatVaultList:slashcommand()
end

function GreatVaultList_OnAddonCompartmentClick()
	GreatVaultInfoFrame:SetShown(not GreatVaultInfoFrame:IsShown()) 
end

function GreatVaultList:Initwindow()
	self:SetupColumns()
    GreatVaultList:createWindow()
	GreatVaultList.data:storeAll()
end

function GreatVaultList:slashcommand() 
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

function GreatVaultList:sortEntries(columnIndex, order)
    local data = GreatVaultList.ScrollFrame.ScollFrame:GetData()
	columnIndex = sortConfig[columnIndex]
	table.sort(data, function (k1, k2) 
		if order == "DESC" then
			return k1[columnIndex] < k2[columnIndex]
		else 
			return k1[columnIndex] > k2[columnIndex]
		end
	end)
	GreatVaultList.ScrollFrame.ScollFrame:SetData(data)
	GreatVaultList.ScrollFrame.ScollFrame:Refresh()
end 

function GreatVaultList:createWindow() 

	local f = DetailsFramework:CreateSimplePanel(UIParent, CONST_WINDOW_WIDTH, CONST_WINDOW_HEIGHT, L["addonName"], "GreatVaultInfoFrame")
	f:Hide()
	f:SetFrameStrata("HIGH")
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

	f:SetScript("OnMouseDown", nil)
	f:SetScript("OnMouseUp", nil)
	
	f:SetScript("OnShow", function()
		GreatVaultList.data:storeAll()
		GreatVaultList.ScrollFrame.ScollFrame:Refresh()
	end)


	local LibWindow = LibStub("LibWindow-1.1")
	LibWindow.RegisterConfig(f, GreatVaultList.db.global.greatvault_frame.position)
	LibWindow.MakeDraggable(f)
	LibWindow.RestorePosition(f)

	local scaleBar = DetailsFramework:CreateScaleBar(f, GreatVaultList.db.global.greatvault_frame)
	f:SetScale(GreatVaultList.db.global.greatvault_frame.scale)

	local statusBar = DetailsFramework:CreateStatusBar(f)
	statusBar.text = statusBar:CreateFontString(nil, "overlay", "GameFontNormal")
	statusBar.text:SetPoint("left", statusBar, "left", 5, 0)
	statusBar.text:SetText("By muhmiauwau | Built with Details! Framework")
	DetailsFramework:SetFontSize(statusBar.text, 11)
	DetailsFramework:SetFontColor(statusBar.text, "gray")

	GreatVaultList.ScrollFrame.create(f) 

	
	local options_button_template = DetailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")

	local function openVault()
		WeeklyRewardsFrame:UpdateTitle()
		WeeklyRewardsFrame:SetShown(not WeeklyRewardsFrame:IsShown());
	end

	local vaultButton = DetailsFramework:CreateButton(f, openVault, 130, 14, L["OpenVault"])
	vaultButton:SetPoint("bottomright", f, "bottomright", -150, 4)
	vaultButton:SetTemplate(options_button_template)

	local function openOptions()
		GreatVaultListOptions:toggle()
	end
	
	local optButton = DetailsFramework:CreateButton(f, openOptions, 130, 14, L["Options"])
	optButton:SetPoint("bottomright", f, "bottomright", -10, 4)
	optButton:SetTemplate(options_button_template)
end













function GreatVaultList.ScrollFrame.create(f) 
	GreatVaultList.ScrollFrame.setHeader(f)
	local scrollFrame = DetailsFramework:CreateScrollBox(f, "$parentScroll", GreatVaultList.ScrollFrame.RefreshScroll, GreatVaultList.db.global.characters, CONST_WINDOW_WIDTH, CONST_WINDOW_HEIGHT-70, GreatVaultList.db.global.greatvault_frame.lines, CONST_SCROLL_LINE_HEIGHT)
	DetailsFramework:ReskinSlider(scrollFrame)
	scrollFrame:CreateLines(GreatVaultList.ScrollFrame.CreateScrollLine, GreatVaultList.db.global.greatvault_frame.lines)
	scrollFrame:SetPoint("topleft", f.Header, "bottomleft", -1, -1)
	scrollFrame:SetPoint("topright", f.Header, "bottomright", 0, -1)
    --scrollFrame:Refresh()
	GreatVaultList.ScrollFrame.ScollFrame = scrollFrame;

	
end

function GreatVaultList.ScrollFrame.setHeader(f)

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
			GreatVaultList:sortEntries(columnHeader.key, columnHeader.order)
		end,
	}

	f.Header = DetailsFramework:CreateHeader(f, headerTable, headerOptions, "GreatVaultInfoFrameHeader")
	f.Header:SetPoint("topleft", f, "topleft", 3, -25)
    f.Header.columnSelected = 2
end


function GreatVaultList.ScrollFrame.setEmptyFieldStr(key, obj, col,   idx)
	local str = ""

	if col and idx then
		str = _.get(GreatVaultList.colConfig, {key, "emptyStr", idx})
	else 
		str = _.get(GreatVaultList.colConfig, {col, "emptyStr"})
	end

	if not str then return obj end

	obj[col].text = GRAY_FONT_COLOR_CODE .. str  ..  FONT_COLOR_CODE_CLOSE
	return obj

end


function GreatVaultList.ScrollFrame.RefreshScroll(self, data, offset, totalLines) 


	local function fillLine(key, value, line, data, idx)
		local col = idx and key .. idx or key
		local lineFn = value["refresh"]
		line = lineFn(line, data, idx)
		if not line[col].text then
			line = GreatVaultList.ScrollFrame.setEmptyFieldStr(key, line, col, idx)
		end
		return line
	end

	for i = 1, totalLines do
		local index = i + offset
		local data = data[index]
		if(data) then 
			local line = self:GetLine(i)
			-- highlicht current char
			local bg = (data.name == PlayerName) and backdrop_color_inparty or backdrop_color
			line:SetBackdropColor(unpack(bg))

			_.forEach(GreatVaultList.colConfig,function(value, key)
				if not value["refresh"] then return end
				if value["subCols"] then
					-- handle subcoluumn setup
					for i = 1, value["subCols"], 1 do
						line = fillLine(key, value, line, data, i)
					end
				else
					line = fillLine(key, value, line, data)
				end
			end)

		end
	end
end


function GreatVaultList.ScrollFrame.CreateScrollLine(self, lineId)
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
		if GreatVaultList.colConfig[value] and GreatVaultList.colConfig[value]["create"] then
			local lineFn = GreatVaultList.colConfig[value]["create"]
			line = lineFn(line)
		else
			local obj = DetailsFramework:CreateLabel(line)
			line[value] = obj
			line:AddFrameToHeaderAlignment(obj)
		end
	end

	line:AlignWithHeader(header, "left")
	return line
end















function GreatVaultList:SetupColumns()

	CONST_WINDOW_WIDTH = 300
	headerTable = {}
	headerTableConfig = {}

	local columnsTable = GreatVaultList.db.global.columns
	columnsTable = _.sortBy(columnsTable, function(a) 
		return a.position 
	end)

	table.sort(columnsTable, function (a, b)
		if a.position == b.position then
			return  a.key < b.key 
		end
		return a.position < b.position 
	end)

	local size = 1

	_.forEach(columnsTable, function(col) 
		if not col.active then return end

		local colstart = size 
		size = size + col.size

		local key = col.key
		local value = GreatVaultList.colConfig[col.key]

		if not value then return end

		-- sortConfig
		if value.sort then
			sortConfig[value.sort.key] = value.sort.store
		end

		if value.subCols then 
			if value.header then
				for idx = 1, value.subCols, 1 do
					local opt = shallowcopy(value.header)
					opt.key = key .. idx
					if idx > 1 then
						opt.text = ""
					end
					local pos = colstart + idx - 1
					table.insert(headerTable, pos, opt)
					table.insert(headerTableConfig, pos, opt.key)
				end
			end
		else
			-- headerTable
			if value.header then
				table.insert(headerTable, colstart, value.header)
				table.insert(headerTableConfig, colstart, col.key)
			end
		end
	
	end)


	local newheaderTableConfig = {}
	local newheaderTable =  {}
	local i = 0 
	for key, _ in pairs(headerTableConfig) do
		i = i + 1
		newheaderTableConfig[i] =  headerTableConfig[key]
		newheaderTable[i] =  headerTable[key]
	end

	headerTableConfig = newheaderTableConfig
	headerTable = newheaderTable



	local windowWidth = 0
	for _, value in ipairs(headerTable) do
		windowWidth = windowWidth + value.width
	end

	--frame options
	CONST_WINDOW_WIDTH = windowWidth + 30
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

			GreatVaultList:Initwindow()

			GreatVaultList:lala()	
			
        end)
    end
end








function GreatVaultList:lala()
-- DevTools_Dump(GreatVaultList.List)
	local  data = {}

	_.forEach(GreatVaultList.db.global.characters, function(entry, i)
		table.insert(data, {entry.class, entry.name, entry.averageItemLevel, entry.raid, entry.activities, entry.pvp,  entry.keystone })
	end)

	local cols = { "class", "character",  "ilevel", "raid", "activities", "pvp", "keystone"}
	GreatVaultListFrame.BrowseResultsFrame:init(cols, data, GreatVaultList.colConfig)

	--GreatVaultListFrame:SetHeight(CONST_WINDOW_HEIGHT)



end