ESX = exports["es_extended"]:getSharedObject()

local Translation = Config.Translation
local Language = Config.Language

local KBPin = 1234

local blipName = 'Bank'

local isNearBank = false

_menuPool = NativeUI.CreatePool()

Citizen.CreateThread(function()
    while true do

        local playerCoords =GetEntityCoords(PlayerPedId())
        isNearBank = false

        for k, v in pairs(Config.Coords) do
            local dist = Vdist(playerCoords, v[1], v[2], v[3])
            if dist < 1.0 then
                isNearBank = true
            end
        end
        Wait(350)
    end
end)

for k, v in pairs(Config.Coords) do
    local blip = AddBlipForCoord(v[1], v[2])
        SetBlipSprite (blip, 108)
        SetBlipScale  (blip, 1.0)
        SetBlipDisplay(blip, 4)
        SetBlipColour (blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blipName)
        EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    while true do

        _menuPool:ProcessMenus()

        if isNearBank then
            showInfobar(Translation[Language]['infoBarBank'])
            if IsControlJustReleased(0, 38) then
                if Config.Menu == 'ox_lib' then
                    openOXBanking()
                elseif Config.Menu == 'NativeUI' then
                    ESX.TriggerServerCallback('KBAtm:getPin', function (playerpin)
                        pin = CreateDialog(Translation[Language]['yourPin'])

                        if tonumber(pin) == playerpin then
                            openNativeBank()
                        else
                            if Config.Notify == 'ESX' then
                                exports["esx_notify"]:Notify("info", 3000, Translation[Language]['wrongPin'])
                            elseif Config.Notify == 'OKOK' then
                                exports['okokNotify']:Alert("Banking", Translation[Language]['wrongPin'] , 5000, 'info')
                            elseif Config.Notify == 'GTA' then
                                ShowNotification(Translation[Language]['wrongPin'])
                            end
                        end

                    end)
                end
            end
        end
        
        Wait(1)
    end
end)

Citizen.CreateThread(function ()
    while true do
        local sleep = 350
        for k, v in pairs(Config.Props) do
            local playerPos = GetEntityCoords(PlayerPedId())
            local nearATM = GetClosestObjectOfType(playerPos, 1.0, GetHashKey(v), false, false, false)
            if nearATM ~= 0 then
                sleep = 1
                showInfobar(Translation[Language]['infoBarATM'])
            
                if IsControlJustReleased(0, 38) then
                    if Config.Menu == 'ox_lib' then
                        openOXATM()
                    elseif Config.Menu == 'NativeUI' then
                        ESX.TriggerServerCallback('KBAtm:getPin', function (playerpin)
                            pin = CreateDialog(Translation[Language]['yourPin'])
    
                            if tonumber(pin) == playerpin then
                                openNativeATM()
                            else
                                if Config.Notify == 'ESX' then
                                    exports["esx_notify"]:Notify("info", 3000, Translation[Language]['wrongPin'])
                                elseif Config.Notify == 'OKOK' then
                                    exports['okokNotify']:Alert("Banking", Translation[Language]['wrongPin'] , 5000, 'info')
                                elseif Config.Notify == 'GTA' then
                                    ShowNotification(Translation[Language]['wrongPin'])
                                end
                            end
    
                        end)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

Citizen.CreateThread(function ()
    while true do

        for k, v in pairs(Config.Coords) do
            DrawMarker(27, v[1], v[2], v[3] -0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 50, 60, 100, false, true, 2, false, false, false, false)
        end

        Wait(1)
    end
end)

RegisterNetEvent('KBAtm:OXWithdraw')
AddEventHandler('KBAtm:OXWithdraw', function ()
    amount = lib.inputDialog(Translation[Language]['atm'], {
        {type = 'input', label = Translation[Language]['howMuch'], icon = 'fa-plus'}
    })

    TriggerServerEvent('KBAtm:withdraw', tonumber(amount[1]))

end)

RegisterNetEvent('KBAtm:OXDeposit')
AddEventHandler('KBAtm:OXDeposit', function ()
    amount = lib.inputDialog(Translation[Language]['atm'], {
        {type = 'input', label = Translation[Language]['howMuch'], icon = 'fa-minus'}
    })

    TriggerServerEvent('KBAtm:deposit', tonumber(amount[1]))
    
end)

RegisterNetEvent('KBBanking:OXChangePin')
AddEventHandler('KBBanking:OXChangePin', function ()
    pin = lib.inputDialog(Translation[Language]['bank'], {
        {type = 'input', label = Translation[Language]['enterNewPIN'], icon = 'lock'}
    })
    KBPin = tonumber(pin[1])
    TriggerServerEvent('KBBanking:changePin', KBPin)
    if Config.Notify == 'ESX' then
        exports["esx_notify"]:Notify("info", 3000, Translation[Language]['newPin'] .. pin[1])
    elseif Config.Notify == 'OKOK' then
        exports['okokNotify']:Alert("Banking", Translation[Language]['newPin'] .. pin[1] , 5000, 'info')
    elseif Config.Notify == 'GTA' then
        ShowNotification(Translation[Language]['newPin'] .. pin[1])
    end
end)

RegisterNetEvent('KBBanking:OXWithdraw')
AddEventHandler('KBBanking:OXWithdraw', function ()
    amount = lib.inputDialog(Translation[Language]['bank'], {
        {type = 'input', label = Translation[Language]['howMuch'], icon = 'fa-plus'}
    })

    TriggerServerEvent('KBAtm:withdraw', tonumber(amount[1]))

end)

RegisterNetEvent('KBBanking:OXDeposit')
AddEventHandler('KBBanking:OXDeposit', function ()
    amount = lib.inputDialog(Translation[Language]['bank'], {
        {type = 'input', label = Translation[Language]['howMuch'], icon = 'fa-minus'}
    })

    TriggerServerEvent('KBAtm:deposit', tonumber(amount[1]))
    
end)

function openOXATM()

    ESX.TriggerServerCallback('KBAtm:getPin', function (playerpin)

    pin = lib.inputDialog(Translation[Language]['atm'], {
        {type = 'input', label = Translation[Language]['enterPin'], password = true, icon = 'lock'}
    })

    if tonumber(pin[1]) == playerpin then
        lib.registerContext({
            id = 'atm',
            title = Translation[Language]['atm'],
            options = {
                {title = 'Pin: ' .. playerpin},
                {title = Translation[Language]['withdrawMoney'], icon = 'fa-plus', event = 'KBAtm:OXWithdraw'},
                {title = Translation[Language]['depositMoney'], icon = 'fa-minus', event = 'KBAtm:OXDeposit'}
            }
        })

        lib.showContext('atm')
    else
        if Config.Notify == 'ESX' then
            exports["esx_notify"]:Notify("info", 3000, Translation[Language]['wrongPin'])
        elseif Config.Notify == 'OKOK' then
            exports['okokNotify']:Alert("Banking", Translation[Language]['wrongPin'] , 5000, 'info')
        elseif Config.Notify == 'GTA' then
            ShowNotification(Translation[Language]['wrongPin'])
        end
    end

    end)
end

function openOXBanking()

    ESX.TriggerServerCallback('KBAtm:getPin', function (playerpin)

        pin = lib.inputDialog(Translation[Language]['bank'], {
            {type = 'input', label = Translation[Language]['enterPin'], password = true, icon = 'lock'}
        })
    
        if tonumber(pin[1]) == playerpin then
            lib.registerContext({
                id = 'bank',
                title = Translation[Language]['bank'],
                options = {
                    {title = 'Pin: ' .. playerpin},
                    {title = Translation[Language]['changePin'], icon = 'lock', event = 'KBBanking:OXChangePin'},
                    {title = Translation[Language]['withdrawMoney'], icon = 'fa-plus', event = 'KBBanking:OXWithdraw'},
                    {title = Translation[Language]['depositMoney'], icon = 'fa-minus', event = 'KBBanking:OXDeposit'}
                }
            })
    
            lib.showContext('bank')
        else
            if Config.Notify == 'ESX' then
                exports["esx_notify"]:Notify("info", 3000, Translation[Language]['wrongPin'])
            elseif Config.Notify == 'OKOK' then
                exports['okokNotify']:Alert("Banking", Translation[Language]['wrongPin'] , 5000, 'info')
            elseif Config.Notify == 'GTA' then
                ShowNotification(Translation[Language]['wrongPin'])
            end
        end
    
    end)
    
end

function openNativeBank()

    ESX.TriggerServerCallback('KBAtm:getPin', function (playerpin)

        local bankMenu = NativeUI.CreateMenu(Translation[Language]['bank'])
        _menuPool:Add(bankMenu)

        local PinItem = NativeUI.CreateItem('Pin: ' .. playerpin, Translation[Language]['currentPIN'] .. playerpin)
        bankMenu:AddItem(PinItem)

        local changePinItem = NativeUI.CreateItem(Translation[Language]['changePin'], '')
        bankMenu:AddItem(changePinItem)

        changePinItem.Activated = function (sender, index)
            pin = CreateDialog(Translation[Language]['enterNewPIN'])

            KBPin = tonumber(pin)
            TriggerServerEvent('KBBanking:changePin', KBPin)
            if Config.Notify == 'ESX' then
                exports["esx_notify"]:Notify("info", 3000, Translation[Language]['newPin'] .. pin)
            elseif Config.Notify == 'OKOK' then
                exports['okokNotify']:Alert("Banking", Translation[Language]['newPin'] .. pin , 5000, 'info')
            elseif Config.Notify == 'GTA' then
                ShowNotification(Translation[Language]['newPin'] .. pin)
            end
        end

        local withdrawItem = NativeUI.CreateItem(Translation[Language]['withdrawMoney'], '')
        bankMenu:AddItem(withdrawItem)

        withdrawItem.Activated = function ()
            amount = CreateDialog(Translation[Language]['howMuch'])

            TriggerServerEvent('KBAtm:withdraw', tonumber(amount))
        end

        local depositItem = NativeUI.CreateItem(Translation[Language]['depositMoney'], '')
        bankMenu:AddItem(depositItem)

        depositItem.Activated = function ()
            amount = CreateDialog(Translation[Language]['howMuch'])

            TriggerServerEvent('KBAtm:deposit', tonumber(amount))
        end

        bankMenu:Visible(true)
        _menuPool:MouseEdgeEnabled(false)

    end)

end

function openNativeATM()
 
    ESX.TriggerServerCallback('KBAtm:getPin', function (playerpin)

        local ATMMenu = NativeUI.CreateMenu(Translation[Language]['atm'])
        _menuPool:Add(ATMMenu)
    
        local PinItem = NativeUI.CreateItem('Pin: ' .. playerpin, Translation[Language]['currentPIN'] .. playerpin)
        ATMMenu:AddItem(PinItem)
    
        local withdrawItem = NativeUI.CreateItem(Translation[Language]['withdrawMoney'], '')
        ATMMenu:AddItem(withdrawItem)
    
        withdrawItem.Activated = function ()
            amount = CreateDialog(Translation[Language]['howMuch'])
    
            TriggerServerEvent('KBAtm:withdraw', tonumber(amount))
        end
    
        local depositItem = NativeUI.CreateItem(Translation[Language]['depositMoney'], '')
        ATMMenu:AddItem(depositItem)
    
        depositItem.Activated = function ()
            amount = CreateDialog(Translation[Language]['howMuch'])
    
            TriggerServerEvent('KBAtm:deposit', tonumber(amount))
        end
    
        ATMMenu:Visible(true)
        _menuPool:MouseEdgeEnabled(false)
    
        end)

end

RegisterNetEvent('KBBanking:NotifyNewPin')
AddEventHandler('KBBanking:NotifyNewPin', function (pin)
    if Config.Notify == 'ESX' then
        exports["esx_notify"]:Notify("info", 3000, Translation[Language]['yourNewPin'] .. pin)
    elseif Config.Notify == 'OKOK' then
        exports['okokNotify']:Alert("Banking", Translation[Language]['yourNewPin'] .. pin , 5000, 'info')
    elseif Config.Notify == 'GTA' then
        ShowNotification(Translation[Language]['yourNewPin'] .. pin)
    end
end)

RegisterNetEvent('KBBanking:NotifyWithdrawn')
AddEventHandler('KBBanking:NotifyWithdrawn', function (amount)
    if Config.Notify == 'ESX' then
        exports["esx_notify"]:Notify("info", 3000, Translation[Language]['youHaveWithdrawn'] .. amount)
    elseif Config.Notify == 'OKOK' then
        exports['okokNotify']:Alert("Banking", Translation[Language]['youHaveWithdrawn'] .. amount , 5000, 'info')
    elseif Config.Notify == 'GTA' then
        ShowNotification(Translation[Language]['youHaveWithdrawn'] .. amount)
    end
end)

RegisterNetEvent('KBBanking:NotifyDeposited')
AddEventHandler('KBBanking:NotifyDeposited', function (amount)
    if Config.Notify == 'ESX' then
        exports["esx_notify"]:Notify("info", 3000, Translation[Language]['youHaveDeposited'] .. amount)
    elseif Config.Notify == 'OKOK' then
        exports['okokNotify']:Alert("Banking", Translation[Language]['youHaveDeposited'] .. amount , 5000, 'info')
    elseif Config.Notify == 'GTA' then
        ShowNotification(Translation[Language]['youHaveDeposited'] .. amount)
    end
end)

RegisterNetEvent('KBBanking:NotifyNotEnoughMoney')
AddEventHandler('KBBanking:NotifyNotEnoughMoney', function ()
    if Config.Notify == 'ESX' then
        exports["esx_notify"]:Notify("info", 3000, Translation[Language]['notEnoughMoney'])
    elseif Config.Notify == 'OKOK' then
        exports['okokNotify']:Alert("Banking", Translation[Language]['notEnoughMoney'] , 5000, 'info')
    elseif Config.Notify == 'GTA' then
        ShowNotification(Translation[Language]['notEnoughMoney'])
    end
end)

if Config.Command == true then
    RegisterCommand('pin', function (input, args, rawCommand)

        ESX.TriggerServerCallback('KBAtm:getPin', function (playerpin)
            if Config.Notify == 'ESX' then
                exports["esx_notify"]:Notify("info", 3000, Translation[Language]['currentPIN'] .. playerpin)
            elseif Config.Notify == 'OKOK' then
                exports['okokNotify']:Alert("Banking", Translation[Language]['currentPIN'] .. playerpin , 5000, 'info')
            elseif Config.Notify == 'GTA' then
                ShowNotification(Translation[Language]['currentPIN'] .. playerpin)
            end
        end)
        
    end)
end





function CreateDialog(OnScreenDisplayTitle_shopmenu) --general OnScreenDisplay for KeyboardInput
	AddTextEntry(OnScreenDisplayTitle_shopmenu, OnScreenDisplayTitle_shopmenu)
	DisplayOnscreenKeyboard(1, OnScreenDisplayTitle_shopmenu, "", "", "", "", "", 32)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local displayResult = GetOnscreenKeyboardResult()
		return displayResult
	end
end

function showInfobar(msg)

    CurrentActionMsg  = msg
    SetTextComponentFormat('STRING')
    AddTextComponentString(CurrentActionMsg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end

function ShowNotification(text)

    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)

end
