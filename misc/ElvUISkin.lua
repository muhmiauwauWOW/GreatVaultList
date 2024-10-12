local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")

-- support for all the ELVUI fanbois out there
function GreatVaultList:ElvUISkin()
    if not C_AddOns.IsAddOnLoaded("ElvUI") then return end
	
	local E, L, V, P, G = unpack(ElvUI)
	local S = E:GetModule("Skins")

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

	
	local function HandleSellList(frame)
		frame:StripTextures()
		frame:SetTemplate('Transparent')

		S:HandleTrimScrollBar(frame.ScrollBar)
		frame.ScrollBar:ClearAllPoints()
		frame.ScrollBar:Point('TOPRIGHT', frame, -10, -16)
		frame.ScrollBar:Point('BOTTOMRIGHT', frame, -10, 16)

		hooksecurefunc(frame, 'RefreshScrollFrame', HandleHeaders)
	end
	HandleSellList(GreatVaultListFrame.ListFrame.ItemList)
	HandleSellList(GreatVaultListFrame.RaidLootList.ItemList)
	HandleSellList(GreatVaultListFrame.DungeonLootList.ItemList)
	HandleSellList(GreatVaultListFrame.DelvesLootList.ItemList)
end