local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

local InspectMixin = {}


function InspectMixin:OnLoad()
	self:SetPortraitTextureRaw("Interface\\AddOns\\GreatVaultList\\vault.png")
	self:GetPortrait():ClearAllPoints()
	self:GetPortrait():SetPoint("TOPLEFT", -2, 5)
	self:GetPortrait():SetSize(55, 55)

	self:SetTitle(GreatVaultList.AddOnInfo[2] .. " Inspect") -- set addon name as title


    local dragarea = self.Drag
    dragarea:RegisterForDrag("LeftButton")
    dragarea:SetScript("OnDragStart", function(s, button)
        self:StartMoving()
    end)

    dragarea:SetScript("OnDragStop", function(s)
        self:StopMovingOrSizing()
    end)

	tinsert(UISpecialFrames, self:GetName())
end


function InspectMixin:OnShow()
    self:UpdateSize();
end


function InspectMixin:UpdateSize()
    self.width = math.max(GreatVaultListFrame:GetWidth(), 600)

    -- self:SetScale(2)

    if not GreatVaultList.db then return end 
    local height = (GreatVaultList.db.global.Options.lines * 21) + 60 + 19  + 7
    self:SetWidth(self.width)
    self:SetHeight(height)
end



function InspectMixin:ShowLoading()
    self.InspectText:Hide()
    self.ListFrame:Hide()
    self.DarkOverlay:Show()
    self.LoadingSpinner:Show()
    self:Show()
end

function InspectMixin:HideLoading()
    self.ListFrame:Show()
    self.InspectText:Show()
    self.DarkOverlay:Hide()
    self.LoadingSpinner:Hide()
 end



 function InspectMixin:updateData(name, payload)
	if _.size(payload) == 0 then return end -- fail silent

	GreatVaultList:updateModuleConfig()
    local colConfig, cols = GreatVaultList:getColConfigforTableDisplay()
    local data = GreatVaultList:getCharaterDataforTableDisplay(payload, false)

	self.InspectText:SetText(name)
	self.ListFrame:init(cols, data, colConfig, true)
end





GreatVaultListInspectMixin = InspectMixin