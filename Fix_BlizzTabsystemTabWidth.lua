local TabSideExtraSpacing = 40
function TabSystemButtonMixin:UpdateTabWidth()
	local minTabWidth, maxTabWidth = self:GetTabSystem():GetTabWidthConstraints();
	local strwidth = self.Text:GetUnboundedStringWidth() or minTabWidth
	strwidth = math.ceil(strwidth)
	local width = strwidth + TabSideExtraSpacing
	local textWidth = width;

	if maxTabWidth and width > maxTabWidth then
		width = maxTabWidth;
		textWidth = width - 10;
	end

	if minTabWidth and width < minTabWidth then
		width = minTabWidth;
		textWidth = width - 10;
	end

	self.Text:SetWidth(textWidth);
	self:SetTabWidth(width);
end