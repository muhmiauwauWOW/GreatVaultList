local ColumKey = "pvp"
local Column = GreatVaultList:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 10,
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 100, canSort = false, dataType = "string", order = "DESC", offset = 50, align = "center"},
    ["subCols"] = 3,
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    },
    ['emptyStr'] = {
        "0/1250",
        "0/2500",
        "0/5000"
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
        characterInfo.pvp = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.RankedPvP)
        _.map(characterInfo.pvp, function(entry)
            entry["raidString"] = nil
            return entry
        end)
        return characterInfo
    end,
    ["refresh"] = function(line, data, idx)
        local activity = _.get(data, {ColumKey, idx})
        local text = nil -- set default

        if activity.progress >= activity.threshold then
            text = GREEN_FONT_COLOR_CODE .. PVPUtil.GetTierName(activity.level) .. FONT_COLOR_CODE_CLOSE
        elseif activity.progress > 0 then
            text  = activity.progress .. "/" .. activity.threshold
        end

        line[ColumKey .. idx].text  = text
        return line
    end
}