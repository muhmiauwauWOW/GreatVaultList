local ColumKey = "highestReward"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

local function formatNumber(rowData, rawNumber)
    if not rawNumber then  return nil end
    if not _.isNumber(rawNumber) then  return nil end
    if rawNumber == 0 then return nil end

    return GreatVaultList.Util:colorItemLvl(rowData.data.averageItemLevel, rawNumber, 3, 6)
end


Column.key = ColumKey
Column.config = {
    ["defaultIndex"] = 4,
    ["width"] = 40,
    ["autoWidth"] = true,
    ["header"] = { key = ColumKey, text = L[ColumKey], canSort = true },
    ["tooltip"] = {
        title =   L["highestReward_tooltip_title"],
        desc = L["highestReward_tooltip_desc"]
    },
    ["demo"] = function(idx)
        return math.random(500, 600)
    end,
    ["populate"] = function(self, number)
        if not self.rowData then return number end
        local computed = GreatVaultList.Data:ComputeHighestReward(self.rowData.data)
        if computed and computed > 0 then
            return formatNumber(self.rowData, computed)
        end
        -- No unlocked vault slots this week: leave the column empty.
        if GreatVaultList.Data:HasUnlockedVaultSlot(self.rowData.data) then
            return formatNumber(self.rowData, self.rowData.data.highestReward or number)
        end
        return nil
    end
}