local ColumKey = "keystone"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 13,
    ["width"] = 180,
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 200, canSort = true},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    }, 
    ['emptyStr'] = "-",
    ["demo"] = function(idx)
        local mapChallengeModeIDs = {}
        table.foreach(C_ChallengeMode.GetMapTable(), function(k, id)
            tinsert(mapChallengeModeIDs, id)
        end)
        
        return {
            activityID = mapChallengeModeIDs[math.random(#mapChallengeModeIDs)],
            keystoneLevel = math.random(5, 15)
        }
    end,
    event = {
        "CHALLENGE_MODE_COMPLETED",
        function(self)
            GreatVaultList.Data:store(self.config, true)
            if GreatVaultListFrame:IsShown() then  -- refresh view if window is open
                GreatVaultList.ScrollFrame.ScollFrame:Refresh()
            end
        end
    },
    ["store"] = function(characterInfo)
        local activityID, groupID, keystoneLevel = C_LFGList.GetOwnedKeystoneActivityAndGroupAndLevel()
        if activityID then 
            characterInfo.keystone = {}
            characterInfo.keystone.activityID = activityID
            characterInfo.keystone.keystoneLevel = keystoneLevel
        else
            characterInfo.keystone = ""
        end

        return characterInfo

    end,
    ["populate"] = function(self, keystone)
        if not keystone then return keystone end
        if type(keystone) ~= "table" then return nil end
        if not keystone.keystoneLevel then return nil end

        local name = C_ChallengeMode.GetMapUIInfo(keystone.activityID)
        local level = keystone.keystoneLevel
        return string.format("%s %s", name, level)
    end
}