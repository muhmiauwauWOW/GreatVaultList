local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()

GreatVaultList.Data = {}

function GreatVaultList.Data:init()
    GreatVaultList.db.global.characters = GreatVaultList.db.global.characters or {}
    self.characterInfo = Mixin({}, self:get())
    self.disabled = UnitLevel("player") < GetMaxLevelForPlayerExpansion()
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
    if not config then return end
    
    local store = _.get(config, { "store" }, function(e) return e end)
    if not store or type(store) ~= "function" then return end
    
    -- Store the data with error handling (prevents crashes from malformed store functions)
    local success, result = pcall(store, self.characterInfo)
    if not success then
        print("GreatVaultList: Failed to execute store function for column:", config.key or "unknown")
        return
    end
    
    -- Update characterInfo with the result (if the store function returned data)
    if result then
        self.characterInfo = result
    end
    
    -- Update timestamp for data freshness tracking
    self.characterInfo.lastUpdate = time()
    
    -- If this is a write operation, persist to database immediately
    if write then 
        self:write() 
    end
    
    return self.characterInfo
end

function GreatVaultList.Data:storeAll()
    if self.disabled then return end
    
    -- Store each column with immediate persistence to ensure data safety (prevents data loss)
    local successCount = 0
    local totalCount = 0
    
    _.forEach(GreatVaultList.ModuleColumns, function(entry, key)
        totalCount = totalCount + 1
        local success = pcall(function()
            self:store(entry.config, true) -- Set write = true for each column (immediate persistence)
        end)
        if success then
            successCount = successCount + 1
        else
            -- Log error for debugging (helps identify problematic columns)
            print("GreatVaultList: Failed to store data for column:", key)
        end
    end)
    
    -- Final write to ensure all data is synchronized in the database
    if successCount > 0 then
        self:write()
    end
    
    -- Return success status for debugging (true = all columns processed successfully)
    return successCount == totalCount

end
