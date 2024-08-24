local ColumKey = "class"
local Column = GreatVaultList:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

local CONST_SCROLL_LINE_HEIGHT = 20
Column.key = ColumKey
Column.config = {
    ["index"] = 1,
    ["header"] = {key = ColumKey, text = "", width = 30, canSort = true, dataType = "string", order = "DESC", offset = 0, xpadding = 0, ypadding = 0 },
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ["create"] = function(line)
        local icon = line:CreateTexture("$parentClassIcon", "overlay")
        icon:SetSize(CONST_SCROLL_LINE_HEIGHT - 2, CONST_SCROLL_LINE_HEIGHT - 2)
        icon:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
        line[ColumKey] = icon
        line:AddFrameToHeaderAlignment(icon)
        return line
    end,
    ["refresh"] = function(line, data)
        local L, R, T, B = unpack(CLASS_ICON_TCOORDS[data.class])
        line[ColumKey]:SetTexCoord(L+0.02, R-0.02, T+0.02, B-0.02)
        return line
    end,
    ["populate"] = function(self, class)
        local L, R, T, B = unpack(CLASS_ICON_TCOORDS[class])
        return CreateTextureMarkup("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", 1024,1024, 20, 20, L+0.02, R-0.02, T+0.02, B-0.02)
    end

}