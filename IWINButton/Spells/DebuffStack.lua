
IWBDebuffStack = IWBDebuff:New("DebuffStack")

function IWBDebuffStack:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		local isFound, count = IWBUtils:FindDebuff(spell["name"], "target")
		if not isFound then
			isReady = true
		else
			isReady = (spell["stack"] and count < IWB_SPELL_REF[spell["name"]]["stack_max"])
		end
	end
	return isReady, slot
end
