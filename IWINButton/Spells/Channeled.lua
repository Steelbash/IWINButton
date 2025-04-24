
IWBChanneled = IWBSpellBase:New("Channeled")

function IWBChanneled:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		isReady = not CastingBarFrame.channeling
	end
	return isReady, slot
end
