E2Lib.RegisterExtension("dermacore", true, "Allows E2 chips to create Derma UI elements")

--[[******************************************************************************]]

local function SendPanelFunction(self, Identifier, Name, ...)
	dermacore.ops.Send(self.player, dermacore.enums.ops.CALL, self.entity:EntIndex(), Identifier, Name, ...)
end

e2function number panelCreate(string className)
	local Identifier = dermacore.store.GetNextIdentifier(self.entity)

	if Identifier < 1 then
		return self:throw("This chip has hit the Panel limit!", -1)
	end

	dermacore.ops.Send(self.player, dermacore.enums.ops.CREATE, self.entity:EntIndex(), className, Identifier)
	self.entity:CallOnRemove("dermacore:Cleanup", dermacore.store.Cleanup)

	dermacore.store.Add(self.entity, Identifier, "") -- Take the ID slot until the player responds

	return Identifier
end

e2function void panelRemove(number identifier)
	dermacore.store.Remove(self.entity, identifier)
	dermacore.ops.Send(self.player, dermacore.enums.ops.REMOVE, self.entity:EntIndex(), identifier)
end

e2function void panelPos(number identifier, number x, number y)
	SendPanelFunction(self, identifier, "SetPos", x, y)
end

e2function void panelSize(number identifier, number width, number height)
	SendPanelFunction(self, identifier, "SetSize", width, height)
end

e2function void panelParent(number identifier, number parent)
	SendPanelFunction(self, identifier, "SetParent", dermacore.store.PanelRef(parent))
end

e2function void panelDock(number identifier, number dock)
	SendPanelFunction(self, identifier, "Dock", dock)
end

e2function void panelCenter(number identifier)
	SendPanelFunction(self, identifier, "Center")
end

e2function void panelSetText(number identifier, string text)
	SendPanelFunction(self, identifier, "SetText", text)
end
