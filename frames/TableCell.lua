local GreatVaultList = LibStub("AceAddon-3.0"):GetAddon("GreatVaultList")
local L, _ = GreatVaultList:GetLibs()



GreatVaultListTableCellBaseMixin = CreateFromMixins(TableBuilderCellMixin);

function GreatVaultListTableCellBaseMixin:Init(owner, dataIndex, columns, columnConfig, width)
    self.columns = columns or {}
    self.columnConfig = columnConfig or {}
    self.width = width
end

function GreatVaultListTableCellBaseMixin:PopulateFn(rowData, dataIndex, idx)
    idx = idx or 1
    local text
    local fn = _.get(self.columnConfig, {self.columns[dataIndex], "populate"})
    if fn and type(fn) == "function" then 
        text = fn(self, rowData[dataIndex], idx)
    else 
        text = rowData[dataIndex]
    end


    if not text then 
        local emptyStr = _.get(self.columnConfig, {self.columns[dataIndex], "emptyStr", idx}, _.get(self.columnConfig, {self.columns[dataIndex], "emptyStr"}, "-"))
        text = GRAY_FONT_COLOR:WrapTextInColorCode(emptyStr)
    end
    return tostring(text)
end

GreatVaultListTableCellTextMixin = CreateFromMixins(GreatVaultListTableCellBaseMixin);


function GreatVaultListTableCellTextMixin:Populate(rowData, dataIndex)
	if not dataIndex then return end
    self.Text:SetText(self:PopulateFn(rowData, dataIndex))
end


GreatVaultListTableCellTripleTextMixin = CreateFromMixins(GreatVaultListTableCellBaseMixin);

function GreatVaultListTableCellTripleTextMixin:Populate(rowData, dataIndex)
    _.forEach({"Text1", "Text2", "Text3"}, function(entry, idx)
        self[entry]:SetWidth(math.floor(self.width/3))
        self[entry].Text:SetJustifyH("CENTER")
        self[entry].Text:SetText(self:PopulateFn(rowData, dataIndex, idx))
    end)
end



GreatVaultListTableCellIconMixin = CreateFromMixins(GreatVaultListTableCellBaseMixin);

function GreatVaultListTableCellIconMixin:Populate(rowData, dataIndex)
	local fn = _.get(self.columnConfig, {self.columns[dataIndex], "populate"})
	local icon = fn(rowData, rowData[dataIndex])
    self.Icon:SetAtlas(icon)
end
