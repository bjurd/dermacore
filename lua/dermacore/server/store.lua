function dermacore.store.GetPanels(Chip)
	local Context = Chip.context

	if not istable(Context) then
		error("Chip has no storage")
		return {}
	end

	if not Context.panelStore then
		Context.panelStore = {}
	end

	return Context.panelStore
end

function dermacore.store.GetNextIdentifier(Chip)
	local Panels = dermacore.store.GetPanels(Chip)

	local NextID = #Panels + 1

	if NextID > dermacore.store.HighestID then
		return -1
	end

	return NextID
end

function dermacore.store.Add(Chip, Identifier, ClassName)
	local Panels = dermacore.store.GetPanels(Chip)

	Panels[Identifier] = { ClassName }
end

function dermacore.store.Remove(Chip, Identifier)
	local Panels = dermacore.store.GetPanels(Chip)

	Panels[Identifier] = nil
end

function dermacore.store.Cleanup(Chip)
	if not Chip.context then
		error("Chip has no context")
		return
	end

	dermacore.ops.Send(Chip.context.player, dermacore.enums.ops.CLEANUP, Chip:EntIndex())
end

function dermacore.store.SaveSync(Chip, Identifier, Function, ...)
	local Panels = dermacore.store.GetPanels(Chip)
	local Panel = Panels[Identifier]

	if not istable(Panel) then
		error("Got bad panel, somehow...")
		return
	end

	Panel[Function] = { ... } -- Let gc handle dat
end

function dermacore.store.GetSync(Chip, Identifier, Function)
	local Panels = dermacore.store.GetPanels(Chip)
	local Panel = Panels[Identifier]

	if not istable(Panel) then
		error("Got bad panel, somehow...")
		return
	end

	return Panel[Function]
end
