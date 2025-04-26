	
IWBSeal = IWBSpellBase:New("Seal")

IWBSeal.seals = {
	"Seal of Command", 
	"Seal of Light",
	"Seal of Wisdom", 
	"Seal of Justice", 
	"Seal of the Crusader", 
	"Seal of Righteousness"
}

function IWBSeal:CreateFrame()
	IWBSpellBase.CreateFrame(self)
	
	local buffCond = CreateFrame("Frame", nil, self.frame)
	buffCond:SetWidth(90)
	buffCond:SetHeight(22)

	local titleTxt = buffCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("If no Seals")

	local checkbox = CreateFrame("CheckButton", nil, self.frame, "UICheckButtonTemplate")
	checkbox:SetWidth(22)
	checkbox:SetHeight(22)
	checkbox:SetPoint("LEFT", titleTxt, "LEFT", 85, 0)
	checkbox:SetScript("OnClick", function() self:SetCondition(checkbox:GetChecked()) end)
	
	
	local typeTxt = buffCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	typeTxt:SetPoint("TOPLEFT",titleTxt,"BOTTOMLEFT", 0, -10)
	typeTxt:SetText("Type")

	local typeEl = DropDownTemplate:new()
	typeEl:CreateFrame("IWBSeal"..self.name, buffCond)
	typeEl:SetWidth(80)
	typeEl.frame:SetPoint("LEFT", typeTxt, "LEFT", 70, -5)
	typeEl:SetOnChange(function() self:SetSealType(typeEl:GetSelected())  end)
	typeEl:SetList({"Buff", "Debuff"}, self.spell["seal_type"])
	
	
	buffCond.checkbox = checkbox
	buffCond.typeEl = typeEl
	buffCond.typeTxt = typeTxt
	
	self.frame.buffCond = buffCond
end

function IWBSeal:SetCondition(v)
	if v ~= self.spell["if_no_seals"] then
		self.spell["if_no_seals"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBSeal:SetSealType(v)
	if v ~= self.spell["seal_type"] then
		self.spell["seal_type"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBSeal:ShowConfig(spell, onChange)
	local lastFrame = IWBSpellBase.ShowConfig(self, spell, onChange)
	
	self.frame.buffCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	if spell["seal_type"] == nil or spell["seal_type"] == "" then
		spell["seal_type"] = "Buff"
	end

	if IWB_SPELL_REF[spell["name"]] ~= nil and IWB_SPELL_REF[spell["name"]]["debuff"] then
		self.frame.buffCond.typeEl:SetSelected(spell["seal_type"])
		self.frame.buffCond.typeEl.frame:Show()
		self.frame.buffCond.typeTxt:Show()
	else
		self.frame.buffCond.typeEl.frame:Hide()
		self.frame.buffCond.typeTxt:Hide()
	end
	
	self.frame.buffCond.checkbox:SetChecked(spell["if_no_seals"])
end

function IWBSeal:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	
	if spell["if_no_seals"] == 1 then
		for n=1,table.getn(self.seals) do
			if IWBUtils:FindBuff(self.seals[n], "player") then
				isReady = false
			end
		end
	end

	if isReady then
		if spell["seal_type"] == "Debuff" then
			if IWB_SPELL_REF[spell["name"]] ~= nil and IWB_SPELL_REF[spell["name"]]["debuff"] ~= nil then
				isReady = (not IWBUtils:FindBuff(spell["name"], "player")) and 	
						  (not IWBUtils:FindDebuff(IWB_SPELL_REF[spell["name"]]["debuff"], "target")) 
			end
		else
			isReady = not IWBUtils:FindBuff(spell["name"], "player")
		end
	end

	return isReady, slot
end




