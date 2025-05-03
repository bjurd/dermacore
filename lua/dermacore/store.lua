dermacore.store = dermacore.store or {}

dermacore.store.HighestID = 1024

dermacore.store.Panels = dermacore.store.Panels or {}

function dermacore.store.GetPanels(Chip)
	if not isnumber(Chip) then
		error("Tried to GetPanels for non-chip '%s'", Chip)
		return
	end

	if not dermacore.store.Panels[Chip] then
		dermacore.store.Panels[Chip] = {}
	end

	return dermacore.store.Panels[Chip]
end

function dermacore.store.GetNextIdentifier(Chip)
	local Panels = dermacore.store.GetPanels(Chip)

	local NextID = #Panels + 1

	if NextID > dermacore.store.HighestID then
		return -1
	end

	return NextID
end

function dermacore.store.Add(Chip, Identifier, StorePanel)
	dermacore.store.Remove(Chip, Identifier)

	if Identifier > dermacore.store.HighestID then
		return
	end

	dermacore.store.GetPanels(Chip)[Identifier] = StorePanel
end

function dermacore.store.Remove(Chip, Identifier)
	local Panels = dermacore.store.GetPanels(Chip)

	if Panels[Identifier] ~= nil then
		if IsValid(Panels[Identifier]) then
			Panels[Identifier]:Remove()
		end

		Panels[Identifier] = nil
	end
end

function dermacore.store.Cleanup(Chip)
	local Panels = dermacore.store.GetPanels(Chip)

	for Identifier, _ in next, Panels do
		dermacore.store.Remove(Chip, Identifier)
	end

	dermacore.store.Panels[Chip] = nil
end
