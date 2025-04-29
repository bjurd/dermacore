function dermacore.store.Add(Chip, Identifier, Panel)
	local Panels = dermacore.store.GetPanels(Chip)

	Panels[Identifier] = Panel
end

function dermacore.store.Remove(Chip, Identifier)
	local Panels = dermacore.store.GetPanels(Chip)

	if IsValid(Panels[Identifier]) then
		Panels[Identifier]:Remove()
	end

	Panels[Identifier] = nil
end

function dermacore.store.Cleanup(Chip)
	local Panels = dermacore.store.GetPanels(Chip)

	for Identifier, Panel in next, Panels do
		Panel:Remove()
		Panels[Identifier] = nil
	end
end
