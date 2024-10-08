local addonName = ...
local L, _ = GreatVaultList:GetLibs()




local InspectMixin = CreateFromMixins(GreatVaultListLootListMixin);
GreatVaultListInspectMixin = InspectMixin

InspectMixin.tabName = string.format("Inspect")
InspectMixin.sortOrder = 1



function InspectMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
end

function InspectMixin:OnShow()
	GreatVaultListLootListMixin.OnShow(self)

	self.InspectText:SetText("lala")
end


function InspectMixin:BuildData(data)
    if not data then return end
	

    _.forEach(GreatVaultList.RegisterdModules, function(entry, key)
        self:AddColumn(entry.name)
    end)
    


	-- self:AddColumn(L["dungeonLoot_col1"])
	-- self:AddColumn(L["tabLoot_ilvl"], true, L["dungeonLoot_col2"])
	-- self:AddColumn(L["tabLoot_upgradelvl"], true, L["dungeonLoot_col2"])
	-- self:AddColumn(L["tabLoot_ilvl"], true, L["tabLoot_greatVault"])
	-- self:AddColumn(L["tabLoot_upgradelvl"], false, L["tabLoot_greatVault"])


	self.ItemList.data = {
        
	}

end


