
IWBBloodrage = IWBSpellBase:New("Bloodrage")


function IWBBloodrage:CreateFrame()
	IWBSpellBase.CreateFrame(self)

	local rageCond = CreateFrame("Frame", nil, self.frame)
	rageCond:SetWidth(90)
	rageCond:SetHeight(22)
	rageCond:SetPoint("TOPLEFT", self.frame, "BOTTOMLEFT", 0, 0)

	local artLayer = rageCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	artLayer:SetText("Rage")
	artLayer:SetPoint("TOPLEFT", 0, 0)

	local artLayer2 = rageCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	artLayer2:SetText("<=")
	artLayer2:SetPoint("TOPLEFT", 90, 0)

	local editBox = CreateFrame("EditBox", nil, rageCond)
	editBox:SetWidth(15)
	editBox:SetHeight(32)
	editBox:SetPoint("LEFT", 120, 5)
	editBox:SetNumeric(true)
	editBox:SetMaxLetters(2)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject("GameFontHighlightSmall")
	rageCond.editBox = editBox

	local leftTex = editBox:CreateTexture(nil, "BACKGROUND")
	leftTex:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Left")
	leftTex:SetWidth(25)
	leftTex:SetHeight(32)
	leftTex:SetPoint("LEFT", -10, 0)
	leftTex:SetTexCoord(0, 0.29296875, 0, 1.0)

	local rightTex = editBox:CreateTexture(nil, "BACKGROUND")
	rightTex:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right")
	rightTex:SetWidth(25)
	rightTex:SetHeight(32)
	rightTex:SetPoint("RIGHT", 10, 0)
	rightTex:SetTexCoord(0.70703125, 1.0, 0, 1.0)

	editBox:SetScript("OnEnterPressed", function()
		this:ClearFocus()
	end)

	editBox:SetScript("OnTextChanged", function()
		self.spell["rage"] = this:GetText()
		if self.spell["rage"] == nil or self.spell["rage"] == "" then
			self.spell["rage"] = 0
		end
	end)
	
	self.frame.rageCond = rageCond
end

function IWBBloodrage:ShowConfig(spell, onChange)
	local lastFrame = IWBSpellBase.ShowConfig(self, spell, onChange)
	
	self.frame.rageCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	if spell["rage"] == nil or spell["rage"] == "" then
		spell["rage"] = 0
	end
	self.frame.rageCond.editBox:SetText(spell["rage"])
end

function IWBBloodrage:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		isReady = UnitMana("player") <= tonumber(spell["rage"])
	end
	return isReady, slot
end
