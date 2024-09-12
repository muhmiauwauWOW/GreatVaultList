local ColumKey = "activities"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()


local DIFFICULTY_NAMES = {
	[DifficultyUtil.ID.DungeonHeroic] = "HC",
	[DifficultyUtil.ID.DungeonTimewalker] = "TW",
	[DifficultyUtil.ID.DungeonMythic] = "M",
}


Column.key = ColumKey
Column.config = {
    ["index"] = 7,
    ["template"] = "GreatVaultListTableCellTripleTextTemplate", 
    ["width"] = 100,
    ["padding"] = 0, 
    ["header"] =  { key = ColumKey, text = DUNGEONS, width = 40, canSort = false},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ['emptyStr'] = {
        "0/1",
        "0/4",
        "0/8"
    },
    ["demo"] = function(idx)

        local level = math.random(5,15)
        local obj = {}
        for i = 1, 3, 1 do
            table.insert(obj, {
                progress = 2,
                threshold = 1,
                level = level + (i*2),
                activityTierID = 0
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
        characterInfo.activities = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Activities)
        _.map(characterInfo.activities, function(entry)
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
        if not activity.activityTierID then return nil end
        if not activity.level then return nil end

        if activity.progress >= activity.threshold then
            text =  (
                        DIFFICULTY_NAMES[C_WeeklyRewards.GetDifficultyIDForActivityTier(activity.activityTierID)] 
                        or 
                        ("+" .. activity.level)
                    )
        elseif activity.progress > 0 then
            text = GreatVaultList.utility:formatActivityProgress(activity)
        end

        return text
    end

}