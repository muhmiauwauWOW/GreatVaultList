local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_character", GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()


Column.key = "character"

Column.config = {
    ["index"] = 2,
    ["header"] = {key = "character", text = L["character"], width = 120, canSort = true, dataType = "string", order = "DESC", offset = 0},
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
        line.character.text = data.name
        return line
    end
}