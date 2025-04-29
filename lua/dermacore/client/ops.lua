dermacore.ops.RegisterCallback(dermacore.enums.ops.CREATE, function(_, ClassName)
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

	print("maked")
	Panel:Remove()
end)
