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
	dermacore.store.Remove(Chip, Identifier)

	local Panels = dermacore.store.GetPanels(Chip)

	Panels[Identifier] = Panel
	Panel.Identifier = Identifier

	-- TODO: Make this better
	Panel.OnRemove = function(self)
		dermacore.store.Remove(Chip, Identifier)
	end
end

function dermacore.store.Remove(Chip, Identifier)
	local Panels = dermacore.store.GetPanels(Chip)

	if Panels[Identifier] ~= nil then
		if IsValid(Panels[Identifier]) then
			Panels[Identifier]:Remove()
		end

		Panels[Identifier] = nil

		dermacore.ops.Send(NULL, dermacore.enums.ops.REMOVE, Chip, Identifier)
	end
end

function dermacore.store.Cleanup(Chip)
	local Panels = dermacore.store.GetPanels(Chip)

	for Identifier, _ in next, Panels do
		Panels[Identifier]:Remove()
	end

	dermacore.store.ChipPanels[Chip] = nil
end
