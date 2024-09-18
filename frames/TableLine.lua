local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

local TableLineMixin = {}
GreatVaultListTableLineMixin = TableLineMixin

function TableLineMixin:OnEnter()
	self.HighlightTexture:Show();
end
function TableLineMixin:OnLeave()
	self.HighlightTexture:Hide();
end