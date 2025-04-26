
IWBNextMelee = IWBSpellBase:New("NextMelee")


function IWBNextMelee:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady and slot ~= nil then
		isReady = not IsCurrentAction(slot)
	end
	return isReady
end
