local trackedBlips = {}

-- MAPOWANIE JOB -> FRAKCJA
local JobFrakcje = {
    police = "LSPD",
    lssd = "LSSD",
    ambulance = "EMS",
    -- Dodaj inne frakcje tutaj
}

-- SPRAWDZANIE CZY POJAZD NALEZY DO FRAKCJI
local function shouldTrackVehicle(vehicle)
    local vehicleModel = GetEntityModel(vehicle)
    local playerJob = ESX.GetPlayerData().job.name

    if Config.frakcjeAuta[playerJob] then
        for _, model in pairs(Config.frakcjeAuta[playerJob]) do
            if vehicleModel == GetHashKey(model) then
                return true
            end
        end
    end
    return false
end

-- TWORZENIE BLIPA NA POJEZDZIE
local function createVehicleBlip(vehicle)
    local vehiclePlate = GetVehicleNumberPlateText(vehicle)
    if trackedBlips[vehiclePlate] then
        -- Jeśli blip już istnieje, nie tworzymy go ponownie
        return
    end

    local vehicleBlip = AddBlipForEntity(vehicle)
    local playerJob = ESX.GetPlayerData().job.name
    local frakcja = JobFrakcje[playerJob] or playerJob  
    local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

    -- Obliczenie dystansu między graczem a pojazdem
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicleCoords = GetEntityCoords(vehicle)
    local distance = #(playerCoords - vehicleCoords)

    -- Ustawienia blipa
    SetBlipSprite(vehicleBlip, 225)
    SetBlipColour(vehicleBlip, 3)
    SetBlipScale(vehicleBlip, 0.75)
    SetBlipCategory(vehicleBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    
    -- Dodanie dystansu do nazwy blipa
    AddTextComponentString('Nadajnik - ' .. frakcja .. ' (' .. math.floor(distance) .. 'm)')
    
    EndTextCommandSetBlipName(vehicleBlip)

    -- Zapisujemy blip na podstawie tablicy rejestracyjnej pojazdu
    trackedBlips[vehiclePlate] = vehicleBlip
end

-- USUWANIE BLIPA Z POJAZDU
local function removeVehicleBlip(vehiclePlate)
    if trackedBlips[vehiclePlate] then
        RemoveBlip(trackedBlips[vehiclePlate])
        trackedBlips[vehiclePlate] = nil
    end
end

-- PĘTLA ODŚWIEŻAJĄCA BLIPA
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.refreshRate * 1000)

        -- Sprawdzenie obecnych pojazdów i usunięcie blipów dla tych, które zniknęły
        local existingBlips = {}
        for vehicle in EnumerateVehicles() do
            local vehiclePlate = GetVehicleNumberPlateText(vehicle)
            if shouldTrackVehicle(vehicle) then
                createVehicleBlip(vehicle)
                existingBlips[vehiclePlate] = true
            end
        end

        -- Usunięcie blipów dla pojazdów, które już nie istnieją
        for vehiclePlate, blip in pairs(trackedBlips) do
            if not existingBlips[vehiclePlate] then
                removeVehicleBlip(vehiclePlate)
            end
        end
    end
end)

function EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, vehicle = FindFirstVehicle()
        local success
        repeat
            coroutine.yield(vehicle)
            success, vehicle = FindNextVehicle(handle)
        until not success
        EndFindVehicle(handle)
    end)
end
