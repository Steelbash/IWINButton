
IWBCombopointAndBuff = IWBCombopoint:New("CombopointAndBuff")

function IWBCombopointAndBuff:CreateFrame()
	IWBCombopoint.CreateFrame(self)
	
	local buffCond = CreateFrame("Frame", nil, self.frame)
	buffCond:SetWidth(90)
	buffCond:SetHeight(22)

	local titleTxt = buffCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("If no buff")

	local checkbox = CreateFrame("CheckButton", nil, self.frame, "UICheckButtonTemplate")
	checkbox:SetWidth(22)
	checkbox:SetHeight(22)
	checkbox:SetPoint("LEFT", titleTxt, "LEFT", 85, 0)
	checkbox:SetScript("OnClick", function() self:SetChecked(checkbox:GetChecked()) end)
	
	buffCond.checkbox = checkbox
	self.frame.buffCond = buffCond
end

function IWBCombopointAndBuff:SetChecked(v)
	if v ~= self.spell["combopoint_and_buff"] then
		self.spell["combopoint_and_buff"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBCombopointAndBuff:ShowConfig(spell, onChange)
	local lastFrame = IWBCombopoint.ShowConfig(self, spell, onChange)
	
	self.frame.buffCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	self.frame.buffCond.checkbox:SetChecked(spell["combopoint_and_buff"])
end

function IWBCombopointAndBuff:IsReady(spell)
	local isReady, slot = IWBCombopoint.IsReady(self, spell)
	
	if isReady then
		isReady = (spell["combopoint_and_buff"] ~= 1) or (not IWBUtils:FindBuff(spell["name"], "player"))
	end

	return isReady, slot
end




