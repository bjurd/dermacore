dermacore = dermacore or {}

AddCSLuaFile()

AddCSLuaFile("enums.lua")
include("enums.lua")

AddCSLuaFile("ops.lua")
include("ops.lua")

AddCSLuaFile("panel.lua")
include("panel.lua")

AddCSLuaFile("store.lua")
include("store.lua")

AddCSLuaFile("client/ops.lua")

if SERVER then
	include("server/ops.lua")
	include("server/store.lua")
elseif CLIENT then
	include("client/ops.lua")
end
