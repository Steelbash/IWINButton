
DropDownTemplate = {}

function DropDownTemplate:new()
    local self = {}
    setmetatable(self, { __index = DropDownTemplate })
    return self
end

function DropDownTemplate:CreateFrame(name, parent)
	local frame = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
	self.frame = frame
end

function DropDownTemplate:SetWidth(width)
	UIDropDownMenu_SetWidth(width, self.frame)
end

function DropDownTemplate:GetSelected()
	return UIDropDownMenu_GetSelectedName(self.frame)
end

function DropDownTemplate:SetSelected(val)
	local cur_val = UIDropDownMenu_GetSelectedName(self.frame)
	UIDropDownMenu_SetSelectedName(self.frame, val)
	if val == nil then
		self:SetText("")
	end
	if cur_val ~= val then
		self:SetText(val)
		self.onChange()
	end
end

function DropDownTemplate:SetText(val)
	getglobal(self.frame:GetName()..'Text'):SetText(val)
end

function DropDownTemplate:SetList(list, selectedVal)
	local function OnClickFunc()
		self:SetSelected(this:GetText())
	end

	local function InitializeDropdown()
		for k, v in pairs(list) do
			local info = {}
			info.text = v
			info.value = v
			info.checked = false;
			info.func = OnClickFunc
			UIDropDownMenu_AddButton(info)
		end
	end
	
	UIDropDownMenu_Initialize(self.frame, InitializeDropdown)
	if selectedVal == nil then
		for idx, val in pairs(list) do
			selectedVal = val
			break;
		end
	end
	self:SetSelected(selectedVal)
end

function DropDownTemplate:SetOnChange(onChange)
	self.onChange = onChange
end	
