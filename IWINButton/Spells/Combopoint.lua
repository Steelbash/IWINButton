
IWBCombopoint = IWBSpellBase:New("Combopoint")

function IWBCombopoint:CreateFrame()
	IWBSpellBase.CreateFrame(self)
	
	local combCond = CreateFrame("Frame", nil, self.frame)
	combCond:SetWidth(90)
	combCond:SetHeight(22)

	local titleTxt = combCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("Combo points")

	local compLayer = combCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	compLayer:SetText(">=")
	compLayer:SetPoint("LEFT", 90, 5)
	
	local valueEl = DropDownTemplate:new()
	valueEl:CreateFrame("IWBCombopoint"..self.name, combCond)
	valueEl:SetWidth(40)
	valueEl.frame:SetPoint("TOPLEFT", compLayer, "TOPRIGHT", -10, 7)
	valueEl:SetOnChange(function() self:SetValue(valueEl:GetSelected())  end)
	valueEl:SetList({"1", "2", "3", "4", "5"}, self.spell["combopoints"])

	combCond.valueEl = valueEl
	self.frame.combCond = combCond
end

function IWBCombopoint:SetValue(v)
	if v ~= self.spell["combopoints"] then
		self.spell["combopoints"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBCombopoint:ShowConfig(spell, onChange)
	local lastFrame = IWBSpellBase.ShowConfig(self, spell, onChange)
	
	self.frame.combCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	if spell["combopoints"] == nil or spell["combopoints"] == "" then
		spell["combopoints"] = "5"
	end

	self.frame.combCond.valueEl:SetSelected(spell["combopoints"])
	
	return self.frame.combCond
end

function IWBCombopoint:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	
	if isReady then
		isReady = (GetComboPoints("target") >= tonumber(spell["combopoints"]))
	end
	
	return isReady, slot
end




