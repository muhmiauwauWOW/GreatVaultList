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
            if GreatVaultListFrame:IsShown() then  -- refresh view if window is open
                GreatVaultListFrame:RefreshScrollFrame()
            end
        end
    },
    ["store"] = function(characterInfo)
        local highestReward = 0
        local hasValidData = false
        local apiCallsMade = 0
        local totalApiCalls = #WeeklyRewardChestThresholdType

        _.forEach(WeeklyRewardChestThresholdType, function(id)
            local info = C_WeeklyRewards.GetActivities(id)
            apiCallsMade = apiCallsMade + 1
            
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

        -- If we made all API calls but found no valid rewards, it's legitimate to set to nil
        -- If we couldn't make all API calls, preserve existing value to avoid data loss
        if apiCallsMade == totalApiCalls then
            if hasValidData and highestReward > 0 then
                characterInfo[ColumKey] = highestReward
            else
                -- All APIs were called but no rewards found - legitimate nil case
                characterInfo[ColumKey] = nil
            end
        elseif characterInfo[ColumKey] then
            -- Not all APIs were called - preserve existing value to avoid data loss
            -- This handles cases where APIs aren't fully loaded yet
        end
        
        return characterInfo
    end,
    ["populate"] = function(self, number)
        if not self.rowData then return number end
        if type(number) ~= "number" then return number end
        
        return GreatVaultList.Util:colorItemLvl(self.rowData.data.averageItemLevel, number, 3, 6)
    end
}