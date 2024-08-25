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
    ["xpadding"] = 0, 
    ["ypadding"] = 0, 
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 40, canSort = false},
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
                        (" +" .. activity.level .. " ")
                    )
        elseif activity.progress > 0 then
            text = activity.progress .. "/" .. activity.threshold
        end

        return text
    end

}