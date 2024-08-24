local ColumKey = "ilevel"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 3,
    ["width"] = 80,
    ["header"] = {key = ColumKey, text = L[ColumKey], width = 80, canSort = true, dataType = "number", order = "DESC", offset = 0},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = "averageItemLevel",
    },
    event = {
        {"WEEKLY_REWARDS_UPDATE", "WEEKLY_REWARDS_ITEM_CHANGED"},
        function(self)
            self.config.store(GreatVaultList.data:get())
            if GreatVaultInfoFrame:IsShown() then  -- refresh view if window is open
                GreatVaultList.ScrollFrame.ScollFrame:Refresh()
            end
        end
    },
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