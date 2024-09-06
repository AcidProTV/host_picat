local sampev = require("lib.samp.events")
local http = require("socket.http")
local vkeys = require("vkeys")
local imgui = require("imgui")
local encoding = require("encoding")
local socket = require("socket")
local json = require("cjson")
local https = require("ssl.https")
require("lib.moonloader")

-- SERVER JS

local keyBinds = {}

local keyBindActive = false
local keyBindParam = nil

local client = assert(socket.tcp())
client:connect('localhost', 5000)
client:settimeout(0)

function receive()
    local ok, response, err = pcall(function() return client:receive() end)
    if ok then
        if response then            
            local ok_json, json_response = pcall(json.decode, response)
            if ok_json then
                if json_response.type and json_response.type == "connect" then
                    if json_response.access then
                        sendInfo(json_response.message, dataAdmin.main_hex_color)
                        keyBinds = json_response.keybinds
                        return 1
                    elseif json_response.access == false then
                        sendInfo(json_response.message)
                        error("Access denied: Module has been disabled.")
                        return 2
                    end
                end
            else
                sendInfo(response, dataAdmin.main_hex_color)
                return 3
            end
        end
    else
        sampAddChatMessage("{ff0000}[!] {ffffff}Nu am putut primi mesajul [contacteaza-l pe acid]: " .. (err or ""), -1)
        return 0
    end
end

-- SERVER JS

-- regulamente

local serverRules = [[
aici va fi regulamentul serverlui
]]
-- regulamente

-- DIALOG

local show_admin_cmd_menu = imgui.ImBool(false)

local screen_x, screen_y = getScreenResolution()
encoding.default = "CP1251"
u8 = encoding.UTF8

local font_changed = false
local cyrillic_glyph_ranges = nil
local fontSize = {1.0}

function imgui.BeforeDrawFrame()
  if not font_changed then
    font_changed = true
    cyrillic_glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    imgui.GetIO().Fonts:Clear()
    imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(20) .. "\\arial.ttf", 14, nil, cyrillic_glyph_ranges)
  end
end


-- DIALOG

local dataAdmin = {
    adminCMD = true,
    adminCMDVersion = "1.0.0",
    moderator = false,

    dataid = false,
    datapm = false,

    spec_name1 = -1,
    spec_id1 = -1,

    spec_name2 = -1,
    spec_id2 = -1,

    spec_name3 = -1,
    spec_id3 = -1,

    toganno = false,
    togcc = false,
    togetp = false,

    showColorPicker = false,
    showColorPicker2 = false,

    main_color = imgui.ImVec4(0.517, 0.354, 0.875, 1), -- #845ADF in RGBA format
    main_hex_color = "{845ADF}",
    bg_color = imgui.ImColor(30, 30, 30, 210):GetVec4()
}


local dataPlayer = {
    lastSpecID = -1,
}

local ServerName = ""
local adminName2 = ""



function main()
    repeat wait(0) until isSampAvailable()
    sendInfo("AdminCMD for B-HOOD Community has loaded succesfully!", dataAdmin.main_hex_color)
    sendInfo("Versiune noua descarcata!", dataAdmin.main_hex_color)

  
    connectToJsServer() -- conectare la Server JS

    -- comenzi reports
    sampRegisterChatCommand("nodm", cmdNodm)
    sampRegisterChatCommand("nui", cmdNui)
    sampRegisterChatCommand("norp", cmdNorp)
    sampRegisterChatCommand("noguns", cmdNoguns)
    sampRegisterChatCommand("nocheats", cmdNocheats)
    sampRegisterChatCommand("nocbug", cmdNocbug)
    sampRegisterChatCommand("nodesync", cmdNodesync)
    sampRegisterChatCommand("fps", cmdFps)
    sampRegisterChatCommand("doneaff", cmdDoneaff)
    sampRegisterChatCommand("noaff", cmdNoaff)
    sampRegisterChatCommand("arz", cmdArz)
    sampRegisterChatCommand("noc", cmdNoc)
    sampRegisterChatCommand("nok", cmdNok)
    sampRegisterChatCommand("noh", cmdNoh)
    sampRegisterChatCommand("noa", cmdNoa)
    sampRegisterChatCommand("notp", cmdNotp)
    sampRegisterChatCommand("rrp", cmdRrp)
    sampRegisterChatCommand("dd", cmdDd)
    sampRegisterChatCommand("ddpd", cmdDdpd)
    sampRegisterChatCommand("afk", cmdAfk)
    sampRegisterChatCommand("nurasp", cmdNurasp)
    sampRegisterChatCommand("a2", cmdA2)
    sampRegisterChatCommand("qc", cmdQc)
    sampRegisterChatCommand("ev", cmdEv)
    sampRegisterChatCommand("jail", cmdJail)
    sampRegisterChatCommand("helpstaff", cmdHelpstaff)
    sampRegisterChatCommand("etp", cmdTpevent)
    sampRegisterChatCommand("rep", cmdReports)
    sampRegisterChatCommand("cits", cmdCheaters)
    sampRegisterChatCommand("fl", cmdFlip)
    sampRegisterChatCommand("mr", cmdMyRaport)
    sampRegisterChatCommand("aiurea", cmdCrAiurea)
    sampRegisterChatCommand("ver", cmdCrVerific)
    sampRegisterChatCommand("acm", cmdCrAcum)
    sampRegisterChatCommand("imd", cmdCrImd)
    sampRegisterChatCommand("rz", cmdCrRezolv)
    sampRegisterChatCommand("rn", cmdRNewbie)
    sampRegisterChatCommand("pronunta", cmdPronunta)
    sampRegisterChatCommand("raiurea", cmdRMUTEAiurea)
    sampRegisterChatCommand("mori", cmdMori)
    sampRegisterChatCommand("fc", cmdFlipcar)
    sampRegisterChatCommand("sc", cmdSlapcar)
    sampRegisterChatCommand("gc", cmdGetcar)
    sampRegisterChatCommand("vulgar", cmdVulgar)
    sampRegisterChatCommand("eu", cmdEuSpec)
    sampRegisterChatCommand("sal", cmdSalut)
    sampRegisterChatCommand("?", cmdSalut2)
    sampRegisterChatCommand("adesync", cmdADesync)
    sampRegisterChatCommand("route", cmdTestRoute)

    sampRegisterChatCommand("idon", cmdSpamIDon)
    sampRegisterChatCommand("idoff", cmdSpamIDoff)
    sampRegisterChatCommand("pmon", cmdSpamPMon)
    sampRegisterChatCommand("pmoff", cmdSpamPMoff)


    -- vehicule
    sampRegisterChatCommand("inf", cmdInfernus)
    sampRegisterChatCommand("mtb", cmdMTB)
    sampRegisterChatCommand("nrg", cmdNRG)
    sampRegisterChatCommand("mave", cmdMaverick)
    sampRegisterChatCommand("tank", cmdTank)
    sampRegisterChatCommand("faggio", cmdFaggio)

    sampRegisterChatCommand("rinf", cmdRInfernus)
    sampRegisterChatCommand("rmtb", cmdRMTB)
    sampRegisterChatCommand("rnrg", cmdRNRG)
    sampRegisterChatCommand("rmave", cmdRMaverick)
    sampRegisterChatCommand("rtank", cmdRTank)
    sampRegisterChatCommand("rfaggio", cmdRFaggio)
    
    -- events
    sampRegisterChatCommand("reparae", cmdRepairEvent)
    sampRegisterChatCommand("repara", cmdRepair)
    sampRegisterChatCommand("viatae", cmdHealEvent)
    sampRegisterChatCommand("viata", cmdHeal)
    sampRegisterChatCommand("dis", cmdDisarm)
    sampRegisterChatCommand("dise", cmdDisarmEvent)
    sampRegisterChatCommand("kille", cmdKillEvent)
    sampRegisterChatCommand("cal112anno", cmdCall112o)
    sampRegisterChatCommand("cal112", cmdCall112)
    sampRegisterChatCommand("aeventcladire", cmdCladireEvent)
    sampRegisterChatCommand("aeventtank", cmdTankEvent)
    sampRegisterChatCommand("aeventlinie", cmdLinieEvent)
    sampRegisterChatCommand("aeventtel", cmdTelEvent)
    sampRegisterChatCommand("eventsms", cmdEventSMS)
    sampRegisterChatCommand("eventmtb", cmdEventMTB)
    sampRegisterChatCommand("eventlcs", cmdEventLCS)
    sampRegisterChatCommand("eventlms", cmdEventLMS)
    sampRegisterChatCommand("eventstunt", cmdEventSTUNT)
    sampRegisterChatCommand("eventhns", cmdEventHNS)
    sampRegisterChatCommand("event1v1", cmdEvent1v1)
    sampRegisterChatCommand("eventvip", cmdEventVIP)


    sampRegisterChatCommand("winner", cmdWinner)
    sampRegisterChatCommand("etp", cmdETP)

    -- alte comenzi
    sampRegisterChatCommand("hp", cmdHpme)
    sampRegisterChatCommand("vw0", cmdVw0me)
    sampRegisterChatCommand("spawnme", cmdSpawnme)
    sampRegisterChatCommand("disarmme", cmdDisarmme)
    sampRegisterChatCommand("gotopaint", cmdGotopaint)
    sampRegisterChatCommand("specc", cmdSpec2)
    sampRegisterChatCommand("resetid", cmdResetSpecID)




    -- ez comenzi
    sampRegisterChatCommand("get", cmdGet)
    sampRegisterChatCommand("got", cmdGot)
    sampRegisterChatCommand("sl", cmdSlap)
    sampRegisterChatCommand("fr", cmdFreeze)
    sampRegisterChatCommand("unfr", cmdUnfreeze)
    sampRegisterChatCommand("sh", cmdSpawnhere)
    sampRegisterChatCommand("md", cmdMDC)
    sampRegisterChatCommand("mor", cmdMor)
    sampRegisterChatCommand("lcc", cmdLcc)
    sampRegisterChatCommand("lpp", cmdLpp)
    sampRegisterChatCommand("check", cmdCheck)
    
    -- save spec list
    sampRegisterChatCommand("speclist", cmdSpecList)
    sampRegisterChatCommand("resetspeclist", cmdResetSpecList)

    sampRegisterChatCommand("sspec", cmdSaveSpec)
    sampRegisterChatCommand("spec1", cmdSpecList1)
    sampRegisterChatCommand("spec2", cmdSpecList2)
    sampRegisterChatCommand("spec3", cmdSpecList3)

    -- admin systems
    sampRegisterChatCommand("o", cmdBlockAnno)
    sampRegisterChatCommand("cc", cmdBlockClearChat)
    sampRegisterChatCommand("cchat", cmdClearChat)
    sampRegisterChatCommand("servers", cmdServers)
    sampRegisterChatCommand("loginplayers", cmdLoginPlayers)
    sampRegisterChatCommand("lvl", cmdLevelCheck)


    -- SERVER COMMANDS
    sampRegisterChatCommand("svadmins", svAdmins)
    sampRegisterChatCommand("keybinds", keyBindsCmd)
    -- sampRegisterChatCommand("setbind", registerBind)


    if ServerName == "RPG B-HOOD" then
        sampRegisterChatCommand("gcc", cmdGetcar2)
    end

    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    adminName2 = sampGetPlayerNickname(id)

    -- AUTO UPDATE
    local version_url = "https://raw.githubusercontent.com/AcidProTV/host_picat/main/Version"

    local function check_version()
        local local_version = dataAdmin.adminCMDVersion

        local body, code = https.request(version_url)
    
    if code == 200 then
        -- sendInfo("Versiunea de pe server a fost descărcată cu succes.", dataAdmin.main_hex_color)
        
        local server_version = body:gsub("%s+", "")
        
        if server_version then
            -- sendInfo("server version: " .. server_version, dataAdmin.main_hex_color)
            -- sendInfo("local version: " .. local_version, dataAdmin.main_hex_color)

            if server_version > local_version then
                sendInfo("New update for AdminCMD is available! New version: " .. server_version, dataAdmin.main_hex_color)
                return true, server_version
            else
                sendInfo("AdminCMD version is up to date!", dataAdmin.main_hex_color)
                return false
            end
        else
            sendInfo("AdminCMD version could not be verified!", dataAdmin.main_hex_color)
            return false
        end
    else
        sendInfo("Eroare la verificarea versiunii de AdminCMD. Cod răspuns: " .. code, dataAdmin.main_hex_color)
        return false
    end
end
    
    -- URL-ul de unde descărcăm modul nou
    local mod_url = "http://example.com/mod/new_mod.zip"

    local function download_mod(url, save_to)
        local response_body = {}

        local result, response_code = http.request{
            url = url,
            sink = ltn12.sink.table(response_body)
        }

        if response_code == 200 then
            -- Scriem fișierul descărcat
            local file = io.open(save_to, "wb")
            file:write(table.concat(response_body))
            file:close()
            sendInfo("Modul a fost descarcat cu succes.", dataAdmin.main_hex_color)
        else
            sendInfo("Eroare la descărcare. Cod raspuns: " .. response_code, dataAdmin.main_hex_color)
        end
    end

-- Verificăm dacă este nevoie de update și dacă este disponibil, descărcăm noua versiune
local needs_update, new_version = check_version()

if needs_update then
    download_mod(mod_url, "new_mod.zip")
end




    while true do
        wait(0)
        receive()

        if testCheat("q1") then
            show_admin_cmd_menu.v = not show_admin_cmd_menu.v
        end
        
        imgui.Process = show_admin_cmd_menu.v

        if not sampIsChatInputActive() then
            checkKeyPresses()
            
        end
        checkdataAdmin()
        checkDialogs()
    end
end

function connectToJsServer()
    data = getDataConnectToServer()
    client:send(json.encode(data))
end


function getDataConnectToServer()
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local playerData = {
        connect = true,
        adminName = sampGetPlayerNickname(id),
        serverName = getPlayingServer(),
        inGameVerify = false,
    }

    return playerData
end

-- citeste toate dialogurile si verifica cand apare dialog ul in care scrie 'Login' la titlu
function checkDialogs()
    local dialog = sampIsDialogActive()
    if dialog then
        local text = sampGetDialogText()

        local name = text:match("Welcome back, ([%w%[%]_%.%@]+)")
        if name then
            sendInfo("Welcome back, " .. name, dataAdmin.main_hex_color)
            -- verifyAdminStatus()
            -- de adaugat verificare + delay ca trebuie sa apara doar cand e parola corecta
        end

    end
end

function verifyAdminStatus()
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    datajson = {
        connect = true,
        adminName = sampGetPlayerNickname(id),
        serverName = getPlayingServer(),
        inGameVerify = true,
    }

    client:send(json.encode(datajson))
end

function checkdataAdmin()
    if dataAdmin.dataid == true or dataAdmin.datapm == true then
        if dataPlayer.lastSpecID == -1 then
            sendError("Spammer-ul a fost dezactivat deoarece ID-ul salvat in [/spec] a fost resetat!")
            dataAdmin.dataid = false
            dataAdmin.datapm = false
            wait(400)
            return
        end
    end

    -- idon
    if dataAdmin.dataid == true then
        sampSendChat("/id " .. dataPlayer.lastSpecID)
        wait(700)
    end

    -- pmon
    if dataAdmin.datapm == true then
        sampSendChat("/pm " .. dataPlayer.lastSpecID .. " Salut, esti la PC? Raspunde in chat sau risti sa fi banat pentru autoclicker!")
        wait(700)
    end
end

function checkKeyPresses()

    if isKeyDown(keyBinds.spec) or isKeyDown(keyBinds.get) or isKeyDown(keyBinds.goto_) or isKeyDown(keyBinds.mdc) or isKeyDown(keyBinds.resetlastspec) then
        if dataPlayer.lastSpecID == -1 then
            sendError("Nu ai dat [/spec]!")
            wait(400)
            return
        end
    end

    -- easy /spec
    if isKeyDown(keyBinds.spec) then
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sendInfo("Te-ai pus [/spec] din nou pe ultimul player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
        sampSendChat("/spec " .. dataPlayer.lastSpecID)
        wait(400)
    end

    -- easy /aaa2
    if isKeyDown(keyBinds.aaa2) then
        sampSendChat("/aaa2")
        sendInfo("Te-ai dus in [/aaa2]!", dataAdmin.main_hex_color)
        wait(400)
    end

    -- easy /goto
    if isKeyDown(keyBinds.goto_) then
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sampSendChat("/goto " .. dataPlayer.lastSpecID)
        sendInfo("Te-ai teleportat (/goto) la jucatorul la care ai dat ultima data {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
        wait(400)
    end

    -- easy /specoff
    if isKeyDown(keyBinds.specoff) then
        sampSendChat("/specoff")
        wait(400)
    end

    -- easy /up
    if isKeyDown(keyBinds.up) then
        sampSendChat("/up")
        sendInfo("Ai dat [/up]!", dataAdmin.main_hex_color)
        wait(400)
    end

    -- easy /get
    if isKeyDown(keyBinds.get) then
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sampSendChat("/get " .. dataPlayer.lastSpecID)
        sendInfo("Ai tras la tine (/gethere) ultimul player pe care ai fost {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
        wait(400)
    end

    -- easy /mdc
    if isKeyDown(keyBinds.mdc) then
        cmdMDC()
        wait(400)
    end
    
    -- easy /sal
    if isKeyDown(keyBinds.sal) then
        cmdSalut()
        wait(400)
    end

    -- easy /arz
    if isKeyDown(keyBinds.arez) then
        cmdArz()
        wait(400)
    end

    -- easy reset lastspecid
    if
    isKeyDown(keyBinds.resetlastspec) then
        sendInfo("Ultimul ID salvat din [/spec] resetat cu {40ff00}succes{ffffff}!", dataAdmin.main_hex_color)
        wait(400)
        dataPlayer.lastSpecID = -1
    end

    -- easy /reports (CTRL R)
    if isKeyDown(17) and isKeyDown(82) then
        sampSendChat("/reports")
        wait(400)
    end

    -- easy /cheaters (CTRL C)
    if isKeyDown(17) and isKeyDown(67) then
        sampSendChat("/cheaters")
        wait(400)
    end

    -- easy /eu (E + U)
    if isKeyDown(69) and isKeyDown(85) then
        cmdEuSpec()
        wait(400)
    end
    
end

-- functii-utile
function TPEventAuto()
    lua_thread.create(function()
        if dataAdmin.togetp == false then
            return
        else
            wait(500)
            cmdETP()
        end
    end)
end

function getArgs(text)
    local args = {}
    for arg in text:gmatch("(%S+)") do
        table.insert(args, arg)
    end
    return args
end

function checkNumberArgs(args, number)
    return #args < number
end

function isInteger(num)
    return num % 1 == 0
end

function isPlayerIdValid(playerId)
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if playerId ~= id then
        if playerId and isInteger(playerId) then
            if sampIsPlayerConnected(playerId) then
                return true
            else
                sendError("Player-ul nu e conectat!")
                return false
            end
        else
            sendError("ID-ul jucatorului nu este valid!")
            return false
        end
    else
        sendError("Aceasta comanda nu functioneaza pe tine!")
        return false
    end
    return false
end

-- -- end functii-utile

function getServerName(serverIP)
    serverIP = tostring(serverIP)
    if serverIP == "104.152.142.24" then
        return "OG B-HOOD"
    elseif serverIP == "104.152.142.7" then
        return "RPG B-HOOD"
    else
        return "Undefined server"
    end
end

function getPlayingServer()
    ServerIP, ServerPort = sampGetCurrentServerAddress()
    ServerName = getServerName(ServerIP)
    return ServerName
end

function sendUsage(message, main_hex_color)
    local formattedMessage = main_hex_color .. "USAGE: {FFFFFF}" .. message
    sampAddChatMessage(formattedMessage, -1)
end

function sendError(message)
    sampAddChatMessage("{FF0000}AdminCMD: {FFFFFF}" .. message, -1)
end

function sendInfo(message, main_hex_color)
    local formattedMessage = main_hex_color .. "AdminCMD: {FFFFFF}" .. message
    sampAddChatMessage(formattedMessage, -1)
end

function specOff()
    sampSendChat("/specoff")
    dataPlayer.lastSpecID = -1
end

-- comenzi reps

function cmdNodm()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu face DM.")
        wait(400)
        specOff()
    end)
end

function cmdNui()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu este blocat.")
        wait(400)
        specOff()
    end)
end

function cmdNorp()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu face Non-RP / nu face nimic suspect.")
        wait(400)
        specOff()
    end)
end

function cmdNoguns()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu are arma & nu face DM.")
        wait(400)
        specOff()
    end)
end

function cmdNocheats()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu are Cheats.")
        wait(400)
        specOff()
    end)
end

function cmdNocbug()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu face C-bug / C-shot.")
        wait(400)
        specOff()
    end)
end

function cmdNodesync()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu are desync.")
        wait(400)
        specOff()
    end)
end

function cmdFps()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu are desync (fps / ping).")
        wait(400)
        specOff()
    end)
end

function cmdDoneaff()
    lua_thread.create(function()
        sampSendChat("/a Am terminat afacerea.")
        wait(400)
        specOff()
    end)
end

function cmdNoaff()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu mai are nevoie de ajutor la afacere.")
        wait(400)
        specOff()
    end)
end

function cmdArz()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul a rezolvat problema!")
        wait(400)
        specOff()
    end)
end

function cmdNoc()
    lua_thread.create(function()
        sampSendChat("/a Vrea masina, dar nu ii dau.")
        sampSendChat("Nu mai oferim vehicule la cerere, poti apela la un Taxi folosind comanda [/service].")
        wait(400)
        specOff()
    end)
end

function cmdNok()
    lua_thread.create(function()
        sampSendChat("/a Vrea spawn / kill, dar nu ii dau.")
        sampSendChat("Nu oferim respawn / kill la cerere, ne pare rau.")
        wait(400)
        specOff()
    end)
end

function cmdNoh()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul doreste heal, dar nu ii dau.")
        sampSendChat("Nu oferim heal la cerere, poti apela la un paramedic folosind comanda [/service] pentru a te ajuta.")
        wait(400)
        specOff()
    end)
end

function cmdNoa()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul doreste arme, dar nu ii dau.")
        sampSendChat("Nu oferim arme la cerere, poti sa mergi sa iti cumperi de la un Gun Shop.")
        wait(400)
        specOff()
    end)
end

function cmdNotp()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul doreste teleport, dar nu ii dau.")
        sampSendChat("Nu oferim teleport la cerere.")
        wait(400)
        specOff()
    end)
end

function cmdRrp()
    lua_thread.create(function()
        sampSendChat("/a Doreste refill / repair, dar nu ii dau.")
        sampSendChat("Nu oferim repair / refill la cerere, apeleaza la un mecanic folosind comanda [/service].")
        wait(400)
        specOff()
    end)
end

function cmdDd()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul are wanted, nu il pot ajuta!")
        sampSendChat("Imi pare rau, dar nu te pot ajuta deoarece ai wanted.")
        wait(400)
        specOff()
    end)
end

function cmdDdpd()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul este PD Duty, nu il pot ajuta!")
        sampSendChat("Imi pare rau, dar nu te pot ajuta deoarece esti la datorie ca politist.")
        wait(400)
        specOff()
    end)
end

function cmdAfk()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul este AFK / sleep.")
        wait(400)
        specOff()
    end)
end

function cmdNurasp()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul nu raspunde / nu ma baga in seama.")
        wait(400)
        specOff()
    end)
end

function cmdA2()
    lua_thread.create(function()
        sampSendChat("/a Acesti jucatori sunt blocati impreuna.")
        wait(400)
        specOff()
    end)
end

function cmdQc()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul s-a deconectat / a luat crash.")
        wait(400)
        specOff()
    end)
end

function cmdEv()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul este la eveniment.")
        wait(400)
        specOff()
    end)
end

function cmdJail()
    lua_thread.create(function()
        sampSendChat("/a Jucatorul se afla in jail.")
        wait(400)
        specOff()
    end)
end

function cmdTpevent()
    sampSendChat("/o Pentru a participa la eveniment folositi comanda [/tpevent].")
end

function cmdCheaters()
    sampSendChat("/cheaters")
end

function cmdReports()
    sampSendChat("/reports")
end

function cmdInfernus()
    sampSendChat("/spawncar 411")
end

function cmdMTB()
    sampSendChat("/spawncar 510")
end

function cmdNRG()
    sampSendChat("/spawncar 522")
end

function cmdMaverick()
    sampSendChat("/spawncar 487")
end

function cmdTank()
    sampSendChat("/spawncar 432")
end

function cmdFaggio()
    sampSendChat("/spawncar 462")
end

function cmdRInfernus()
    lua_thread.create(function()
        if dataPlayer.lastSpecID == -1 then
            sendError("Nu ai dat [/spec] pe un jucator!")
            return
        end
        sampSendChat("/spawncar 411")
        wait(400)
        sampSendChat("/spec " .. dataPlayer.lastSpecID)
        sendInfo("Ai spawnat un {ff4d4d}Infernus{ffffff} si te-ai pus din nou [/spec] pe jucatorul salvat! [ID: " .. dataPlayer.lastSpecID .. "]", dataAdmin.main_hex_color)
    end)
end

function cmdRMTB()
    lua_thread.create(function()
        if dataPlayer.lastSpecID == -1 then
            sendError("Nu ai dat [/spec] pe un jucator!")
            return
        end
        sampSendChat("/spawncar 510")
        wait(400)
        sampSendChat("/spec " .. dataPlayer.lastSpecID)
        sendInfo("Ai spawnat un {ff4d4d}Mountain Bike{ffffff} si te-ai pus din nou [/spec] pe jucatorul salvat! [ID: " .. dataPlayer.lastSpecID .. "]", dataAdmin.main_hex_color)
    end)
end

function cmdRNRG()
    lua_thread.create(function()
        if dataPlayer.lastSpecID == -1 then
            sendError("Nu ai dat [/spec] pe un jucator!")
            return
        end
        sampSendChat("/spawncar 522")
        wait(400)
        sampSendChat("/spec " .. dataPlayer.lastSpecID)
        sendInfo("Ai spawnat un {ff4d4d}NRG-500{ffffff} si te-ai pus din nou [/spec] pe jucatorul salvat! [ID: " .. dataPlayer.lastSpecID .. "]", dataAdmin.main_hex_color)
    end)
end

function cmdRMaverick()
    lua_thread.create(function()
        if dataPlayer.lastSpecID == -1 then
            sendError("Nu ai dat [/spec] pe un jucator!")
            return
        end
        sampSendChat("/spawncar 487")
        wait(400)
        sampSendChat("/spec " .. dataPlayer.lastSpecID)
        sendInfo("Ai spawnat un {ff4d4d}Maverick{ffffff} si te-ai pus din nou [/spec] pe jucatorul salvat! [ID: " .. dataPlayer.lastSpecID .. "]", dataAdmin.main_hex_color)
    end)
end

function cmdRTank()
    lua_thread.create(function()
        if dataPlayer.lastSpecID == -1 then
            sendError("Nu ai dat [/spec] pe un jucator!")
            return
        end
        sampSendChat("/spawncar 432")
        wait(400)
        sampSendChat("/spec " .. dataPlayer.lastSpecID)
        sendInfo("Ai spawnat un {ff4d4d}Rhino{ffffff} si te-ai pus din nou [/spec] pe jucatorul salvat! [ID: " .. dataPlayer.lastSpecID .. "]", dataAdmin.main_hex_color)
    end)
end

function cmdRFaggio()
    lua_thread.create(function()
        if dataPlayer.lastSpecID == -1 then
            sendError("Nu ai dat [/spec] pe un jucator!")
            return
        end
        sampSendChat("/spawncar 462")
        wait(400)
        sampSendChat("/spec " .. dataPlayer.lastSpecID)
        sendInfo("Ai spawnat un {ff4d4d}Faggio{ffffff} si te-ai pus din nou [/spec] pe jucatorul salvat! [ID: " .. dataPlayer.lastSpecID .. "]", dataAdmin.main_hex_color)
    end)
end

function cmdRepairEvent()
    sampSendChat("/area repair 150")
end

function cmdRepair()
    sampSendChat("/area repair 20")
end

function cmdHealEvent()
    sampSendChat("/area heal 150")
end

function cmdHeal()
    sampSendChat("/area heal 20")
end

function cmdDisarm()
    sampSendChat("/area disarm 20")
end

function cmdDisarmEvent()
    sampSendChat("/area disarm 150")
end

function cmdKillEvent()
    sampSendChat("/area kill 150")
end

function cmdFlip()
    sampSendChat("/flip")
end

function cmdMyRaport()
    sampSendChat("/myraport")
end


function cmdCrAiurea(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/aiurea <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/cr " .. playerId .. " Report aiurea")
    end
end

function cmdCrVerific(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/ver <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/cr " .. playerId .. " Verific")
    end
end

function cmdCrAcum(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/acm <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/cr " .. playerId .. " Acum")
    end
end

function cmdCrImd(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/imd <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/cr " .. playerId .. " Imediat")
    end
end

function cmdCrRezolv(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/rz <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/cr " .. playerId .. " Rezolv")
    end
end

function cmdRNewbie(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/rn <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/rnewbie " .. playerId)
    end
end

function cmdPronunta(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/pronunta <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/re " .. playerId .. " Nu mai pronunta numele acelui server. Next BAN")
    end
end

function cmdRMUTEAiurea(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/raiurea <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/rmute " .. playerId .. " 30 /report aiurea")
    end
end

function cmdMori(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/mori <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])
    if isPlayerIdValid(playerId) then
        sampSendChat("/sethp " .. playerId .. " 0")
    end
end

function cmdFlipcar(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/fc <carid>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/flipcar " .. text)
end

function cmdSlapcar(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/sc <carid>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/slapcar " .. text)
end

function cmdGetcar(text)
    if ServerName == "RPG B-HOOD" then
        sampSendChat("/gc " .. text)
        return
    end

    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/gc <carid>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/getcar " .. text)
end

function cmdGetcar2(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/gcc <carid>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/getcar " .. text)
end

function cmdCall112o()
    sampSendChat("/anno Cine foloseste comanda [/call 112] la eveniment va fi sanctionat cu WARN.")
end

function cmdCall112()
    sampSendChat("/as Cine foloseste comanda [/call 112] la eveniment va fi sanctionat cu WARN.")
end

function cmdCladireEvent()
    sampSendChat("/as Cine se ascunde in cladire sau in spatele acesteia primeste SPAWN.")
end

function cmdTankEvent()
    sampSendChat("/as Cine se urca pe TANK primeste SPAWN.")
end

function cmdLinieEvent()
    sampSendChat("/as Cine nu se pune in LINIE primeste SPAWN.")
end

function cmdTelEvent()
    sampSendChat("/as Jucatorii care joaca de pe TELEFON vor primi SPAWN, deoarece nu le scade viata.")
end

function cmdETP()
    sampSendChat("/o Pentru a participa la eveniment folositi comanda [/tpevent].")
end

function cmdWinner(text)
    local args = getArgs(text)
    if #args < 1 then
        sendUsage("/winner <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[1])

    if isPlayerIdValid(playerId) then
        local playerName = sampGetPlayerNickname(playerId)
        sampSendChat("/o Castigatorul evenimentului este " .. playerName .. " (/id " .. playerId .. "). Felicitari tuturor si multumesc pentru participare!")
    end
end

function cmdEventSMS(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 4) then
        sendUsage("/eventsms <bani (ex: 5.000.000)> <text (minim 3 cuvinte)>", dataAdmin.main_hex_color)
        return
    end
    
    local message = table.concat(args, " ", 2)
    sampSendChat("/o Primul jucator care imi trimite [/sms] cu textul '" .. message .. "' castiga suma de $" .. args[1] .. ".")
end

function cmdEventMTB(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        sendUsage("/eventmtb <bani (ex: 5.000.000)>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/o Primul jucator ce reuseste sa ma ucida va castiga suma de '$" ..  args[1] .. "'.")
end

function cmdEventLCS(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        sendUsage("/eventlcs <bani (ex: 5.000.000)>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/o In urmatoarele momente va urma un event de tip `Last Car Standing`, premiul este de '$" ..  args[1] .. "'.")
    TPEventAuto()
end

function cmdEventLMS(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        sendUsage("/eventlms <bani (ex: 5.000.000)>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/o In urmatoarele momente va urma un event de tip `Last Man Standing`, premiul este de '$" ..  args[1] .. "'.")
    TPEventAuto()
end

function cmdEventSTUNT(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        sendUsage("/eventstunt <bani (ex: 5.000.000)>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/o In urmatoarele momente va urma un event de tip `Stunt`, premiul este de '$" ..  args[1] .. "'.")
end

function cmdEventHNS(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        sendUsage("/eventhns <bani (ex: 5.000.000)>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/o In urmatoarele momente va urma un event de tip `Hide & Seek`, premiul este de '$" ..  args[1] .. "'.")
    TPEventAuto()
end

function cmdEvent1v1(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        sendUsage("/event1v1 <bani (ex: 5.000.000)>", dataAdmin.main_hex_color)
        return
    end
    sampSendChat("/o In urmatoarele momente va urma un event de tip `1vs1`, premiul este de '$" ..  args[1] .. "'.")
    TPEventAuto()
end


function cmdEventVIP(text)
    local args = getArgs(text)
    if #args < 2 then
        sendUsage("/eventvip <bani (ex: 5.000.000)> <lista id-uri (ex: 15 392 593 155)>", dataAdmin.main_hex_color)
        return
    end

    local usersNick = {}
    local ids = {}
    for i = 2, #args do
        local playerId = tonumber(args[i])
        if not playerId or not isInteger(playerId) then
            sendError("Un ID nu este corect!")
            return
        end

        if not isPlayerIdValid(playerId) then
            sendError("Un ID nu este corect!")
            return
        end
        local nickname = sampGetPlayerNickname(playerId)
        table.insert(usersNick, nickname .. " (/id " .. playerId .. ")")
        table.insert(ids, playerId)
    end

    local countLenNumes = 0
    for i = 1, #usersNick do
        countLenNumes = countLenNumes + string.len(usersNick[i])
    end

    lua_thread.create(function()
        sampSendChat("/o In urmatoarele momente va urma un event de tip 'Protect the VIP', premiul este de '$" .. args[1] .. "'!")
        wait(400)
        if countLenNumes > 100 then
            sampSendChat("/o Jucatorii care trebuie sa ma apere sunt: " .. table.concat(usersNick, ", ", 1, 5))
            wait(400)
            sampSendChat("/o " .. table.concat(usersNick, ", ", 6, #usersNick))
        else
            sampSendChat("/o Jucatorii care trebuie sa ma apere sunt: " .. table.concat(usersNick, ", "))
        end
    end)
end


-- end comenzi events

function cmdHpme()
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    sampSendChat("/sethp " .. id .. " 999999")      
end

function cmdVw0me()
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    sampSendChat("/setvw " .. id .. " 0")      
end

function cmdSpawnme()
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    sampSendChat("/respawn " .. id)      
end

function cmdDisarmme()
    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    sampSendChat("/disarm " .. id)      
end

function cmdGotopaint()
    setCharCoordinates(PLAYER_PED, 1154.2747, -1439.8785, 15.7969)
    sendInfo("Te-ai teleportat cu succes la paint!", dataAdmin.main_hex_color)
end

-- easy spec
function sampev.onSendCommand(cmd)
    local id = tonumber(cmd:match("^/(%d+)$"))
    if id then
        if isPlayerIdValid(tonumber(cmd:match("^/(%d+)$"))) == true then
            sampSendChat("/spec " .. id)
            dataPlayer.lastSpecID = id
            return false
        else
            return false
        end
    end
    return true
end

function cmdClearChat()
    sampSendChat("/cc")
end

function cmdBlockAnno(text)
    if dataAdmin.toganno == true then
        sendError("Aceasta comanda este dezactivata, foloseste [/anno] sau dezactiveaza sistemul intrand in 'Admin Systems'.")
    else
        sampSendChat("/o " .. text)
    end
end

function cmdBlockClearChat()
    if dataAdmin.togcc == true then
        sendError("Aceasta comanda este dezactivata, foloseste [/cchat] sau dezactiveaza sistemul intrand in 'Admin Systems'.")
    else
        sampSendChat("/cc")
    end
end


function cmdVulgar(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 2) then
        sendUsage("/vulgar <playerid/name> <vipname/carplate/biz/house/petname/job>", dataAdmin.main_hex_color)
        return
    end
    if args[2] == "vipname" then
        sampSendChat("/re " .. args[1] .. " Salut, schimba numele de la VIPNAME imediat, deoarece acesta este unul indecent sau risti WARN.")
    elseif args[2] == "carplate" then
        sampSendChat("/re " .. args[1] .. " Salut, schimba numele de la CARPLATE imediat, deoarece acesta este unul indecent sau risti WARN.")
    elseif args[2] == "biz" then
        sampSendChat("/re " .. args[1] .. " Salut, schimba numele de la BUSINESS imediat, deoarece acesta este unul indecent sau risti WARN.")
    elseif args[2] == "house" then
        sampSendChat("/re " .. args[1] .. " Salut, schimba numele de la CASA imediat, deoarece acesta este unul indecent sau risti WARN.")
    elseif args[2] == "petname" then
        if ServerName == "RPG B-HOOD" then
        sampSendChat("/re " .. args[1] .. " Salut, schimba numele de la PET imediat, deoarece acesta este unul indecent sau risti WARN.")
        else
            sendError("Aceasta optiune este disponibila doar pentru server-ul RPG.")
        end
    elseif args[2] == "job" then
        if ServerName == "RPG B-HOOD" then
        sampSendChat("/re " .. args[1] .. " Salut, schimba numele de la JOB imediat, deoarece acesta este unul indecent sau risti WARN.")
        else
            sendError("Aceasta optiune este disponibila doar pentru server-ul RPG.")
        end
    else
        sendError("Parametri disponibili: vipname/carplate/biz/house/petname/job")
    end
end

function cmdADesync()
    lua_thread.create(function()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
    else
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sendInfo("Ai folosit comanda [/adesync] si urmeaza sa faci un test desync (/re + /slap) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID .. ")].", dataAdmin.main_hex_color)
        sampSendChat("/re " .. dataPlayer.lastSpecID .. " In urmatoarele momente iti voi face un test desync.")
        wait(800)
        sampSendChat("/slap " .. dataPlayer.lastSpecID)
    end
    end)
end

function cmdTestRoute()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
    else
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sendInfo("Ai folosit comanda [/route] si urmeaza sa faci un test de tip Route-Recording ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID .. ")].", dataAdmin.main_hex_color)
        sampSendChat("Simulare /re " .. dataPlayer.lastSpecID .. " In urmatoarele momente iti voi face un test Route-Recording.")
    end
end

function cmdGet(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        if dataPlayer.lastSpecID == -1 then
            sendUsage("/get <playerid/name>", dataAdmin.main_hex_color)
            return
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            sendInfo("Ai tras la tine (/gethere) ultimul player pe care ai fost {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].")
            sampSendChat("/gethere " .. dataPlayer.lastSpecID)
            return
        end
    end
    sampSendChat("/gethere " ..  args[1])
end

function cmdGot(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        if dataPlayer.lastSpecID == -1 then
            sendUsage("/got <playerid/name>", dataAdmin.main_hex_color)
            return
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            sendInfo("Te-ai teleportat (/goto) la jucatorul la care ai dat ultima data {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
            sampSendChat("/goto " .. dataPlayer.lastSpecID)
            return
        end
    end
    sampSendChat("/goto " ..  args[1])
end

function cmdLcc(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        if dataPlayer.lastSpecID == -1 then
            sendUsage("/lcc <playerid/name>", dataAdmin.main_hex_color)
            return
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            sendInfo("Ai verificat chatlog-ul (/lastchat) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].")
            sampSendChat("/lastchat " .. dataPlayer.lastSpecID)
            return
        end
    end
    sampSendChat("/lastchat " ..  args[1])
end

function cmdLpp()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sendInfo("Ai verificat Last Punish-ul (/lp) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
        sampSendChat("/lp " .. dataPlayer.lastSpecID)
        return
    end
end

function cmdSlap(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        if dataPlayer.lastSpecID == -1 then
            sendUsage("/sl <playerid/name>", dataAdmin.main_hex_color)
            return
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            sendInfo("Ai dat (/slap) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].")
            sampSendChat("/slap " .. dataPlayer.lastSpecID)
            return
        end
    end
    sampSendChat("/slap " ..  args[1])
end

function cmdFreeze(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        if dataPlayer.lastSpecID == -1 then
            sendUsage("/fr <playerid/name>", dataAdmin.main_hex_color)
            return
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            sendInfo("Ai dat (/freeze) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
            sampSendChat("/freeze " .. dataPlayer.lastSpecID)
            return
        end
    end
    sampSendChat("/freeze " ..  args[1])
end

function cmdUnfreeze(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        if dataPlayer.lastSpecID == -1 then
            sendUsage("/unfr <playerid/name>", dataAdmin.main_hex_color)
            return
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            sendInfo("Ai dat (/unfreeze) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
            sampSendChat("/unfreeze " .. dataPlayer.lastSpecID)
            return
        end
    end
    sampSendChat("/unfreeze " ..  args[1])
end

function cmdSpawnhere(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        if dataPlayer.lastSpecID == -1 then
            sendUsage("/sh <playerid/name>", dataAdmin.main_hex_color)
            return
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            sendInfo("Ai dat (/spawnhere) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
            sampSendChat("/spawnhere " .. dataPlayer.lastSpecID)
            return
        end
    end
    sampSendChat("/spawnhere " ..  args[1])
end

function cmdMDC()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sendInfo("Ai verificat MDC-ul (/mdc) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
        sampSendChat("/mdc " .. dataPlayer.lastSpecID)
        return
    end
end

function cmdMor()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sendInfo("Ai setat 0 HP (/sethp 0) ultimului player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
        sampSendChat("/sethp " .. dataPlayer.lastSpecID .. " 0")
        return
    end
end

function cmdCheck(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        if dataPlayer.lastSpecID == -1 then
            sendUsage("/check <playerid/name>", dataAdmin.main_hex_color)
            return
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            sendInfo("Ai dat (/check) pe ultimul player din {ff4d4d}[/spec]{ffffff} [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
            sampSendChat("/check " .. dataPlayer.lastSpecID)
            return
        end
    end
    sampSendChat("/check " ..  args[1])
end

function cmdSpec2(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        sendUsage("/specc <playerid/name>", dataAdmin.main_hex_color)
        return
    end
    if isPlayerIdValid(text) then
    sampSendChat("/spec " .. args[1])
    end
end

function cmdEuSpec()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sampSendChat("/a Eu sunt [/spec] pe " .. playerName .. ", [ID: ".. dataPlayer.lastSpecID .."].")
        return
    end
end

function cmdSalut()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sampSendChat("Salut " .. playerName .. ", cu ce te pot ajuta?")
        return
    end
end

function cmdSalut2()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
        sampSendChat("Salut " .. playerName .. ", mai ai nevoie de ajutor?")
        return
    end
end

function cmdSpamIDon()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        if dataAdmin.dataid == true then
            sendError("Spammer-ul pentru [/id] este deja activat!")
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            dataAdmin.dataid = true
            sendInfo("Spammer pentru [/id] a fost pornit! Verificarea se va efectua pe [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].", dataAdmin.main_hex_color)
            return
        end
    end
end

function cmdSpamIDoff()
    if dataAdmin.dataid == false then
        sendError("Spammer-ul pentru [/id] nu este pornit!")
        return
    else
        dataAdmin.dataid = false
        sendInfo("Spammer-ul pentru [/id] a fost oprit!", dataAdmin.main_hex_color)
        return
    end
end

function cmdSpamPMon()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        if dataAdmin.datapm == true then
            sendError("Spammer-ul pentru Auto-clicker este deja activat!")
        else
            local playerName = sampGetPlayerNickname(dataPlayer.lastSpecID)
            dataAdmin.datapm = true
            sendInfo("Spammer pentru Auto-clicker a fost pornit! Verificarea se va efectua pe [" .. playerName .. " (".. dataPlayer.lastSpecID ..")].")
            return
        end
    end
end

function cmdSpamPMoff()
    if dataAdmin.datapm == false then
        sendError("Spammer-ul pentru Auto-clicker nu este pornit!")
        return
    else
        dataAdmin.datapm = false
        sendInfo("Spammer-ul pentru Auto-clicker a fost oprit!", dataAdmin.main_hex_color)
        return
    end
end

function cmdResetSpecID()
    if dataPlayer.lastSpecID == -1 then
        sendError("Nu ai dat [/spec] pe un jucator!")
        return
    else
        sendInfo("Ultimul ID salvat din [/spec] resetat cu {40ff00}succes{ffffff}!", dataAdmin.main_hex_color)
        dataPlayer.lastSpecID = -1
        return
    end
end

function cmdSaveSpec(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 2) then
        sendUsage("/sspec <slot 1-3> <playerid>", dataAdmin.main_hex_color)
        return
    end

    local playerId = tonumber(args[2])
    local playerName = sampGetPlayerNickname(playerId)

    if isPlayerIdValid(args[2]) then
        if args[1] == "1" then
            dataAdmin.spec_name1 = playerName
            dataAdmin.spec_id1 = playerId
            sendInfo("Jucatorul " .. playerName .. " (" .. playerId .. ") a fost salvat in [/speclist] (slot #1).", dataAdmin.main_hex_color)


        elseif args[1] == "2" then
            dataAdmin.spec_name2 = playerName
            dataAdmin.spec_id2 = playerId
            sendInfo("Jucatorul " .. playerName .. " (" .. playerId .. ") a fost salvat in [/speclist] (slot #2).", dataAdmin.main_hex_color)



        elseif args[1] == "3" then
            dataAdmin.spec_name3 = playerName
            dataAdmin.spec_id3 = playerId
            sendInfo("Jucatorul " .. playerName .. " (" .. playerId .. ") a fost salvat in [/speclist] (slot #3).", dataAdmin.main_hex_color)
        end
    else
        sendError("Parametri disponibili: (1-3)")
    end
end



function cmdSpecList()
    if dataAdmin.spec_id1 == -1 and dataAdmin.spec_id2 == -1 and dataAdmin.spec_id3 == -1 then 
        sendError("Nu ai jucatori salvati in [/speclist].")
        return
    else
        
        Spec1 = "1. " .. dataAdmin.spec_name1 .. " ({ff4d4d}ID: " .. dataAdmin.spec_id1 .. "{FFFFFF}) >> {99ff99}[/spec1]{ffffff}" 
        Spec2 = "2. " .. dataAdmin.spec_name2 .. " ({ff4d4d}ID: " .. dataAdmin.spec_id2 .. "{FFFFFF}) >> {99ff99}[/spec2]{ffffff}" 
        Spec3 = "3. " .. dataAdmin.spec_name3 .. " ({ff4d4d}ID: " .. dataAdmin.spec_id3 .. "{FFFFFF}) >> {99ff99}[/spec3]{ffffff}" 
        
        sampAddChatMessage("{66a3ff}>>{FFFFFF} Jucatori salvati in [/spec]: {66a3ff}<<", -1)

        if dataAdmin.spec_id1 ~= -1 then -- specc1
            sampAddChatMessage(Spec1, -1)
        end

        if dataAdmin.spec_id2 ~= -1 then -- specc2
            sampAddChatMessage(Spec2, -1)
        end

        if dataAdmin.spec_id3 ~= -1 then -- specc3
            sampAddChatMessage(Spec3, -1)
        end

    end
end

function cmdResetSpecList(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 1) then
        sendUsage("/resetspeclist <1-3/all>", dataAdmin.main_hex_color)
        return
    end
    if args[1] == "1" then
        if dataAdmin.spec_id1 == -1 then
            sendError("Nu ai un jucator salvat pe acest slot de [/spec] (#1)!")
        else
            sendInfo("Jucatorul " .. dataAdmin.spec_name1 .. " (ID: " .. dataAdmin.spec_id1 .. ") a fost sters din [/speclist] (slot #1).", dataAdmin.main_hex_color)
            dataAdmin.spec_name1 = -1
            dataAdmin.spec_id1 = -1
        end


    elseif args[1] == "2" then
        if dataAdmin.spec_id2 == -1 then
            sendError("Nu ai un jucator salvat pe acest slot de [/spec] (#2)!")
        else
            sendInfo("Jucatorul " .. dataAdmin.spec_name2 .. " (ID: " .. dataAdmin.spec_id2 .. ") a fost sters din [/speclist] (slot #2).", dataAdmin.main_hex_color)
            dataAdmin.spec_name2 = -1
            dataAdmin.spec_id2 = -1   
        end
        


    elseif args[1] == "3" then
        if dataAdmin.spec_id3 == -1 then
            sendError("Nu ai un jucator salvat pe acest slot de [/spec] (#3)!", dataAdmin.main_hex_color)
        else
            sendInfo("Jucatorul " .. dataAdmin.spec_name3 .. " (ID: " .. dataAdmin.spec_id3 .. ") a fost sters din [/speclist] (slot #3).", dataAdmin.main_hex_color)
            dataAdmin.spec_name3 = -1
            dataAdmin.spec_id3 = -1  
        end
        


    elseif args[1] == "all" then
        sendInfo("Toti jucatorii salvati in [/speclist] au fost resetati cu succes!", dataAdmin.main_hex_color)
            dataAdmin.spec_name1 = -1
            dataAdmin.spec_id1 = -1
            dataAdmin.spec_name2 = -1
            dataAdmin.spec_id2 = -1 
            dataAdmin.spec_name3 = -1
            dataAdmin.spec_id3 = -1 

    else
        sendError("Parametri disponibili: (1-3), all")
    end
end



function cmdSpecList1()
    if dataAdmin.spec_id1 == -1 then
        sendError("Nu ai un jucator salvat pe acest slot de [/spec] (#1)!")
    else
        sendInfo("Te-ai pus [/spec] pe jucatorul (#1) salvat in {ff4d4d}[/speclist]{ffffff} >> [" .. dataAdmin.spec_name1 .. " (".. dataAdmin.spec_id1 ..")].", dataAdmin.main_hex_color)
        dataPlayer.lastSpecID = dataAdmin.spec_id1
        sampSendChat("/spec " .. dataAdmin.spec_id1)
    end
end

function cmdSpecList2()
    if dataAdmin.spec_id2 == -1 then
        sendError("Nu ai un jucator salvat pe acest slot de [/spec] (#2)!")
    else
        sendInfo("Te-ai pus [/spec] pe jucatorul (#2) salvat in {ff4d4d}[/speclist]{ffffff} >> [" .. dataAdmin.spec_name2 .. " (".. dataAdmin.spec_id2 ..")].", dataAdmin.main_hex_color)
        dataPlayer.lastSpecID = dataAdmin.spec_id2
        sampSendChat("/spec " .. dataAdmin.spec_id2)
    end
end

function cmdSpecList3()
    if dataAdmin.spec_id3 == -1 then
        sendError("Nu ai un jucator salvat pe acest slot de [/spec] (#3)!")
    else
        sendInfo("Te-ai pus [/spec] pe jucatorul (#3) salvat in {ff4d4d}[/speclist]{ffffff} >> [" .. dataAdmin.spec_name3 .. " (".. dataAdmin.spec_id3 ..")].", dataAdmin.main_hex_color)
        dataPlayer.lastSpecID = dataAdmin.spec_id3
        sampSendChat("/spec " .. dataAdmin.spec_id3)
    end
end


-- DIALOG
function imgui.OnDrawFrame()
    function apply_custom_style()
        local style = imgui.GetStyle()
        local colors = style.Colors
        local col = imgui.Col
        local im_vec4 = imgui.ImVec4
        style.WindowRounding = 10.0
        style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
        style.ChildWindowRounding = 10.0
        style.FrameRounding = 10.0
        style.ItemSpacing = imgui.ImVec2(10, 10)
        style.ScrollbarSize = 13
        style.ScrollbarRounding = 10.0
        style.GrabMinSize = 8
        style.GrabRounding = 10.0
        style.WindowPadding = imgui.ImVec2(15, 15)
        style.FramePadding = imgui.ImVec2(5, 5)
        style.ButtonTextAlign = imgui.ImVec2(1, 1)

        colors[col.Text] = im_vec4(1, 1, 1, 1)
        colors[col.WindowBg] = dataAdmin.bg_color
        colors[col.FrameBg] = imgui.ImColor(50, 50, 50, 230):GetVec4()
        colors[col.Button] = dataAdmin.main_color
        colors[col.ButtonHovered] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8)
        colors[col.ButtonActive] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5)
        colors[col.TitleBg] = imgui.ImColor(dataAdmin.bg_color.x, dataAdmin.bg_color.y, dataAdmin.bg_color.z, 200):GetVec4()
        colors[col.TitleBgActive] = imgui.ImColor(dataAdmin.bg_color.x, dataAdmin.bg_color.y, dataAdmin.bg_color.z, 200):GetVec4()
        colors[col.Header] = dataAdmin.main_color
        colors[col.HeaderHovered] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8)
        colors[col.HeaderActive] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5)
        colors[col.ScrollbarGrab] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.6)
        colors[col.ScrollbarGrabHovered] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.4)
        colors[col.ScrollbarGrabActive] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.25)
        colors[col.CloseButton] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.6)
        colors[col.CloseButtonHovered] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.4)
        colors[col.CloseButtonActive] = imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.25)
    end


    apply_custom_style()
    if show_admin_cmd_menu.v then
        imgui.SetNextWindowSize(imgui.ImVec2(550, 500), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(screen_x / 2, screen_y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin("AdminCMD for B-HOOD Community", show_admin_cmd_menu)

        if imgui.IsWindowCollapsed() then
            if sampIsChatInputActive() then
                imgui.ShowCursor = true
            else
                imgui.ShowCursor = false
            end
        else
            local player_id = select(2, sampGetPlayerIdByCharHandle(playerPed))
            local player_name = sampGetPlayerNickname(player_id)
            
            imgui.Columns(2)
            imgui.Text(string.format("Welcome, " .. player_name .. "!"))
            imgui.NextColumn()
            imgui.Text(string.format("Playing server: " .. ServerName))
            imgui.Columns(1)

            


            imgui.Separator()
--------
            if imgui.CollapsingHeader("Admin Systems") then
            
                imgui.PushStyleColor(imgui.Col.Button, dataAdmin.main_color)
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5))
            

                
                imgui.Columns(3)
            
                if imgui.Checkbox('Block [/o]', imgui.ImBool(dataAdmin.toganno)) then
                    dataAdmin.toganno = not dataAdmin.toganno
                    if dataAdmin.toganno == true then
                        sendInfo("Sistemul 'Block [/o]' a fost {40ff00}activat{ffffff}!", dataAdmin.main_hex_color)
                    else
                        sendInfo("Sistemul 'Block [/o]' a fost {ff0000}dezactivat{ffffff}!", dataAdmin.main_hex_color)
                    end
                end
            
                imgui.NextColumn()
            
                if imgui.Checkbox('Block [/cc]', imgui.ImBool(dataAdmin.togcc)) then
                    dataAdmin.togcc = not dataAdmin.togcc
                    if dataAdmin.togcc == true then
                        sendInfo("Sistemul 'Block [/cc]' a fost {40ff00}activat{ffffff}!", dataAdmin.main_hex_color)
                    else
                        sendInfo("Sistemul 'Block [/cc]' a fost {ff0000}dezactivat{ffffff}!", dataAdmin.main_hex_color)
                    end
                end
            
                imgui.NextColumn()
            
                if imgui.Checkbox('Auto [/etp]', imgui.ImBool(dataAdmin.togetp)) then
                    dataAdmin.togetp = not dataAdmin.togetp
                    if dataAdmin.togetp == true then
                        sendInfo("Sistemul 'Auto [/etp]' a fost {40ff00}activat{ffffff}!", dataAdmin.main_hex_color)
                    else
                        sendInfo("Sistemul 'Auto [/etp]' a fost {ff0000}dezactivat{ffffff}!", dataAdmin.main_hex_color)
                    end
                end
            
                imgui.Columns(1)

                imgui.Separator()
            
                if imgui.Button("Edit theme") then
                    showColorPicker = not showColorPicker
                end

                -- if dataAdmin.moderator == true then
                    if imgui.Button("Edit background") then
                        showColorPicker2 = not showColorPicker2
                    end
                -- end

                if showColorPicker then
                    if imgui.ColorEdit3("Select Theme Color", dataAdmin.main_color) then
                        local r = math.floor(dataAdmin.main_color.x * 255)
                        local g = math.floor(dataAdmin.main_color.y * 255)
                        local b = math.floor(dataAdmin.main_color.z * 255)  
                    end
                end

                if showColorPicker2 then
                    if imgui.ColorEdit3("Select Background Color", dataAdmin.bg_color) then
                        local r = math.floor(dataAdmin.bg_color.x * 255)
                        local g = math.floor(dataAdmin.bg_color.y * 255)
                        local b = math.floor(dataAdmin.bg_color.z * 255)
                          
                    end
                end

                
                
            
                -- for _, cmd in ipairs(commands) do
                --     imgui.TextColored(dataAdmin.main_color, cmd[1])
                --     imgui.SameLine(0, 5)
                --     imgui.TextWrapped(cmd[2])
                -- end

                imgui.PopStyleColor(3)
            
                imgui.Separator()
                
            end
--------
            if imgui.CollapsingHeader("Regulament Server") then

                imgui.PushStyleColor(imgui.Col.Button, dataAdmin.main_color)
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5))
            
                local textChunks = splitTextIntoChunks(serverRules, 800)
            
                for _, chunk in ipairs(textChunks) do
                    imgui.TextWrapped(chunk)
                end
            
                imgui.PopStyleColor(3)
            end

            imgui.Separator()

            if imgui.CollapsingHeader("Admin Commands") then

                imgui.PushStyleColor(imgui.Col.Button, dataAdmin.main_color)
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5))

                local commands = {
                    {"/nodm", "- Anunti pe [/a] ca jucatorul nu face DM"},
                    {"/nui", "- Anunti pe [/a] ca jucatorul nu este blocat"},
                    {"/norp", "- Anunti pe [/a] ca jucatorul nu face Non-RP / nu face nimic suspect."},
                    {"/noguns", "- Anunti pe [/a] ca jucatorul nu are ARMA + jucatorul nu face DM."},
                    {"/nocheats", "- Anunti pe [/a] ca jucatorul nu are Cheats."},
                    {"/nocbug", "- Anunti pe [/a] ca jucatorul nu face C-BUG / C-SHOT."},
                    {"/nodesync", "- Anunti pe [/a] ca jucatorul nu are desync."},
                    {"/fps", "- Anunti pe [/a] ca jucatorul nu are desync (fps / ping)."},
                    {"/doneaff", "- Anunti pe [/a] ca ai terminat afacerea."},
                    {"/noaff", "- Anunti pe [/a] ca jucatorul nu face afacere / nu are nevoie de ajutor la o afacere."},
                    {"/arz", "- Anunti pe [/a] ca jucatorul a rezolvat problemele."},
                    {"/noc", "- Anunti pe [/a] ca jucatorul doreste vehicul + il anunti pe jucator ca nu ii oferi vehicul."},
                    {"/nok", "- Anunti pe [/a] ca jucatorul doreste kill / spawn + il anunti pe jucator ca nu ii oferi spawn / kill."},
                    {"/noh", "- Anunti pe [/a] ca jucatorul doreste heal + il anunti pe jucator ca nu ii oferi heal."},
                    {"/noa", "- Anunti pe [/a] ca jucatorul doreste arme + il anunti pe jucator ca nu ii oferi arme."},
                    {"/notp", "- Anunti pe [/a] ca jucatorul doreste teleport + il anunti pe jucator ca nu ii oferi teleport la cerere."},
                    {"/rrp", "- Anunti pe [/a] ca jucatorul doreste repair + il anunti pe jucator ca nu ii oferi repair / refill."},
                    {"/dd", "- Anunti pe [/a] 'Jucatorul wanted, nu il pot ajuta!' si il informezi ca 'Imi pare rau, dar nu te pot ajuta deoarece ai wanted.'"},
                    {"/ddpd", "- Anunti pe [/a] 'Jucatorul este PD Duty, nu il pot ajuta!' si il informezi ca 'Imi pare rau, dar nu te pot ajuta deoarece esti la datorie ca politist.'"},
                    {"/afk", "- Anunti pe [/a] ca jucatorul este 'AFK / SLEEP'."},
                    {"/nurasp", "- Anunti pe [/a] ca jucatorul nu raspunde / nu te baga in seama.'"},
                    {"/a2", "- Anunti pe [/a] ca jucatorii care au dat report sunt iwmpreuna.'"},
                    {"/qc", "- Anunti pe [/a] ca jucatorul s-a deconectat / a luat crash.'"},
                    {"/ev", "- Anunti pe [/a] ca jucatorul este de la eveniment.'"},
                    {"/jail", "- Anunti pe [/a] ca jucatorul este in jail."},
                    {"/helpstaff", "- Anunti pe [/anno] ca jucatorii pot folosi comanda [/report] respectiv [/n] daca au intrebari / probleme legate de server."},
                    {"/etp", "- Pentru a participa la event folositi comanda [/tpevent]."},
                    {"/rep", "- Vezi [/reports]-urile."},
                    {"/cits", "- Vezi [/cheats]-urile."},
                    {"/fl", "- Dai [/flip] la vehicul."},
                    {"/mr", "- Folosesti comanda [/myraport]."},
                    {"/aiurea", "- Aceasta comanda inchide report-ul.'"},
                    {"/ver", "- Inchizi report-ul pe motiv 'Verific.'"},
                    {"/acm", "- Inchizi report-ul pe motiv 'Acum.'"},
                    {"/imd", "- Inchizi report-ul pe motiv 'Imediat.'"},
                    {"/rz", "- Inchizi report-ul pe motiv 'Rezolv.'"},
                    {"/rn <ID>", "- Trimiti un report la helperi."},
                    {"/pronunta", "- Trimiti un [/re <id>] pe motiv 'Nu mai pronunta numele acelui server. Next BAN!'"},
                    {"/raiurea", "- Dai mute pentru 'Report aiurea.'"},
                    {"/mori <ID>", "- Setezi viata jucatorului la 0."},
                    {"/fc <veh ID>", "- Dai flip la un vehicul."},
                    {"/sc <veh ID>", "- Dai slap la un vehicul."}
                }

                if ServerName == "OG B-HOOD" then
                    table.insert(commands, {"/gc <veh ID>", "- Dai [/getcar] la un vehicul."})
                elseif ServerName == "RPG B-HOOD" then
                    table.insert(commands, {"/gcc <veh ID>", "- Dai [/getcar] la un vehicul."})
                end



                for _, cmd in ipairs(commands) do
                    imgui.TextColored(dataAdmin.main_color, cmd[1])
                    imgui.SameLine(0, 5)
                    imgui.TextWrapped(cmd[2])
                end
                
                
                imgui.PopStyleColor(3)
            end

--------
            if imgui.CollapsingHeader("Vehicle Commands") then

                imgui.PushStyleColor(imgui.Col.Button, dataAdmin.main_color)
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5))

                local commands = {
                    {"/inf", "- Spawnezi un Infernus."},
                    {"/mtb", "- Spawnezi un Mountain Bike."},
                    {"/nrg", "- Spawnezi un NRG-500."},
                    {"/mave", "- Spawnezi un Maverick."},
                    {"/tank", "- Spawnezi un Rhino."},
                    {"/faggio", "- Spawnezi un Faggio."},
                    {"/rinf", "- Spawnezi un Infernus si te pui din nou [/spec] pe ultimul ID."},
                    {"/rmtb", "- Spawnezi un Mountain Bike si te pui din nou [/spec] pe ultimul ID."},
                    {"/rnrg", "- Spawnezi un NRG-500 si te pui din nou [/spec] pe ultimul ID."},
                    {"/rmave", "- Spawnezi un Maverick si te pui din nou [/spec] pe ultimul ID."},
                    {"/rtank", "- Spawnezi un Rhino si te pui din nou [/spec] pe ultimul ID."},
                    {"/rfaggio", "- Spawnezi un Faggio si te pui din nou [/spec] pe ultimul ID."}
                }



                for _, cmd in ipairs(commands) do
                    imgui.TextColored(dataAdmin.main_color, cmd[1])
                    imgui.SameLine(0, 5)
                    imgui.TextWrapped(cmd[2])
                end
                
                
                imgui.PopStyleColor(3)
            end
--------
            if imgui.CollapsingHeader("Event Commands") then

                imgui.PushStyleColor(imgui.Col.Button, dataAdmin.main_color)
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5))

                local commands = {
                    {"/reparae", "- Dai '/area Repair 150' daca esti la 'EVENT' / 'ANY'."},
                    {"/repara", "- Dai '/area Repair 15'."},
                    {"/viatae", "- Dai '/area Heal 150' daca esti la 'EVENT' / 'ANY'."},
                    {"/viata", "- Dai '/area Heal 15'."},
                    {"/dis", "- Dai '/area disarm 15'."},
                    {"/dise", "- Dai '/area disarm 150'."},
                    {"/kille", "- Dai '/area kill 150'."},
                    {"/cal112anno", "- Anunta pe [/anno] cine foloseste [/call 112] primeste WARN."},
                    {"/cal112", "- Anunta pe [/as] cine foloseste [/call 112] primeste WARN."},
                    {"/aeventcladire", "- Cine se ascunde in spate la cladire = SPAWN"},
                    {"/aeventtank", "- Cine se urca pe tank = SPAWN"},
                    {"/aeventlinie", "- Cine nu se pune in LINIE primeste SPAWN."},
                    {"/aeventtel", "- Jucatorii care joaca pe TELEFON vor primi SPAWN, deoarece nu le scade viata."},
                    {"/eventsms", "- Tasteaza pe chat [/eventsms]-ul. Fii singur pentru a nu vedea si altcineva."},
                    {"/eventmtb", "- Primul jucator ca reuseste sa ma ucida, castiga suma de $<suma>."},
                    {"/eventlcs", "- In urmatoarele momente va urma un event de tip 'Last Car Standing', premiul este de $<suma>. | Dispune de sistemul 'Auto [/etp]'"},
                    {"/eventlms", "- In urmatoarele momente va urma un event de tip 'Last Man Standing', premiul este de $<suma>. | Dispune de sistemul 'Auto [/etp]'"},
                    {"/eventstunt", "- In urmatoarele momente va urma un event de tip 'Stunt', premiul este de $<suma>."},
                    {"/eventhns", "- In urmatoarele momente va urma un event de tip 'Hide and Seek', premiul este de $<suma>. | Dispune de sistemul 'Auto [/etp]'"},
                    {"/event1v1", "- In urmatoarele momente va urma un event de tip '1 vs 1', premiul este de $<suma>. | Dispune de sistemul 'Auto [/etp]'"},
                    {"/eventvip", "- In urmatoarele momente va urma un event de tip 'Protect the vip', premiul este de $<suma>."},
                    {"/winner", "- Anunti pe [/anno] 'Jucatorul evenimentului este x.'"},
                    {"/etp", "- Anunti pe [/anno] 'Pentru a participa la eveniment folositi comanda [/etp].'"}
                }


                for _, cmd in ipairs(commands) do
                    imgui.TextColored(dataAdmin.main_color, cmd[1])
                    imgui.SameLine(0, 5)
                    imgui.TextWrapped(cmd[2])
                end
                
                
                imgui.PopStyleColor(3)
            end
--------
            if imgui.CollapsingHeader("Easy Commands") then

                imgui.PushStyleColor(imgui.Col.Button, dataAdmin.main_color)
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5))

                local commands = {
                    {"/get", "- Tragi un jucator la tine."},
                    {"/got", "- Te vei teleporta la jucatorul la care ai dat ultima data [/spec]."},
                    {"/sl", "- Vei da [/slap] jucatorului caruia ai dat ultima data [/spec]."},
                    {"/fr", "- Vei da [/freeze] jucatorului caruia ai dat ultima data [/spec]."},
                    {"/unfr", "- Vei da [/unfreeze] jucatorului caruia ai dat ultima data [/spec]."},
                    {"/sh", "- Vei da [/respawn] jucatorului caruia ai dat ultima data [/spec]."},
                    {"/md", "- Vei da [/mdc] jucatorului caruia ai dat ultima data [/spec]."},
                    {"/mor", "- Vei da [/sethp 0] jucatorului caruia ai dat ultima data [/spec]."},
                    {"/lcc", "- Vei da [/lastchat] jucatorului caruia ai dat ultima data [/spec]."},
                    {"/lpp", "- Vei da [/lp] jucatorului caruia ai dat ultima data [/spec]."},
                    {"/check", "- Vei da [/stats] jucatorului caruia ai dat ultima data [/spec]."}
                }



                for _, cmd in ipairs(commands) do
                    imgui.TextColored(dataAdmin.main_color, cmd[1])
                    imgui.SameLine(0, 5)
                    imgui.TextWrapped(cmd[2])
                end
                
                
                imgui.PopStyleColor(3)
            end
--------
            if imgui.CollapsingHeader("Other Commands") then

                imgui.PushStyleColor(imgui.Col.Button, dataAdmin.main_color)
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5))

                local commands = {
                    {"/hp", "- Iti setezi viata infinita."},
                    {"/vw0 <ID>", "- Iti setezi Virtual World 0."},
                    {"/spawnme", "- Iti dai [/spawn]."},
                    {"/disarmme", "- Iti dai [/disarm]."},
                    {"/specc", "- Folosesti [/spec] si ID-ul nu va ramane salvat."},
                    {"/resetid", "- Resetezi ID-ul salvat in Admin CMD."},
                    {"/gotopaint", "- Iti dai teleport la 'Paint'."},
                    {"/gotocp", "- Iti dai teleport la checkpoint-ul setat pe server."},
                    {"/servers", "- Te conectezi pe un server ce apartine de comunitate."},
                    {"/loginplayers", "- Vezi ce jucatori sunt in conectare."},
                    {"/lvl", "- Vezi jucatorii ce au un anumit level bazat pe o conditie setata de tine."}
                }


                for _, cmd in ipairs(commands) do
                    imgui.TextColored(dataAdmin.main_color, cmd[1])
                    imgui.SameLine(0, 5)
                    imgui.TextWrapped(cmd[2])
                end
                
                
                imgui.PopStyleColor(3)
            end
--------
            if imgui.CollapsingHeader("Spec List Commands") then

                imgui.PushStyleColor(imgui.Col.Button, dataAdmin.main_color)
                imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.8))
                imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(dataAdmin.main_color.x, dataAdmin.main_color.y, dataAdmin.main_color.z, 0.5))

                local commands = {
                    {"/speclist", "- Vizualizezi jucatorii salvati."},
                    {"/resetspeclist", "- Resetezi ID-urile salvate."},
                    {"/spec1", "- Te pui pe jucatorul salvat pe acest slot."},
                    {"/spec2", "- Te pui pe jucatorul salvat pe acest slot."},
                    {"/spec3", "- Te pui pe jucatorul salvat pe acest slot."},
                    {"/sspec", "- Salvezi un jucator in [/speclist]."}
                }



                for _, cmd in ipairs(commands) do
                    imgui.TextColored(dataAdmin.main_color, cmd[1])
                    imgui.SameLine(0, 5)
                    imgui.TextWrapped(cmd[2])
                end
                
                
                imgui.PopStyleColor(3)
            end



        end

        imgui.End()
    end
end

--

function splitTextIntoChunks(text, chunkSize)
    local chunks = {}
    local start = 1
    while start <= #text do
        local chunk = text:sub(start, start + chunkSize - 1)
        table.insert(chunks, chunk)
        start = start + chunkSize
    end
    return chunks
end

-- SERVER
function svAdmins()
    _, id = sampGetPlayerIdByCharHandle(playerPed)
    dataJson = {
        command = "svAdmins",
        adminName = sampGetPlayerNickname(id),
        serverName = getServerName(),
    }

    client:send(json.encode(dataJson))
end

function keyBindsCmd()
    sendInfo("Keybinds:", dataAdmin.main_hex_color)
    for key, value in pairs(keyBinds) do
        sendInfo(key .. " - " .. value, dataAdmin.main_hex_color)
    end
end

function cmdLoginPlayers()
    sampAddChatMessage("{66a3ff}>>{FFFFFF} Jucatori in Login {66a3ff}<<", -1)
    for id = 0, 999 do
        if sampIsPlayerConnected(id) then
            player_level = sampGetPlayerScore(id)
            if player_level == 0 then
               level_name = sampGetPlayerNickname(id)
               player_ping = sampGetPlayerPing(id)
               sampAddChatMessage("({ff4d4d}ID: " .. id .. "{ffffff}) " .. level_name .. " | Ping: " .. player_ping, -1)
            end
        end
    end
end

function cmdLevelCheck(text)
    local args = getArgs(text)
    if checkNumberArgs(args, 2) then
        sendUsage("/lvl <conditie> <level>", dataAdmin.main_hex_color)
        sendUsage("Conditii: '<', '>', '<=', '>=', '=='.", dataAdmin.main_hex_color)
        return
    end

    if args[1] ~= "<" and args[1] ~= ">" and args[1] ~= "<=" and args[1] ~= ">=" and args[1] ~= "==" then
        sendError("Conditie invalida. ('<', '>', '<=', '>=', '==')") 
        return
    end

    level = tonumber(args[2])
    if level <= 0 or level > 999 then
        sendError("Level invalid. (1-999)")
        return
    end

    sampAddChatMessage("{66a3ff}>>{FFFFFF} Jucatori cu level " .. args[1] .. " " .. level .. " {66a3ff}<<", -1)
    for id = 0, 999 do
        if sampIsPlayerConnected(id) then
            player_level = sampGetPlayerScore(id)
            if args[1] == "<" then
                if player_level < level then
                    level_name = sampGetPlayerNickname(id)
                    player_ping = sampGetPlayerPing(id)
                   sampAddChatMessage("({ff4d4d}ID: " .. id .. "{ffffff}) " .. level_name .. " | Level: {99ff99}" .. player_level .. " {ffffff}| Ping: " .. player_ping, -1)
                end
            elseif args[1] == ">" then
                if player_level > level then
                    level_name = sampGetPlayerNickname(id)
                    player_ping = sampGetPlayerPing(id)
                    sampAddChatMessage("({ff4d4d}ID: " .. id .. "{ffffff}) " .. level_name .. " | Level: {99ff99}" .. player_level .. " {ffffff}| Ping: " .. player_ping, -1)
                end
            elseif args[1] == "<=" then
                if player_level <= level then
                    level_name = sampGetPlayerNickname(id)
                    player_ping = sampGetPlayerPing(id)
                    sampAddChatMessage("({ff4d4d}ID: " .. id .. "{ffffff}) " .. level_name .. " | Level: {99ff99}" .. player_level .. " {ffffff}| Ping: " .. player_ping, -1)
                end
            elseif args[1] == ">=" then
                if player_level >= level then
                    level_name = sampGetPlayerNickname(id)
                    player_ping = sampGetPlayerPing(id)
                    sampAddChatMessage("({ff4d4d}ID: " .. id .. "{ffffff}) " .. level_name .. " | Level: {99ff99}" .. player_level .. " {ffffff}| Ping: " .. player_ping, -1)
                end
            elseif args[1] == "==" then
                if player_level == level then
                    level_name = sampGetPlayerNickname(id)
                    player_ping = sampGetPlayerPing(id)
                    sampAddChatMessage("({ff4d4d}ID: " .. id .. "{ffffff}) " .. level_name .. " | Level: {99ff99}" .. player_level .. " {ffffff}| Ping: " .. player_ping, -1)
                end
            else
                return
            end
        end
    end
end




-- dialoguri

function cmdHelpstaff()
    lua_thread.create(function()
        sampShowDialog(1000, "Confirm Helpstaff", "Esti sigur ca vrei sa folosesti comanda [/helpstaff]?\n\n(!) Textul de mai jos va fi afisat pe [/anno]:\nAi o problema/intrebare legata de server? Foloseste comanda [/report], respectiv [/n].", "Yes", "No", 0)
        while sampIsDialogActive(1000) do wait(100) end 
        local _, button, _ = sampHasDialogRespond(1000)
        if button == 1 then
            sendInfo("Anunt postat cu succes. Ai grija sa nu dai altul in scurt timp.", dataAdmin.main_hex_color)
            sampSendChat("/o Ai o problema/intrebare legata de server? Foloseste comanda [/report], respectiv [/n].")
        else
            return -- exit dialog
        end
    end)
end

function cmdServers()
    lua_thread.create(function()
        sampShowDialog(1001, "Select server to connect", "RPG Server\nOG Server\nRPG Beta Server\nOG Beta Server", "Select", "Close", 2)
        while sampIsDialogActive(1001) do wait(100) end 
        local _, button, list, _ = sampHasDialogRespond(1001) 
        if button == 1 then 
            if list == 0 then
                sendInfo("Urmeaza sa te conectezi pe server-ul RPG B-HOOD!", dataAdmin.main_hex_color)
                sampConnectToServer("104.152.142.7", 7777)
                sampSetLocalPlayerName(adminName2)
            elseif list == 1 then
                sendInfo("Urmeaza sa te conectezi pe server-ul OG B-HOOD!", dataAdmin.main_hex_color)
                sampConnectToServer("104.152.142.24", 7777)
                sampSetLocalPlayerName(adminName2)
            elseif list == 2 then
                sendInfo("Urmeaza sa te conectezi pe server-ul Beta RPG B-HOOD!", dataAdmin.main_hex_color)
                sampConnectToServer("104.152.142.7", 8888)
                sampSetLocalPlayerName(adminName2)
            elseif list == 3 then
                sendInfo("Urmeaza sa te conectezi pe server-ul Beta OG B-HOOD!", dataAdmin.main_hex_color)
                sampConnectToServer("104.152.142.24", 8888)
                sampSetLocalPlayerName(adminName2)
            end
        else 
            return -- exit dialog
        end
    end)
end
