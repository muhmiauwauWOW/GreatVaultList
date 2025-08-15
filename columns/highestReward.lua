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
        local highestReward = 0
        local hasValidData = false
        local existingValue = characterInfo[ColumKey]  -- Preserve existing value to prevent data loss

        -- Get rewards data from all sources (Raid, Activities, World)
        _.forEach(WeeklyRewardChestThresholdType, function(id)
            local info = C_WeeklyRewards.GetActivities(id)
            if not info or not info[1] or not info[1].id then return end
            
            local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(info[1].id)
            if itemLink then
                local itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
                if itemLevel and itemLevel > 0 then
                    highestReward = math.max(highestReward, itemLevel)  -- Track highest item level found
                    hasValidData = true
                end
            end
        end)

        -- Update the value if we found valid data, otherwise preserve existing value
        if hasValidData and highestReward > 0 then
            characterInfo[ColumKey] = highestReward  -- Set new highest reward value
        elseif existingValue and existingValue > 0 then
            -- Preserve existing value if APIs aren't ready yet (prevents data loss on fast login/logout)
            characterInfo[ColumKey] = existingValue
        else
            -- Only set to nil if we have no existing value and no valid data
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