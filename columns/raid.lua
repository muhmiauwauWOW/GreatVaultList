local ColumKey = "raid"
local Column = GreatVaultList:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
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
    ["xpadding"] = 0,
    ["ypadding"] = 0,
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 40, canSort = false, dataType = "string", order = "DESC", offset = 20, align = "center"},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = "averageItemLevel",
    },
    ['emptyStr'] = {
        "0/2",
        "0/4",
        "0/6"
    },
    event = {
        {"WEEKLY_REWARDS_UPDATE", "WEEKLY_REWARDS_ITEM_CHANGED"},
        function(self)
            self.config.store(GreatVaultList.data:get())
            if GreatVaultInfoFrame:IsShown() then  -- refresh view if window is open
                GreatVaultList.ScrollFrame.ScollFrame:Refresh()
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
    ["refresh"] = function(line, data, idx)
        local activity = _.get(data, {ColumKey, idx})
        local text = nil -- set default

        if activity.progress >= activity.threshold then
            text  = GREEN_FONT_COLOR_CODE .. DIFFICULTY_NAMES[activity.level] .. FONT_COLOR_CODE_CLOSE
        elseif activity.progress > 0 then
            text  = activity.progress .. "/" .. activity.threshold
        end

        line[ColumKey .. idx].text  = text
        return line
    end,
    ["populate"] = function(self, data, idx)
        local activity = _.get(data, {idx})
        local text = nil -- set default
        
        if activity.progress >= activity.threshold then
            text = DIFFICULTY_NAMES[activity.level]
        elseif activity.progress > 0 then
            text = activity.progress .. "/" .. activity.threshold
        end

        return text
    end
}