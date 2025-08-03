local addonName = ...
local L, _ = GreatVaultList:GetLibs()
local LibGearData = LibStub("LibGearData-1.0")


local TabID = "raidLoot"
local Tab = GreatVaultList:NewModule(TabID, GREATVAULTLIST_TABS)

Tab.id = TabID
Tab.name = string.format(L["tabLoot_name"], RAIDS)
Tab.template = "GreatVaultListRaidLootTemplate"


GreatVaultListRaidLootListMixin  = CreateFromMixins(GreatVaultListLootListMixin);

GreatVaultListRaidLootListMixin.id = TabID
GreatVaultListRaidLootListMixin.tabName = Tab.name
GreatVaultListRaidLootListMixin.sortOrder = 5


function GreatVaultListRaidLootListMixin:OnLoad()
	GreatVaultListLootListMixin.OnLoad(self)
	-- GreatVaultList.ElvUi:AddTab(self)
end

function GreatVaultListRaidLootListMixin:GetHelpConfig()

	local width = self:GetWidth()
	local height = self:GetHeight() + 50



	local helpConfig = {
		FramePos = { x = 0, y = 0 },
		FrameSize = { width = width, height = height },
		[1] = { ButtonPos = { position = "CENTER" }, HighLightBox = { x = 5, y = -40, width = width + 10 , height = height - 40 - 5 - 50 },  ToolTipDir = "RIGHT",   ToolTipText = L["HELP_Loot_table"] },
	}

	return helpConfig
end

function GreatVaultListRaidLootListMixin:BuildData()


	
	 function GetRaidLootList()
        local raidData = LibGearData:GetData("raid")
        if not raidData then return {} end

        local crests = {}
		local ilvls = {}
		local result = {}

		for _, entry in ipairs(raidData) do
			if entry.loot and entry.difficulty then
				if not ilvls[entry.difficulty] then
					ilvls[entry.difficulty] = {}
				end
				table.insert(ilvls[entry.difficulty], entry.loot)
			end

			if entry.crest and entry.crestAmount and entry.difficulty then
				if not crests[entry.difficulty] then
					crests[entry.difficulty] = {}
				end
				crests[entry.difficulty] = {
					crest = entry.crest,
					crestAmount = entry.crestAmount
				}
			end
		end

		local DifficultiesOrder = LibGearData:GetDifficultiesOrder("raid")
		for k, v in pairs(DifficultiesOrder) do
			local crestsObj = crests and crests[v]
			local crestAmount = crestsObj and crests[v]["crestAmount"] or "-"
			local crest = crestsObj and crests[v]["crest"] or {}
			local crestStr = crestsObj and crest.icon and crest.name and
								string.format("%s %s", crest.icon, crest.name) or
								""

			table.insert(result, {
				name = v,
				ilvls = ilvls[v],
				crest = crestStr,
				crestAmount = crestAmount
			})
		end
		return {
			bosses = LibGearData:GetRaidBossesMap(),
			data = result
		}
    end

    local raidloot = GetRaidLootList()

	local lootTable = {}
	self:AddColumn(L["raidLoot_col1"])
	_.forEach(raidloot.bosses, function (v)
		self:AddColumn(string.format(L["raidLoot_bosses"], v), true)
	end)
	self:AddColumn(L["tabLoot_crestType"], false, L["tabLoot_crestType_desc"])




    _.forEach(raidloot.data, function (value)
		local row = {value.name}
		_.forEach(value.ilvls,function (e)
			_.push(row, e)
		end)
        _.push(row, value.crest)
        _.push(lootTable, row)
    end)

    self.ItemList.data = lootTable
end