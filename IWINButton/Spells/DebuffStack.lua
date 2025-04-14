
IWBDebuffStack = IWBDebuff:New("DebuffStack")

function IWBDebuffStack:CreateFrame()
	IWBDebuff.CreateFrame(self)
	
	local debuffCond = CreateFrame("Frame", nil, self.frame)
	debuffCond:SetWidth(90)
	debuffCond:SetHeight(22)
	debuffCond:SetPoint("TOPLEFT", self.frame, "BOTTOMLEFT", 0, -10)

	local artLayer = debuffCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	artLayer:SetText("Stacks")
	artLayer:SetPoint("TOPLEFT", 0, -10)

	local artLayer2 = debuffCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	artLayer2:SetText(">=")
	artLayer2:SetPoint("TOPLEFT", 50, -10)

	local editBox = CreateFrame("EditBox", nil, debuffCond)
	editBox:SetWidth(15)
	editBox:SetHeight(32)
	editBox:SetPoint("TOPLEFT", 80, 0)
	editBox:SetNumeric(true)
	editBox:SetMaxLetters(2)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject("GameFontHighlightSmall")
	debuffCond.editBox = editBox

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
		self.spell["stack"] = this:GetText()
	end)
	
	self.frame.debuffCond = debuffCond
end

function IWBDebuffStack:ShowConfig(spell, onChange)
	local lastFrame = IWBDebuff.ShowConfig(self, spell, onChange)
	
	self.frame.debuffCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	if spell["stack"] == nil or spell["stack"] == "" then
		spell["stack"] = 1
	end
	self.frame.debuffCond.editBox:SetText(spell["stack"])
end

function IWBDebuffStack:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		local isFound, count = IWBUtils:FindDebuff(spell["name"], "target")
		if not isFound then
			isReady = true
		else
			isReady = (spell["stack"] and count < tonumber(spell["stack"]))
		end
	end
	return isReady, slot
end
