local addonName = ...
local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
local L, _ = GreatVaultList:GetLibs()


GreatVaultListMixin = {}


function GreatVaultListMixin:OnLoad()
	TabSystemOwnerMixin.OnLoad(self);
	self:SetTabSystem(self.TabSystem);
	self:AddNamedTab("List", self.ListFrame);
	self:SetTab(1)


	self:SetPortraitTextureRaw("Interface\\AddOns\\GreatVaultList\\vault.png")
	self:GetPortrait():ClearAllPoints()
	self:GetPortrait():SetPoint("TOPLEFT", -2, 5)
	self:GetPortrait():SetSize(55, 55)

	self:SetTitle(AddOnInfo[2]) -- set addon name as title

    self.width = 800

    local dragarea = GreatVaultListFrame.Drag
    GreatVaultListFrame:SetMovable(true)
    GreatVaultListFrame:EnableMouse(true)
    dragarea:EnableMouse(true)
    dragarea:RegisterForDrag("LeftButton")
    dragarea:SetScript("OnDragStart", function(self, button)
        GreatVaultListFrame:StartMoving()
    end)

    dragarea:SetScript("OnDragStop", function(self)
        GreatVaultListFrame:StopMovingOrSizing()
    end)

	tinsert(UISpecialFrames, self:GetName())

end

function GreatVaultListMixin:OnShow()
    self:UpdateSize();
    self.ListFrame.ItemList:RefreshScrollFrame();
end


function GreatVaultListMixin:RemoveTab(id)
    local findIndex = _.findIndex(self.internalTabTracker.tabbedElements, function(tab, idx) return tab.id == id end)
    if findIndex  == -1 then return end


    -- DevTool:AddData(self.internalTabTracker.tabbedElements[findIndex])
    -- self.internalTabTracker.tabbedElements[findIndex]:Hide()
    -- table.remove(self.internalTabTracker.tabbedElements, findIndex)
    -- table.remove(self.TabSystem.tabs, findIndex)


    for widget in self.TabSystem.tabPool:EnumerateActive() do
        if widget.tabID == findIndex then
            widget:Hide()
            -- self.TabSystem.tabPool:Release(widget)
        end
    end

    self.TabSystem:MarkDirty();
    self:SetTab(1)
end


function GreatVaultListMixin:UpdateSize(width)
    self.width = width or self.width

	local tabsWidth = self.TabSystem:GetWidth() + 50
	self.width = math.max(tabsWidth, self.width)

    if not GreatVaultList.db then return  end 
    local height = (GreatVaultList.db.global.Options.lines * 21) + 60 + 19  + 7
    self:SetWidth(self.width + 5)
    self:SetHeight(height)
end


function GreatVaultListMixin:OnHide()
    HelpPlate_Hide();
end

function GreatVaultListMixin:RefreshScrollFrame()
	self.ListFrame.ItemList:RefreshScrollFrame();
end