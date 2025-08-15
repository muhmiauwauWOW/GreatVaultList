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
    event = {
        {"WEEKLY_REWARDS_UPDATE", "WEEKLY_REWARDS_ITEM_CHANGED"},
        function(self)
            GreatVaultList.Data:store(self.config, true)
            if GreatVaultListFrame:IsShown() then
                GreatVaultListFrame:RefreshScrollFrame()
            end
        end
    },
    ["store"] = function(characterInfo)
        -- If last week's rewards are still claimable, keep the existing value and do nothing
        -- Also if the rewards are claimable there may not be clear info on the item level
        if C_WeeklyRewards.HasAvailableRewards and C_WeeklyRewards.HasAvailableRewards() then
            return characterInfo
        end

        local highestReward = 0
        local hasValidData = false

        -- Compute current cycle example reward (Raid, Activities, World)
        _.forEach(WeeklyRewardChestThresholdType, function(id)
            local info = C_WeeklyRewards.GetActivities(id)
            if not info or not info[1] or not info[1].id then return end

            local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(info[1].id)
            if itemLink then
                local itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
                if itemLevel and itemLevel > 0 then
                    highestReward = math.max(highestReward, itemLevel)
                    hasValidData = true
                end
            end
        end)

        if hasValidData and highestReward > 0 then
            characterInfo[ColumKey] = highestReward
        else
            characterInfo[ColumKey] = nil
        end

        return characterInfo
    end,
    ["populate"] = function(self, number)
        if not self.rowData then return number end
        if type(number) ~= "number" then return number end
        
        return GreatVaultList.Util:colorItemLvl(self.rowData.data.averageItemLevel, number, 3, 6)
    end
}