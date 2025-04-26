
IWBCombopointAndDebuff = IWBCombopoint:New("CombopointAndDebuff")

function IWBCombopointAndDebuff:CreateFrame()
	IWBCombopoint.CreateFrame(self)
	
	local buffCond = CreateFrame("Frame", nil, self.frame)
	buffCond:SetWidth(90)
	buffCond:SetHeight(22)

	local titleTxt = buffCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("If no Debuff")

	local checkbox = CreateFrame("CheckButton", nil, self.frame, "UICheckButtonTemplate")
	checkbox:SetWidth(22)
	checkbox:SetHeight(22)
	checkbox:SetPoint("LEFT", titleTxt, "LEFT", 85, 0)
	checkbox:SetScript("OnClick", function() self:SetChecked(checkbox:GetChecked()) end)
	
	buffCond.checkbox = checkbox
	self.frame.buffCond = buffCond
end

function IWBCombopointAndDebuff:SetChecked(v)
	if v ~= self.spell["combopoint_and_debuff"] then
		self.spell["combopoint_and_debuff"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBCombopointAndDebuff:ShowConfig(spell, onChange)
	local lastFrame = IWBCombopoint.ShowConfig(self, spell, onChange)
	
	self.frame.buffCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	self.frame.buffCond.checkbox:SetChecked(spell["combopoint_and_debuff"])
end

function IWBCombopointAndDebuff:IsReady(spell)
	local isReady, slot = IWBCombopoint.IsReady(self, spell)
	
	if isReady then
		isReady = (spell["combopoint_and_debuff"] ~= 1) or (not IWBUtils:FindDebuff(spell["name"], "target"))
	end

	return isReady, slot
end




