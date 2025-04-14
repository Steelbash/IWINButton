
IWBButtonFrame = {}

function IWBButtonFrame:Initialize(parent)
    
    local frame = CreateFrame("Frame", nil, parent)
	frame:SetToplevel(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")
	frame:SetWidth(240)
	frame:SetHeight(150)
	frame:Hide()

	frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", -35, -10)

	frame:SetBackdrop({
		bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = {
			left = 11,
			right = 12,
			top = 12,
			bottom = 11,
		}
	})
	
	local title = CreateFrame("Frame", nil, frame)
	title:SetWidth(110)
	title:SetHeight(32)
	title:SetPoint("TOP", frame, "TOP", 0, 10)

	local leftTexture = title:CreateTexture(nil, "BACKGROUND")
	leftTexture:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Left")
	leftTexture:SetWidth(75)
	leftTexture:SetHeight(32)
	leftTexture:SetPoint("LEFT", title, "LEFT", -10, 0)
	leftTexture:SetTexCoord(0, 0.29296875, 0, 1.0)

	local rightTexture = title:CreateTexture(nil, "BACKGROUND")
	rightTexture:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right")
	rightTexture:SetWidth(75)
	rightTexture:SetHeight(32)
	rightTexture:SetPoint("RIGHT", title, "RIGHT", 10, 0)
	rightTexture:SetTexCoord(0.70703125, 1.0, 0, 1.0)

	local text = title:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
	text:SetText("Edit Button")
	text:SetWidth(110)
	text:SetHeight(0)
	text:SetPoint("TOP", title, "TOP", 0, -10)

	title.text = text
	frame.title = title
	
	local editBox = CreateFrame("EditBox", nil, frame)
	editBox:SetWidth(130)
	editBox:SetHeight(32)
	editBox:SetPoint("TOP", frame, "TOP", 0, -50)
	editBox:SetAutoFocus(true)
	editBox:SetHistoryLines(1)
	editBox:SetMaxLetters(20)
	editBox:SetFontObject("ChatFontNormal")
	editBox:SetScript("OnEnterPressed", function()
		if self.onApply ~= nil then
			self.onApply(frame.editBox:GetText())
		end
	end)

	local leftTexture = editBox:CreateTexture(nil, "BACKGROUND")
	leftTexture:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Left")
	leftTexture:SetWidth(75)
	leftTexture:SetHeight(32)
	leftTexture:SetPoint("LEFT", editBox, "LEFT", -10, 0)
	leftTexture:SetTexCoord(0, 0.29296875, 0, 1.0)

	local rightTexture = editBox:CreateTexture(nil, "BACKGROUND")
	rightTexture:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right")
	rightTexture:SetWidth(75)
	rightTexture:SetHeight(32)
	rightTexture:SetPoint("RIGHT", editBox, "RIGHT", 10, 0)
	rightTexture:SetTexCoord(0.70703125, 1.0, 0, 1.0)

	local text = editBox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	text:SetText("Name")
	text:SetPoint("TOPLEFT", editBox, "TOPLEFT", -5, 15)
	
	frame.editBox = editBox
	

	local applyButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	applyButton:SetWidth(90)
	applyButton:SetHeight(22)
	applyButton:SetPoint("BOTTOM", frame, "BOTTOM", -50, 20)
	applyButton:SetText("Apply")

	applyButton:SetScript("OnClick", function()
		if self.onApply ~= nil then
			self.onApply(frame.editBox:GetText())
		end
	end)
	
	frame.applyButton = applyButton
	
	local cancelButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	cancelButton:SetWidth(90)
	cancelButton:SetHeight(22)
	cancelButton:SetPoint("BOTTOM", frame, "BOTTOM", 50, 20)
	cancelButton:SetText("Cancel")

	cancelButton:SetScript("OnClick", function()
		self.frame:Hide()
	end)
	
	frame.cancelButton = cancelButton
	
	self.frame = frame
end

function IWBButtonFrame:SetOnApply(onApply)
	self.onApply = onApply
end

function IWBButtonFrame:Show(data)
	self.frame.title.text:SetText(data["title"])
	self.frame.editBox:SetText(data["name"])
	self.frame.applyButton:SetText(data["ok"])
	self.frame.cancelButton:SetText(data["cancel"])
	self.frame:Show()
end

function IWBButtonFrame:Hide()
	self.frame:Hide()
end
