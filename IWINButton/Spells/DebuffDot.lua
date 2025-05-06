
IWBDebuffDot = IWBDebuff:New("DebuffDot")

IWBDebuffDot.dotStart = {}

local frame = CreateFrame("Frame", nil)
IWBDebuffDot.frame = frame

frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")


frame:SetScript('OnEvent', function()
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		local _, _, dotName = string.find(arg1, "Your (%a+) was")
		if dotName then
			local _, uuid = UnitExists("target")
			IWBDebuffDot:SetUnitDotTime(dotName, uuid, 0)
		end
	end
end)

function IWBDebuffDot:SetUnitDotTime(dotName, uuid, tt)
	if not uuid then
		return
	end
	
	if not IWBDebuffDot.dotStart[dotName] then
		IWBDebuffDot.dotStart[dotName] = {}
	end
	IWBDebuffDot.dotStart[dotName][uuid] = tt

	-- Clear old values
	for key, value in pairs(IWBDebuffDot.dotStart[dotName]) do
		if GetTime() - value > 60 then
			IWBDebuffDot.dotStart[dotName][key] = nil
		end
	end
end

function IWBDebuffDot:IsUnitDotTimeOut(dotName, uuid)
	if not uuid then
		return false
	end
	if (not IWBDebuffDot.dotStart[dotName]) or (not IWBDebuffDot.dotStart[dotName][uuid]) then
		return true
	end
	
	local elapsed = GetTime() - IWBDebuffDot.dotStart[dotName][uuid]
	return elapsed >= IWB_SPELL_REF[dotName]["duration"]
end

function IWBDebuffDot:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)

	local isExists, uuid = UnitExists("target")
	isReady = isReady and UnitCanAttack("player", "target") and isExists

	if isReady then
		isReady = (not IWBUtils:FindDebuff(spell["name"], "target")) or 
				  IWBDebuffDot:IsUnitDotTimeOut(spell["name"], uuid)
		
		if spell["target_hp"] == nil or spell["target_hp"] == "" then
			spell["target_hp"] = 0
		end
		isReady = isReady and (UnitHealth("target") >= tonumber(spell["target_hp"]))
	end
	return isReady, slot
end

function IWBDebuffDot:Cast(spell)
	IWBSpellBase.Cast(self, spell)
	
	local _, uuid = UnitExists("target")
	if UnitCanAttack("player", "target") and uuid then
		IWBDebuffDot:SetUnitDotTime(spell["name"], uuid, GetTime())
	end
	
	return true
end
