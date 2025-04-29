IWBIfBuff = IWBSpellBase:New("IfBuff")

function IWBIfBuff:CreateFrame()
	IWBSpellBase.CreateFrame(self)
	
	local whenBuffCond = CreateFrame("Frame", nil, self.frame)
	whenBuffCond:SetWidth(90)
	whenBuffCond:SetHeight(22)

	local whenBuffTxt = whenBuffCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	whenBuffTxt:SetPoint("TOPLEFT", 0, 0)
	whenBuffTxt:SetText("Buff condition")

	local listBuffs = DropDownTemplate:new()
	listBuffs:CreateFrame("IWBWhenBuff"..self.name, whenBuffCond)
	listBuffs:SetWidth(120)
	listBuffs.frame:SetPoint("LEFT", whenBuffTxt, "LEFT", 70, 0)
	listBuffs:SetOnChange(function() self:SetBuffCondition(listBuffs:GetSelected())  end)
	whenBuffCond.listBuffs = listBuffs
	
	self.frame.whenBuffCond = whenBuffCond
end


function IWBIfBuff:SetBuffCondition(v)
	if v ~= self.spell["when_buff"] then
		self.spell["when_buff"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end


function IWBIfBuff:ShowConfig(spell, onChange)
	local lastFrame = IWBSpellBase.ShowConfig(self, spell, onChange)
	
	self.frame.whenBuffCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
	self.frame.whenBuffCond.listBuffs:SetList(IWB_SPELL_REF[spell["name"]]["buff_list"], self.spell["when_buff"])
	lastFrame = self.frame.whenBuffCond
	
	return lastFrame
end

function IWBIfBuff:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	
	if spell["when_buff"] and spell["when_buff"] ~= "None" then
		local isBuff = IWBUtils:FindBuff(spell["when_buff"], "player")
		if not isBuff then
			isReady = false
		end
	end
	
	return isReady, slot
end
