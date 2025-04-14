
IWBBuff = IWBSpellBase:New("Buff")

function IWBBuff:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		isReady = not IWBUtils:FindBuff(spell["name"], "player")
	end
	return isReady, slot
end




