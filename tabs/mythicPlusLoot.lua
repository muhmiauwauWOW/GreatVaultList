local addonName = ...
local _ = LibStub("LibLodash-1"):Get()


GreatVaultListMythicPlusLootListMixin  = CreateFromMixins(GreatVaultListListMixin);

function GreatVaultListMythicPlusLootListMixin:OnLoad()
	GreatVaultListListMixin.OnLoad(self)
    self.itemlvl = 0
	self:BuildDataAndInit()
	GreatVaultListFrame:HookScript("OnLoad", function() 
		GreatVaultListFrame:AddTabFn("Mythic Plus Loot", self); --Delves Item Level Loot Table
	end)
end

function GreatVaultListMythicPlusLootListMixin:OnShow()
    self.itemlvl = select(2, GetAverageItemLevel())
	self.reverseSort = true
    self:GetParent().currentPlayer = 0
	self:SetSortOrder(1)
	self:GetParent():UpdateSize(self.width);
end


function GreatVaultListMythicPlusLootListMixin:init(columns, data, columnConfig)
	local asserttext = "variable \"%s\" size is 0"
	GreatVaultList:assert(_.size(columns) > 0, "GreatVaultListListMixin:init", asserttext, "columns")
	GreatVaultList:assert(_.size(data) > 0, "GreatVaultListListMixin:init", asserttext, "data")
	GreatVaultList:assert(_.size(columnConfig) > 0, "GreatVaultListListMixin:init", asserttext, "columnConfig")

    self.columns = columns
	self.ItemList.data = data
    self.columnConfig = columnConfig
	self.columnConfig = self:calcAutoWidthColumns(self.ItemList.data, self.columnConfig, self.columns)

	local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

	self.width = width
    self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList), self.columnConfig);
end



function GreatVaultListMythicPlusLootListMixin:colorItemLvl(itemlvl, ilvl)

    local function ColorGradient(perc, r1, g1, b1, r2, g2, b2)
        if perc >= 1 then
            local r, g, b = r2, g2, b2 -- select(select('#', ...) - 2, ...)
            return r, g, b
        elseif perc <= 0 then
            local r, g, b = r1, g1, b1
            return r, g, b
        end
    
        -- local num = 2 -- select('#', ...) / 3
        -- local segment, relperc = math.modf(perc) --*(num-1))
        -- local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)
    
        return r1 + (r2 - r1) * perc, g1 + (g2 - g1) * perc, b1 + (b2 - b1) * perc
    end


    local function ColorDiff(a, b)
        local diff = a - b
        local perc = diff / 10
    
        local r, g, b
        if perc < 0 then -- higher ilevel than us
            perc = perc * -1
            r, g, b = ColorGradient(perc, 1, 1, 0, 0, 1, 0)
        else
            r, g, b = ColorGradient(perc, 1, 1, 0, 1, 0, 0)
        end
        return r, g, b
    end

    local r1, g1, b1 = ColorDiff(itemlvl, ilvl)

    return CreateColor(r1, g1, b1):WrapTextInColorCode(ilvl)
end


function GreatVaultListMythicPlusLootListMixin:BuildDataAndInit()
	local cols = {}

	local i = 0
	local function getColconfig(name)
		i = i + 1
		table.insert(cols, "col" .. i)
		local config = {}
		config.index = i
		config.width = 40
		config.autoWidth = true
		config.header = {text = name, canSort = false}
		config.colType = "fill"

        if i == 2 or i == 4 then 
            config.populate = function(s, number)
                if type(number) ~= "number" then return number end
                return self:colorItemLvl(self.itemlvl, number)
            end

        end
		return config
	end


	local colConfig = {
		col1 = getColconfig("Keystone Level"),
		col2 = getColconfig("EoD"),
		col3 = getColconfig("Upgrade Level"),
		col4 = getColconfig("Great Vault"),
		col5 = getColconfig("Upgrade Level")
	}

	local data = {
		{ 
			2,
			597,
			"Champion 1/8",
			606,
			"Champion 4/8"
		},
		{ 
			3,
			597,
			"Champion 1/8",
			610,
			"Hero 1/6"
		},
		{ 
			4,
			600,
			"Champion 2/8",
			610,
			"Hero 1/6"
		},
		{ 
			5,
			603,
			"Champion 3/8",
			613,
			"Hero 2/6"
		},
		{ 
			6,
			606,
			"Champion 4/8",
			613,
			"Hero 2/6"
		},
		{ 
			7,
			610,
			"Hero 1/6",
			616,
			"Hero 3/6"
		},
		{ 
			8,
			610,
			"Hero 1/6",
			619,
			"Hero 4/6"
		},
		{ 
			9,
			613,
			"Hero 1/6",
			619,
			"Hero 4/6"
		},
		{ 
			10,
			613,
			"Hero 1/6",
			623,
			"Myth 1/6"
		}
	}

	GreatVaultListFrame.MythicPlusLootList:init(cols, data, colConfig)
end
