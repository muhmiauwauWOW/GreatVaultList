local ColumKey = "class"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

local CONST_SCROLL_LINE_HEIGHT = 20
Column.key = ColumKey
Column.config = {
    ["index"] = 1,
    ["width"] = 30,
    ["padding"] = 0,
    ["header"] = {key = ColumKey, text = "", width = 30, canSort = true},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ["sortable"] = true, 
    ["demo"] = function(idx)
        local classes = {"HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR", "DEATHKNIGHT", "MONK", "DEMONHUNTER", "EVOKER"};
        return classes[math.random(#classes)]
    end,
    ["populate"] = function(self, class)
        if type(class) ~= "string" then return nil end
        local icon = CLASS_ICON_TCOORDS[class] or CLASS_ICON_TCOORDS["PALADIN"]
        local L, R, T, B = unpack(icon)
        return CreateTextureMarkup("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", 1024,1024, 20, 20, L+0.02, R-0.02, T+0.02, B-0.02)
    end

}