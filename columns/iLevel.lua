local ColumKey = "ilevel"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 3,
    ["width"] = 80,
    ["header"] = {key = ColumKey, text = L[ColumKey], width = 80, canSort = true},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = "averageItemLevel",
    },
    ["demo"] = function(idx)
        return math.random(50000, 60000)/100
    end,
    ["store"] = function(characterInfo)
        local _, ilvl = GetAverageItemLevel();
        characterInfo.averageItemLevel = ilvl
        return characterInfo
    end,
    ["populate"] = function(self, number)
       if type(number) ~= "number" then return number end
       return string.format("%.2f", number)
    end
}