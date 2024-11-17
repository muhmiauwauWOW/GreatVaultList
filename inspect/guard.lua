local _ = LibStub("LibLodash-1"):Get()
DevTool = DevTool or { AddData = function(str, name) end }

local PermissionGuard = LibStub:NewLibrary("PermissionGuard-1", 1)

local Guard = {}

Guard.permissionOrder = {
    "Self",
    "BattleNetFriend",
    "Friend",
    -- "Guild",
    "Group",
    -- "Raid"
}


local function validateInput(self, user)
    assert(user)
    assert(self.permissions, "PermissionGuard: No permission set")
	if not user then return true end

    local match = string.match(user, "^Player%-[0-9]*%-[0-9A-Z]*$")
    if not match == user then return true end

    return false
end



function Guard:SetPermissions(obj)
    self.permissions = obj
end

function Guard:GetRegisterdPermissionsTypes()
    return Guard.permissionOrder
end

function Guard:check(user)
    if validateInput(self, user) then return end

    local allow = false

    _.forEach(self.permissionOrder, function(key, index)
        if not allow then 
            if self.permissions[key] or key == "Self" then 
                local Fn = self["Is" .. key] or function(self, user) return false end
                allow = Fn(self, user)
                if allow then 
                   DevTool:AddData(key, "allow because of")
                end
            end
        end
    end)

    DevTool:AddData(tostring(allow), "PermissionGuard check")
    -- DevTool:AddData(self.permissions, "permissions")

    return allow
end





function Guard:IsSelf(user)
    if validateInput(self, user) then return end
	if user == UnitGUID("player") then return true end
end

function Guard:IsBattleNetFriend(user)
    if validateInput(self, user) then return end

	local gameAccountInfo  = {C_BattleNet.GetGameAccountInfoByGUID(user)}
	if not _.size(gameAccountInfo) == 0 then return true end

	return false
end

function Guard:IsFriend(user)
    if validateInput(self, user) then return end
	local isFriend = C_FriendList.IsFriend(user)
	return isFriend
end


function Guard:IsGuild(user)
    if validateInput(self, user) then return end
    if not IsInGuild() then return false end
    -- print("is guild", user)

    -- local localizedClass, englishClass, localizedRace, englishRace, sex, name, realmName = GetPlayerInfoByGUID(user)
    -- print(localizedClass, englishClass, localizedRace, englishRace, sex, name, realmName)


end



function Guard:IsGroup(user)
    if validateInput(self, user) then return end
    if not IsInGroup() then return false end
    -- print("IsGroup", user)

	return IsGUIDInGroup(user)
end


function Guard:IsRaid(user)
    if validateInput(self, user) then return end
    if not IsInRaid() then return false end
    -- print("IsGroup", user)

	-- return IsGUIDInGroup(user)
end







PermissionGuard = Mixin(PermissionGuard, Guard)


-- GreatVaultList.Inspect = GreatVaultList.Inspect or {}
-- GreatVaultList.Inspect.Guard = Guard