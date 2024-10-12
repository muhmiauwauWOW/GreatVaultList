local addonName = ...

local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()
local BlizzMoveAPI = _G.BlizzMoveAPI


GreatVaultListOptions = {}


function GreatVaultListOptions:init()
    local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
    local category, layout = Settings.RegisterVerticalLayoutCategory(AddOnInfo[2])
    self.category = category
    self.layout = layout
    Settings.RegisterAddOnCategory(category)
    GreatVaultList.OptionsID = category:GetID()


    self:InitTabsCategory()
    -- Init columns category
    self:InitColumnCategory()




    local setting = Settings.RegisterAddOnSetting(self.category, "mninimaphide", "hide", GreatVaultList.db.global.Options.minimap, "boolean", L["opt_minimap_name"], GreatVaultList.db.global.Options.minimap.hide)
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
        local setting = Settings.RegisterAddOnSetting(self.category, "scale", "scale", GreatVaultList.db.global.Options, "number", L["opt_scale_name"], 1)
        setting:SetValueChangedCallback(function(self) GreatVaultListFrame:SetScale(self:GetValue()) end)

        local function FormatScaledPercentage(value)
            return FormatPercentage(value);
        end

        local options = Settings.CreateSliderOptions(.4, 2, .01)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, FormatScaledPercentage);
        Settings.CreateSlider(self.category, setting, options, L["opt_scale_desc"])
    end

    -- lines
    local setting = Settings.RegisterAddOnSetting(category, "lines", "lines", GreatVaultList.db.global.Options, "number", L["opt_lines_name"], 12)
    setting:SetValueChangedCallback(function(self)
        GreatVaultListFrame:UpdateSize()
    end)
  
    local options = Settings.CreateSliderOptions(4, 24, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(self.category, setting, options, L["opt_lines_desc"])











    


    self.layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Modules"));

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


  
    

    local setting = Settings.RegisterAddOnSetting(self.category, "modules", "modules", GreatVaultList.db.global.Options, "table", L["opt_column_order_name"], default)

    setting:SetValueChangedCallback(function(self)
        local value = self:GetValue()
        for name, module in GreatVaultList:IterateModules() do
            local mode = value[name].active
            if value[name].active ~=  module.enabledState  then
                if mode then
                    module:Enable()
                else
                    module:Disable()
                end
            end
         end
    end)


    Settings.CreateColumnOrder(self.category, setting,  options,  L["opt_column_order_desc"])

    -- Settings.OpenToCategory(GreatVaultList.OptionsID)
    -- Settings.OpenToCategory(GreatVaultList.OptionsID)
end






function GreatVaultListOptions:InitTabsCategory()
    self.TabsSubcategory = Settings.RegisterVerticalLayoutSubcategory(self.category, "Tabs");
    self.tabsSubcategories = {}

    _.forEach(GreatVaultList.Tabs.registeredTabs, function(entry, id)
        local name = entry.name
        local category = Settings.RegisterVerticalLayoutSubcategory(self.TabsSubcategory, name);
        Settings.RegisterAddOnCategory(category);
        self.tabsSubcategories[id] = category

        local setting = Settings.RegisterAddOnSetting(self.tabsSubcategories[id], id .. "active", "active", GreatVaultList.db.global.Options.tabs[id], "boolean", L["opt_tab_actve_name"], true)
        setting:SetValueChangedCallback(function(self)
            local value = self:GetValue()
            print("value", value, entry:IsEnabled())
            if value then 
                entry:Enable()
            else 
                entry:Disable()
            end

        end)
        Settings.CreateCheckbox(self.tabsSubcategories[id], setting, L["opt_tab_actve_desc"])

        local tabFrame = _G["GreatVaultList_TabFrame_"..id]
        if tabFrame.AddConfig then
            tabFrame:AddConfig(self.tabsSubcategories[id])
        end

    end)
end





function GreatVaultListOptions:InitColumnCategory()
    self.ColumnsSubcategory = Settings.RegisterVerticalLayoutSubcategory(self.category,  L["opt_category_columns"]);
    self.columnsSubcategories = {}
end



function GreatVaultListOptions:AddColumnCategory(entry)

    local name = string.format("%s (%s)", entry.name, entry.id)
    local category = Settings.RegisterVerticalLayoutSubcategory(self.ColumnsSubcategory, name);
    Settings.RegisterAddOnCategory(category);
    self.columnsSubcategories[entry.id] = category
end