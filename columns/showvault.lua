local ColumKey = "showvault"
local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()



function Column:OnInitialize()
    WeeklyRewardsFrame:HookScript("OnShow", function(self) 

		if not self.weeklyRewardsActivities then return end

		local hasAvailableRewards = _.every(self.weeklyRewardsActivities, function(entry) 
			return _.size(entry.rewards) > 0
		end)


		self.hasAvailableRewards = hasAvailableRewards;
		self.couldClaimRewardsInOnShow = false;
		self.isReadOnly = true;
		self.SelectRewardButton:SetShown(false);


		local activities = self.weeklyRewardsActivities
		for i, activityInfo in ipairs(activities) do
			local frame = self:GetActivityFrame(activityInfo.type, activityInfo.index);
			if frame then
				-- hide current progress for current week if rewards are present
				if canClaimRewards and #activityInfo.rewards == 0 then
					activityInfo.progress = 0;
				end
				activityInfo.rewards = {}
				function frame:ShowPreviewItemTooltip()end

				frame:Refresh(activityInfo);
			end
		end

    end)
end


Column.key = ColumKey
Column.config = {
    ["index"] = 13,
    ["header"] =  { key = ColumKey, text = "", width = 50, canSort = false, dataType = "string", order = "DESC", offset = 0},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    }, 
    ['emptyStr'] = "-",
    ["create"] = function(line)
        local options_button_template = DetailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")
        local button = DetailsFramework:CreateButton(line, nil, 50, 14, L["Open"])
        button:SetPoint("bottomright", line, "bottomright", 0, 0)
        button:SetTemplate(options_button_template)

        

        line[ColumKey] = button
        line:AddFrameToHeaderAlignment(button)
        return line
    end,
    ["refresh"] = function(line, data)
        local weeklyRewardsActivities = {}
        tAppendAll(weeklyRewardsActivities, data.activities)
        tAppendAll(weeklyRewardsActivities, data.raid)
        tAppendAll(weeklyRewardsActivities, data.pvp)
        
    --    local text = "ddd"
        line[ColumKey]:SetClickFunction(function(self, btn, obj) 
            WeeklyRewardsFrame:SetShown(false);
            WeeklyRewardsFrame.weeklyRewardsActivities = obj
            WeeklyRewardsFrame:SetShown(true);
            WeeklyRewardsFrame.weeklyRewardsActivities = nil
        end, weeklyRewardsActivities)
        
        return line
    end
}