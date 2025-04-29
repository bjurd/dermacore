function dermacore.store.SaveSync(Chip, Identifier, Function, ...)
	local Panel = dermacore.store.GetPanels(Chip)[Identifier]

	if not IsValid(Panel) then
		error("Got bad panel, somehow...")
		return
	end

	Panel[Function] = { ... } -- Let gc handle dat
end

function dermacore.store.GetSync(Chip, Identifier, Function)
	local Panel = dermacore.store.GetPanels(Chip)[Identifier]

	if not IsValid(Panel) then
		error("Got bad panel, somehow...")
		return
	end

	return Panel[Function]
end

function dermacore.store.ChipCleanup(Chip)
	dermacore.store.Cleanup(Chip:EntIndex())

	dermacore.ops.Send(Chip.context.player, dermacore.enums.ops.CLEANUP, Chip:EntIndex())
end
