local addonName = ...
local L, _ = GreatVaultList:GetLibs()




local InspectMixin = CreateFromMixins(GreatVaultListListMixin);
GreatVaultListInspectMixin = InspectMixin

InspectMixin.tabName = string.format("Inspect")
InspectMixin.sortOrder = 1



function InspectMixin:OnLoad()
	GreatVaultListListMixin.OnLoad(self)

    GreatVaultListFrame:HookScript("OnLoad", function() 
		GreatVaultListFrame:AddTabFn(self.tabName, self);
	end)
end

function InspectMixin:OnShow()
	GreatVaultListListMixin.OnShow(self)

end


function InspectMixin:SetSender(name)
	self.InspectText:SetText(name)
end


