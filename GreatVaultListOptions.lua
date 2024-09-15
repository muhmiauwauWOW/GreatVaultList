local addonName = ...

local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()
local BlizzMoveAPI = _G.BlizzMoveAPI


GreatVaultListOptions = {}



function GreatVaultListOptions:init()
    local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
    local category, layout = Settings.RegisterVerticalLayoutCategory(AddOnInfo[2])
    Settings.RegisterAddOnCategory(category)
    GreatVaultList.OptionsID = category:GetID()




    -- local setting = Settings.RegisterAddOnSetting(category, "mninimaphide", "hide", GreatVaultList.db.global.Options.minimap, "boolean", L["opt_minimap_name"], GreatVaultList.db.global.Options.minimap.hide)
    -- setting:SetValueChangedCallback(function(self)
    --     if self:GetValue() then 
    --         GreatVaultList.minimapIcon:Hide(addonName)
    --     else 
    --         GreatVaultList.minimapIcon:Show(addonName)
    --     end
    -- end)

    -- Settings.CreateCheckbox(category, setting, L["opt_minimap_desc"])



    -- scale
    if not BlizzMoveAPI then 
        local setting = Settings.RegisterAddOnSetting(category, "scale", "scale", GreatVaultList.db.global.Options, "number", L["opt_scale_name"], 1)
        setting:SetValueChangedCallback(function(self) GreatVaultListFrame:SetScale(self:GetValue()) end)

        local function FormatScaledPercentage(value)
            return FormatPercentage(value);
        end
        local options = Settings.CreateSliderOptions(.4, 2, .01)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, FormatScaledPercentage);
        Settings.CreateSlider(category, setting, options, L["opt_scale_desc"])
    end

    -- lines
    local setting = Settings.RegisterAddOnSetting(category, "lines", "lines", GreatVaultList.db.global.Options, "number", L["opt_lines_name"], 12)
    setting:SetValueChangedCallback(function(self)
        GreatVaultListFrame:UpdateSize()
    end)


  
    local options = Settings.CreateSliderOptions(4, 24, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(category, setting, options, L["opt_lines_desc"])

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Modules"));



    local modules = GreatVaultList:IterateModules()
    for name, module in GreatVaultList:IterateModules() do
    
        local cbSetting = Settings.RegisterAddOnSetting(self.category, "moduleactive"..name, "active", GreatVaultList.db.global.Options.modules[name], "boolean", name, true)
        local sliderSetting = Settings.RegisterAddOnSetting(self.category, "moduleindex"..name, "index", GreatVaultList.db.global.Options.modules[name], "number", name, module.config.index)


        cbSetting:SetValueChangedCallback(function(self)
            local value = self:GetValue()


            if value == true then 
                module:Enable()
            else 
                module:Disable()
            end
            
            GreatVaultList:updateData()
        end)

        sliderSetting:SetValueChangedCallback(function(self)
            GreatVaultList:updateData()
        end)

        local options = Settings.CreateSliderOptions(0, 10, 1)
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    

        
        local initializer = CreateSettingsCheckboxSliderInitializer(
                cbSetting, string.format(L["opt_module_name"], module.key), L["opt_module_desc"],
                sliderSetting, options, L["opt_position_name"], L["opt_position_desc"]
        );
        layout:AddInitializer(initializer);

    end
end