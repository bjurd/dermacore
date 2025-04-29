E2Lib.RegisterExtension("dermacore", true, "Allows E2 chips to create Derma UI elements")

--[[******************************************************************************]]

e2function number panelCreate(string className)
	local Identifier = dermacore.store.GetNextIdentifier(self.entity)

	if Identifier < 1 then
		return self:throw("This chip has hit the Panel limit!", -1)
	end

	dermacore.ops.Send(self.player, dermacore.enums.ops.CREATE, self.entity, className, Identifier)
	self.entity:CallOnRemove("dermacore:Cleanup", dermacore.store.Cleanup)

	return Identifier
end

e2function void panelRemove(number identifier)
	dermacore.store.Remove(self.entity, identifier)
	dermacore.ops.Send(self.player, dermacore.enums.ops.REMOVE, self.entity, identifier)
end
