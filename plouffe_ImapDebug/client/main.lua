local stop = false
local sleepThread = false
local currentImap = 'kek'
local lastImap = 'kek'
local oldImap = 'kek'
local load = false
local unload = false
local saved = {}

RegisterCommand("ImapLoadAll", function(source, args, raw)
    load = true
    Unload = false
end)

RegisterCommand("ImapRemoveAll", function(source, args, raw)
    load = false
    Unload = true
end)

RegisterCommand("ImapRequest", function(source, args, raw)
    RequestImap(args[1])
end)

RegisterCommand("ImapRemove", function(source, args, raw)
    RemoveImap(args[1])
end)

RegisterCommand("ImapStop", function(source, args, raw)
    stop = not stop
end)

RegisterCommand("ImapSave", function(source, args, raw)
    table.insert(saved, tostring(currentImap))
    if args[1] ~= nil then
        table.insert(saved, args[1])
        chatPrint('Saved: '..currentImap.. ' For: ' ..args[1])
    else
        chatPrint('Saved: '..currentImap)
    end
end)

RegisterCommand("ImapWait", function(source, args, raw)
    sleepThread = not sleepThread
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        DrawText2d('Current Imap: '..currentImap, 0.01,0.60,0.5)
        DrawText2d('Last Imap: '..lastImap, 0.01,0.65,0.5)
        DrawText2d('Old Imap: '..oldImap, 0.01,0.70,0.5)
        if sleepThread then 
            DrawText2d('Imap loading is currently waiting.', 0.01,0.4,0.5)
        end
        if load then 
            DrawText2d('Currently loading Imaps', 0.01,0.2,0.5)
        end
        if stop then
            DrawText2d('Hard stop on imap loader.', 0.01,0.1,0.5)
        end

        if Config.UseControl then
            if IsControlJustReleased(0,0x05CA7C52) then --Down Arrow
                sleepThread = not sleepThread
            end

            if IsControlJustReleased(0,0x6319DB71) then --Up Arrow
                table.insert(saved, tostring(currentImap))
            end

        end

    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for i=1, #saved, 1 do
            DrawText2d(saved[1], 0.9,0.02,0.5)
            DrawText2d(saved[2], 0.9,0.06,0.5)
            DrawText2d(saved[3], 0.9,0.10,0.5)
            DrawText2d(saved[4], 0.9,0.14,0.5)
            DrawText2d(saved[5], 0.9,0.18,0.5)
            DrawText2d(saved[6], 0.9,0.22,0.5)
            DrawText2d(saved[7], 0.9,0.26,0.5)
            DrawText2d(saved[8], 0.9,0.30,0.5)
            DrawText2d(saved[9], 0.9,0.34,0.5)
            DrawText2d(saved[10], 0.9,0.38,0.5)
            DrawText2d(saved[11], 0.9,0.42,0.5)
            DrawText2d(saved[12], 0.9,0.46,0.5)
            DrawText2d(saved[13], 0.9,0.50,0.5)
            DrawText2d(saved[14], 0.9,0.54,0.5)
            DrawText2d(saved[15], 0.9,0.58,0.5)
            DrawText2d(saved[16], 0.9,0.62,0.5)
            DrawText2d(saved[17], 0.9,0.66,0.5)
            DrawText2d(saved[18], 0.9,0.70,0.5)
            DrawText2d(saved[19], 0.9,0.74,0.5)
            DrawText2d(saved[20], 0.9,0.78,0.5)
            DrawText2d(saved[21], 0.9,0.82,0.5)
        end 
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if load then
            for i=1, #ipls, 1 do
                chatPrint(i) 
                chatPrint(ipls[i])
                Citizen.InvokeNative(0x59767C5A7A9AE6DA,ipls[i])
                oldImap = lastImap
                lastImap = currentImap
                currentImap = ipls[i]
                Wait(Config.LoadDelay)
                while sleepThread do 
                    Wait(2000)
                end
                if stop then break end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if Unload then
            for i=1, #ipls, 1 do 
                chatPrint(ipls[i])
                Citizen.InvokeNative(0x5A3E5CF7B4014B96,ipls[i])
                Wait(10)
                if stop then break end
            end
            Unload = not Unload
        end
    end
end)

function DrawText2d(text,x,y,scale)
    local str = CreateVarString(10,"LITERAL_STRING",text)
    SetTextScale(scale,scale)
    SetTextColor(255,255,255,255)
    SetTextDropshadow(0.1,20,20,20,255)
    DisplayText(str,x,y)
end

function chatPrint( msg )
	TriggerEvent( 'chatMessage', "Imap", { 255, 255, 255 }, msg )
end 
