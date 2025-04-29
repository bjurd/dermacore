dermacore.ops.RegisterCallback(dermacore.enums.ops.ERROR, function(Sender, Message)
	WireLib.ClientError(Message, Sender)
end)
