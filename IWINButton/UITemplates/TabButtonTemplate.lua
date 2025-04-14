
TabButtonTemplate = {}

function TabButtonTemplate:new()
    local self = {}
    setmetatable(self, { __index = TabButtonTemplate })
    return self
end

function TabButtonTemplate:Initialize(parent)
    
	local button = CreateFrame("Button", nil, parent)  
	button:SetWidth(100)
	button:SetHeight(32)

    -- Normal
    
	local leftNormal = button:CreateTexture(nil, "BACKGROUND")  
	leftNormal:SetWidth(20)
	leftNormal:SetHeight(32)
	leftNormal:SetPoint("LEFT", 0, -3)  
	leftNormal:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab")  
	leftNormal:SetTexCoord(0, 0.15625, 0, 1.0)  
	button.Left = leftNormal
	
	local middleNormal = button:CreateTexture(nil, "BACKGROUND")  
	middleNormal:SetWidth(65)
	middleNormal:SetHeight(32)
	middleNormal:SetPoint("LEFT", leftNormal, "RIGHT", 0, 0)  
	middleNormal:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab")  
	middleNormal:SetTexCoord(0.15625, 0.84375, 0, 1.0)  
	button.Middle = middleNormal
	
	local rightNormal = button:CreateTexture(nil, "BACKGROUND")  
	rightNormal:SetWidth(20)
	rightNormal:SetHeight(32)
	rightNormal:SetPoint("LEFT", middleNormal, "RIGHT", 0, 0)  
	rightNormal:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab")  
	rightNormal:SetTexCoord(0.84375, 1.0, 0, 1.0)  
	button.Right = rightNormal
	
	-- Disabled
	
	local leftDisabled = button:CreateTexture(nil, "BACKGROUND")  
	leftDisabled:SetWidth(20)
	leftDisabled:SetHeight(32)
	leftDisabled:SetPoint("LEFT", 0, 0)  
	leftDisabled:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ActiveTab")  
	leftDisabled:SetTexCoord(0, 0.15625, 0, 1.0)  
	button.LeftDisabled = leftDisabled

	local middleDisabled = button:CreateTexture(nil, "BACKGROUND")  
	middleDisabled:SetWidth(80)
	middleDisabled:SetHeight(32)
	middleDisabled:SetPoint("LEFT", leftDisabled, "RIGHT")  
	middleDisabled:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ActiveTab")  
	middleDisabled:SetTexCoord(0.15625, 0.84375, 0, 1.0)  
	button.MiddleDisabled = middleDisabled
	
	local rightDisabled = button:CreateTexture(nil, "BACKGROUND")  
	rightDisabled:SetWidth(20)
	rightDisabled:SetHeight(32)
	rightDisabled:SetPoint("LEFT", middleDisabled, "RIGHT")  
	rightDisabled:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ActiveTab")  
	rightDisabled:SetTexCoord(0.84375, 1.0, 0, 1.0)  
	button.RightDisabled = rightDisabled
	

	local buttonText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")  
	buttonText:SetPoint("CENTER", 0, 0)  
	--buttonText:SetText("Rotation Indication")
	buttonText:SetFontObject("GameFontNormalSmall")
	button.Text = buttonText
	
	
	local highlight = button:CreateTexture(nil, "HIGHLIGHT")  
	highlight:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")  
	highlight:SetBlendMode("ADD")  
	highlight:SetPoint("LEFT", 10, 0)  
	highlight:SetPoint("RIGHT", -10, 0)
	button.Highlight = highlight
	
	
	button:SetScript("OnMouseDown", function()
		if button:IsEnabled() == 1 then
			buttonText:SetPoint("CENTER", 1, -1)
		end
	end)

	button:SetScript("OnMouseUp", function()
		buttonText:SetPoint("CENTER", 0, 0)
	end)
	
	button:SetScript("OnEnter", function()
		button.Text:SetFontObject("GameFontHighlightSmall")
	end)
	
	button:SetScript("OnLeave", function()
		button.Text:SetFontObject("GameFontNormalSmall")
	end)
	

	self.frame = button

	self:Disable()
	self:Resize(0)
end

function TabButtonTemplate:Enable()
	self.frame.Left:Show()
	self.frame.Middle:Show()
	self.frame.Right:Show()
	self.frame.Highlight:Show()
	
	self.frame.LeftDisabled:Hide()
	self.frame.MiddleDisabled:Hide()
	self.frame.RightDisabled:Hide()
	
	self.frame.Text:SetFontObject("GameFontNormalSmall")
	
	self.frame:Enable()
end

function TabButtonTemplate:Disable()
	self.frame.Left:Hide()
	self.frame.Middle:Hide()
	self.frame.Right:Hide()
	self.frame.Highlight:Hide()
	
	self.frame.LeftDisabled:Show()
	self.frame.MiddleDisabled:Show()
	self.frame.RightDisabled:Show()
	
	self.frame.Text:SetFontObject("GameFontHighlightSmall")
	
	self.frame:Disable()
end

function TabButtonTemplate:Resize(padding, absoluteSize, maxWidth)
	local tab = self.frame
	local buttonMiddle =tab.Middle;
	local buttonMiddleDisabled = tab.MiddleDisabled;
	local highlightTexture = tab.Highlight
	local sideWidths = 2 * tab.Left:GetWidth();
	local tabText = tab.Text;
	local width, tabWidth;
	
	if ( absoluteSize ) then
		if ( absoluteSize < sideWidths) then
			width = 1;
			tabWidth = sideWidths
		else
			width = absoluteSize - sideWidths;
			tabWidth = absoluteSize
		end
		tabText:SetWidth(width);
	else
		if ( padding ) then
			width = tabText:GetWidth() + padding;
		else
			width = tabText:GetWidth() + 24;
		end
		if ( maxWidth and width > maxWidth ) then
			if ( padding ) then
				width = maxWidth + padding;
			else
				width = maxWidth + 24;
			end
			tabText:SetWidth(width);
		else
			tabText:SetWidth(0);
		end
		tabWidth = width + sideWidths;
	end
	
	if ( buttonMiddle ) then
		buttonMiddle:SetWidth(width);
	end
	if ( buttonMiddleDisabled ) then
		buttonMiddleDisabled:SetWidth(width);
	end
	if ( highlightTexture ) then
		highlightTexture:SetWidth(tabWidth);
	end
	
	tab:SetWidth(tabWidth);
end

function TabButtonTemplate:SetOnClick(onclick)
	self.frame:SetScript("OnClick", onclick)
end
