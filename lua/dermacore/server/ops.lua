-- The client can spoof the Identifier here and fuck things up a little bit
-- Not really a way to fix that because Panels are entirely controlled by the client
dermacore.ops.RegisterCallback(dermacore.enums.ops.CREATE, function(Sender, Chip, ClassName, Identifier)
	if not isnumber(Chip) then return end
	if not isstring(ClassName) then return end
	if not isnumber(Identifier) then return end

	Chip = Entity(Chip)

	if not IsValid(Chip) then return end
	if Chip:GetClass() ~= "gmod_wire_expression2" then return end

	local Context = Chip.context
	if not istable(Context) or Context.player ~= Sender then return end

	dermacore.store.Add(Chip, Identifier, ClassName)
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.REMOVE, function(Sender, Chip, Identifier)
	if not isnumber(Chip) then return end
	if not isnumber(Identifier) then return end

	Chip = Entity(Chip)

	if not IsValid(Chip) then return end
	if Chip:GetClass() ~= "gmod_wire_expression2" then return end

	local Context = Chip.context
	if not istable(Context) or Context.player ~= Sender then return end

	dermacore.store.Remove(Chip, Identifier)
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.SYNC, function(Sender, Chip, Identifier, Function, ...)
	if not isnumber(Chip) then return end
	if not isnumber(Identifier) then return end
	if not isstring(Function) or string.len(Function) < 1 then return end

	Chip = Entity(Chip)

	if not IsValid(Chip) then return end
	if Chip:GetClass() ~= "gmod_wire_expression2" then return end

	local Context = Chip.context
	if not istable(Context) or Context.player ~= Sender then return end

	dermacore.store.SaveSync(Chip, Identifier, Function, ...)
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.ERROR, function(Sender, Message)
	if not isstring(Message) or string.len(Message) < 1 then return end

	WireLib.ClientError(Message, Sender)
end)
