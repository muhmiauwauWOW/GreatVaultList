local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.Util = {}

-- baseilvl number - base itemlevel
-- ilvl number - itemlevel for output
-- addMod number - gradient offset
-- diffMod number - gradient size
function GreatVaultList.Util:colorItemLvl(baseilvl, ilvl, addMod, diffMod)

    local function ColorGradient(perc, r1, g1, b1, r2, g2, b2)
        if perc >= 1 then
            local r, g, b = r2, g2, b2
            return r, g, b
        elseif perc <= 0 then
            local r, g, b = r1, g1, b1
            return r, g, b
        end
        return r1 + (r2 - r1) * perc, g1 + (g2 - g1) * perc, b1 + (b2 - b1) * perc
    end


    local function ColorDiff(a, b)
        local diff = a - b
        local perc = (diff + addMod) / diffMod
    
        local r, g, b
        if perc < 0 then
            perc = perc * -1
            r, g, b = ColorGradient(perc, 1, 1, 0, 0, 1, 0)
        else
            r, g, b = ColorGradient(perc, 1, 1, 0, 1, 0, 0)
        end
        return r, g, b
    end

    local r1, g1, b1 = ColorDiff(baseilvl, ilvl)

    return CreateColor(r1, g1, b1):WrapTextInColorCode(ilvl)
end