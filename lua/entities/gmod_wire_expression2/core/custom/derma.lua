E2Lib.RegisterExtension("dermacore", true, "Allows E2 chips to create Derma UI elements")

local istable = istable -- TODO: Custom ispanel for server (Why does the normal one even exist on server)

registerType(
	"panel",
	"p",

	NULL,

	nil,
	nil,
	function(Object) return not istable(Object),
	function(Object) return not istable(Object) or not Object:istable() end
end)

--[[******************************************************************************]]

e2function panel panelCreate(string className)
	dermacore.ops.Send(self.player, dermacore.enums.ops.CREATE, className)

	return NULL
end
