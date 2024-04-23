local ColumKey = "class"
local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()

local CONST_SCROLL_LINE_HEIGHT = 20
Column.key = ColumKey
Column.config = {
    ["index"] = 1,
    ["header"] = {key = ColumKey, text = "", width = 25, canSort = true, dataType = "string", order = "DESC", offset = 0},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ["create"] = function(line)
        local icon = line:CreateTexture("$parentClassIcon", "overlay")
        icon:SetSize(CONST_SCROLL_LINE_HEIGHT - 2, CONST_SCROLL_LINE_HEIGHT - 2)
        icon:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
        line.icon = icon
        line:AddFrameToHeaderAlignment(icon)
        return line
    end,
    ["refresh"] = function(line, data)
        local L, R, T, B = unpack(CLASS_ICON_TCOORDS[data.class])
        line.icon:SetTexCoord(L+0.02, R-0.02, T+0.02, B-0.02)
        return line
    end
}