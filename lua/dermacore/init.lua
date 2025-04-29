dermacore = dermacore or {}

AddCSLuaFile()

AddCSLuaFile("enums.lua")
include("enums.lua")

AddCSLuaFile("ops.lua")
include("ops.lua")

AddCSLuaFile("client/ops.lua")

if SERVER then
	include("server/ops.lua")
	include("server/panel.lua")
elseif CLIENT then
	include("client/ops.lua")
end
