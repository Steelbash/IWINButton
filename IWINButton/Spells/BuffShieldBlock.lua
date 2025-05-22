
IWBShieldBlock = IWBBuff:New("ShieldBlock")

function IWBShieldBlock:CreateFrame()
	IWBBuff.CreateFrame(self)
	
	local extraCond = CreateFrame("Frame", nil, self.frame)
	extraCond:SetWidth(90)
	extraCond:SetHeight(22)

	local titleTxt = extraCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("Condition")

	local checkbox = CreateFrame("CheckButton", nil, extraCond, "UICheckButtonTemplate")
	checkbox:SetWidth(22)
	checkbox:SetHeight(22)
	checkbox:SetPoint("LEFT", titleTxt, "LEFT", 85, 0)
	checkbox:SetScript("OnClick", function() self:SetExtraCond(checkbox:GetChecked())  end)
	extraCond.checkbox = checkbox
	
	local titleDesc = extraCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleDesc:SetPoint("LEFT", checkbox, "RIGHT", 0, 0)
	titleDesc:SetText("If no buff 'Improved Shield Slam'")
	
	self.frame.extraCond = extraCond
end

function IWBShieldBlock:SetExtraCond(v)
	if v ~= self.spell["check_improved_shield_slam"] then
		self.spell["check_improved_shield_slam"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBShieldBlock:ShowConfig(spell, onChange)
	local lastFrame = IWBBuff.ShowConfig(self, spell, onChange)
	
	self.frame.extraCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	self.frame.extraCond.checkbox:SetChecked(spell["check_improved_shield_slam"])
end

function IWBShieldBlock:IsReady(spell)
	local isReady, slot = IWBBuff.IsReady(self, spell)
	if isReady then
		if spell["check_improved_shield_slam"] then
			isReady = isReady and (not IWBUtils:FindBuff("Improved Shield Slam", "player"))
		end
	end
	return isReady, slot
end
