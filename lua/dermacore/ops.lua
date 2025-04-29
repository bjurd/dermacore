dermacore.ops = dermacore.ops or {}

if SERVER then
	util.AddNetworkString("dermacore_op")
end

dermacore.ops.Callbacks = dermacore.ops.Callbacks or {}

function dermacore.ops.Write(Op, ...)
	net.WriteUInt(Op, dermacore.enums.ops.OPS_SIZE)
	net.WriteTable({ ... }, true) -- Terrible, hopefully temporary solution
end

function dermacore.ops.Send(Target, Op, ...) -- "Target" argument ignored on cl, put anything :)
	net.Start("dermacore_op")
		dermacore.ops.Write(Op, ...)

	if SERVER then
		net.Send(Target)
	elseif CLIENT then
		net.SendToServer()
	end
end

function dermacore.ops.RegisterCallback(Op, Callback)
	dermacore.ops.Callbacks[Op] = Callback
end

net.Receive("dermacore_op", function(Length, Sender)
	local Op = net.ReadUInt(dermacore.enums.ops.OPS_SIZE)
	local Callback = dermacore.ops.Callbacks[Op]

	if isfunction(Callback) then
		local Args = net.ReadTable(true)

		local Result = Callback(Sender, unpack(Args))

		if isstring(Result) then
			if SERVER then
				ErrorNoHaltWithStack("[DermaCore]\n", Result)
			elseif CLIENT then
				dermacore.ops.Send(NULL, dermacore.enums.ops.ERROR, Result)
			end
		end
	end
end)
