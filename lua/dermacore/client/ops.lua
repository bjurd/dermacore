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

	local StorePanel = dermacore.panel.Create(Chip, ClassName, Identifier)
	StorePanel:SetPanel(Panel)

	-- Events
	dermacore.panel.Hook(Panel, "OnRemove", function(self)
		dermacore.store.Remove(Chip, Identifier)
		dermacore.ops.Send(NULL, dermacore.enums.ops.REMOVE, Chip, Identifier)
	end)

	dermacore.panel.Hook(Panel, "DoClick", function(self)
		dermacore.ops.Send(NULL, dermacore.enums.ops.EVENT, Chip, StorePanel:ToReference(), "panelClicked")
	end)

	dermacore.panel.Hook(Panel, "DoRightClick", function(self)
		dermacore.ops.Send(NULL, dermacore.enums.ops.EVENT, Chip, StorePanel:ToReference(), "panelRightClicked")
	end)

	dermacore.panel.Hook(Panel, "DoMiddleClick", function(self)
		dermacore.ops.Send(NULL, dermacore.enums.ops.EVENT, Chip, StorePanel:ToReference(), "panelMiddleClicked")
	end)

	dermacore.panel.Hook(Panel, "DoDoubleClick", function(self)
		dermacore.ops.Send(NULL, dermacore.enums.ops.EVENT, Chip, StorePanel:ToReference(), "panelDoubleClicked")
	end)

	dermacore.store.Add(Chip, Identifier, StorePanel)
	dermacore.ops.Send(NULL, dermacore.enums.ops.CREATE, Chip, ClassName, Identifier)
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.REMOVE, function(_, Chip, Identifier)
	dermacore.store.Remove(Chip, Identifier)
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.CALL, function(_, Chip, Identifier, Function, ...)
	local StorePanel = dermacore.store.GetPanels(Chip)[Identifier]

	if not IsValid(StorePanel) then
		return Format("Tried to use '%s' on non-existent Panel %d", Function, Identifier)
	end

	local Panel = StorePanel:GetPanel()

	if not IsValid(Panel) then
		return Format("Tried to use '%s' on invalid Panel %d", Function, Identifier)
	end

	local TargetFunction = Panel[Function]

	if not isfunction(TargetFunction) then
		return Format("Tried to call non-existent function '%s' on %d", Function, Identifier)
	end

	local Arguments = dermacore.panel.UnReferenceAll(...)

	for i = 1, #Arguments do -- Get actual panels for function calls
		if dermacore.panel.IsPanel(Arguments[i]) then
			Arguments[i] = Arguments[i]:GetPanel()
		end
	end

	TargetFunction(Panel, unpack(Arguments))
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.SYNC, function(_, Chip, Identifier, Function, ...)
	local StorePanel = dermacore.store.GetPanels(Chip)[Identifier]

	if not IsValid(StorePanel) then
		return Format("Tried to use '%s' on non-existent Panel %d", Function, Identifier)
	end

	local Panel = StorePanel:GetPanel()

	if not IsValid(Panel) then
		return Format("Tried to use '%s' on invalid Panel %d", Function, Identifier)
	end

	local TargetFunction = Panel[Function]

	if not isfunction(TargetFunction) then
		return Format("Tried to call non-existent function '%s' on %d", Function, Identifier)
	end

	local Arguments = dermacore.panel.UnReferenceAll(...)
	local Result = dermacore.panel.ReferenceAll(TargetFunction(Panel, unpack(Arguments)))

	dermacore.ops.Send(NULL, dermacore.enums.ops.SYNC, Chip, Identifier, Function, unpack(Result))
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.CLEANUP, function(_, Chip)
	dermacore.store.Cleanup(Chip)
end)
