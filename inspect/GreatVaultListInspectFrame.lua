



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



function InspectMixin:UpdateSize(width)
    self.width = width or self.width

    if not GreatVaultList.db then return  end 
    local height = (GreatVaultList.db.global.Options.lines * 21) + 60 + 19  + 7
    self:SetWidth(self.width + 5)
    self:SetHeight(height)
end








GreatVaultListInspectMixin = InspectMixin