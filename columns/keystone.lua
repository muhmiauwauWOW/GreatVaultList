local ColumKey = "keystone"
local Column = GreatVaultList:NewModule(ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultList:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 13,
    ["width"] = 180,
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 200, canSort = false},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
    }, 
    ["sortFn"] = function(a, b, comp)
        if type(a) ~= "table" then a = {keystoneLevel = 1} end
        if type(b) ~= "table" then b = {keystoneLevel = 1} end
        return comp(a.keystoneLevel, b.keystoneLevel)
    end,
    ['emptyStr'] = "-",
    ["demo"] = function(idx)
        local mapChallengeModeIDs = {}
        table.foreach(C_LFGList.GetAvailableActivities(2), function(k, id)
            local info = C_LFGList.GetActivityInfoTable(id)
            if info.isMythicPlusActivity then
                tinsert(mapChallengeModeIDs,id)
            end
        end)

        return {
            activityID =  1278, --mapChallengeModeIDs[math.random(#mapChallengeModeIDs)],
            groupID = 328,
            keystoneLevel = math.random(5,15)
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
            characterInfo.keystone.groupID = groupID
            characterInfo.keystone.keystoneLevel = keystoneLevel
        else
            characterInfo.keystone = nil
        end

        return characterInfo
    end,
    ["populate"] = function(self, keystone)
        if not keystone then return keystone end
        if type(keystone) ~= "table" then return nil end
        if not keystone.keystoneLevel then return nil end

        local name = C_LFGList.GetActivityGroupInfo(keystone.groupID)
        local level = keystone.keystoneLevel
        return string.format("%s %s", name, level)
    end
}