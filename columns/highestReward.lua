local ColumKey = "highestReward"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

local WeeklyRewardChestThresholdType = {
    Enum.WeeklyRewardChestThresholdType.Raid, 
	Enum.WeeklyRewardChestThresholdType.Activities,
	Enum.WeeklyRewardChestThresholdType.World,
}



Column.key = ColumKey
Column.config = {
    ["index"] = 3,
    ["width"] = 40,
    ["autoWidth"] = true,
    ["header"] = { key = ColumKey, text = L[ColumKey], canSort = true },
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ["tooltip"] = {
        title =   L["highestReward_tooltip_title"],
        desc = L["highestReward_tooltip_desc"]
    },
    ["demo"] = function(idx)
        return math.random(500, 600)
    end,
    ["store"] = function(characterInfo)
        local highestReward = 0

        _.forEach(WeeklyRewardChestThresholdType, function(id)
            local info =  C_WeeklyRewards.GetActivities(id)
            if not info[1].id then return end -- the first one ist always the higherst
            local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(info[1].id);
            if itemLink then
                local itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink);
                if itemLevel then
                    highestReward = highestReward < itemLevel and itemLevel or highestReward
                end
            end
        end)

        characterInfo[ColumKey] = highestReward > 0 and highestReward or nil
        return characterInfo
    end,
    ["populate"] = function(self, number)
        if not self.rowData then return end
       if type(number) ~= "number" then return number end

       return GreatVaultList.Util:colorItemLvl(self.rowData.data.averageItemLevel, number, 3, 6)
    end
}