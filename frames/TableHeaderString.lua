local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()



local TableHeaderStringMixin = CreateFromMixins(TableBuilderElementMixin);
GreatVaultListTableHeaderStringMixin = TableHeaderStringMixin



function TableHeaderStringMixin:OnClick()
	if not self.interactiveHeader then return end
	self.owner:SetSortOrder(self.sortOrder);
end

function TableHeaderStringMixin:OnEnter()
	if not self.tooltip then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	if type(self.tooltip) == "table" then 
		GameTooltip_SetTitle(GameTooltip, self.tooltip.title);
		GameTooltip:AddLine(self.tooltip.desc);
	else
		GameTooltip:AddLine(self.tooltip);
	end
	GameTooltip:Show();
end
function TableHeaderStringMixin:OnLeave()
	if not self.tooltip then return end
	GameTooltip:Hide();
end


function TableHeaderStringMixin:Init(owner, headerText, sortOrder, tooltip)
	self:SetText(headerText);

	local find = _.find(owner.sortHeaders, function(entry) return entry == sortOrder; end)
	self.interactiveHeader = owner.RegisterHeader and find;
	self.tooltip = tooltip
	self.owner = owner;
	self.sortOrder = sortOrder;

	

	if self.interactiveHeader then
		owner:RegisterHeader(self);
		self:UpdateArrow();
	else
		self:ClearHighlightTexture()
		self:ClearPushedTexture()
		self:SetPushedTextOffset(0, 0)
		self.Arrow:Hide();
	end
end

function TableHeaderStringMixin:UpdateArrow(reverse)
	if self.owner.sort == self.sortOrder then 
		self:SetArrowState(reverse)
		self.Arrow:Show();
	else 
		self.Arrow:Hide();
	end
end

function TableHeaderStringMixin:SetArrowState(reverse)
	if reverse then
		self.Arrow:SetTexCoord(0, 1, 1, 0);
	else 
		self.Arrow:SetTexCoord(0, 1, 0, 1);
	end
end