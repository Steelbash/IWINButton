ScrollFrameTemplate = {}

function ScrollFrameTemplate:new()
    local self = {}
    setmetatable(self, { __index = ScrollFrameTemplate })
    return self
end

function ScrollFrameTemplate:CreateFrame(name, parent)
	local frame = CreateFrame("ScrollFrame", name, parent, "FauxScrollFrameTemplate")
   
    frame:SetScript("OnVerticalScroll", function()
		FauxScrollFrame_OnVerticalScroll(math.floor(self.itemHeight), function() 
			self:UpdateFrame()
		end);
    end)
    
    frame:SetScript("OnShow", function()
		self:UpdateFrame()
    end)
	
	self.frame = frame
	self.items = {}
	self.list = {}
	self.itemHeight = 0
	self.selected = -1
end

function ScrollFrameTemplate:SetSelected(v)
	if v > 0 and v <= table.getn(self.list) then
		self.selected = v
	else
		self.selected = -1
	end
	
	self:UpdateFrame()
	if self.onChange then
		self.onChange()
	end
end

function ScrollFrameTemplate:GetSelected()
	return self.selected
end

function ScrollFrameTemplate:SetOnChange(onChange)
	self.onChange = onChange
end

function ScrollFrameTemplate:UpdateFrame()
	FauxScrollFrame_Update(self.frame, table.getn(self.list), table.getn(self.items), math.floor(self.itemHeight))
	
	for line=1,table.getn(self.items) do
		local item = self.items[line]
		local listIndex = line + FauxScrollFrame_GetOffset(self.frame);
		
		if listIndex <= table.getn(self.list) then
			item:SetSelected(listIndex == self.selected)
			item:SetData(self.list[listIndex])
			item.frame:Show()
		else
			item.frame:Hide()
		end
	end
end

function ScrollFrameTemplate:CreateItems(class, offsetX, offsetY, width, height, count)
	local items = {}
	local prev_item = nil
	self.itemHeight = height
	
	for i = 1, count do
		local item = class:new()
		item:CreateFrame(self.frame:GetParent(), width, height)
		item.frame:SetID(i)
		item:SetOnClick(function(frame) 
			local sel = FauxScrollFrame_GetOffset(self.frame) + tonumber(frame:GetID())
			if sel ~= self.selected then
				self:SetSelected(sel)
			end
		end)
		
		if prev_item == nil then
			item.frame:SetPoint("TOPLEFT", offsetX, offsetY)
		else
			item.frame:SetPoint("TOPLEFT", prev_item.frame, "BOTTOMLEFT", 0, 0)
		end
		prev_item = item
		table.insert(items, item)
	end
	
	self.items = items
end

function ScrollFrameTemplate:SetList(list, selected)
	self.list = list
	if selected ~= nil then
		self:SetSelected(selected)
	end
	self:UpdateFrame()
end

