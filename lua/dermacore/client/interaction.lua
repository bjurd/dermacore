local function HookMousePress(GAMEMODE)
	if not istable(GAMEMODE) then
		ErrorNoHaltWithStack("Failed to get GAMEMODE table!")
		return
	end

	if not GAMEMODE.BaseVGUIMousePressAllowed then
		-- Anti auto-refresh
		GAMEMODE.BaseVGUIMousePressAllowed = GAMEMODE.VGUIMousePressAllowed or true
	end

	function GAMEMODE:VGUIMousePressAllowed(Button)
		local Result = isfunction(self.BaseVGUIMousePressAllowed) and self:BaseVGUIMousePressAllowed(Button)
		if Result == true then return end

		local Panel = vgui.GetHoveredPanel()

		if not IsValid(Panel) then
			return
		end

		local Chip, Identifier = Panel:GetStoreIdentifier()

		if not isnumber(Chip) or not isnumber(Identifier) then
			return
		end

		Result = hook.Call("VGUIMousePressAllowed", nil, Button)
		if Result == true then return end

		local Reference = Panel:ToStorePanel():ToReference()

		if Button == MOUSE_LEFT then
			dermacore.ops.Send(NULL, dermacore.enums.ops.EVENT, Chip, Reference, "panelClicked")
		elseif Button == MOUSE_RIGHT then
			dermacore.ops.Send(NULL, dermacore.enums.ops.EVENT, Chip, Reference, "panelRightClicked")
		elseif Button == MOUSE_MIDDLE then
			dermacore.ops.Send(NULL, dermacore.enums.ops.EVENT, Chip, Reference, "panelMiddleClicked")
		end
	end
end

local GAMEMODE = gmod.GetGamemode()

if not istable(GAMEMODE) then
	hook.Add("PostGamemodeLoaded", "dermacore:Interaction", function()
		HookMousePress(gmod.GetGamemode())
	end)

	return
end

HookMousePress(GAMEMODE)
