
IWBDebuff = IWBSpellBase:New("Debuff")

function IWBDebuff:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		isReady = not IWBUtils:FindDebuff(spell["name"], "target")
	end
	return isReady, slot
end




