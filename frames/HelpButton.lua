local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

local HelpButtonMixin = {}
GreatVaultListListHelpButtonMixin = HelpButtonMixin





function HelpButtonMixin:OnClick()
    if self.timer then self.timer:Cancel() end

    local parent = self:GetParent()

    if not self.helpPlate then 
        self.helpPlate = self:GetHelpConfig()
    end
    
	if ( self.helpPlate and not HelpPlate_IsShowing( self.helpPlate ) ) then
		HelpPlate_Show( self.helpPlate, parent, self)
        HelpPlate:SetScale(GreatVaultListFrame:GetScale())
	else
		HelpPlate_Hide(true);
        self.timer = C_Timer.NewTimer(1, function()
            self.timer:Cancel()
            HelpPlate:SetScale(1)
        end)
       
	end
end


function HelpButtonMixin:GetHelpConfig()
    local parent = self:GetParent()
    GreatVaultList:assert(parent.GetHelpConfig, "HelpButtonMixin:GetHelpConfig", "No help defined")
    local helpConfig = parent:GetHelpConfig();
    -- DevTool:AddData(helpConfig, "helpConfig")
     _.map(helpConfig, function(entry, key)
        if type(key) ~= "number" then return end
        if not entry.ButtonPos then return end
        if not entry.HighLightBox then return end
        if not entry.ButtonPos.position then return end

        local box = entry["HighLightBox"]
        local x = 0
        local y = box.y - (box.height/2) + (46/2)

        if entry.ButtonPos.position == "CENTER" then 
            x = box.x + (box.width/2) - (46/2)
        elseif entry.ButtonPos.position == "LEFT" then 
            x = box.x  - (46/2)
        elseif entry.ButtonPos.position == "RIGHT" then 
            x = box.x + box.width  - (46/2)
        end

        entry.ButtonPos = {
            x =x,
            y = y
        }

        return entry
    end)

    return helpConfig

end