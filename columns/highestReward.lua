local ColumKey = "highestReward"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 3,
    ["width"] = 40,
    ["autoWidth"] = true,
    ["header"] = {key = ColumKey, text = L[ColumKey], canSort = true},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ["demo"] = function(idx)

        


        return math.random(500, 600)
    end,
    ["store"] = function(characterInfo)
        local _, ilvl = GetAverageItemLevel();
        characterInfo.averageItemLevel = ilvl
        return characterInfo
    end,
    ["populate"] = function(self, number)
       if type(number) ~= "number" then return number end
       return number
    end
}