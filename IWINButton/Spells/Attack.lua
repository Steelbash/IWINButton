
IWBAttack = IWBSpellBase:New("Attack")

function IWBAttack:CreateFrame()
	IWBSpellBase.CreateFrame(self)
	
	local rangeCond = CreateFrame("Frame", nil, self.frame)
	rangeCond:SetWidth(90)
	rangeCond:SetHeight(22)

	local titleTxt = rangeCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("Melee range")

	local checkbox = CreateFrame("CheckButton", nil, rangeCond, "UICheckButtonTemplate")
	checkbox:SetWidth(22)
	checkbox:SetHeight(22)
	checkbox:SetPoint("LEFT", titleTxt, "LEFT", 85, 0)
	checkbox:SetScript("OnClick", function() self:SetMeleeRange(checkbox:GetChecked())  end)
	rangeCond.checkbox = checkbox
	
	self.frame.rangeCond = rangeCond
end

function IWBAttack:SetMeleeRange(v)
	if v ~= self.spell["melee_range"] then
		self.spell["melee_range"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBAttack:ShowConfig(spell, onChange)
	local lastFrame = IWBSpellBase.ShowConfig(self, spell, onChange)
	
	self.frame.rangeCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	self.frame.rangeCond.checkbox:SetChecked(spell["melee_range"])
end

function IWBAttack:IsReady(spell)
	local isReady = true

	local slot = IWBUtils:FindSpellOnActionBar(spell["name"], spell["rank"])
	if slot ~= nil then
		if IsCurrentAction(slot) then
			isReady = false
		end
	end
	
	if (spell["auto_target"] ~= 1) and (UnitCanAttack("player", "target") == nil) then
		isReady = false
	end
	
	if (spell["melee_range"] == 1) and (CheckInteractDistance("target", 3) == nil) then
		isReady = false
	end
	
	return isReady
end

function IWBAttack:Cast(spell)
	IWBSpellBase.Cast(self, spell)
	return false
end
