dermacore.ops.RegisterCallback(dermacore.enums.ops.CREATE, function(_, Chip, ClassName, Identifier)
	if not isstring(ClassName) then
		return "Got non-string Panel class name"
	end

	if not vgui.Exists(ClassName) then
		return Format("Class '%s' is not a valid Panel class", ClassName)
	end

	local Panel = vgui.Create(ClassName)

	if not IsValid(Panel) then
		return Format("Failed to create Panel of class '%s'", ClassName)
	end

	dermacore.store.Add(Chip, Identifier, Panel)
	dermacore.ops.Send(NULL, dermacore.enums.ops.CREATE, Chip, ClassName, Identifier)
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.REMOVE, function(_, Chip, Identifier)
	dermacore.store.Remove(Chip, Identifier)
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.CALL, function(_, Chip, Identifier, Function, ...)
	local Panels = dermacore.store.GetPanels(Chip)
	local Panel = Panels[Identifier]

	if not IsValid(Panel) then
		return Format("Tried to use '%s' on non-existent Panel %u", Function, Identifier)
	end

	local TargetFunction = Panel[Function]

	if not isfunction(TargetFunction) then
		return Format("Tried to call non-existent function '%s' on %u", Function, Identifier)
	end

	local Arguments = dermacore.store.UnRefAll(Panels, ...)

	TargetFunction(Panel, unpack(Arguments))
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.SYNC, function(_, Chip, Identifier, Function, ...)
	local Panels = dermacore.store.GetPanels(Chip)
	local Panel = Panels[Identifier]

	if not IsValid(Panel) then
		return Format("Tried to use '%s' on non-existent Panel %u", Function, Identifier)
	end

	local TargetFunction = Panel[Function]

	if not isfunction(TargetFunction) then
		return Format("Tried to call non-existent function '%s' on %u", Function, Identifier)
	end

	local Arguments = dermacore.store.UnRefAll(Panels, ...)

	local Result = { TargetFunction(Panel, unpack(Arguments)) }
	local RefResult = dermacore.store.RefAll(Panels, unpack(Result))

	dermacore.ops.Send(NULL, dermacore.enums.ops.SYNC, Chip, Identifier, Function, unpack(RefResult))
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.CLEANUP, function(_, Chip)
	dermacore.store.Cleanup(Chip)
end)
