
IWBDb = {}

function IWBDb:Initialize()
    IWB_Data = IWB_Data or {["buttons"] = {}}
end

function IWBDb:IsButtonExists(name)
    return name ~= nil and IWB_Data["buttons"][name] ~= nil 
end

function IWBDb:AddButton(name)
    if not IWBDb:IsButtonExists(name) then
        IWB_Data["buttons"][name] = { ["spells"] = {} }
    end
end

function IWBDb:GetButtonNames()
    local names={}
    for k,v in pairs(IWB_Data["buttons"]) do
        table.insert(names, k)
    end
    return names
end

function IWBDb:GetButtonByName(name)
	if not IWBDb:IsButtonExists(name) then
        return nil
    end
	
    return IWB_Data["buttons"][name]
end

function IWBDb:GetButtonCount()
    local totalButtons = 0
    for idx, buttonName in pairs(IWBDb:GetButtonNames()) do
        totalButtons = totalButtons + 1
    end
    return totalButtons
end

function IWBDb:GetSpellCount(name)
    if not IWBDb:IsButtonExists(name) then
        return 0
    end

    return table.getn(IWB_Data["buttons"][name]["spells"])
end

function IWBDb:GetSpellByIndex(name, index)
    if IWBDb:IsButtonExists(name) then
        local spells = IWB_Data["buttons"][name]["spells"]
        if index >= 1 and index <= table.getn(spells) then
            return spells[index]
        end
    end

	return nil
end

function IWBDb:ChangeButtonName(oldName, newName)
    if oldName == nil or newName == nil or oldName == newName then
        return
    end
    if IWBDb:IsButtonExists(newName) or not IWBDb:IsButtonExists(oldName) then
        return
    end

    IWB_Data["buttons"][newName] = IWB_Data["buttons"][oldName]
    IWB_Data["buttons"][oldName] = nil
end


function IWBDb:DeleteButton(name)
    if IWBDb:IsButtonExists(name) then
        IWB_Data["buttons"][name] = nil
    end
end

function IWBDb:AddSpell(name, spell)
    if IWBDb:IsButtonExists(name) then
        table.insert(IWB_Data["buttons"][name]["spells"], spell)
    end
end


function IWBDb:SetSpellMaxRank(name, index)
    if IWBDb:IsButtonExists(name) then
        local spells = IWB_Data["buttons"][name]["spells"]
		
        if index >= 1 and index <= table.getn(spells) then
            spells[index]["rank"] = nil
        end
    end
end


function IWBDb:DeleteSpell(name, index)
    if IWBDb:IsButtonExists(name) then
        local spells = IWB_Data["buttons"][name]["spells"]
		
        if index >= 1 and index <= table.getn(spells) then
            table.remove(spells, index)
        end
    end
end

function IWBDb:ChangeSpellOrderUp(name, index)
    if IWBDb:IsButtonExists(name) then
        local spells = IWB_Data["buttons"][name]["spells"]
		
        if index >= 2 and index <= table.getn(spells) then
            local tmpSpell = spells[index-1]
            spells[index-1] = spells[index]
            spells[index] = tmpSpell
        end
    end
end

function IWBDb:ChangeSpellOrderDown(name, index)
	if IWBDb:IsButtonExists(name) then
        local spells = IWB_Data["buttons"][name]["spells"]
		
        if index >= 1 and index < table.getn(spells) then
            local tmpSpell = spells[index+1]
            spells[index+1] = spells[index]
            spells[index] = tmpSpell
        end
    end
end
