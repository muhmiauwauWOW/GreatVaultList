local ColumKey = "class"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["defaultIndex"] = 1,
    ["template"] = "GreatVaultListTableCellIconTemplate", 
    ["width"] = 20,
    ["padding"] = 0,
    ["header"] = {key = ColumKey, text = L[ColumKey], canSort = true, hidden = true},
    ["sortFn"] = function(a, b, comp)
        if type(a) ~= "string" then a = "" end
        if type(b) ~= "string" then b = "" end
        return comp(a, b)
    end,
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