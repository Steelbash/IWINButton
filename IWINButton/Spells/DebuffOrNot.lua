
IWBDebuffOrNot = IWBSpellBase:New("DebuffOrNot")

function IWBDebuffOrNot:CreateFrame()
	IWBSpellBase.CreateFrame(self)
	
	local behaviorCond = CreateFrame("Frame", nil, self.frame)
	behaviorCond:SetWidth(90)
	behaviorCond:SetHeight(22)

	local titleTxt = behaviorCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("Type")
	behaviorCond.titleTxt = titleTxt
	
	local listEl = DropDownTemplate:new()
	listEl:CreateFrame("IWBDebuffOrNot"..self.name, behaviorCond)
	listEl:SetWidth(80)
	listEl.frame:SetPoint("TOPLEFT", titleTxt, "TOPRIGHT", 5, 7)
	listEl:SetOnChange(function() self:SetBehavior(listEl:GetSelected())  end)
	listEl:SetList({"Spell", "Debuff"}, self.spell["behavior"])

	behaviorCond.listEl = listEl
	self.frame.behaviorCond = behaviorCond
end

function IWBDebuffOrNot:SetBehavior(v)
	if v ~= self.spell["behavior"] then
		self.spell["behavior"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBDebuffOrNot:ShowConfig(spell, onChange)
	local lastFrame = IWBSpellBase.ShowConfig(self, spell, onChange)
	
	self.frame.behaviorCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	if spell["behavior"] == nil or spell["behavior"] == "" then
		spell["behavior"] = "Spell"
	end
	self.frame.behaviorCond.listEl:SetSelected(spell["behavior"])
end

function IWBDebuffOrNot:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	
	if isReady and (spell["behavior"] == "Debuff") then
		isReady = not IWBUtils:FindDebuff(spell["name"], "target")
	end
	return isReady, slot
end




