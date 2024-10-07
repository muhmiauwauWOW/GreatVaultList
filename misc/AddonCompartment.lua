local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")

function GreatVaultList_OnAddonCompartmentClick(addonName, buttonName)
    if buttonName == "RightButton" then
        Settings.OpenToCategory(GreatVaultList.OptionsID)
    else
        GreatVaultList:toggleWindow()
    end
end
