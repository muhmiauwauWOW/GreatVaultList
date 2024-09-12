local ColumKey = "raid"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

local DIFFICULTY_NAMES = {
	[DifficultyUtil.ID.Raid10Normal] = "NHC",
	[DifficultyUtil.ID.Raid25Normal] = "NHC",
	[DifficultyUtil.ID.Raid10Heroic] = "HC",
	[DifficultyUtil.ID.Raid25Heroic] = "HC",
	[DifficultyUtil.ID.RaidLFR] = "LFR",
	[DifficultyUtil.ID.PrimaryRaidNormal] = "NHC",
	[DifficultyUtil.ID.PrimaryRaidHeroic] = "HC",
	[DifficultyUtil.ID.PrimaryRaidMythic] = "MTH",
	[DifficultyUtil.ID.PrimaryRaidLFR] = "LFR",
}


Column.key = ColumKey
Column.config = {
    ["index"] = 4,
    ["template"] = "GreatVaultListTableCellTripleTextTemplate",
    ["width"] = 100,
    ["padding"] = 0, 
    ["header"] =  { key = ColumKey, text = RAIDS, width = 40, canSort = false},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ['emptyStr'] = {
        "0/2",
        "0/4",
        "0/6"
    },
    ["demo"] = function(idx)
        local keys =  _.keys(DIFFICULTY_NAMES)
        local level = keys[math.random(_.size(keys))]
        local obj = {}

        local progress = math.random(7) - 1
        local threshold = {2, 4, 6}

        for i = 1, 3, 1 do
            
            table.insert(obj, {
                progress = progress,
                threshold = threshold[i],
                level = level
            })
        end
        return obj
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
        characterInfo.raid = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Raid)
        _.map(characterInfo.raid, function(entry)
            entry["raidString"] = nil
            return entry
        end)
        return characterInfo
    end,
    ["populate"] = function(self, data, idx)
        if type(data) ~= "table" then return nil end
        local activity = _.get(data, {idx}, {} )
        local text = nil -- set default
        
        if not activity.progress then return nil end
        if not activity.threshold then return nil end
        
        if activity.progress >= activity.threshold then
            text = DIFFICULTY_NAMES[activity.level]
        elseif activity.progress > 0 then
            text = GreatVaultList.utility:formatActivityProgress(activity)
        end

        return text
    end
}