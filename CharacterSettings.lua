local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultListCharacterSettingsMixin = CreateFromMixins(SettingsControlMixin)

function GreatVaultListCharacterSettingsMixin:OnLoad()
    SettingsControlMixin.OnLoad(self)
    self.ShowCheckbox:SetScript("OnClick", function(button)
        self:OnShowClick()
    end)
    self.Ignore:SetScript("OnClick", function(button)
        self:OnIgnoreClick()
    end)
    self.Delete:SetScript("OnClick", function(button)
        self:OnDeleteClick()
    end)
end

function GreatVaultListCharacterSettingsMixin:Init(initializer)
    SettingsControlMixin.Init(self, initializer)

    self.characterKey = initializer:GetOptions()
    self.setting = self:GetSetting()
    self.character = self.setting:GetValue()
    self:SetHeight(44)
    self:UpdateDisplay()
end

function GreatVaultListCharacterSettingsMixin:UpdateDisplay()
    local character = self.character or {}
    self.ShowLabel:SetText(L["opt_CharacterList_show"])
    self.IgnoreLabel:SetText(L["opt_CharacterList_ignore"])
    self.Delete:SetText(L["opt_CharacterList_delete"])
    self.ShowCheckbox:SetChecked(character.enabled ~= false)
    self.Ignore:SetChecked(character.ignored == true)
end

function GreatVaultListCharacterSettingsMixin:SetCharacterValue(key, value)
    local character = self.setting:GetValue()
    character[key] = value
    self.character = character
    self.setting:SetValue(character)
    self:UpdateDisplay()
    GreatVaultList:updateData(true)
end

function GreatVaultListCharacterSettingsMixin:OnShowClick()
    self:SetCharacterValue("enabled", self.ShowCheckbox:GetChecked())
end

function GreatVaultListCharacterSettingsMixin:OnIgnoreClick()
    self:SetCharacterValue("ignored", self.Ignore:GetChecked())
end

function GreatVaultListCharacterSettingsMixin:OnDeleteClick()
    local characterName = self.character.name or self.characterKey
    StaticPopupDialogs["GreatVaultListCharacterSettings_DELETE"] = {
        text = string.format(L["opt_CharacterList_delete_confirm"], characterName),
        button1 = YES,
        button2 = NO,
        OnAccept = function()
            GreatVaultList.db.global.characters[self.characterKey] = nil
            self:Hide()
            self:SetHeight(0)
            GreatVaultList:updateData(true)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
    StaticPopup_Show("GreatVaultListCharacterSettings_DELETE")
end

function GreatVaultListCharacterSettingsMixin:OnSettingValueChanged(setting, value)
    SettingsControlMixin.OnSettingValueChanged(self, setting, value)
    self.character = value
    self:UpdateDisplay()
end
