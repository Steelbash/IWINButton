
IWBAttack = IWBSpellBase:New("Attack")

function IWBAttack:IsReady(spell)
	local isReady = true

	local slot = IWBUtils:FindSpellOnActionBar(spell["name"], spell["rank"])
	if slot ~= nil then
		if IsCurrentAction(slot) then
			isReady = false
		end
	end
	
	return isReady
end

