local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()


GreatVaultListOptions = {}



function GreatVaultListOptions:init()
    local category, layout = Settings.RegisterVerticalLayoutCategory("Great Vault List")
    Settings.RegisterAddOnCategory(category)
    self.layout = layout
    self.category = category

    

    GreatVaultList.OptionsID = category:GetID()


    -- local setting = Settings.RegisterAddOnSetting(self.category, "checkboxi", "checkboxi", OptionTbl, type(false), "testi checki", false)
    -- setting:SetValueChangedCallback(valueChangedCallback)
	-- Settings.CreateCheckbox(self.category, setting, "tooltip?")



    local setting = Settings.RegisterAddOnSetting(self.category, "lines", "lines", GreatVaultList.db.global.Options, "number", L["opt_lines_name"], 12)
    setting:SetValueChangedCallback(function(self)
        GreatVaultListFrame:UpdateSize()
    end)
  
    local options = Settings.CreateSliderOptions(4, 24, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
    Settings.CreateSlider(self.category, setting, options, L["opt_lines_desc"])

    self.layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Modules"));



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
                cbSetting, module.key, "",
                sliderSetting, options, "Index", ""
        );
        layout:AddInitializer(initializer);

    end
end