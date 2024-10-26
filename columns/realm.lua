local ColumKey = "realm"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["defaultState"] = false,
    ["index"] = 1,
    ["defaultIndex"] = 3,
    ["width"] = 50,
    ["autoWidth"] = true,
    ["padding"] = 0,
    ["header"] = {key = ColumKey, text = L[ColumKey], canSort = true},
    ["sortFn"] = function(a, b, comp)
        if type(a) ~= "string" then a = "" end
        if type(b) ~= "string" then b = "" end
        return comp(a, b)
    end,
    ["demo"] = function(idx)
        return "My Demo Realm"
    end,
    ["populate"] = function(self, realm)
        if not realm or type(realm) ~= "string" then return end

        return realm
    end

}