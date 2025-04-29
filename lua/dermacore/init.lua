dermacore = dermacore or {}

AddCSLuaFile()

AddCSLuaFile("enums.lua")
include("enums.lua")

AddCSLuaFile("ops.lua")
include("ops.lua")

AddCSLuaFile("store.lua")
include("store.lua")

AddCSLuaFile("client/ops.lua")
AddCSLuaFile("client/store.lua")

if SERVER then
	include("server/ops.lua")
	include("server/panel.lua")
	include("server/store.lua")
elseif CLIENT then
	include("client/ops.lua")
	include("client/store.lua")
end
