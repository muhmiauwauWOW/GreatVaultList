local addonName = ...
local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")

local ldb =  LibStub("LibDataBroker-1.1"):NewDataObject(AddOnInfo[2], {
	type = "data source",
	icon = C_AddOns.GetAddOnMetadata(addonName, "IconTexture"),
	OnClick = GreatVaultList_OnAddonCompartmentClick,
})
GreatVaultList.minimapIcon = LibStub("LibDBIcon-1.0")

function GreatVaultList:DataBrokerInit()
    GreatVaultList.minimapIcon:Register(addonName, ldb, self.db.global.Options.minimap)
end
