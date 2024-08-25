local ColumKey = "character"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 2,
    ["width"] = 120,
    ["header"] = {key = ColumKey, text = L[ColumKey], width = 120, canSort = true},
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

}