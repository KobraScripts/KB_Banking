print("----------------------------------------------------------")
print(" ")
print("        KK    KK     BBBBBB")
print("        KK  KK       BB    BB")
print("        KKKK         BBBBBB")
print("        KK  KK       BB    BB")
print("        KK    KK     BBBBBB")
print(" ")
print("               Banking")
print("----------------------------------------------------------")



ESX = exports["es_extended"]:getSharedObject()

local Translation = Config.Translation
local Language = Config.Language

ESX.RegisterServerCallback('KBAtm:getPin', function (source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT pin FROM kb_banking_pincodes WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
    }, function (result)
        if result ~= nil and result[1] ~= nil then
            cb(result[1].pin)
        else
            local pin = 1234
            MySQL.Async.execute('INSERT INTO kb_banking_pincodes (identifier, pin) VALUES (@identifier, @pin)', {
                ['@identifier'] = xPlayer.identifier,
                ['@pin'] = pin
            }, function ()
                cb(pin)
                xPlayer.showNotification(Translation[Language]['yourNewPin'] .. pin)
            end)
        end

    end
)

end)

RegisterServerEvent('KBBanking:changePin')
AddEventHandler('KBBanking:changePin', function (newpin)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE kb_banking_pincodes SET pin = @pin WHERE identifier = @identifier', {
        ['@pin'] = newpin,
        ['@identifier'] = xPlayer.identifier
    })

    changePinLogs(newpin)

end)

RegisterServerEvent('KBAtm:withdraw')
AddEventHandler('KBAtm:withdraw', function (amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount('bank').money >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addAccountMoney('money', amount)
        xPlayer.showNotification(Translation[Language]['youHaveWithdrawn'] .. amount)
        withdrawLogs(amount)
    else
        xPlayer.showNotification(Translation[Language]['notEnoughMoney'])
    end

end)

RegisterServerEvent('KBAtm:deposit')
AddEventHandler('KBAtm:deposit', function (amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= amount then
        xPlayer.removeMoney(amount)
        xPlayer.addAccountMoney('bank', amount)
        xPlayer.showNotification(Translation[Language]['youHaveDeposited'] .. amount)
        depositLogs(amount)
    else
        xPlayer.showNotification(Translation[Language]['notEnoughMoney'])
    end
    
end)

function changePinLogs(newpin)

    local identifiers = GetPlayerIdentifiers(source)

    local discordID, fivemIdentifier
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, "discord:") then
            discordID = string.sub(identifier, 9)
        elseif string.find(identifier, "license:") then
            fivemIdentifier = string.sub(identifier, 9)
        end
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local playerid = xPlayer.source
    local name = xPlayer.getName(xPlayer)
    local money = xPlayer.getAccount('money').money
    local blackMoney = xPlayer.getAccount('black_money').money
    local bank = xPlayer.getAccount('bank').money

    local url = Config.Webhook

    local embeds = {
        {
            ["title"] = "Banking PIN Changed",
            ["type"] = "rich",
            ["color"] = Config.Color,
            ["description"] = '**New Pin:** '..newpin..'\n'..'\n'..'\n**User:** '..name..'\n**ID:** '..playerid..'\n**Money:** '..money..'\n**Bank:** '..bank..'\n**Black Money:** '..blackMoney..'\n**identifier:** '..'||**'..fivemIdentifier..'**||**'..'\n**Discord ID: '..'||'..discordID..'||',
            ["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
        }
    }
    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = Config.Name, embeds = embeds}), { ['Content-Type'] = 'application/json'})
end

function withdrawLogs(amount)

    local identifiers = GetPlayerIdentifiers(source)

    local discordID, fivemIdentifier
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, "discord:") then
            discordID = string.sub(identifier, 9)
        elseif string.find(identifier, "license:") then
            fivemIdentifier = string.sub(identifier, 9)
        end
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local playerid = xPlayer.source
    local name = xPlayer.getName(xPlayer)
    local money = xPlayer.getAccount('money').money
    local blackMoney = xPlayer.getAccount('black_money').money
    local bank = xPlayer.getAccount('bank').money

    local url = Config.Webhook

    local embeds = {
        {
            ["title"] = Translation[Language]['bankingWithdraw'],
            ["type"] = "rich",
            ["color"] = Config.Color,
            ["description"] = Translation[Language]['Withdrawd']..amount..'\n'..'\n'..'\n**User:** '..name..'\n**ID:** '..playerid..'\n**Money:** '..money..'\n**Bank:** '..bank..'\n**Black Money:** '..blackMoney..'\n**identifier:** '..'||**'..fivemIdentifier..'**||**'..'\n**Discord ID: '..'||'..discordID..'||',
            ["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
        }
    }
    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = Config.Name, embeds = embeds}), { ['Content-Type'] = 'application/json'})
end

function depositLogs(amount)

    local identifiers = GetPlayerIdentifiers(source)

    local discordID, fivemIdentifier
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, "discord:") then
            discordID = string.sub(identifier, 9)
        elseif string.find(identifier, "license:") then
            fivemIdentifier = string.sub(identifier, 9)
        end
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local playerid = xPlayer.source
    local name = xPlayer.getName(xPlayer)
    local money = xPlayer.getAccount('money').money
    local blackMoney = xPlayer.getAccount('black_money').money
    local bank = xPlayer.getAccount('bank').money

    local url = Config.Webhook

    local embeds = {
        {
            ["title"] = Translation[Language]['bankingdeposited'],
            ["type"] = "rich",
            ["color"] = Config.Color,
            ["description"] = Translation[Language]['deposited']..amount..'\n'..'\n'..'\n**User:** '..name..'\n**ID:** '..playerid..'\n**Money:** '..money..'\n**Bank:** '..bank..'\n**Black Money:** '..blackMoney..'\n**identifier:** '..'||**'..fivemIdentifier..'**||**'..'\n**Discord ID: '..'||'..discordID..'||',
            ["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
        }
    }
    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = Config.Name, embeds = embeds}), { ['Content-Type'] = 'application/json'})
end