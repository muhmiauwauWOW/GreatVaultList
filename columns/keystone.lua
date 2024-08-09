local ColumKey = "keystone"
local Column = GreatVaultAddon:NewModule("GREATVAULTLIST_COLUMNS_" .. ColumKey, GREATVAULTLIST_COLUMNS)
local L, _ = GreatVaultAddon:GetLibs()

Column.key = ColumKey
Column.config = {
    ["index"] = 13,
    ["header"] =  { key = ColumKey, text = L[ColumKey], width = 180, canSort = false, dataType = "string", order = "DESC", offset = 0},
    ["sort"] = {
        ["key"] = ColumKey,
        ["store"] = ColumKey,
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
    ["refresh"] = function(line, data)
        if not data.keystone then line.keystone.text = GRAY_FONT_COLOR_CODE .. "-" .. FONT_COLOR_CODE_CLOSE; return line end

        local fullName = C_LFGList.GetActivityFullName(data.keystone.activityID)
        local estart, _ = string.find(fullName, " %(")
        local estart2, _ = string.find(fullName, " %- ")
        if estart2 and estart2 < estart then
            estart = estart2
        end
        fullName = string.sub(fullName, 1, estart-1)  
        line.keystone.text = fullName .. " " .. data.keystone.keystoneLevel
        return line
    end
}