
IWBSpellBase = {["name"] = "Base"}

function IWBSpellBase:New(name)
    local obj  = {
		["name"] = name,
		["created"] = false,
		["frame"] = nil,
		["onChange"] = nil,
		["spell"] = nil
	}
    setmetatable(obj, { __index = self })
    return obj 
end

function IWBSpellBase:CreateFrame()
	local frame = CreateFrame("Frame", nil, IWBMainFrame.frame.rotationTab.spellProps)
	frame:SetAllPoints(IWBMainFrame.frame.rotationTab.spellProps)
	
	local frameTop = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frameTop:SetHeight(0)
	frameTop:SetPoint("TOPLEFT", 10, -15)
	frame.frameTop = frameTop
	
	local rankCond = CreateFrame("Frame", nil, frame)
	rankCond:SetWidth(90)
	rankCond:SetHeight(22)
	rankCond:SetPoint("TOPLEFT", frameTop, "BOTTOMLEFT", 0, 0)

	local rankTitle = rankCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	rankTitle:SetPoint("TOPLEFT", 0, 0)
	rankTitle:SetText("Rank")
	rankCond.rankTitle = rankTitle
	
	local rankList = DropDownTemplate:new()
	rankList:CreateFrame("IWBRankList"..self.name, rankCond)
	rankList:SetWidth(40)
	rankList:SetOnChange(function() self:SetRank(rankList:GetSelected())  end)
	rankList.frame:SetPoint("LEFT", rankTitle, "LEFT", 70, 0)
	rankCond.rankList = rankList
	
	local maxButton = CreateFrame("Button", nil, rankCond, "UIPanelButtonTemplate")
	maxButton:SetWidth(35)
	maxButton:SetHeight(22)
	maxButton:SetText("max")
	maxButton:SetPoint("LEFT", rankList.frame, "RIGHT", -10, 3)
	maxButton:SetScript("OnClick", function() self:MaxOnClick() end)
	rankCond.maxButton = maxButton

	
	local autoCond = CreateFrame("Frame", nil, frame)
	autoCond:SetWidth(90)
	autoCond:SetHeight(22)

	local titleTxt = autoCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titleTxt:SetPoint("TOPLEFT", 0, 0)
	titleTxt:SetText("Auto target")

	local checkbox = CreateFrame("CheckButton", nil, autoCond, "UICheckButtonTemplate")
	checkbox:SetWidth(22)
	checkbox:SetHeight(22)
	checkbox:SetPoint("LEFT", titleTxt, "LEFT", 85, 0)
	checkbox:SetScript("OnClick", function() self:SetAutoTarget(checkbox:GetChecked()) end)
	autoCond.checkbox = checkbox
	
	frame.autoCond = autoCond
	frame.rankCond = rankCond
	
	self.frame = frame
	self.created = true
end

function IWBSpellBase:SetAutoTarget(v)
	if v ~= self.spell["auto_target"] then
		self.spell["auto_target"] = v
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBSpellBase:Show()
	self.frame:Show()
end

function IWBSpellBase:Hide()
	self.frame:Hide()
end

function IWBSpellBase:SetRank(v)
	local maxRank = IWBUtils:GetSpellMaxRank(self.spell["name"])
	if maxRank and tonumber(v) < maxRank then
		self.frame.rankCond.maxButton:Enable()
	else
		self.frame.rankCond.maxButton:Disable()
	end

	local rank = "Rank "..v
	if rank ~= self.spell["rank"] then
		self.spell["rank"] = rank
		self.spell["id"] = IWBUtils:GetSpellId(self.spell["name"], self.spell["rank"])
		
		if self.onChange ~= nil then
			self.onChange()
		end
	end
end

function IWBSpellBase:MaxOnClick()
	local maxRank = IWBUtils:GetSpellMaxRank(self.spell["name"])
	self.frame.rankCond.rankList:SetSelected(tostring(maxRank))
end

function IWBSpellBase:ShowConfig(spell, onChange)
	self.spell = spell
	self.onChange = onChange
	
	if not self.created then
		self:CreateFrame()
	end

	local lastFrame = self.frame.frameTop
	
	self.frame:Show()
	
	if (spell["rank"] ~= nil and spell["rank"] ~= "") then
		self.frame.rankCond:Show()
		lastFrame = self.frame.rankCond
		
		local list = {}
		local rankNum = IWBUtils:GetRankNum(spell["rank"])
		local maxRank = IWBUtils:GetSpellMaxRank(spell["name"])
		if maxRank then
			for i = 1,maxRank do
				table.insert(list, tostring(i))
			end
		end
		self.frame.rankCond.rankList:SetList(list, rankNum)
	else
		self.frame.rankCond:Hide()
	end
	
	if IWB_SPELL_REF[spell["name"]] ~= nil and IWB_SPELL_REF[spell["name"]]["auto_target"] then
		self.frame.autoCond:Show()
		self.frame.autoCond:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
		self.frame.autoCond.checkbox:SetChecked(spell["auto_target"])
		lastFrame = self.frame.autoCond
	else
		self.frame.autoCond:Hide()
	end
	
	return lastFrame
end

function IWBSpellBase:IsReady(spell)
	local isReady = true

	local slot = spell["actionBarSlot"]
	if slot ~= nil then
		if not IsUsableAction(slot) or IsActionInRange(slot) == 0 then
			isReady = false
		end
	end
	
	local spellId = IWBUtils:GetSpellId(spell["name"], spell["rank"])
	if isReady and (GetSpellCooldown(spellId, "spell") ~= 0) then
		isReady = false
	end
	
	if (IWB_SPELL_REF[spell["name"]] ~= nil) and IWB_SPELL_REF[spell["name"]]["auto_target"] and
		(spell["auto_target"] ~= 1) and (UnitCanAttack("player", "target") == nil) then
		isReady = false
	end
	
	if (IWB_SPELL_REF[spell["name"]] ~= nil) and (IWB_SPELL_REF[spell["name"]]["need_range"] ~= nil) and (UnitCanAttack("player", "target") ~= nil) then
		isReady = isReady and (CheckInteractDistance("target", IWB_SPELL_REF[spell["name"]]["need_range"]) == 1)
	end
	
	return isReady, slot
end

function IWBSpellBase:Cast(spell)
	local spell_id = IWBUtils:GetSpellId(spell["name"], spell["rank"])
	if spell_id then
		CastSpell(spell_id, "spell")
	end
	return true
end

