local ColumKey = "vaultStatus"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()


local StatusArray = {
    ["collect"] = 1,
    ["complete"] = 2,
    ["incomplete"] = 3
}


Column.key = ColumKey
Column.config = {
    ["defaultIndex"] = 10,
    ["template"] = "GreatVaultListTableCellVaultStatusTemplate",
    ["width"] = 20,
    ["padding"] = 0,
    ["header"] = {key = ColumKey, text = "", canSort = true},
    ["sortFn"] = function(a, b, comp)
        if not StatusArray[a] or not StatusArray[b] then return false end
        return comp(StatusArray[a], StatusArray[b])
    end,
    ["demo"] = function(idx)
        local ary = _.keys(StatusArray)
        return ary[math.random(#ary)]
    end,
    ["store"] = function(characterInfo)
        characterInfo[ColumKey] = GreatVaultList:GetVaultState()
        return characterInfo
    end,
    ["populate"] = function(self, status)
        if not status or type(status) ~= "string" then return end

        return status
    end

}