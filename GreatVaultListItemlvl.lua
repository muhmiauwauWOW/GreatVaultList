local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.itemlvl = {}

local maxRanks = {
    Explorer = 8,
    Adventurer = 8,
    Veteran = 8,
    Champion = 8,
    Hero = 6,
    Myth = 6
}

local crestIcons = {
    ["weathered"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3285).iconFileID..":12|t",
    ["carved"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3287).iconFileID..":12|t",
    ["runed"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3289).iconFileID..":12|t",
    ["gilded"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3290).iconFileID..":12|t"
}

local crestIconsWithNames  = {
    ["weathered"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3285).iconFileID..":12|t " .. C_CurrencyInfo.GetCurrencyInfo(3285).name,
    ["carved"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3287).iconFileID..":12|t " .. C_CurrencyInfo.GetCurrencyInfo(3287).name,
    ["runed"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3289).iconFileID..":12|t " .. C_CurrencyInfo.GetCurrencyInfo(3289).name,
    ["gilded"] = "|T"..C_CurrencyInfo.GetCurrencyInfo(3290).iconFileID..":12|t " .. C_CurrencyInfo.GetCurrencyInfo(3290).name
}


local data = {
    [642] = {tracks = {{"Explorer", 1}}},
    [645] = {tracks = {{"Explorer", 2}}},
    [649] = {tracks = {{"Explorer", 3}}},
    [652] = {tracks = {{"Explorer", 4}}},
    [655] = {tracks = {{"Explorer", 5}, {"Adventurer", 1}}},
    [658] = {tracks = {{"Explorer", 6}, {"Adventurer", 2}}},
    [662] = {tracks = {{"Explorer", 7}, {"Adventurer", 3}}},
    [665] = {tracks = {{"Explorer", 8}, {"Adventurer", 4}}},
    [668] = {crest = "weathered", tracks = {{"Adventurer", 5}, {"Veteran", 1}}},
    [671] = {crest = "weathered", tracks = {{"Adventurer", 6}, {"Veteran", 2}}},
    [675] = {crest = "weathered", tracks = {{"Adventurer", 7}, {"Veteran", 3}}},
    [678] = {crest = "weathered", tracks = {{"Adventurer", 8}, {"Veteran", 4}}},
    [681] = {crest = "carved", tracks = {{"Veteran", 5}, {"Champion", 1}}},
    [684] = {crest = "carved", tracks = {{"Veteran", 6}, {"Champion", 2}}},
    [688] = {crest = "carved", tracks = {{"Veteran", 7}, {"Champion", 3}}},
    [691] = {crest = "carved", tracks = {{"Veteran", 8}, {"Champion", 4}}},
    [694] = {crest = "runed", tracks = {{"Champion", 5}, {"Hero", 1}}},
    [697] = {crest = "runed", tracks = {{"Champion", 6}, {"Hero", 2}}},
    [701] = {crest = "runed", tracks = {{"Champion", 7}, {"Hero", 3}}},
    [704] = {crest = "runed", tracks = {{"Champion", 8}, {"Hero", 4}}},
    [707] = {crest = "gilded", tracks = {{"Hero", 5}, {"Myth", 1}}},
    [710] = {crest = "gilded", tracks = {{"Hero", 6}, {"Myth", 2}}},
    [714] = {crest = "gilded", tracks = {{"Myth", 3}}},
    [717] = {crest = "gilded", tracks = {{"Myth", 4}}},
    [720] = {crest = "gilded", tracks = {{"Myth", 5}}},
    [723] = {crest = "gilded", tracks = {{"Myth", 6}}}
}

GreatVaultList.itemlvl.data = data
local function buildTrackKey(name) return "gearTrack_" .. name end

function GreatVaultList.itemlvl:GetTracksByItemLevel(ilvl)
    if not self.data[ilvl] then return nil end
    return self.data[ilvl].tracks or nil
end

function GreatVaultList.itemlvl:GetCrestByItemLevel(ilvl)
    if not self.data[ilvl] then return nil end
    return self.data[ilvl].crest or nil
end

function GreatVaultList.itemlvl:GetCrestIconByKey(key, name)
    local data = crestIcons
    if name then
        data = crestIconsWithNames
    end
    if not data[key] then return nil end
    return data[key] or nil
end



function GreatVaultList.itemlvl:GetHighestTrackString(ilvl)
    local tracks = self.data[ilvl] and self.data[ilvl].tracks
    if not tracks then
        return "unknown"
    end
    if #tracks > 0 then
        local highest = tracks[#tracks]
        local translation = L[buildTrackKey(highest[1])]
        return string.format(
            "%s %d/%d",
            translation,
            highest[2],
            self:GetMaxRankForTrack(highest[1])
        )
    end
    return "unknown"
end

function GreatVaultList.itemlvl:GetMaxRankForTrack(trackName)
    return maxRanks[trackName] or 8
end

