dermacore.store = dermacore.store or {}

dermacore.store.HighestID = 1024

function dermacore.store.PanelRef(Identifier) -- This is a hacky way of passing a Panel by identifier from server
	return { ["i"] = Identifier }
end

function dermacore.store.PanelUnRef(Panels, Ref)
	if istable(Panels) and istable(Ref) and isnumber(Ref.i) then
		return Panels[Ref.i]
	else
		return nil
	end
end

function dermacore.store.RefAll(Panels, ...)
	local Arguments = { ... }

	for i = 1, #Arguments do
		local Identifier = table.KeyFromValue(Panels, Arguments[i]) -- BAD

		if Identifier then
			Arguments[i] = dermacore.store.PanelRef(Identifier)
		end
	end

	return Arguments
end

function dermacore.store.UnRefAll(Panels, ...)
	local Arguments = { ... }

	for i = 1, #Arguments do
		Arguments[i] = dermacore.store.PanelUnRef(Panels, Arguments[i]) or Arguments[i]
	end

	return Arguments
end
