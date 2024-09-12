local ColumKey = "class"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 1,
    ["template"] = "GreatVaultListTableCellIconTemplate", 
    ["width"] = 20,
    ["padding"] = 0,
    ["header"] = {key = ColumKey, text = "", width = 30, canSort = true},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ["demo"] = function(idx)
        local classes = _.keys(CLASS_ICON_TCOORDS);
        return string.lower(classes[math.random(#classes)])
    end,
    ["populate"] = function(self, class)
        if type(class) ~= "string" then return nil end
        local classatlas = GetClassAtlas(string.lower(class))
        return classatlas
    end

}