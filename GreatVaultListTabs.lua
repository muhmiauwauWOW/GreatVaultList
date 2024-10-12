local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.Tabs = {}
GreatVaultList.Tabs.registeredTabs = {}

function GreatVaultList.Tabs:Add(id, name, template)
	GreatVaultList:assert(id, "GreatVaultList.Tabs:Add", 'Argument (id) missing')
	GreatVaultList:assert(name, "GreatVaultList.Tabs:Add", 'Argument (name) missing')
	GreatVaultList:assert(template, "GreatVaultList.Tabs:Add", 'Argument (template) missing')

	local findIndex = _.findIndex(GreatVaultListFrame.internalTabTracker.tabbedElements, function(tab, idx) return tab.id == id end)
	if findIndex  ~= -1 then
	
		for widget in GreatVaultListFrame.TabSystem.tabPool:EnumerateActive() do
			if widget.tabID == findIndex then
				widget:Show()
				break
			end
		end

		GreatVaultListFrame.TabSystem:MarkDirty();
		return 
	end	




	local frame = CreateFrame("Frame", "GreatVaultList_TabFrame_" .. id,GreatVaultListFrame, template)
	frame:Hide()
	GreatVaultListFrame:AddNamedTab(name, frame)

	
end

function GreatVaultList.Tabs:Remove(id)
	GreatVaultList:assert(id, "GreatVaultList.Tabs:Remove", 'Argument (id) missing')
	GreatVaultListFrame:RemoveTab(id)
end


GREATVAULTLIST_TABS = {
	OnInitialize = function(self)
		GreatVaultList.Tabs.registeredTabs[self.id] = self
		self.enabledState = GreatVaultList.db.global.Options.tabs[self.id].active
	end,
	OnEnable = function(self)
		if not GreatVaultList.db.global.Options.tabs[self.id].active then return end
		GreatVaultList.db.global.Options.tabs[self.id].active = true

		GreatVaultList.Tabs:Add(self.id, self.name, self.template)
	end,
	OnDisable = function(self)
		if GreatVaultList.db.global.Options.tabs[self.id].active then return end
		GreatVaultList.db.global.Options.tabs[self.id].active = false
		GreatVaultList.Tabs:Remove(self.id)
	end
}
