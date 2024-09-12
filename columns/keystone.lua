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
        table.foreach(C_LFGList.GetAvailableActivities(2), function(k, id)
            local info = C_LFGList.GetActivityInfoTable(id)
            if info.isMythicPlusActivity then
                tinsert(mapChallengeModeIDs,id)
            end
        end)

        return {
            activityID = mapChallengeModeIDs[math.random(#mapChallengeModeIDs)],
            keystoneLevel = math.random(5,15)
        }
    end,
    event = {
        "CHALLENGE_MODE_COMPLETED",
        function(self)
            GreatVaultList.Data:store(self.config, true)
            if GreatVaultInfoFrame:IsShown() then  -- refresh view if window is open
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

        local fullName = C_LFGList.GetActivityFullName(keystone.activityID)
        local estart, _ = string.find(fullName, " %(")
        local estart2, _ = string.find(fullName, " %- ")
        if estart2 and estart2 < estart then
            estart = estart2
        end
        fullName = string.sub(fullName, 1, estart-1)  
        return fullName .. " " .. keystone.keystoneLevel
    end
}