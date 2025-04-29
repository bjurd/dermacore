E2Lib.RegisterExtension("dermacore", true, "Allows E2 chips to create Derma UI elements")

local NULLPanel = dermacore.panel.Create("Panel", -1)

registerType(
	"panel",
	"p",

	NULLPanel,

	nil,
	nil,
	function(Object) return not ispanel(Object),
	function(Object) return not ispanel(Object) or Object == NULLPanel end
end)

--[[******************************************************************************]]

local function SendPanelFunction(self, Identifier, Name, ...)
	dermacore.ops.Send(self.player, dermacore.enums.ops.CALL, self.entity:EntIndex(), Identifier, Name, ...)
end

e2function panel panelCreate(string className)
	local Identifier = dermacore.store.GetNextIdentifier(self.entity:EntIndex())

	if Identifier < 1 then
		return self:throw("This chip has hit the Panel limit!", NULLPanel)
	end

	dermacore.ops.Send(self.player, dermacore.enums.ops.CREATE, self.entity:EntIndex(), className, Identifier)
	self.entity:CallOnRemove("dermacore:Cleanup", dermacore.store.ChipCleanup)

	local Panel = dermacore.panel.Create(self.entity:EntIndex(), className, Identifier)
	dermacore.store.Add(self.entity:EntIndex(), Identifier, Panel) -- Take the ID slot until the player responds

	return Panel
end

e2function string panel:toString()
	return tostring(this)
end

e2function void panel:remove()
	dermacore.ops.Send(self.player, dermacore.enums.ops.REMOVE, self.entity:EntIndex(), this:GetIdentifier())
	dermacore.store.Remove(self.entity:EntIndex(), this:GetIdentifier())
end

e2function void panel:setVisible(number visible)
	SendPanelFunction(self, this:GetIdentifier(), "SetVisible", tobool(visible))
end

-- TODO: GetVisible

e2function void panel:makePopup()
	SendPanelFunction(self, this:GetIdentifier(), "MakePopup")
end

e2function void panel:setPos(number x, number y)
	SendPanelFunction(self, this:GetIdentifier(), "SetPos", x, y)
end

-- TODO: GetPos

e2function void panel:setSize(number width, number height)
	SendPanelFunction(self, this:GetIdentifier(), "SetSize", width, height)
end

-- TODO: GetSize

e2function void panel:setParent(panel parent)
	SendPanelFunction(self, this:GetIdentifier(), "SetParent", parent:ToReference())
	dermacore.ops.Send(self.player, dermacore.enums.ops.SYNC, self.entity:EntIndex(), this:GetIdentifier(), "GetParent")
end

e2function panel panel:getParent() -- TODO:
	local Data = dermacore.store.GetSync(self.entity:EntIndex(), this:GetIdentifier(), "GetParent")

	if not Data then
		return NULLPanel
	end

	local Panels = dermacore.store.GetPanels(self.entity:EntIndex())
	local Parent = dermacore.store.PanelUnRef(Panels, Data[1])

	return Parent or NULLPanel
end

e2function void panel:dock(number dock)
	SendPanelFunction(self, this:GetIdentifier(), "Dock", dock)
end

-- TODO: GetDock

e2function void panel:center()
	SendPanelFunction(self, this:GetIdentifier(), "Center")
end

e2function void panel:setText(string text)
	SendPanelFunction(self, this:GetIdentifier(), "SetText", text)
end

-- TODO: GetText

E2Lib.registerEvent("panelClicked", { {"Panel", "p"} })
