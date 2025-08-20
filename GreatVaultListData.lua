local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.Data = {}

function GreatVaultList.Data:init()
	GreatVaultList.db.global.characters = GreatVaultList.db.global.characters or {}
	self.characterInfo = Mixin({}, self:get())
	self.disabled = UnitLevel("player") < GetMaxLevelForPlayerExpansion()
	
	self.skipStore = C_WeeklyRewards.CanClaimRewards()

	-- will not work if user is logged in when C_WeeklyRewards.CanClaimRewards() changes. But who cares? right?
	if not self.skipStore then return end
	GreatVaultList:RegisterEvent("WEEKLY_REWARDS_UPDATE", function()
		if C_WeeklyRewards.CanClaimRewards() then return end
		self.skipStore = false
		self:storeAll()

		self:ClearVaultTmpData()
	end)

	if not C_WeeklyRewards.HasAvailableRewards() then
		self:ClearVaultTmpData()
	end
end


function GreatVaultList.Data:get()
	local playerGUID  = UnitGUID("player")
	local info = GreatVaultList.db.global.characters[playerGUID]

	-- check for old method
	if not info then 
		local playerName = UnitName("player")
		info = GreatVaultList.db.global.characters[playerName]
		if info then 
			GreatVaultList.db.global.characters[playerName] = nil
		end
	end

	-- new character
	if not info then 
		info = {}
	end
	
	return info
end

function GreatVaultList.Data:write()
	if self.disabled then return end
	self.characterInfo.lastUpdate = time()

	local playerGUID = UnitGUID("player")
	if not playerGUID then return end
	GreatVaultList.db.global.characters[playerGUID] = self.characterInfo
end

function GreatVaultList.Data:store(config, write)
	if self.disabled then return end
	if self.skipStore then return end
	local store = _.get(config, { "store" }, function(e) return e end)
	self.characterInfo = store(self.characterInfo)
	self.characterInfo.lastUpdate = time()
	if write then self:write() end
end

function GreatVaultList.Data:storeAll()
	if self.disabled then return end
	if self.skipStore then return end
	_.forEach(GreatVaultList.ModuleColumns, function(entry, key)
		self:store(entry.config, false)
	end)

	self.characterInfo.activitiesData = self:GetVaultData()

	self:write()
end












local VaultTmpData = nil
function GreatVaultList.Data:ClearVaultTmpData()
	VaultTmpData = nil
end

function GreatVaultList.Data:GetVaultData()
	if VaultTmpData then return VaultTmpData end
	
	
	local data = C_WeeklyRewards.GetActivities()


	local tooltip = {}
	local function addToTooltip(type, value, color)

		if color then
			color = color:GenerateHexColor()--:GetHex()
		end

		table.insert(tooltip, {
			type = type,
			value = value,
			color = color
		})
	
	end

	local function EncountersSort(left, right)
		if left.instanceID ~= right.instanceID then
			return left.instanceID < right.instanceID;
		end
		local leftCompleted = left.bestDifficulty > 0;
		local rightCompleted = right.bestDifficulty > 0;
		if leftCompleted ~= rightCompleted then
			return leftCompleted;
		end
		return left.uiOrder < right.uiOrder;
	end


	local function GameTooltip_AddNormalLine(g, value)
		 addToTooltip("GameTooltip_AddNormalLine", value )
	end

	local function GameTooltip_AddBlankLineToTooltip(g)
		 addToTooltip("GameTooltip_AddBlankLineToTooltip")
	end

	local function GameTooltip_AddColoredLine(g, value, color)
		 addToTooltip("GameTooltip_AddColoredLine", value, color)
	end

	local function GameTooltip_AddHighlightLine(g, value)
		 addToTooltip("GameTooltip_AddHighlightLine", value)
	end




	_.map(data, function(entry)

		local itemLink, upgradeItemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(entry.id);
		local itemLevel, upgradeItemLevel;
		if itemLink then
			itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink);
			entry.itemLevel = itemLevel
		end
		if upgradeItemLink then
			upgradeItemLevel = C_Item.GetDetailedItemLevelInfo(upgradeItemLink);
			entry.upgradeItemLevel = upgradeItemLevel
		end
		
		

		tooltip = {}
		

		if itemLevel then 
			if entry.type == Enum.WeeklyRewardChestThresholdType.Raid then
				local currentDifficultyID = entry.level;
                local currentDifficultyName = DifficultyUtil.GetDifficultyName(currentDifficultyID);
                GameTooltip_AddNormalLine(GameTooltip, string.format(WEEKLY_REWARDS_ITEM_LEVEL_RAID, itemLevel, currentDifficultyName));
				GameTooltip_AddBlankLineToTooltip(GameTooltip);
				
                if upgradeItemLevel then
                    local nextDifficultyID = DifficultyUtil.GetNextPrimaryRaidDifficultyID(currentDifficultyID);
                    if nextDifficultyID then
                        local difficultyName = DifficultyUtil.GetDifficultyName(nextDifficultyID);
                        GameTooltip_AddColoredLine(GameTooltip, string.format(WEEKLY_REWARDS_IMPROVE_ITEM_LEVEL, upgradeItemLevel), GREEN_FONT_COLOR);
						GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_COMPLETE_RAID, difficultyName));
						
                        local encounters = C_WeeklyRewards.GetActivityEncounterInfo(entry.type, entry.index);
						if encounters then
							table.sort(encounters, EncountersSort);
							local lastInstanceID = nil;
							for index, encounter in ipairs(encounters) do
								local name, description, encounterID, rootSectionID, link, instanceID = EJ_GetEncounterInfo(encounter.encounterID);
								if instanceID ~= lastInstanceID then
									local instanceName = EJ_GetInstanceInfo(instanceID);
									GameTooltip_AddBlankLineToTooltip(GameTooltip);	
									GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_ENCOUNTER_LIST, instanceName));
									lastInstanceID = instanceID;
								end
								if name then
									if encounter.bestDifficulty > 0 then
										local completedDifficultyName = DifficultyUtil.GetDifficultyName(encounter.bestDifficulty);
										GameTooltip_AddColoredLine(GameTooltip, string.format(WEEKLY_REWARDS_COMPLETED_ENCOUNTER, name, completedDifficultyName), GREEN_FONT_COLOR);
									else
										GameTooltip_AddColoredLine(GameTooltip, string.format(DASH_WITH_TEXT, name), DISABLED_FONT_COLOR);
									end
								end
							end
						end
                    end
                end
			
			elseif entry.type == Enum.WeeklyRewardChestThresholdType.Activities then
				local hasData, nextActivityTierID, nextLevel, nextItemLevel = C_WeeklyRewards.GetNextActivitiesIncrease(entry.activityTierID, entry.level);
				if hasData then
					upgradeItemLevel = nextItemLevel;
				else
					nextLevel = WeeklyRewardsUtil.GetNextMythicLevel(entry.level);
				end
				local isHeroicLevel = self:IsCompletedAtHeroicLevel();
				if isHeroicLevel then		
					GameTooltip_AddNormalLine(GameTooltip, string.format(WEEKLY_REWARDS_ITEM_LEVEL_HEROIC, itemLevel));
				else
					GameTooltip_AddNormalLine(GameTooltip, string.format(WEEKLY_REWARDS_ITEM_LEVEL_MYTHIC, itemLevel, entry.level));
				end
				GameTooltip_AddBlankLineToTooltip(GameTooltip);
				if upgradeItemLevel then
					GameTooltip_AddColoredLine(GameTooltip, string.format(WEEKLY_REWARDS_IMPROVE_ITEM_LEVEL, upgradeItemLevel), GREEN_FONT_COLOR);
					if self.info.threshold == 1 then
						if isHeroicLevel then
							GameTooltip_AddHighlightLine(GameTooltip, WEEKLY_REWARDS_COMPLETE_HEROIC_SHORT);
						else
							GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_COMPLETE_MYTHIC_SHORT, nextLevel));
						end
					else
						GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_COMPLETE_MYTHIC, nextLevel, entry.threshold));
						GameTooltip_AddBlankLineToTooltip(GameTooltip);


						GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_MYTHIC_TOP_RUNS, entry.threshold));

						local runHistory = C_MythicPlus.GetRunHistory(false, true);
						if #runHistory > 0 then
							local comparison = function(entry1, entry2)
								if ( entry1.level == entry2.level ) then
									return entry1.mapChallengeModeID < entry2.mapChallengeModeID;
								else
									return entry1.level > entry2.level;
								end
							end
							table.sort(runHistory, comparison);
							for i = 1, entry.threshold do
								if runHistory[i] then
									local runInfo = runHistory[i];
									local name = C_ChallengeMode.GetMapUIInfo(runInfo.mapChallengeModeID);
									GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_MYTHIC_RUN_INFO, runInfo.level, name));
								end
							end
						end

						local missingRuns = entry.threshold - #runHistory;
						if missingRuns > 0 then
							local numHeroic, numMythic, numMythicPlus = C_WeeklyRewards.GetNumCompletedDungeonRuns();
							while numMythic > 0 and missingRuns > 0 do
								GameTooltip_AddHighlightLine(GameTooltip, WEEKLY_REWARDS_MYTHIC:format(WeeklyRewardsUtil.MythicLevel));
								numMythic = numMythic - 1;
								missingRuns = missingRuns - 1;
							end
							while numHeroic > 0 and missingRuns > 0 do
								GameTooltip_AddHighlightLine(GameTooltip, WEEKLY_REWARDS_HEROIC);
								numHeroic = numHeroic - 1;
								missingRuns = missingRuns - 1;
							end
						end
					end
				end
			elseif entry.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
				local tierName = PVPUtil.GetTierName(entry.level);
				GameTooltip_AddNormalLine(GameTooltip, string.format(WEEKLY_REWARDS_ITEM_LEVEL_PVP, itemLevel, tierName));
				GameTooltip_AddBlankLineToTooltip(GameTooltip);
				if upgradeItemLevel then
					-- All brackets have the same breakpoints, use the first one
					local tierID = C_PvP.GetPvpTierID(entry.level, CONQUEST_BRACKET_INDEXES[1]);
					local tierInfo = C_PvP.GetPvpTierInfo(tierID);
					local ascendTierInfo = C_PvP.GetPvpTierInfo(tierInfo.ascendTier);
					if ascendTierInfo then
						GameTooltip_AddColoredLine(GameTooltip, string.format(WEEKLY_REWARDS_IMPROVE_ITEM_LEVEL, upgradeItemLevel), GREEN_FONT_COLOR);
						local ascendTierName = PVPUtil.GetTierName(ascendTierInfo.pvpTierEnum);
						if ascendTierInfo.ascendRating == 0 then
							GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_COMPLETE_PVP_MAX, ascendTierName, tierInfo.ascendRating));
						else
							GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_COMPLETE_PVP, ascendTierName, tierInfo.ascendRating, ascendTierInfo.ascendRating - 1));
						end
					end
				end
			elseif entry.type == Enum.WeeklyRewardChestThresholdType.World then
				local hasData, nextActivityTierID, nextLevel, nextItemLevel = C_WeeklyRewards.GetNextActivitiesIncrease(entry.activityTierID, entry.level);
				if hasData then
					upgradeItemLevel = nextItemLevel;
				else
					nextLevel = entry.level + 1;
				end

				GameTooltip_AddNormalLine(GameTooltip, string.format(WEEKLY_REWARDS_ITEM_LEVEL_WORLD, itemLevel, entry.level));
	
				GameTooltip_AddBlankLineToTooltip(GameTooltip);
				if upgradeItemLevel then
					GameTooltip_AddColoredLine(GameTooltip, string.format(WEEKLY_REWARDS_IMPROVE_ITEM_LEVEL, upgradeItemLevel), GREEN_FONT_COLOR);
					GameTooltip_AddHighlightLine(GameTooltip, string.format(WEEKLY_REWARDS_COMPLETE_WORLD, nextLevel));
				end

			end

			if not upgradeItemLevel then
				GameTooltip_AddColoredLine(GameTooltip, WEEKLY_REWARDS_MAXED_REWARD, GREEN_FONT_COLOR);
			end


		end


		entry.tooltip = tooltip
	end)









	VaultTmpData = data
 	return VaultTmpData
end