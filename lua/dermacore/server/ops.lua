-- The client can spoof the Identifier here and fuck things up a little bit
-- Not really a way to fix that because Panels are entirely controlled by the client
dermacore.ops.RegisterCallback(dermacore.enums.ops.CREATE, function(Sender, Chip, ClassName, Identifier)
	if not IsValid(Chip) then return end
	if Chip:GetClass() ~= "gmod_wire_expression2" then return end

	local Context = Chip.context
	if not istable(Context) or Context.player ~= Sender then return end

	dermacore.store.Add(Chip, Identifier, ClassName)
end)

dermacore.ops.RegisterCallback(dermacore.enums.ops.ERROR, function(Sender, Message)
	WireLib.ClientError(Message, Sender)
end)
