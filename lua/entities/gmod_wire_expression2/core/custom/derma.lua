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

e2function string panel:toString()
	return tostring(this)
end

e2function number panel:getIdentifier()
	return this:GetIdentifier()
end

e2function string panel:getClassName()
	return this:GetClassName()
end

e2function number panel:isValid()
	return this:IsValid() and 1 or 0
end

e2function number operator==(panel a, panel b)
	return a == b and 1 or 0
end

e2function string operator+(panel a, string b)
	return tostring(a) .. b
end

e2function string operator+(string a, panel b)
	return a .. tostring(b)
end

e2function void panel:call(string functionName, ...args)
	local Arguments = dermacore.panel.ReferenceAll(unpack(args))

	SendPanelFunction(self, this:GetIdentifier(), functionName, unpack(Arguments))
end

e2function void panel:sync(string functionName, ...args)
	local Arguments = dermacore.panel.ReferenceAll(unpack(args))

	dermacore.ops.Send(self.player, dermacore.enums.ops.SYNC, self.entity:EntIndex(), this:GetIdentifier(), functionName, unpack(Arguments))
end

e2function number panel:getSyncedNumber(string functionName)
	local Data = dermacore.store.GetSync(self.entity:EntIndex(), this:GetIdentifier(), functionName)

	if not Data then
		return (0 / 0)
	end

	return tonumber(Data[1]) or (0 / 0)
end

e2function string panel:getSyncedString(string functionName)
	local Data = dermacore.store.GetSync(self.entity:EntIndex(), this:GetIdentifier(), functionName)

	if not Data then
		return ""
	end

	return Data[1] or ""
end

e2function panel panel:getSyncedPanel(string functionName)
	local Data = dermacore.store.GetSync(self.entity:EntIndex(), this:GetIdentifier(), functionName)

	if not Data then
		return NULLPanel
	end

	local UnReferenced = dermacore.panel.UnReference(Data[1])

	if UnReferenced == Data[1] then
		-- UnReference failed
		return NULLPanel
	else
		return UnReferenced
	end
end

e2function void panel:remove()
	dermacore.ops.Send(self.player, dermacore.enums.ops.REMOVE, self.entity:EntIndex(), this:GetIdentifier())
	dermacore.store.Remove(self.entity:EntIndex(), this:GetIdentifier())
end

E2Lib.registerEvent("panelClicked", { {"Panel", "p"} })
E2Lib.registerEvent("panelRightClicked", { {"Panel", "p"} })
E2Lib.registerEvent("panelMiddleClicked", { {"Panel", "p"} })
E2Lib.registerEvent("panelDoubleClicked", { {"Panel", "p"} })
E2Lib.registerEvent("panelDataSync", { {"Panel", "p"}, { "Function", "s" } })
