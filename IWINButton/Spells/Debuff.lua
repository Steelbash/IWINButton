
IWBDebuff = IWBSpellBase:New("Debuff")

function IWBDebuff:CreateFrame()
	IWBSpellBase.CreateFrame(self)

	local hpCond = CreateFrame("Frame", nil, self.frame)
	hpCond:SetWidth(90)
	hpCond:SetHeight(22)
	hpCond:SetPoint("TOPLEFT", self.frame, "BOTTOMLEFT", 0, -10)

	local artLayer = hpCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	artLayer:SetText("Target HP")
	artLayer:SetPoint("TOPLEFT", 0,0)

	local artLayer2 = hpCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	artLayer2:SetText(">=")
	artLayer2:SetPoint("TOPLEFT", 90, 0)

	local editBox = CreateFrame("EditBox", nil, hpCond)
	editBox:SetWidth(30)
	editBox:SetHeight(32)
	editBox:SetPoint("LEFT", 120, 5)
	editBox:SetNumeric(true)
	editBox:SetMaxLetters(10)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject("GameFontHighlightSmall")
	hpCond.editBox = editBox

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
		self.spell["target_hp"] = this:GetText()
	end)
	
	self.frame.hpCond = hpCond
end

function IWBDebuff:ShowConfig(spell, onChange)
	local lastFrame = IWBSpellBase.ShowConfig(self, spell, onChange)
	
	self.frame.hpCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	if spell["target_hp"] == nil or spell["target_hp"] == "" then
		spell["target_hp"] = 0
	end
	self.frame.hpCond.editBox:SetText(spell["target_hp"])
end

function IWBDebuff:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		isReady = (not IWBUtils:FindDebuff(spell["name"], "target")) and 
					(UnitHealth("target") >= tonumber(spell["target_hp"]))
	end
	return isReady, slot
end




