local ColumKey = "showvault"
local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()



function Column:OnInitialize()

    local WeeklyRewardsFrame_FullRefresh = WeeklyRewardsFrame.FullRefresh

    function WeeklyRewardsFrame:FullRefresh()
		if not self.weeklyRewardsActivities then 
            WeeklyRewardsFrame_FullRefresh(self)
            return
        end

        
        

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

           --     frameShowPreviewItemTooltip()

				function frame:ShowPreviewItemTooltip()

                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -7, -11);
	                GameTooltip_SetTitle(GameTooltip, WEEKLY_REWARDS_CURRENT_REWARD);

                    local itemLevel = self.info.itemLevel
                    local upgradeItemLevel = self.info.upgradeItemLevel
                    local nextLevel = self.info.nextLevel

                  --  if not itemLevel then return end

                    self.UpdateTooltip = nil;
                    if self.info.type == Enum.WeeklyRewardChestThresholdType.Raid then
                        self:HandlePreviewRaidRewardTooltip(itemLevel, upgradeItemLevel);
                    elseif self.info.type == Enum.WeeklyRewardChestThresholdType.Activities then
                        self:HandlePreviewMythicRewardTooltip(itemLevel, upgradeItemLevel, nextLevel);
                    elseif self.info.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
                        self:HandlePreviewPvPRewardTooltip(itemLevel, upgradeItemLevel);
                    elseif self.info.type == Enum.WeeklyRewardChestThresholdType.World then
                        self:HandlePreviewWorldRewardTooltip(itemLevel, upgradeItemLevel, nextLevel);
                    end
            
                    if not upgradeItemLevel then
                        GameTooltip_AddColoredLine(GameTooltip, WEEKLY_REWARDS_MAXED_REWARD, GREEN_FONT_COLOR);
                    end

                    GameTooltip:Show();

                end

				frame:Refresh(activityInfo);
			end
		end

        self.weeklyRewardsActivities = nil
    end
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
    ["store"] = function(characterInfo)
        local activities  = C_WeeklyRewards.GetActivities()
        _.map(activities, function(entry)
            entry["raidString"] = nil

            local itemLink, upgradeItemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(entry.id);

            if itemLink then
                entry.itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink);
            end
            if upgradeItemLink then
                entry.upgradeItemLevel = C_Item.GetDetailedItemLevelInfo(upgradeItemLink);
            end

            local hasData, nextActivityTierID, nextLevel, nextItemLevel = C_WeeklyRewards.GetNextActivitiesIncrease(entry.activityTierID, entry.level);
            if hasData then
                entry.upgradeItemLevel = nextItemLevel;
            else
                entry.nextLevel = WeeklyRewardsUtil.GetNextMythicLevel(entry.level);
            end


            
            return entry
        end)


        characterInfo[ColumKey] = activities
        
        return characterInfo
    end,
    ["create"] = function(line)
        local options_button_template = DetailsFramework:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")
        local button = DetailsFramework:CreateButton(line, nil, 50, 14, L["showvault_btn"])
        button:SetPoint("bottomright", line, "bottomright", 0, 0)
        button:SetTemplate(options_button_template)

        

        line[ColumKey] = button
        line:AddFrameToHeaderAlignment(button)
        return line
    end,
    ["refresh"] = function(line, data)


        
        if data[ColumKey] and #data[ColumKey] > 0  then 
            line[ColumKey]:SetClickFunction(function(self, btn, obj) 
                WeeklyRewardsFrame.weeklyRewardsActivities = obj
                    

                if WeeklyRewardsFrame:IsShown() then
                    WeeklyRewardsFrame.HeaderFrame.Text:SetText(data.name);
                    WeeklyRewardsFrame:FullRefresh()
                else
                    WeeklyRewardsFrame:Show();
                end
                
            end, data[ColumKey])

            line[ColumKey]:Show()
        else
            line[ColumKey]:Hide()
        end
      
        
        return line
    end
}