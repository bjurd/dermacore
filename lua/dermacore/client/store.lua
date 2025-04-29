dermacore.store.ChipPanels = dermacore.store.ChipPanels or {}

function dermacore.store.GetPanels(Chip)
	local PanelStore = dermacore.store.ChipPanels[Chip]

	if not PanelStore then
		PanelStore = {}
		dermacore.store.ChipPanels[Chip] = PanelStore
	end

	return PanelStore
end

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

	for Identifier, _ in next, Panels do
		dermacore.store.Remove(Chip, Identifier)
	end

	dermacore.store.ChipPanels[Chip] = nil
end
