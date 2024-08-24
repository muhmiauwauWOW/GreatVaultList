local ColumKey = "character"
local Column = GreatVaultList:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 2,
    ["header"] = {key = ColumKey, text = L[ColumKey], width = 120, canSort = true, dataType = "string", order = "DESC", offset = 0},
    ["sort"] = {
        ["key"] = "character",
        ["store"] = "name",
    },
    ["store"] = function(characterInfo)
        local _, className = UnitClass("player")
        characterInfo.name = UnitName("player")
        characterInfo.class = className
        characterInfo.realm = GetRealmName()
        characterInfo.level = UnitLevel("player")

        return characterInfo
    end,
    ["refresh"] = function(line, data)
        line[ColumKey].text = data.name
        return line
    end

}