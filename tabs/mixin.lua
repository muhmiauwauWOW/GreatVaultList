local addonName = ...
local L, _ = GreatVaultList:GetLibs()


GreatVaultListLootListMixin  = CreateFromMixins(GreatVaultListListMixin);

GreatVaultListLootListMixin.tabName = ""
GreatVaultListLootListMixin.sortOrder = 1

function GreatVaultListLootListMixin:OnLoad()
	GreatVaultListListMixin.OnLoad(self)
	self.i = 0
    self.itemlvl = 0

	self.columnConfig = {}
	self.columns = {}


	self:BuildData()
	self:init()

	GreatVaultListFrame:HookScript("OnLoad", function() 
		GreatVaultListFrame:AddTabFn(self.tabName, self); --Delves Item Level Loot Table
	end)
end

function GreatVaultListLootListMixin:OnShow()
    self.itemlvl = select(2, GetAverageItemLevel())
	self.reverseSort = true
    self:GetParent().currentPlayer = 0
	self:SetSortOrder(self.sortOrder)
	self:GetParent():UpdateSize(self.width0);
	self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList, true), self.columnConfig);
end


function GreatVaultListLootListMixin:init()
	self.columnConfig = self:calcAutoWidthColumns(self.ItemList.data, self.columnConfig, self.columns)

	local width = 15 + (_.size(self.columnConfig) * 1)
    _.forEach(self.columnConfig, function(entry)
        width = width + (entry.width or 0)
    end)

	self.width = width
    --self.ItemList:SetTableBuilderLayout(self:GetBrowseListLayout(self, self.ItemList, true), self.columnConfig);
end


function GreatVaultListLootListMixin:colorItemLvl(itemlvl, ilvl)

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
        local perc = (diff + 10) / 30
    
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


function GreatVaultListLootListMixin:AddColumn(name, color)
	self.i = self.i + 1
	local key = "col" .. self.i
	self.columnConfig[key] =  self:getColconfig(name, color)
	table.insert(self.columns, key)
end

function GreatVaultListLootListMixin:getColconfig(name, color)
	local config = {}
	config.index = i
	config.width = 50
	config.autoWidth = true
	config.header = {text = name, canSort = false}
	config.colType = "fill"

	if color then 
		config.populate = function(s, number)
			if type(number) ~= "number" then return number end
			return self:colorItemLvl(self.itemlvl, number)
		end
	end
	return config
end