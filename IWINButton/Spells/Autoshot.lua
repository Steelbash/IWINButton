
IWBAutoshot = IWBSpellBase:New("Autoshot")


function IWBAutoshot:IsReady(spell)
	local isReady = true

	local slot = IWBUtils:FindSpellOnActionBar(spell["name"], spell["rank"])
	if slot ~= nil then
		if IsAutoRepeatAction(slot) then
			isReady = false
		end
	end
	
	return isReady
end

function IWBAutoshot:Cast(spell)
	IWBSpellBase.Cast(self, spell)
	return false
end
