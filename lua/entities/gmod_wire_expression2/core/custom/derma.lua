E2Lib.RegisterExtension("dermacore", true, "Allows E2 chips to create Derma UI elements")

local NULLPanel = dermacore.panel.Create("Panel", "NULL", -1)

registerType(
	"panel",
	"p",

	NULLPanel,

	nil,
	nil,
	function(Object) return not ispanel(Object),
	function(Object) return not ispanel(Object) or Object == NULLPanel end
end)

E2Lib.registerConstant("DOCK_NONE", 0) -- NODOCK
E2Lib.registerConstant("DOCK_FILL", 1) -- FILL
E2Lib.registerConstant("DOCK_LEFT", 2) -- LEFT
E2Lib.registerConstant("DOCK_RIGHT", 3) -- RIGHT
E2Lib.registerConstant("DOCK_TOP", 4) -- TOP
E2Lib.registerConstant("DOCK_BOTTOM", 5) -- BOTTOM

--[[******************************************************************************]]

local function SendPanelFunction(self, Identifier, Name, ...)
	dermacore.ops.Send(self.player, dermacore.enums.ops.CALL, self.entity:EntIndex(), Identifier, Name, ...)
end

local function SendSyncFunction(self, Identifier, SendData, SyncData)
	SendPanelFunction(self, Identifier, SendData[1], select(2, unpack(SendData)))
	dermacore.ops.Send(self.player, dermacore.enums.ops.SYNC, self.entity:EntIndex(), Identifier, SyncData[1], select(2, unpack(SyncData)))
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

e2function void panel:rawCall(string functionName, ...args)
	local Arguments = dermacore.panel.ReferenceAll(unpack(args))

	SendPanelFunction(self, this:GetIdentifier(), functionName, unpack(Arguments))
end

e2function string panel:toString()
	return tostring(this)
end

e2function number panel:getIdentifier()
	return this:GetIdentifier()
end

e2function string panel:getClassName()
	return this:GetClassName()
end

e2function number operator==(panel a, panel b)
	return a == b and 1 or 0
end

e2function void panel:remove()
	dermacore.ops.Send(self.player, dermacore.enums.ops.REMOVE, self.entity:EntIndex(), this:GetIdentifier())
	dermacore.store.Remove(self.entity:EntIndex(), this:GetIdentifier())
end

e2function void panel:setVisible(number visible)
	SendSyncFunction(self, this:GetIdentifier(), { "SetVisible", tobool(visible) }, { "IsVisible" })
end

e2function number panel:getVisible()
	local Data = dermacore.store.GetSync(self.entity:EntIndex(), this:GetIdentifier(), "IsVisible")

	if not Data then
		return -1
	end

	return Data[1] and 1 or 0
end

e2function void panel:makePopup()
	SendPanelFunction(self, this:GetIdentifier(), "MakePopup")
end

e2function void panel:setPos(number x, number y)
	SendPanelFunction(self, this:GetIdentifier(), "SetPos", x, y)
end

e2function void panel:setPos(vector2 pos)
	SendPanelFunction(self, this:GetIdentifier(), "SetPos", pos[1], pos[2])
end

-- TODO: GetPos

e2function void panel:setSize(number width, number height)
	SendPanelFunction(self, this:GetIdentifier(), "SetSize", width, height)
end

e2function void panel:setSize(vector2 size)
	SendPanelFunction(self, this:GetIdentifier(), "SetSize", size[1], size[2])
end

-- TODO: GetSize

e2function void panel:setParent(panel parent)
	SendSyncFunction(self, this:GetIdentifier(), { "SetParent", parent:ToReference() }, { "GetParent" })
end

e2function panel panel:getParent()
	local Data = dermacore.store.GetSync(self.entity:EntIndex(), this:GetIdentifier(), "GetParent")

	if not Data then
		return NULLPanel
	end

	local Parent = dermacore.panel.UnReference(Data[1])

	if Parent == Data[1] then
		return NULLPanel
	else
		return Parent
	end
end

e2function void panel:setDock(number dock)
	SendPanelFunction(self, this:GetIdentifier(), "Dock", dock)
end

-- TODO: GetDock

e2function void panel:setDockMargin(number left, number top, number right, number bottom)
	SendPanelFunction(self, this:GetIdentifier(), "DockMargin", left, top, right, bottom)
end

e2function void panel:setDockPadding(number left, number top, number right, number bottom)
	SendPanelFunction(self, this:GetIdentifier(), "DockPadding", left, top, right, bottom)
end

e2function void panel:center()
	SendPanelFunction(self, this:GetIdentifier(), "Center")
end

e2function void panel:setText(string text)
	SendPanelFunction(self, this:GetIdentifier(), "SetText", text)
end

-- TODO: GetText

E2Lib.registerEvent("panelClicked", { {"Panel", "p"} })
E2Lib.registerEvent("panelRightClicked", { {"Panel", "p"} })
E2Lib.registerEvent("panelMiddleClicked", { {"Panel", "p"} })
E2Lib.registerEvent("panelDoubleClicked", { {"Panel", "p"} })
