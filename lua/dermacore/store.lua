dermacore.store = dermacore.store or {}

dermacore.store.HighestID = 1024

function dermacore.store.GetPanels(Chip)
	local Context = SERVER and Chip.context or Chip:GetTable()

	if not istable(Context) then
		error("Chip has no context")
		return {}
	end

	if not Context.panelStore then
		Context.panelStore = {}
	end

	return Context.panelStore
end
