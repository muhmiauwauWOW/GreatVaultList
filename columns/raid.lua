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


-- local DifficultySorting = {
-- 	[DifficultyUtil.ID.Raid10Normal] = "NHC",
-- 	[DifficultyUtil.ID.Raid25Normal] = "NHC",
-- 	[DifficultyUtil.ID.Raid10Heroic] = "HC",
-- 	[DifficultyUtil.ID.Raid25Heroic] = "HC",
-- 	[DifficultyUtil.ID.RaidLFR] = "LFR",
-- 	[DifficultyUtil.ID.PrimaryRaidNormal] = "NHC",
-- 	[DifficultyUtil.ID.PrimaryRaidHeroic] = "HC",
-- 	[DifficultyUtil.ID.PrimaryRaidMythic] = "MTH",
-- 	[DifficultyUtil.ID.PrimaryRaidLFR] = "LFR",
-- }



local PRIMARY_RAIDS = { DifficultyUtil.ID.PrimaryRaidLFR, DifficultyUtil.ID.PrimaryRaidNormal, DifficultyUtil.ID.PrimaryRaidHeroic, DifficultyUtil.ID.PrimaryRaidMythic };


Column.key = ColumKey
Column.config = {
    ["index"] = 4,
    ["template"] = "GreatVaultListTableCellTripleTextTemplate",
    ["width"] = 100,
    ["padding"] = 0, 
    ["header"] =  { key = ColumKey, text = RAIDS, width = 40, canSort = true},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ["sortFn"] = function(a, b, comp)
        local a1Level = _.indexOf(PRIMARY_RAIDS, a[1].level)
        local b1Level = _.indexOf(PRIMARY_RAIDS, b[1].level)
        local a2Level = _.indexOf(PRIMARY_RAIDS, a[2].level)
        local b2Level = _.indexOf(PRIMARY_RAIDS, b[2].level)
        local a3Level = _.indexOf(PRIMARY_RAIDS, a[3].level)
        local b3Level = _.indexOf(PRIMARY_RAIDS, b[3].level)


        if a1Level == b1Level and a2Level == b2Level and a3Level == b3Level  then
            return comp(a[3].progress, b[3].progress)
        end
       
        if a1Level == b1Level then
            if a2Level == b2Level then
                return comp(a3Level, b3Level)
            end
            return comp(a2Level, b2Level)
        end
        
        return comp(a1Level, b1Level)
    end,
    ['emptyStr'] = {
        "0/2",
        "0/4",
        "0/6"
    },
    ["demo"] = function(idx)
        local obj = {}
        local progress = math.random(9) -1
        local threshold = {2, 4, 6}

        local start = math.random(#PRIMARY_RAIDS)
        for i = 1, 3, 1 do
            start = start - i > 1  and start -  math.random(0,1) or 1
            local level = PRIMARY_RAIDS[start]

            table.insert(obj, {
                progress = progress,
                threshold = threshold[i],
                level = progress >= threshold[i] and level or 0
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