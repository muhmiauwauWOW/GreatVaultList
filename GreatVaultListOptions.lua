local addonName = ...

local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()
local BlizzMoveAPI = _G.BlizzMoveAPI


GreatVaultListOptions = {}



function GreatVaultListOptions:init()
    local AddOnInfo = { C_AddOns.GetAddOnInfo(addonName) }
    local category, layout = Settings.RegisterVerticalLayoutCategory(AddOnInfo[2])
    self.category = category
    self.layout = layout
    Settings.RegisterAddOnCategory(category)
    GreatVaultList.OptionsID = category:GetID()

    self:InitCharacterCategory()

    -- Init columns category
    self:InitColumnCategory()
    -- Init Tabs category
    self:InitTabsCategory()

    local setting = Settings.RegisterAddOnSetting(self.category, "mninimaphide", "hide",
        GreatVaultList.db.global.Options.minimap, "boolean", L["opt_minimap_name"],
        GreatVaultList.db.global.Options.minimap.hide)
    setting:SetValueChangedCallback(function(self)
        if self:GetValue() then
            GreatVaultList.minimapIcon:Hide(addonName)
        else
            GreatVaultList.minimapIcon:Show(addonName)
        end
    end)
    Settings.CreateCheckbox(self.category, setting, L["opt_minimap_desc"])

    -- scale
    if not BlizzMoveAPI then
        local setting = Settings.RegisterAddOnSetting(self.category, "scale", "scale", GreatVaultList.db.global.Options,
            "number", L["opt_scale_name"], 1)
        setting:SetValueChangedCallback(function(self) GreatVaultListFrame:SetScale(self:GetValue()) end)
        local function FormatScaledPercentage(value)
            return FormatPercentage(value)
        end
        local options = Settings.CreateSliderOptions(.4, 2, .01)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, FormatScaledPercentage)
        Settings.CreateSlider(self.category, setting, options, L["opt_scale_desc"])
    end

    -- lines
    local setting = Settings.RegisterAddOnSetting(category, "lines", "lines", GreatVaultList.db.global.Options, "number",
        L["opt_lines_name"], 12)
    setting:SetValueChangedCallback(function(self) GreatVaultListFrame:UpdateSize() end)
    local options = Settings.CreateSliderOptions(4, 24, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    Settings.CreateSlider(self.category, setting, options, L["opt_lines_desc"])

    GreatVaultList.ElvUi:AddOption(self.category)

    do
        local function onButtonClick()
            local keybindsCategory = SettingsPanel:GetCategory(Settings.KEYBINDINGS_CATEGORY_ID)
            local keybindsLayout = SettingsPanel:GetLayout(keybindsCategory)
            for _, initializer in keybindsLayout:EnumerateInitializers() do
                if initializer.data.name == BINDING_HEADER_GreatVaultList then
                    initializer.data.expanded = true
                    Settings.OpenToCategory(Settings.KEYBINDINGS_CATEGORY_ID, BINDING_HEADER_GreatVaultList)
                    return
                end
            end
        end
        local initializer = CreateSettingsButtonInitializer("", SETTINGS_KEYBINDINGS_LABEL, onButtonClick, nil, false)
        layout:AddInitializer(initializer)
    end

    --@do-not-package@
	-- Settings.OpenToCategory(GreatVaultList.OptionsID)
	--@end-do-not-package@
end

function GreatVaultListOptions:InitCharacterCategory()
    -- Character List
    self.CharacterSubcategory = Settings.RegisterVerticalLayoutSubcategory(self.category, L["opt_CharacterList_title"])
    Settings.RegisterAddOnCategory(self.CharacterSubcategory)
    local characterLayout = SettingsPanel:GetLayout(self.CharacterSubcategory)

    local characters = {}
    _.forEach(GreatVaultList.db.global.characters, function(entry, key)
        if entry.enabled == nil then entry.enabled = true end
        table.insert(characters, { key = key, entry = entry })
    end)
    sort(characters, function(left, right)
        local leftRealm = left.entry.normalizedRealm or left.entry.realm or ""
        local rightRealm = right.entry.normalizedRealm or right.entry.realm or ""
        if leftRealm ~= rightRealm then
            return leftRealm < rightRealm
        end
        return (left.entry.name or left.key) < (right.entry.name or right.key)
    end)

    local currentRealm
    _.forEach(characters, function(character)
        local realmName = character.entry.normalizedRealm or character.entry.realm
        if not realmName or realmName == "" then
            realmName = L["opt_CharacterList_unknown_realm"]
        end
        if realmName ~= currentRealm then
            characterLayout:AddInitializer(CreateSettingsListSectionHeaderInitializer(realmName))
            currentRealm = realmName
        end

        local setting = Settings.RegisterAddOnSetting(
            self.category,
            "character_" .. character.key,
            "character_" .. character.key,
            character.entry,
            "table",
            character.entry.name or character.key,
            character.entry
        )
        characterLayout:AddInitializer(Settings.CreateControlInitializer(
            "GreatVaultListCharacterSettingsTemplate",
            setting,
            character.key
        ))
    end)
end

function GreatVaultListOptions:InitTabsCategory()
    self.TabsSubcategory = Settings.RegisterVerticalLayoutSubcategory(self.category, L["Tabs"]);
    self.tabsSubcategories = {}

    _.forEach(GreatVaultList.Tabs.registeredTabs, function(entry, id)
        local name = entry.name

        local checkboxName = string.format(L["opt_tab_actve_name"], name, id)
        local checkboxTooltip = string.format(L["opt_tab_actve_desc"], name, id)

        local setting = Settings.RegisterAddOnSetting(self.TabsSubcategory, id .. "active", "active",
            GreatVaultList.db.global.Options.tabs[id], "boolean", checkboxName, true)
        setting:SetValueChangedCallback(function(self)
            local value = self:GetValue()
            if value then
                entry:Enable()
            else
                entry:Disable()
            end
        end)

        Settings.CreateCheckbox(self.TabsSubcategory, setting, checkboxTooltip)

        -- add tab spezific optionsTable
        local tabFrame = _G["GreatVaultList_TabFrame_" .. id]
        if not tabFrame then return end
        if tabFrame.AddOptions then
            local category = Settings.RegisterVerticalLayoutSubcategory(self.TabsSubcategory, name);
            Settings.RegisterAddOnCategory(category);
            self.tabsSubcategories[id] = category

            tabFrame:AddOptions(self.tabsSubcategories[id])
        end
    end)
end

function GreatVaultListOptions:InitColumnCategory()
    self.ColumnsSubcategory = Settings.RegisterVerticalLayoutSubcategory(self.category, L["opt_category_columns"]);
    self.columnsSubcategories = {}

    local default = {}
    local options = {}
    _.forEach(GreatVaultList.RegisterdModules, function(entry, key)
        default[key] = {
            active = entry.active,
            index = entry.index,
            id = entry.id
        }

        options[key] = {
            id = entry.id,
            name = entry.name
        }

        self:AddColumnCategory(entry)
    end)


    local changesModules = CopyTable(GreatVaultList.db.global.Options.modules)


    local setting = Settings.RegisterAddOnSetting(self.ColumnsSubcategory, "modules", "modules",
        GreatVaultList.db.global.Options, "table", L["opt_column_order_name"], default)


    setting:SetValueChangedCallback(function(self)
        local value = self:GetValue()
        if not value then return end

        _.forEach(GreatVaultList.RegisterdModules, function(entry, name)
            local module = entry.module
            local mode = value[name].active

            if changesModules[name].active ~= mode then
                if mode then
                    module:Enable()
                else
                    module:Disable()
                end
            end
        end)

        GreatVaultList:updateData(true)
        changesModules = CopyTable(GreatVaultList.db.global.Options.modules)
    end)

    Settings.CreateColumnOrder(self.ColumnsSubcategory, setting, options, L["opt_column_order_desc"])
end

function GreatVaultListOptions:AddColumnCategory(entry)
    local module = entry.module
    if not module.AddOptions then return end
    local name = entry.name

    local category = Settings.RegisterVerticalLayoutSubcategory(self.ColumnsSubcategory, name);
    Settings.RegisterAddOnCategory(category);
    self.columnsSubcategories[entry.id] = category

    if not GreatVaultList.db.global.Options.columns[module.key] or type(GreatVaultList.db.global.Options.columns[module.key]) ~= "table" then
        GreatVaultList.db.global.Options.columns[module.key] = {}
    end
    module:AddOptions(category, GreatVaultList.db.global.Options.columns[module.key])
end
