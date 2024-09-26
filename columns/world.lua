local ColumKey = "world"
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
    ["header"] =  { key = ColumKey, text = WORLD, canSort = true},
    ["subCols"] = 3,
    ["sortFn"] = function(a, b, comp)
        if a[1].level == b[1].level and a[2].level == b[2].level and a[3].level == b[3].level  then
            return comp(a[3].progress, b[3].progress)
        end
       
        if a[3].level == b[3].level then
            if a[2].level == b[2].level then
                return comp(a[1].level, b[1].level)
            end
            return comp(a[2].level, b[2].level)
        end
        
        return comp(a[3].level, b[3].level)
    end,
    ['emptyStr'] = {
        "0/2",
        "0/4",
        "0/8"
    },
    ["demo"] = function(idx)

        local progress = math.random(10)
        local level = math.random(5,15)
        local obj = {}
        local threshold = {1, 4, 8}

        for i = 1, 3, 1 do
            local level = (progress>= threshold[i]) and level + (i +  math.random(1, 3)) or 0
        
            table.insert(obj, {
                progress = progress,
                threshold = threshold[i],
                level = level,
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
        characterInfo.world = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.World)
        _.map(characterInfo.world, function(entry)
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
            text = activity.level
        elseif activity.progress > 0 then
            text = GreatVaultList.utility:formatActivityProgress(activity)
        end

        return text
    end

}