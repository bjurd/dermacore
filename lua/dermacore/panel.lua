dermacore.panel = dermacore.panel or {}

dermacore.panel.Metatable = dermacore.panel.Metatable or {}
local PANEL = dermacore.panel.Metatable

PANEL.__index = PANEL

AccessorFunc(PANEL, "Chip", "Chip", FORCE_NUMBER)
AccessorFunc(PANEL, "ClassName", "ClassName", FORCE_STRING)
AccessorFunc(PANEL, "Identifier", "Identifier", FORCE_NUMBER)

if CLIENT then
	AccessorFunc(PANEL, "Panel", "Panel")
end

function PANEL:GetChip() -- AccessorFunc sucks
	return tonumber(self.Chip) or 0
end

function PANEL:GetChipEnt() -- AccessorFunc sucks
	return Entity(self:GetChip())
end

function PANEL:GetIdentifier()
	return tonumber(self.Identifier) or -1
end

function PANEL:IsValid()
	if self:GetIdentifier() <= 0 then
		return false
	end

	if SERVER then
		return IsValid(self:GetChipEnt())
	elseif CLIENT then
		return IsValid(self:GetPanel())
	end
end

function PANEL:Remove()
	self:SetIdentifier(-1)

	if CLIENT then
		if IsValid(self:GetPanel()) then
			self:GetPanel():Remove()
		end
	end
end

function PANEL:__eq(Other)
	return self:GetIdentifier() == Other:GetIdentifier()
end

function PANEL:__tostring()
	return Format("Panel %d ('%s')", self:GetIdentifier(), self:GetClassName())
end

function PANEL:ToReference()
	return { ["i"] = self:GetIdentifier(), ["c"] = self:GetChip() }
end

function dermacore.panel.Create(Chip, ClassName, Identifier)
	local Panel = setmetatable({}, PANEL)

	Panel:SetChip(Chip)
	Panel:SetClassName(ClassName)
	Panel:SetIdentifier(Identifier)

	return Panel
end

function dermacore.panel.UnReference(Panel)
	if not istable(Panel) or not Panel.c or not Panel.i then -- TODO: Make reference object?
		return Panel
	end

	return dermacore.store.GetPanels(Panel.c)[Panel.i]
end

function dermacore.panel.IsPanel(Object)
	return getmetatable(Object) == PANEL
end

function dermacore.panel.ReferenceAll(...)
	local Arguments = { ... }

	for i = 1, #Arguments do
		local Argument = Arguments[i]

		if dermacore.panel.IsPanel(Argument) then
			Arguments[i] = Argument[i]:ToReference()
		elseif CLIENT and ispanel(Argument) then
			Arguments[i] = -1
		end
	end

	return Arguments
end

function dermacore.panel.UnReferenceAll(...)
	local Arguments = { ... }

	for i = 1, #Arguments do
		Arguments[i] = dermacore.panel.UnReference(Arguments[i])
	end

	return Arguments
end
