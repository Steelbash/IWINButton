
SpellItemTemplate = {}

function SpellItemTemplate:new()
    local self = {}
    setmetatable(self, { __index = SpellItemTemplate })
    return self
end

function SpellItemTemplate:CreateFrame(parent, width, height, onclick)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetWidth(width)
	frame:SetHeight(height)
	frame:SetFrameStrata("DIALOG")
	frame:SetToplevel(true)
	frame:EnableMouse(true)
	frame:SetPoint("TOPLEFT", 0, 0)
	frame:Show()
	
	local highlight = frame:CreateTexture(nil, "BACKGROUND")
	highlight:SetWidth(width)
	highlight:SetHeight(height)
	highlight:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight")
	highlight:SetPoint("TOPLEFT", 0, 0)

	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetWidth(18)
	icon:SetHeight(18)
	icon:SetPoint("LEFT", 3, 0)
	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	
	local nameText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	nameText:SetPoint("LEFT", 25, 0)

	local rankText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	rankText:SetPoint("RIGHT", 0, 0)
	
	local warnIcon = frame:CreateTexture(nil, "ARTWORK")
	warnIcon:SetWidth(18)
	warnIcon:SetHeight(18)
	warnIcon:SetTexture("Interface\\DialogFrame\\DialogAlertIcon")
	warnIcon:SetPoint("RIGHT", -50, 0)
	warnIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	
	local hoverFrame = CreateFrame("Frame", nil, frame)
	hoverFrame:SetAllPoints(warnIcon)
	hoverFrame:EnableMouse(true)
	
	hoverFrame:SetScript("OnMouseDown", function()
		if arg1 == "LeftButton" then
			if self.onClick ~= nil then
				self.onClick(self.frame)
			end
		end
	end)
	IWBUtils:SetTooltip(hoverFrame, "Put spell on action bar")

	
	self.frame = frame
	self.icon = icon
	self.nameText = nameText
	self.rankText = rankText
	self.highlight = highlight
	self.warnIcon = warnIcon
	self.warnFrame = hoverFrame
	
	self:SetSelected(false)
end

function SpellItemTemplate:SetSelected(v)
	self.selected = v
	if v then
		self.nameText:SetFontObject("GameFontHighlight")
		self.rankText:SetFontObject("GameFontHighlight")
		self.highlight:Show()
	else
		self.nameText:SetFontObject("GameFontNormal")
		self.rankText:SetFontObject("GameFontNormal")
		self.highlight:Hide()
	end
end

function SpellItemTemplate:GetSelected()
	return self.selected
end

function SpellItemTemplate:SetData(data)
	self.icon:SetTexture(data["texture"])
	self.nameText:SetText(data["name"])
	self.rankText:SetText(data["rank"])
	if data["actionBarSlot"] ~= nil then
		self.warnFrame:Hide()
		self.warnIcon:Hide()
	else
		self.warnFrame:Show()
		self.warnIcon:Show()
	end
end

function SpellItemTemplate:SetOnClick(onclick)
	self.onClick = onclick
	self.frame:SetScript("OnMouseDown", function()
		if arg1 == "LeftButton" then
			onclick(self.frame)
		end
	end)
end
