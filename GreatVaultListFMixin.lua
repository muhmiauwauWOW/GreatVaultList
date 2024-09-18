local addonName = ...
local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
local L, _ = GreatVaultList:GetLibs()


GreatVaultListMixin = {}


function GreatVaultListMixin:OnLoad()
	TabSystemOwnerMixin.OnLoad(self);
	self:SetTabSystem(self.TabSystem);
	self:AddTabFn("List", self.ListFrame);
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


function GreatVaultListMixin:AddTabFn(key, ...)
    self:AddNamedTab(key, ...);
end


function GreatVaultListMixin:UpdateSize(width)
    self.width = width or self.width

	local tabsWidth = self.TabSystem:GetWidth() + 50
	self.width = tabsWidth > self.width and tabsWidth or self.width

    if not GreatVaultList.db then return  end 
    local height = (GreatVaultList.db.global.Options.lines * 21) + 60 + 19  + 7
    self:SetWidth(self.width)
    self:SetHeight(height)
end


function GreatVaultListMixin:OnHide()
end


function GreatVaultListMixin:RefreshScrollFrame()
	self.ListFrame.ItemList:RefreshScrollFrame();
end



function GreatVaultListMixin:GetState()
	if C_WeeklyRewards.HasAvailableRewards() then
		return "collect";
	end

	local rewardCheck = false
	_.forEach(Enum.WeeklyRewardChestThresholdType, function(type)
		if rewardCheck then return end
		rewardCheck = WeeklyRewardsUtil.HasUnlockedRewards(type)
	end)

	if rewardCheck then
		return "complete";
	end

	return "incomplete";
end