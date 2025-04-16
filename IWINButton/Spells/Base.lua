
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
	frameTop:SetPoint("TOPLEFT", 10, 0)
	frame.frameTop = frameTop
	
	local rankCond = CreateFrame("Frame", nil, frame)
	rankCond:SetWidth(90)
	rankCond:SetHeight(22)
	rankCond:SetPoint("TOPLEFT", frameTop, "BOTTOMLEFT", 0, -10)

	local rankTitle = rankCond:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	rankTitle:SetPoint("TOPLEFT", 0, 0)
	rankTitle:SetText("Rank")
	rankCond.rankTitle = rankTitle
	
	local rankList = DropDownTemplate:new()
	rankList:CreateFrame("IWBRankList"..self.name, rankCond)
	rankList:SetWidth(40)
	rankList:SetOnChange(function() self:SetRank(rankList:GetSelected())  end)

	rankList.frame:SetPoint("TOPLEFT", rankTitle, "TOPRIGHT", 5, 7)
	rankCond.rankList = rankList
	frame.rankCond = rankCond
	
	self.frame = frame
	self.created = true
end

function IWBSpellBase:Show()
	self.frame:Show()
end

function IWBSpellBase:Hide()
	self.frame:Hide()
end

function IWBSpellBase:SetRank(v)
	local rank = "Rank "..v
	if rank ~= self.spell["rank"] then
		self.spell["rank"] = rank
		if self.onChange ~= nil then
			self.onChange()
		end
	end
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
		for i = 1,IWBUtils:GetSpellMaxRank(spell["name"]) do
			table.insert(list, tostring(i))
		end
		self.frame.rankCond.rankList:SetList(list, IWBUtils:GetRankNum(spell["rank"]))
	else
		self.frame.rankCond:Hide()
	end
	
	return lastFrame
end

function IWBSpellBase:IsReady(spell)
	local isReady = true

	local slot = IWBUtils:FindSpellOnActionBar(spell["name"], spell["rank"])
	if slot ~= nil then
		if not IsUsableAction(slot) or IsActionInRange(slot) == 0 then
			isReady = false
		end
	end
	
	if isReady and (GetSpellCooldown(spell["id"], "spell") ~= 0) then
		isReady = false
	end
	
	return isReady, slot
end

function IWBSpellBase:Cast(spell)
	CastSpell(spell["id"], "spell")
end

