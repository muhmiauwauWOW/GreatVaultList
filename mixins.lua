local addonName = ...
local AddOnInfo = {C_AddOns.GetAddOnInfo(addonName)}
local L, _, TableBuilderLib = GreatVaultList:GetLibs()





GreatVaultListTableCellTextMixin = CreateFromMixins(TableBuilderCellMixin);

function GreatVaultListTableCellTextMixin:Init(owner, columnConfig)
    self.columnConfig = columnConfig or {}
end

function GreatVaultListTableCellTextMixin:PopulateFn(rowData, dataIndex, idx)
    idx = idx or 1
    local text
    local fn = self.columnConfig.populate
    if fn then
        text = fn(self, rowData[dataIndex], idx)
    else 
        text = rowData[dataIndex]
    end

    if not text then 
        local emptyStr = _.get(self.columnConfig, {"emptyStr", idx}, _.get(self.columnConfig, {"emptyStr"}, "-"))
		return GRAY_FONT_COLOR:WrapTextInColorCode(emptyStr)
    end
    return tostring(text)
end

function GreatVaultListTableCellTextMixin:Populate(rowData, dataIndex)
    self.Text:SetText(self:PopulateFn(rowData, dataIndex))
end


GreatVaultListTableCellTripleTextMixin = CreateFromMixins(GreatVaultListTableCellTextMixin);

function GreatVaultListTableCellTripleTextMixin:Populate(rowData, dataIndex)
    _.forEach({"Text1","Text2","Text3"}, function(entry, idx)
        self[entry]:SetWidth(math.floor(self.columnConfig.width/3))
        self[entry].Text:SetJustifyH("CENTER")
		local text = self:PopulateFn(rowData, dataIndex, idx)
        self[entry].Text:SetText(self:PopulateFn(rowData, dataIndex, idx))
    end)
end




GreatVaultListMixin = {}



function GreatVaultListMixin:OnLoad()
	self:SetPortraitTextureRaw("Interface\\AddOns\\GreatVaultList\\vault.png")
	self:GetPortrait():ClearAllPoints()
	self:GetPortrait():SetPoint("TOPLEFT", -2, 5)
	self:GetPortrait():SetSize(55, 55)

	self:SetTitle(AddOnInfo[2]) -- set addon name as title

    self.width = 800

    local dragarea = GreatVaultListFrame.Drag
    GreatVaultListFrame:SetMovable(true)
    GreatVaultListFrame:EnableMouse(true)
    dragarea:EnableMouse(true)
    dragarea:RegisterForDrag("LeftButton")
    dragarea:SetScript("OnDragStart", function(self, button)
        GreatVaultListFrame:StartMoving()
    end)

    dragarea:SetScript("OnDragStop", function(self)
        GreatVaultListFrame:StopMovingOrSizing()
    end)
end

function GreatVaultListMixin:OnShow()
    self:UpdateSize();
	
	local width = TableBuilderLib:GetWidth("GreatVaultListTable")
	self:SetWidth(width)
   -- self.ListFrame.ItemList:RefreshScrollFrame();
end


function GreatVaultListMixin:UpdateSize(width)
    -- self.width = width or self.width

    if not  GreatVaultList.db then return  end 
    local height = (GreatVaultList.db.global.Options.lines * 21) + 70 + 19  + 7
    -- self:SetWidth(self.width)
    self:SetHeight(height)
end


function GreatVaultListMixin:OnHide()
end


function GreatVaultListMixin:RefreshScrollFrame()
	self.ListFrame.ItemList:RefreshScrollFrame();
end








GreatVaultListListMixin = {};

function GreatVaultListListMixin:OnLoad()
end

function GreatVaultListListMixin:init(data, columnConfig, refresh)


	self.currentPlayer = 0
  
	local config = {
	} 
  
  
	TableBuilderLib:New("GreatVaultListTable", self, config, columnConfig, data)


	-- TableBuilderLib:SetData("GreatVaultListTable", data)


	if true then return end
	self.currentPlayer =  _.findIndex(self.ItemList.data, function(entry)  return entry[fidx] == UnitName("player") end)
	self.ItemList:RefreshScrollFrame();
end