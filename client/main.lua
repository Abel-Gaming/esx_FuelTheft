ESX              = nil
local FuelInHand = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

RegisterCommand(Config.StealCommand, function()
	StealVehicleFuel()
end)

RegisterCommand(Config.UseFuelCommand, function()
	UseStolenFuel()
end)

if Config.EnableKeyMapping then
	RegisterKeyMapping('_stealfuel', 'Steal Fuel', 'keyboard', ';')
	RegisterKeyMapping('_usestolenfuel', 'Use Stolen Fuel', 'keyboard', ']')
end

if Config.Enable3DText then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			-- Get the closest vehicle
			local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
			
			while #(GetEntityCoords(closestVehicle) - GetEntityCoords(PlayerPedId())) < 2.0 and editMode and not grillLocked do
		end
	end)
end

function StealVehicleFuel()
	--Get the closest vehicle
	local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local closestVehicleCoords = GetEntityCoords(closestVehicle)

	if #(GetEntityCoords(PlayerPedId()) - closestVehicleCoords) <= 5.0 then
		if IsVehicleStopped(closestVehicle) then
			local vehicleCurrentFuel = GetVehicleFuelLevel(closestVehicle)
			FuelInHand = FuelInHand + vehicleCurrentFuel
			ESX.ShowNotification('You stole ~b~' .. vehicleCurrentFuel .. ' ~w~gallons of fuel')
			TriggerServerEvent('esx_FuelTheft:SyncVehicleFuel', closestVehicle, 0.0)

			-- Print if debug is enabled
			if Config.EnableDebug then
				print('You stole ' .. vehicleCurrentFuel .. ' gallons of fuel')
			end
		end
	else
		ESX.ShowHelpNotification('~r~[ERROR]~w~ No nearby vehicle')
	end
end

function UseStolenFuel()
	local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local closestVehicleCoords = GetEntityCoords(closestVehicle)

	if #(GetEntityCoords(PlayerPedId()) - closestVehicleCoords) <= 5.0 then
		if IsVehicleStopped(closestVehicle) then
			if FuelInHand <= 0 then
				ESX.ShowHelpNotification('~r~[ERROR]~w~ You have no fuel to use!')
			else
				local vehicleCurrentFuel = GetVehicleFuelLevel(closestVehicle)
				ESX.ShowNotification('You used ~b~' .. FuelInHand .. ' ~w~gallons of fuel')
				TriggerServerEvent('esx_FuelTheft:SyncVehicleFuel', closestVehicle, vehicleCurrentFuel + FuelInHand)
				if Config.EnableDebug then
					print('You used ' .. FuelInHand .. ' gallons of fuel')
				end
				FuelInHand = 0
			end
		end
	else
		ESX.ShowHelpNotification('~r~[ERROR]~w~ No nearby vehicle')
	end
end

RegisterNetEvent('esx_FuelTheft:SyncFuelReturn')
AddEventHandler('esx_FuelTheft:SyncFuelReturn', function(vehicle, fuelLevel)
	SetVehicleFuelLevel(vehicle, fuelLevel)
end)