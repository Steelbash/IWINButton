
IWBRageNextMelee = IWBRage:New("RageNextMelee")


function IWBRageNextMelee:IsReady(spell)
	local isReady, slot = IWBRage.IsReady(self, spell)
	if isReady and slot ~= nil then
		isReady = not IsCurrentAction(slot)
	end
	return isReady
end
