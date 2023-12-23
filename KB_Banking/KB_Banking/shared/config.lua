Config = {}

Config.Language = 'de' -- You can choose between 'en' and 'de'.

Config.Menu = 'ox_lib'  -- ox_lib or NativeUI

Config.Notify = 'ESX' -- You can use ESX Notify(ESX), GTA Notify(GTA) and OKOK Notify(OKOK)

Config.Command = true  -- Here you have the option to enable or disable a command that shows you your current PIN.

Config.Coords = {
    {149.96, -1040.75, 29.37},
    {-1212.63, -330.78, 37.59},
    {-2962.47, 482.93, 15.5},
    {-113.01, 6470.24, 31.43},
    {314.16, -279.09, 53.97},
    {-350.99, -49.99, 48.84},
    {1175.02, 2706.87, 37.89},
    {246.63, 223.62, 106.0}
}

Config.Props = {
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm'
}

-- WeebHook --

Config.Webhook = ""

Config.DateFormat = '%x %H:%M' -- Here you can find the various options for formatting time: https://www.lua.org/pil/22.1.html

Config.Name = 'Banking'

Config.Color = 16711680 -- You can find the required number under "Decimal value" on this website: https://www.spycolor.com

-- Translations --

Config.Translation = {

    ['de'] = {
        ['infoBarBank'] = 'Drücke ~g~E~s~, um auf die Bank zuzugreifen',
        ['infoBarATM'] = 'Drücke ~g~E~s~, um auf den Geldautomaten zuzugreifen',
        ['yourPin'] = 'Deine Pin:',
        ['wrongPin'] = 'Falsche Pin',
        ['atm'] = 'Geldautomat',
        ['bank'] = 'Bank',
        ['howMuch'] = 'wie viel?',
        ['enterNewPIN'] = 'Neue Pin eingebne',
        ['enterPin'] = 'Pin eingeben',
        ['withdrawMoney'] = 'Geld auszahlen',
        ['depositMoney'] = 'Geld einzahlen',
        ['changePin'] = 'Pin ändern',
        ['currentPIN'] = 'Deine Aktuelle Pin ist: ',
        ['newPin'] = 'Neue Pin: ',
        ['yourNewPin'] = 'Deine Neue Pin ist ',
        ['youHaveWithdrawn'] = 'Du hast abgehoben: ',
        ['youHaveDeposited'] = 'Du hast eingezahlt: ',
        ['notEnoughMoney'] = 'Du hast nicht genug Geld',
        ['bankingWithdraw'] = 'Banking Ausgezahlt',
        ['Withdrawd'] = '**Ausgezahlt:** ',
        ['bankingdeposited'] = 'Banking Eingezahlt',
        ['deposited'] = '**Eingezahlt:** ',
    },

    ['en'] = {
        ['infoBarBank'] = 'Press ~g~E~s~, to access the bank.',
        ['infoBarATM'] = 'Press ~g~E~s~, to access the ATM.',
        ['yourPin'] = 'Your PIN:',
        ['wrongPin'] = 'Wrong PIN',
        ['atm'] = 'ATM',
        ['bank'] = 'Bank',
        ['howMuch'] = 'How much?',
        ['enterNewPIN'] = 'Enter new PIN',
        ['enterPin'] = 'Enter PIN',
        ['withdrawMoney'] = 'Withdraw money',
        ['depositMoney'] = 'Deposit money',
        ['changePin'] = 'Change PIN',
        ['currentPIN'] = 'Your current PIN is: ',
        ['newPin'] = 'New PIN: ',
        ['yourNewPin'] = 'Your new PIN is ',
        ['youHaveWithdrawn'] = 'You have withdrawn: ',
        ['youHaveDeposited'] = 'You have deposited: ',
        ['notEnoughMoney'] = 'You dont have enough money',
        ['bankingWithdraw'] = 'Banking Withdrawd',
        ['Withdrawd'] = '**Withdrawd:** ',
        ['bankingdeposited'] = 'Banking deposited',
        ['deposited'] = '**deposited:** '
    }
}
