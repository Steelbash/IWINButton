
local OrigSpellButton_OnClick = SpellButton_OnClick

IWBMainFrame = {}

function IWBMainFrame:Initialize(parent)
	self:SetSpellBookHook()
	self:CreateFrame(parent)

	IWBButtonFrame:Initialize(self.frame)
	IWBButtonFrame:SetOnApply(function(text) IWBMainFrame:ButtonFrameOnApply(text) end)
	
	self.updateSpellsLast = 0
	self.updateSpellsPeriod = 1
	self.lastSpellHandler = nil
end

function IWBMainFrame:SetSpellBookHook()
    for i=1,12 do
        local button = getglobal("SpellButton"..i)
        button:RegisterForClicks("LeftButtonUp");
    end
    SpellButton_OnClick = function(drag) IWBMainFrame:SpellButtonOnClick(drag) end
end

function IWBMainFrame:SpellButtonOnClick(drag)
    if IWBMainFrame.frame:IsVisible() and IsShiftKeyDown() and  IsControlKeyDown() then
        this:SetChecked(nil)
        
        local button = IWBMainFrame:getSelectedButton()
        if button ~= nil then
			local id = SpellBook_GetSpellID(this:GetID());
			local texture = GetSpellTexture(id, SpellBookFrame.bookType)
			local name, rank = GetSpellName(id, SpellBookFrame.bookType)
					
			if rank and string.find(rank, "Passive") then 
			else
				local spell = {}
				spell["id"] = id
				spell["texture"] = texture
				spell["name"] = name
				if string.find(rank, "Rank") then
					if IWB_SPELL_REF[name] == nil or not IWB_SPELL_REF[name]["no_rank"] then
						spell["rank"] = rank
					end
				end
				
				IWBDb:AddSpell(button, spell)
				IWBMainFrame.frame.rotationTab.scrollFrame:SetSelected(IWBDb:GetSpellCount(button))
			end
		else
			IWBUtils:ModalDialogError("Select button first!", 0, 100)
		end
	else
		OrigSpellButton_OnClick(drag)
    end
end

function IWBMainFrame:CreateFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	IWBMainFrame.frame = frame
	
	frame:SetToplevel(true)
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")
	frame:SetWidth(384)
	frame:SetHeight(512)
	frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 15, 0)
	
	frame:SetScript("OnUpdate", function()
		IWBMainFrame:FindSpellsOnActionBar()
	end)
	
	frame:SetScript("OnShow", function()
		self.frame.buttonList:SetList(IWBDb:GetButtonNames())
		self.firstSlotBindignsUpdated = false
	end)
	
	local bgLayer = frame:CreateTexture(nil, "BACKGROUND")
	bgLayer:SetTexture("Interface\\MacroFrame\\MacroFrame-Icon")
	
	bgLayer:SetWidth(60)
	bgLayer:SetHeight(60)
	bgLayer:SetPoint("TOPLEFT", 7, -6)

	local borderTL = frame:CreateTexture(nil, "BORDER")
	borderTL:SetTexture("Interface\\paperdollinfoframe\\ui-character-general-topleft")
	borderTL:SetWidth(256)
	borderTL:SetHeight(256)
	borderTL:SetPoint("TOPLEFT", 0, 0)

	local borderTR = frame:CreateTexture(nil, "BORDER")
	borderTR:SetTexture("Interface\\paperdollinfoframe\\ui-character-general-topright")
	borderTR:SetWidth(128)
	borderTR:SetHeight(256)
	borderTR:SetPoint("TOPRIGHT", 0, 0)

	local borderBL = frame:CreateTexture(nil, "BORDER")
	borderBL:SetTexture("Interface\\paperdollinfoframe\\ui-character-general-bottomleft")
	borderBL:SetWidth(256)
	borderBL:SetHeight(256)
	borderBL:SetPoint("BOTTOMLEFT", 0, 0)

	local borderBR = frame:CreateTexture(nil, "BORDER")
	borderBR:SetTexture("Interface\\paperdollinfoframe\\ui-character-general-bottomright")
	borderBR:SetWidth(128)
	borderBR:SetHeight(256)
	borderBR:SetPoint("BOTTOMRIGHT", 0, 0)
	
	local titleText = frame:CreateFontString(nil, "BORDER", "GameFontNormal")
	titleText:SetText("I.W.I.N. Button ")
	titleText:SetPoint("TOP", frame, "TOP", 0, -17)
	
	local versionText = frame:CreateFontString(nil, "BORDER", "GameFontHighlightSmall")
	versionText:SetText("v"..GetAddOnMetadata("IWINButton", "Version"))
	versionText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -65, -18)

	-- Close Button
	local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	closeButton:SetWidth(32)
	closeButton:SetHeight(32)
	closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -29, -8)

	closeButton:SetScript("OnClick", function()
		frame:Hide()
	end)
	
	-- Macros Button
	local macroButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	macroButton:SetWidth(45)
	macroButton:SetHeight(22)
	macroButton:SetText("Macros")
	macroButton:SetPoint("TOPLEFT", frame, "TOPRIGHT", -90, -43)
	macroButton:Disable()
	macroButton:SetScript("OnClick", function() IWBMainFrame:MacrosOnClick() end)
	frame.macroButton = macroButton
	
	-- Delete Button
	local delButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	delButton:SetWidth(45)
	delButton:SetHeight(22)
	delButton:SetText("Delete")
	delButton:SetPoint("TOPRIGHT", macroButton, "TOPLEFT", -3, 0)
	delButton:Disable()

	delButton:SetScript("OnClick", function() IWBMainFrame:DeleteOnClick() end)
	frame.deleteButton = delButton
	
	-- New Button
	local newButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	newButton:SetWidth(45)
	newButton:SetHeight(22)
	newButton:SetText("New")
	newButton:SetPoint("TOPRIGHT", delButton, "TOPLEFT", -3, 0)
	newButton:SetScript("OnClick", function() IWBMainFrame:NewOnClick()	end)
	
	-- Button List
	local buttonList = DropDownTemplate:new()
	buttonList:CreateFrame("IWBButtonList", frame)
	buttonList:SetWidth(100)
	buttonList:SetOnChange(function() IWBMainFrame:ButtonListOnChange() end)
	buttonList.frame:SetPoint("TOPRIGHT", newButton, "TOPLEFT", 12, 2)
	frame.buttonList = buttonList
	
	IWBMainFrame:CreateRotation()
	IWBMainFrame:CreateIndication()
	
	local rotationButton = TabButtonTemplate:new()
	rotationButton:Initialize(frame)
	rotationButton.frame.Text:SetText("Rotation")
	rotationButton.frame:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 10, 82)
	rotationButton:Resize()
	rotationButton:Disable()
	rotationButton:SetOnClick(function() 
		IWBMainFrame:SelectTab("Rotation")
	end)
	frame.rotationButton = rotationButton
	
	local indicationButton = TabButtonTemplate:new()
	indicationButton:Initialize(frame)
	indicationButton.frame.Text:SetText("Indication")
	indicationButton.frame:SetPoint("TOPLEFT", rotationButton.frame, "TOPRIGHT", -15, 0)
	indicationButton:Resize()
	indicationButton:Enable()
	indicationButton:SetOnClick(function() 
		IWBMainFrame:SelectTab("Indication")
	end)
	frame.indicationButton = indicationButton
	
	
	frame.rotationTab:Hide()
	frame.rotationButton.frame:Hide()
	frame.indicationTab:Hide()
	frame.indicationButton.frame:Hide()
	
	IWBMainFrame.frame:Hide()
end

function IWBMainFrame:CreateRotation()
	local rotationTab = CreateFrame("Frame", nil, IWBMainFrame.frame)
	rotationTab:SetToplevel(true)
	rotationTab:SetFrameStrata("DIALOG")
	rotationTab:SetWidth(322)
	rotationTab:SetHeight(357)
	rotationTab:SetPoint("TOPLEFT", 19, -73)
	
	local horizontalBarLeft = rotationTab:CreateTexture(nil, "ARTWORK")
	horizontalBarLeft:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
	horizontalBarLeft:SetWidth(256)
	horizontalBarLeft:SetHeight(16)
	horizontalBarLeft:SetPoint("TOPLEFT", -4, -154)
	horizontalBarLeft:SetTexCoord(0, 1.0, 0, 0.25)

	local horizontalBarRight = rotationTab:CreateTexture(nil, "ARTWORK")
	horizontalBarRight:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
	horizontalBarRight:SetWidth(75)
	horizontalBarRight:SetHeight(16)
	horizontalBarRight:SetPoint("LEFT", horizontalBarLeft, "RIGHT", 0, 0)
	horizontalBarRight:SetTexCoord(0, 0.29296875, 0.25, 0.5)
	
	
	local sf = ScrollFrameTemplate:new()
	sf:CreateFrame("IWSpellScrollFrame", rotationTab)
	sf.frame:SetWidth(300)
	sf.frame:SetHeight(154)
	sf.frame:SetPoint("TOPRIGHT", rotationTab, "TOPRIGHT", -24, -2)

	sf:CreateItems(SpellItemTemplate, 3, -2,  293, 22, 7)
	sf:SetOnChange(function() IWBMainFrame:SpellListOnChange() end)
	rotationTab.scrollFrame = sf
	
	
	local spellProps = CreateFrame("Frame", nil, rotationTab)
	spellProps:SetWidth(322)
	spellProps:SetHeight(192)
	spellProps:SetPoint("TOPLEFT", 0, -165)
	spellProps:Hide()
	rotationTab.spellProps = spellProps
	
	-- Slot Bindings updated
	
	local slotBindUpdFrame = CreateFrame("Frame", "IWBSlotBindingFrame", rotationTab)
	slotBindUpdFrame:SetWidth(180)
	slotBindUpdFrame:SetHeight(50)
	slotBindUpdFrame:SetToplevel(true)
	slotBindUpdFrame:SetPoint("CENTER", rotationTab, "CENTER", 0, 100)
	slotBindUpdFrame:Hide()
	
	slotBindUpdFrame:SetBackdrop({
		bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = {
			left = 11,
			right = 12,
			top = 12,
			bottom = 11,
		}
	})
	
	local slotBindUpdText = slotBindUpdFrame:CreateFontString(nil, "ARTWORK", "GameFontGreen")
	slotBindUpdText:SetPoint("CENTER", 0, 0)
	slotBindUpdText:SetText("Slot Bindings Updated")
	rotationTab.slotBindUpdFrame = slotBindUpdFrame

	
	-- Delete Spell
	
	local deleteButton = CreateFrame("Button", nil, spellProps, "UIPanelButtonTemplate")
	deleteButton:SetWidth(80)
	deleteButton:SetHeight(22)
	deleteButton:SetText("Delete Spell")
	deleteButton:SetPoint("BOTTOMLEFT", 5, 5)
	deleteButton:SetScript("OnClick", function() IWBMainFrame:DeleteSpellOnClick() end)
	
	-- Change Order
	
	local changeOrderText = spellProps:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	changeOrderText:SetPoint("BOTTOMRIGHT", -95, 10)
	changeOrderText:SetText("Change Order")
	
	local orderUpButton = CreateFrame("Button", nil, spellProps, "UIPanelButtonTemplate")
	orderUpButton:SetWidth(40)
	orderUpButton:SetHeight(22)
	orderUpButton:SetText("Up")
	orderUpButton:SetPoint("BOTTOMRIGHT", -50, 5)
	orderUpButton:SetScript("OnClick", function() IWBMainFrame:ChangeOrderUpOnClick() end)
	rotationTab.orderUpButton = orderUpButton
	
	local orderDownButton = CreateFrame("Button", nil, spellProps, "UIPanelButtonTemplate")
	orderDownButton:SetWidth(40)
	orderDownButton:SetHeight(22)
	orderDownButton:SetText("Down")
	orderDownButton:SetPoint("BOTTOMRIGHT", -5, 5)
	orderDownButton:SetScript("OnClick", function() IWBMainFrame:ChangeOrderDownOnClick() end)
	rotationTab.orderDownButton = orderDownButton

	
	IWBMainFrame.frame.rotationTab = rotationTab
end

function IWBMainFrame:CreateIndication()
	local indicationTab = CreateFrame("Frame", nil, IWBMainFrame.frame)
	indicationTab:SetToplevel(true)
	indicationTab:SetFrameStrata("DIALOG")
	indicationTab:SetWidth(322)
	indicationTab:SetHeight(357)
	indicationTab:SetPoint("TOPLEFT", 19, -73)
	
	local titleText = indicationTab:CreateFontString(nil, "BORDER", "GameFontHighlight")
	titleText:SetText("Under construction")
	titleText:SetPoint("CENTER", indicationTab, "CENTER", 0, 0)
	
	IWBMainFrame.frame.indicationTab = indicationTab
end

function IWBMainFrame:Show()
	self.frame:Show()
end

function IWBMainFrame:SelectTab(tab)
	local frame = IWBMainFrame.frame
	
	if tab == "Rotation" then
		frame.rotationButton:Disable()
		frame.indicationButton:Enable()
		frame.rotationTab:Show()
		frame.indicationTab:Hide()
	else
		frame.indicationButton:Disable()
		frame.rotationButton:Enable()
		frame.indicationTab:Show()
		frame.rotationTab:Hide()
	end
end

function IWBMainFrame:ShowTabs(tab)
	local frame = IWBMainFrame.frame
	frame.rotationButton.frame:Show()
	frame.indicationButton.frame:Show()
	IWBMainFrame:SelectTab(tab)
end

function IWBMainFrame:HideTabs()
	local frame = IWBMainFrame.frame
	frame.rotationButton.frame:Hide()
	frame.indicationButton.frame:Hide()
	frame.indicationTab:Hide()
	frame.rotationTab:Hide()
end

function IWBMainFrame:getSelectedButton()
	return IWBMainFrame.frame.buttonList:GetSelected()
end

function IWBMainFrame:NewOnClick()
	IWBButtonFrame:Show({["title"] = "New Button", ["name"] = "", ["ok"] = "Create", ["cancel"] = "Cancel"})
end

function IWBMainFrame:DeleteOnClick()
	IWBUtils:ModalDialogQuestion("Delete button?", 
	
		function()
		   local buttonName = IWBMainFrame:getSelectedButton()
			if buttonName ~= nil then
				IWBDb:DeleteButton(buttonName)
				IWBMainFrame.frame.buttonList:SetList(IWBDb:GetButtonNames())
				
				local macroIndex = GetMacroIndexByName(buttonName)
				if  macroIndex > 0 then
					DeleteMacro(macroIndex)
				end
			end
		end,
		
		function()
		end,
		
		0,170
	)
end

function IWBMainFrame:MacrosOnClick()
	local numAccountMacros, numCharacterMacros = GetNumMacros();
	
	if numCharacterMacros >= 18 then
		IWBUtils:ModalDialogError("No space in character specific macros!", 0, 180)
		return
	end

	local buttonName = IWBMainFrame:getSelectedButton()
	local macroName = buttonName
	local macroScript = '/script IWButton_Run("'..buttonName..'")'
	local macroIcon = 6

	local macroIndex = GetMacroIndexByName(macroName)
	if macroIndex > 0 then
		--EditMacro(macroIndex, macroName, macroIcon, macroScript, nil, 1)
	else
		CreateMacro(macroName, macroIcon, macroScript, nil, 1)
		macroIndex = GetMacroIndexByName(macroName)
	end

	PickupMacro(macroIndex)
end

function IWBMainFrame:ButtonFrameOnApply(text)
	if text == nil then 
		return
	end
	text = IWBUtils:StrTrim(text)
	if text == "" then 
		return
	end
	
	if not IWBDb:IsButtonExists(text) then
		IWBDb:AddButton(text)
		IWBButtonFrame:Hide()
		self.frame.buttonList:SetList(IWBDb:GetButtonNames(), text)
	else
		IWBUtils:ModalDialogError("Button '"..text.."' already exists!",0, 100)
	end
end

function IWBMainFrame:ButtonListOnChange()
	local buttonName = IWBMainFrame.frame.buttonList:GetSelected()
--	print("Button list OnChange: "..(buttonName or "nil"))
	local button = IWBDb:GetButtonByName(buttonName)
	if button ~= nil then
		IWBMainFrame.frame.rotationTab.scrollFrame:SetList(button["spells"], 1)
		IWBMainFrame.frame.deleteButton:Enable()
		IWBMainFrame.frame.macroButton:Enable()
		IWBMainFrame:ShowTabs("Rotation")
	else
		IWBMainFrame.frame.deleteButton:Disable()
		IWBMainFrame.frame.macroButton:Disable()
		IWBMainFrame:HideTabs()
	end
end

function IWBMainFrame:SpellListOnChange()
--	print("Spell OnChange: " ..IWBMainFrame.frame.rotationTab.scrollFrame:GetSelected())
	IWBMainFrame.frame.rotationTab.spellProps:Hide()
	if self.lastSpellHandler ~= nil then
		self.lastSpellHandler:Hide()
	end
	
	local button = IWBMainFrame.frame.buttonList:GetSelected()
	if button ~= nil then
		local spellIndex = IWBMainFrame.frame.rotationTab.scrollFrame:GetSelected()
		local spell = IWBDb:GetSpellByIndex(button, spellIndex)
		if spell ~= nil then
			IWBMainFrame.frame.rotationTab.spellProps:Show()
			IWBMainFrame.frame.rotationTab.orderUpButton:Disable()
			if spellIndex > 1 then
				IWBMainFrame.frame.rotationTab.orderUpButton:Enable()
			end
			IWBMainFrame.frame.rotationTab.orderDownButton:Disable()
			if spellIndex < IWBDb:GetSpellCount(button) then
				IWBMainFrame.frame.rotationTab.orderDownButton:Enable()
			end
			
			local spellHandler = IWBSpellBase
			if IWB_SPELL_REF[spell["name"]] ~= nil then
				spellHandler = IWB_SPELL_REF[spell["name"]]["handler"]
			end

			spellHandler:ShowConfig(spell, function() 
				IWBMainFrame.frame.rotationTab.scrollFrame:UpdateFrame()
			end)
			self.lastSpellHandler = spellHandler
		end
	end
end

function IWBMainFrame:DeleteSpellOnClick()
	local buttonName = IWBMainFrame:getSelectedButton()
	if buttonName ~= nil then
		local spellIndex = IWBMainFrame.frame.rotationTab.scrollFrame:GetSelected()
		if spellIndex > 0 then
			IWBDb:DeleteSpell(buttonName, spellIndex)
			local spellCount = IWBDb:GetSpellCount(buttonName)

			if spellIndex > spellCount then
				spellIndex = spellCount
			end
			IWBMainFrame.frame.rotationTab.scrollFrame:SetSelected(spellIndex)
		end
	end
end

function IWBMainFrame:ChangeOrderUpOnClick()
	local buttonName = IWBMainFrame:getSelectedButton()
	if buttonName ~= nil then
		local spellIndex = IWBMainFrame.frame.rotationTab.scrollFrame:GetSelected()
		if spellIndex > 1 then
			IWBDb:ChangeSpellOrderUp(buttonName, spellIndex)
			IWBMainFrame.frame.rotationTab.scrollFrame:SetSelected(spellIndex - 1)
		end
	end
end

function IWBMainFrame:ChangeOrderDownOnClick()
	local buttonName = IWBMainFrame:getSelectedButton()
	if buttonName ~= nil then
		local spellIndex = IWBMainFrame.frame.rotationTab.scrollFrame:GetSelected()
		if spellIndex < IWBDb:GetSpellCount(buttonName) then
			IWBDb:ChangeSpellOrderDown(buttonName, spellIndex)
			IWBMainFrame.frame.rotationTab.scrollFrame:SetSelected(spellIndex + 1)
		end
	end
end

function IWBMainFrame:FindSpellsOnActionBar()
	if GetTime() < self.updateSpellsLast + self.updateSpellsPeriod then
		return
	end
		
	local button = IWBMainFrame.frame.buttonList:GetSelected()
	if button ~= nil then
		local spells = {}
		local spellCount = IWBDb:GetSpellCount(button)
		for i = 1,spellCount  do
			local spell = IWBDb:GetSpellByIndex(button, i)
			local slot = IWBUtils:FindSpellOnActionBar(spell["name"], spell["rank"])
			spell["actionBarSlot"] = slot
		end
		
		if (spellCount > 0) and (not self.firstSlotBindignsUpdated) then
			self.firstSlotBindignsUpdated = true
			UIFrameFlash(self.frame.rotationTab.slotBindUpdFrame, 0.3, 0.3, 1, false, 0, 1)
		elseif spellCount == 0 then
			self.firstSlotBindignsUpdated = true
		end
	end
	
	IWBMainFrame.frame.rotationTab.scrollFrame:UpdateFrame()
	self.updateSpellsLast = GetTime()
end

