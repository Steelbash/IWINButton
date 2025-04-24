
IWBUtils = {}

function IWBUtils:ModalDialogQuestion(question, onAcceptFunc, onCancelFunc, offsetX, offsetY)
	StaticPopupDialogs["IWB_DIALOG_QUESTION"] = {
		text = question,
		button1 = "Yes",
		button2 = "No",
		OnAccept = onAcceptFunc,
		OnCancel = onCancelFunc,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		OnShow = function()
			this:ClearAllPoints()
			this:SetPoint("CENTER", UIParent, "CENTER", offsetX, offsetY)
		end
	}
	StaticPopup_Show("IWB_DIALOG_QUESTION")
end

function IWBUtils:ModalDialogError(error, offsetX, offsetY)
	StaticPopupDialogs["IWB_DIALOG_ERROR"] = {
		text = error,
		button1 = "OK",
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		showAlert = true,
		OnShow = function()
			this:ClearAllPoints()
			this:SetPoint("CENTER", UIParent, "CENTER", offsetX, offsetY)
		end
	}
	StaticPopup_Show("IWB_DIALOG_ERROR")
end

function IWBUtils:SetTooltip(frame, text)
    local func = function()
        GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(text)
        GameTooltip:Show()
    end
    
    frame:SetScript("OnEnter", func)
    frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

function IWBUtils:DumpTable(table, indent, visited)
    indent = indent or 0
    visited = visited or {}
    
    if type(table) ~= "table" then
        return tostring(table)
    end
    if visited[table] then
        return "{...}"
    end
    visited[table] = true

    local spacing = string.rep("    ", indent)
    local result = "{\n"

    for key, value in pairs(table) do
        local keyStr = "[" .. tostring(key) .. "]"
        result = result .. spacing .. "    " .. keyStr .. " = " .. IWBUtils:DumpTable(value, indent + 1, visited) .. ",\n"
    end

    return result .. spacing .. "}"
end

function IWBUtils:StrTrim(str)
    local len = string.len(str)
    local start, finish = 1, len
    
    while start <= len and string.find(string.sub(str, start, start), "%s") do
        start = start + 1
    end
    
    while finish >= start and string.find(string.sub(str, finish, finish), "%s") do
        finish = finish - 1
    end
    
    return start <= finish and string.sub(str, start, finish) or ""
end

function IWBUtils:ActionButtonList()
	local ActionBars = {'Action', 'BonusAction', 'MultiBarBottomLeft','MultiBarBottomRight','MultiBarRight','MultiBarLeft'}
	local buttons = {}

	for _, barName in pairs(ActionBars) do
		for i = 1, 12 do
			local actionButtonName = barName .. 'Button' .. i
			local btn = getglobal(actionButtonName)
			local slot = ActionButton_GetPagedID(btn)
			buttons[slot] = actionButtonName
		end
	end
	return buttons
end

function IWBUtils:GetActionInfo(slot)
	if HasAction(slot) then
		if GetActionText(slot) == nil then
			IWBTooltip:SetAction(slot)

			local spell_name = IWBTooltip:GetText("TextLeft1")
			local spell_rank = IWBTooltip:GetText("TextRight1")
			
			return spell_name, spell_rank
		end
	end
	
	return nil
end

function IWBUtils:FindSpellOnActionBar(name, rank)
	for slot, btn in pairs(IWBUtils:ActionButtonList()) do
		local ab_spell, ab_rank = IWBUtils:GetActionInfo(slot)
		
		if (ab_spell == name) then
			if rank ~= nil and rank ~= "" and ab_rank == rank then
				return slot
			end
			if rank == nil or rank == "" then
				return slot
			end
		end
	end
	return nil
end

function IWBUtils:GetRankNum(rank)
	local _,_,rankNum = string.find(rank, "(%d+)")
	return rankNum
end

function IWBUtils:GetSpellMaxRank(spell_name)
	local n = 1
    local maxRank = 0

    while true do
        local name, rank = GetSpellName(n, "spell")
        if not name then
            break
        end
        if name == spell_name then
			if rank ~= nil and rank ~= "" then
				local rankNum = IWBUtils:GetRankNum(rank)
				if rankNum ~= nil and tonumber(rankNum) > maxRank then
					maxRank = tonumber(rankNum)
				end
			end
        end
        n = n + 1
    end

	if maxRank == 0 then
		return nil
	else
		return maxRank
	end
end

function IWBUtils:GetSpellMinRank(spell_name)
	local n = 1
    local minRank = 0

    while true do
        local name, rank = GetSpellName(n, "spell")
        if not name then
            break
        end
        if name == spell_name then
			if rank ~= nil and rank ~= "" then
				local rankNum = IWBUtils:GetRankNum(rank)
				if rankNum ~= nil and tonumber(rankNum) < minRank then
					minRank = tonumber(rankNum)
				end
			end
        end
        n = n + 1
    end

	if minRank == 0 then
		return nil
	else
		return minRank
	end
end

function IWBUtils:GetSpellId(spell_name, spell_rank)
	local n = 1

    while true do
        local name, rank = GetSpellName(n, "spell")
        if not name then
            break
        end
        if name == spell_name and rank == spell_rank then
			return n
        end
        n = n + 1
    end
	return nil
end


function IWBUtils:FindBuff(buff, unit)
	local hasBuff = GetWeaponEnchantInfo();
	if hasBuff then
		IWBTooltip:SetInventoryItem(unit, 16);
		for i=1, 23 do
			local text = IWBTooltip:GetText("TextLeft"..i);
			if (not text) then
				break;
			elseif strfind(text, buff) then
				return true;
			end
		end
	end
	

    for i=1, 64 do
		IWBTooltip:SetUnitBuff(unit, i);
		local text = IWBTooltip:GetText("TextLeft1");
        
		if text and strfind(text, buff) then
			return true;
		end
	end
    
    return false
end

function IWBUtils:FindDebuff(debuff, unit)
	for i=1, 64 do
		IWBTooltip:SetUnitDebuff(unit, i);
        local text = IWBTooltip:GetText("TextLeft1");

		if text and strfind(text, debuff) then
			local _, count = UnitDebuff(unit, i)
			return true, count
		end
	end
    return false, 0
end
