dermacore.panel = dermacore.panel or {} -- TODO: A shared container between states so things can be faster and more organized

dermacore.panel.ispanel = dermacore.panel.ispanel or ispanel

dermacore.panel.Metatable = dermacore.panel.Metatable or {}
dermacore.panel.Metatable.__index = dermacore.panel.Metatable

AccessorFunc(dermacore.panel.Metatable, "ChipIndex", "ChipIndex", FORCE_NUMBER)
AccessorFunc(dermacore.panel.Metatable, "ClassName", "ClassName", FORCE_STRING)
AccessorFunc(dermacore.panel.Metatable, "Identifier", "Identifier", FORCE_NUMBER)

function dermacore.panel.Metatable:IsValid()
	return self:GetIdentifier() > 0 and IsValid(Entity(self:GetChipIndex()))
end

function dermacore.panel.Metatable:Remove()
	self:SetIdentifier(-1)
end

function dermacore.panel.Metatable:__eq(Other)
	return self:GetIdentifier() == Other:GetIdentifier()
end

function dermacore.panel.Metatable:__tostring()
	return Format("Panel %u ('%s')", self:GetIdentifier(), self:GetClassName())
end

function dermacore.panel.Create(ChipIndex, ClassName, Identifier)
	local Panel = setmetatable({}, dermacore.panel.Metatable)

	Panel:SetChipIndex(ChipIndex)
	Panel:SetClassName(ClassName)
	Panel:SetIdentifier(Identifier)

	return Panel
end

-- This function is pointless on server
function ispanel(Object)
	return getmetatable(Object) == dermacore.panel.Metatable or dermacore.panel.ispanel(Object)
end
