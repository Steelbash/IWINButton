
IWBSteadyShot = IWBSpellBase:New("SteadyShot")

IWBSteadyShot.lastAutoShot = 0
IWBSteadyShot.lastSteadyShot = 0

IWBSteadyShot.frame = CreateFrame("Frame", nil)
IWBSteadyShot.frame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")

IWBSteadyShot.frame:SetScript('OnEvent', function()
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		if string.find(arg1, "Your Auto Shot") then
			IWBSteadyShot.lastAutoShot = GetTime()
		end
    end
end)

function IWBSteadyShot:IsReady(spell)
	local isReady, slot = IWBSpellBase.IsReady(self, spell)
	if isReady then
		if IWBSteadyShot.lastAutoShot > IWBSteadyShot.lastSteadyShot then
			IWBSteadyShot.lastSteadyShot = GetTime()
			isReady = true
		else
			isReady = false
		end
	end
	
	return isReady, slot
end
