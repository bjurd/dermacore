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

dermacore.ops.RegisterCallback(dermacore.enums.ops.CLEANUP, function(_, Chip)
	dermacore.store.Cleanup(Chip)
end)
