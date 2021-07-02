ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_FuelTheft:SyncVehicleFuel')
AddEventHandler('esx_FuelTheft:SyncVehicleFuel', function(vehicle, fuelLevel)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('esx_FuelTheft:SyncFuelReturn', -1, vehicle, fuelLevel)
    
    if Config.EnableDebug then
        print('Synced vehicle fuel level: ' .. fuelLevel)
    end
end)