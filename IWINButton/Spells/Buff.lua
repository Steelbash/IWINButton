
IWBBuff = IWBSpellBase:New("Buff")

function IWBBuff:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		isReady = (not IWBUtils:FindBuff(spell["name"], "player"))
		if IWB_SPELL_REF[spell["name"]] ~= nil and IWB_SPELL_REF[spell["name"]]["alias"] ~= nil then
			isReady = isReady and (not IWBUtils:FindBuff(IWB_SPELL_REF[spell["name"]]["alias"], "player"))
		end
	end
	return isReady, slot
end




