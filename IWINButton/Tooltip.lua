
IWBTooltip = {}

function IWBTooltip:Initialize()
	local frame = CreateFrame("GameTooltip", "IWBTooltipFrame", WorldFrame, "GameTooltipTemplate")
	frame:SetOwner(WorldFrame, "ANCHOR_NONE")
	
	self.frame = frame
end

function IWBTooltip:SetAction(slot)
	self.frame:ClearLines()
	self.frame:SetAction(slot)
end

function IWBTooltip:SetUnitBuff(unit, i)
	self.frame:ClearLines()
	self.frame:SetUnitBuff(unit, i)
end

function IWBTooltip:SetInventoryItem(unit, i)
	self.frame:ClearLines()
	self.frame:SetInventoryItem(unit, i)
end

function IWBTooltip:SetUnitDebuff(unit, i)
	self.frame:ClearLines()
	self.frame:SetUnitDebuff(unit, i)
end

function IWBTooltip:SetTrackingSpell()
	self.frame:ClearLines()
	self.frame:SetTrackingSpell()
end

function IWBTooltip:GetText(rName)
	return getglobal("IWBTooltipFrame"..rName):GetText()
end
