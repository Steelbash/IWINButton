
IWBBuffWithDebuff = IWBBuff:New("BuffWithDebuff")

function IWBBuffWithDebuff:IsReady(spell)
	local isReady, slot = IWBBuff.IsReady(self, spell)
	if IWBUtils:FindDebuff(IWB_SPELL_REF[spell["name"]]["debuff"], "player") then
		isReady = false
	end
	return isReady, slot
end
