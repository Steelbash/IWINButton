
IWBAutoshot = IWBSpellBase:New("Autoshot")

function IWBAutoshot:CreateFrame()
	IWBSpellBase.CreateFrame(self)
	
	local rangeCond = CreateFrame("Frame", nil, self.frame)
	rangeCond:SetWidth(90)
	rangeCond:SetHeight(22)

	local titleTxt = rangeCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("Melee")

	local checkbox = CreateFrame("CheckButton", nil, rangeCond, "UICheckButtonTemplate")
	checkbox:SetWidth(22)
	checkbox:SetHeight(22)
	checkbox:SetPoint("LEFT", titleTxt, "LEFT", 85, 0)
	checkbox:SetScript("OnClick", function() self:SetMelee(checkbox:GetChecked())  end)
	rangeCond.checkbox = checkbox
	
	local titleDesc = rangeCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleDesc:SetPoint("LEFT", checkbox, "RIGHT", 0, 0)
	titleDesc:SetText("Switch if in range")
	
	self.frame.rangeCond = rangeCond
end

function IWBAutoshot:SetMelee(v)
	if v ~= self.spell["switch_to_melee"] then
		self.spell["switch_to_melee"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBAutoshot:ShowConfig(spell, onChange)
	local lastFrame = IWBSpellBase.ShowConfig(self, spell, onChange)
	
	self.frame.rangeCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	self.frame.rangeCond.checkbox:SetChecked(spell["switch_to_melee"])
end

function IWBAutoshot:IsReady(spell)
	local isReady = true

	local slot = spell["actionBarSlot"]
	if slot ~= nil then
		if IsAutoRepeatAction(slot) then
			isReady = false
		end
		
		if IsActionInRange(slot) == 0 then
			if spell["switch_to_melee"] then
				slot = IWBUtils:FindAttackOnActionBar()
				if IsCurrentAction(slot) then
					isReady = false
				end
			else
				isReady = false
			end
		end
	end
	
	return isReady
end

function IWBAutoshot:Cast(spell)
	local slot = spell["actionBarSlot"]
	if IsActionInRange(slot) == 0 and spell["switch_to_melee"] then
		slot = IWBUtils:FindAttackOnActionBar()
	end 
	
	if slot then
		UseAction(slot)
	end

	return false
end
