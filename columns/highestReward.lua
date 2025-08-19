local ColumKey = "highestReward"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

 local typeToDataSource = {
        [Enum.WeeklyRewardChestThresholdType.Raid] = "raid",
        [Enum.WeeklyRewardChestThresholdType.Activities] = "dungeons",
        [Enum.WeeklyRewardChestThresholdType.World] = "delves"
    }


local function highestRewardFN(Adata)
    if not _.isTable(Adata) then return nil end
    local ilvlTable = {0}
    
    _.forEach(Adata, function(entry)
        local itemLevel = entry.itemLevel or 0
        table.insert(ilvlTable, itemLevel)
    end)

    return math.max(unpack(ilvlTable))
end

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
    -- event = {
    --     {"WEEKLY_REWARDS_UPDATE"},
    --     function(self)
    --         GreatVaultList.Data:store(self.config, true)
    --         if GreatVaultListFrame:IsShown() then  -- refresh view if window is open
    --             GreatVaultListFrame:RefreshScrollFrame()
    --         end
    --     end
    -- },
    ["store"] = function(characterInfo)
        -- characterInfo.activitiesData = GreatVaultList:GetVaultData(ColumKey)
        return characterInfo
    end,
    ["populate"] = function(self, number)
        if not self.rowData then return number end
        if not self.rowData.data.activitiesData then
            if number then return number end
            return nil
        end
        if  not _.isTable(self.rowData.data.activitiesData) then return nil end
           
        return formatNumber(self.rowData, highestRewardFN(self.rowData.data.activitiesData))
    end
}