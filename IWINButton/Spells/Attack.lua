
IWBAttack = IWBSpellBase:New("Attack")

function IWBAttack:IsReady(spell)
	local isReady = true

	local slot = spell["actionBarSlot"]
	if slot ~= nil then
		if IsCurrentAction(slot) then
			isReady = false
		end
	end
	
	if (spell["auto_target"] ~= 1) and (UnitCanAttack("player", "target") == nil) then
		isReady = false
	end
	
	return isReady
end

function IWBAttack:Cast(spell)
	local slot = spell["actionBarSlot"]
	if slot then
		UseAction(slot)
	end
	return false
end
