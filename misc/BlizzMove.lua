local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")

function GreatVaultList:BlizzMove()
    if BlizzMoveAPI then 
		GreatVaultListFrame.Drag:Hide()
		GreatVaultListInspectFrame.Drag:Hide()
		BlizzMoveAPI:RegisterAddOnFrames({
			["GreatVaultList"] = { 
				["GreatVaultListFrame"] = {},
				["GreatVaultListInspectFrame"] = {}
			},
		});
	else
		GreatVaultListFrame:SetScale(GreatVaultList.db.global.Options.scale)
		GreatVaultListInspectFrame:SetScale(GreatVaultList.db.global.Options.scale)
	end
end
