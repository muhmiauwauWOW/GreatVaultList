local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.ElvUi = {}

-- support for all the ELVUI fanbois out there
function GreatVaultList.ElvUi:Init()
    if not C_AddOns.IsAddOnLoaded("ElvUI") then return end
	
	local E, L, V, P, G = unpack(ElvUI)
	local S = E:GetModule("Skins")
	self.S = S

	GreatVaultListFrame:StripTextures()
	GreatVaultListFrame:SetTemplate("Transparent")

	S:HandleCloseButton(GreatVaultListFrameCloseButton)
	

	for _, tab in next, {GreatVaultListFrame.TabSystem:GetChildren() } do
		S:HandleTab(tab)
	end

	GreatVaultListFrame.TabSystem:ClearAllPoints()
	GreatVaultListFrame.TabSystem:Point('TOPLEFT', PlayerSpellsFrame, 'BOTTOMLEFT', -3, 0)


	S:HandleEditBox(GreatVaultListFrame.ListFrame.Search)
	S:HandleButton(GreatVaultListFrame.ListFrame.Filter)


	
	local function HandleHeaders(frame)
		local maxHeaders = frame.HeaderContainer:GetNumChildren()
		for i, header in next, { frame.HeaderContainer:GetChildren() } do
			if not header.IsSkinned then
				header:DisableDrawLayer('BACKGROUND')

				if not header.backdrop then
					header:CreateBackdrop('Transparent')
				end

				header.IsSkinned = true
			end

			if header.backdrop then
				header.backdrop:Point('BOTTOMRIGHT', i < maxHeaders and -5 or 0, -2)
			end
		end
	end


	self.HandleSellList = function(self, frame)
		frame:StripTextures()
		frame:SetTemplate('Transparent')

		S:HandleTrimScrollBar(frame.ScrollBar)
		frame.ScrollBar:ClearAllPoints()
		frame.ScrollBar:Point('TOPRIGHT', frame, -10, -16)
		frame.ScrollBar:Point('BOTTOMRIGHT', frame, -10, 16)

		hooksecurefunc(frame, 'RefreshScrollFrame', HandleHeaders)
	end


	self:HandleSellList(GreatVaultListFrame.ListFrame.ItemList)
end


function GreatVaultList.ElvUi:AddTab(tab)
	if not C_AddOns.IsAddOnLoaded("ElvUI") then return end
	if not tab then return end
	self:HandleSellList(tab.ItemList)
    for widget in GreatVaultListFrame.TabSystem.tabPool:EnumerateActive() do
		self.S:HandleTab(widget)
    end
end