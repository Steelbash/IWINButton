
IWBBuffWithDebuff = IWBSpellBase:New("BuffWithDebuff")

function IWBBuffWithDebuff:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		isReady = (not IWBUtils:FindBuff(spell["name"], "player")) and (not IWBUtils:FindDebuff(IWB_SPELL_REF[spell["name"]]["debuff"], "player"))
	end
	return isReady, slot
end




