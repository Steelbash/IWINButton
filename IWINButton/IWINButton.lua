local frame = CreateFrame('FRAME');

function frame:VARIABLES_LOADED()
	IWBDb:Initialize()
	IWBTooltip:Initialize()
	IWBMainFrame:Initialize(SpellBookFrame)
	frame:CreateSpellBookButton()
end

function frame:CreateSpellBookButton()
	local IWButton = CreateFrame("Button", nil, SpellBookFrame, "UIPanelButtonTemplate")
	IWButton:SetWidth(120)
	IWButton:SetHeight(22)
	IWButton:SetText("I.W.I.N. Button")
	IWButton:SetPoint("TOP", 0, -42)

	IWButton:SetScript("OnClick", function()
		IWBMainFrame:Show()
	end)

end

frame:SetScript('OnEvent', function()
	this[event]()
end)

function IWButton_Run(button)
	if button ~= nil then
		for i = 1, IWBDb:GetSpellCount(button) do
			local spell = IWBDb:GetSpellByIndex(button, i)
			if spell ~= nil then
				local spellHandler = IWBSpellBase
				if IWB_SPELL_REF[spell["name"]] ~= nil then
					spellHandler = IWB_SPELL_REF[spell["name"]]["handler"]
				end
			
				if spellHandler:IsReady(spell) then
					if spellHandler:Cast(spell) then
						break
					end
				end
			end
		end
	end
end

frame:RegisterEvent("VARIABLES_LOADED")
