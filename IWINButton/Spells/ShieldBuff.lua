
IWBShieldBuff = IWBSpellBase:New("ShieldBuff")

function IWBShieldBuff:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		isReady = (not IWBUtils:FindBuff(spell["name"], "player")) and (not IWBUtils:FindDebuff("Weakened Soul", "player"))
	end
	return isReady, slot
end




