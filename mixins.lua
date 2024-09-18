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




GreatVaultListListOpenVaultMixin = {}

function GreatVaultListListOpenVaultMixin:OnShow()
	local state = self:GetParent():GetParent():GetState()

	self.NormalTexture:SetShown(state ~= "incomplete");
	self.handlesTexture:SetShown(state == "incomplete");
	self.centerPlateTexture:SetShown(state == "incomplete");
	self.NormalTexture:SetDesaturated(state ~= "collect");
end

function GreatVaultListListOpenVaultMixin:OnClick()
	WeeklyRewardsFrame:SetShown(not WeeklyRewardsFrame:IsShown());
end













GreatVaultListListSearchBoxMixin = {}


function GreatVaultListListSearchBoxMixin:OnLoad()
	SearchBoxTemplate_OnLoad(self);
	self.clearButton:SetScript("OnClick", function(btn)
		self:Reset()
		SearchBoxTemplateClearButton_OnClick(btn);
	end)
end

function GreatVaultListListSearchBoxMixin:OnEnterPressed()
	self:GetParent():UpdateFilteredData(self:GetText())
	self:GetParent().ItemList:RefreshScrollFrame();
end

function GreatVaultListListSearchBoxMixin:Reset()
	self:SetText("");
	self:GetParent():UpdateFilteredData()
	self:GetParent().ItemList:RefreshScrollFrame();
end


GreatVaultListListFilterMixin = {}

function GreatVaultListListFilterMixin:OnLoad()
	WowStyle1FilterDropdownMixin.OnLoad(self);
	self.init = false
end

function GreatVaultListListFilterMixin:OnShow()
	if self.init then return end
	self.init = true

	local function IsSelected(filter)
		local find = _.find(GreatVaultList.db.global.characters, function(entry)
			return entry.name == filter
		end)
		if find == nil then return  end
		if find.enabled == nil then return true end
		return find.enabled;
	end
	
	local function SetSelected(filter)
		local find = _.find(GreatVaultList.db.global.characters, function(entry) return entry.name == filter end)

		find.enabled = not find.enabled
		local findItemList = _.find(self:GetParent().data, function(entry) return entry.name == filter end)

		findItemList.enabled = find.enabled
		self:GetParent():UpdateFilteredData()
		self:GetParent().ItemList:RefreshScrollFrame();
		self:GetParent().Search:Reset();
	end

	self:SetupMenu(function(dropdown, rootDescription)
		rootDescription:SetTag("MENU_GREATVAULTLIST_FILTER");
		_.forEach(GreatVaultList.db.global.characters, function(char, key)
			rootDescription:CreateCheckbox(char.name, IsSelected, SetSelected, char.name);
		end)
	end);
end