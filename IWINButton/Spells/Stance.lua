
IWBStance = IWBSpellBase:New("Stance")

IWBStance.stances = {
	["Battle Stance"] = 1,
	["Defensive Stance"] = 2,
	["Berseker Stance"] = 3
}

function IWBStance:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		local _, _, active = GetShapeshiftFormInfo(self.stances[spell["name"]])
		isReady = active == nil
	end
	return isReady, slot
end
