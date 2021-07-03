------------    SCRIPT CREATED BY ANDRESTVZ   -------------------
-- SUBSCRIBE TO MY CHANNEL https://www.youtube.com/c/AndresTVz --
------------    PLEASE NOT REMOVE THIS LINES  -------------------

addCommandHandler("chat",
function(player,cmd,text)

    local error = {syntax = "[#ff0000ERROR#ffffff] Syntax:"}
    local status = string.lower(text)
    local level = getElementData(player,"admin:level")

    -- SI ES ADMIN PODRA REALIZAR LA ACCION --
    if level == 4 then
        -- SI EL TEXTO ESTA VACIO RETORNA ERROR DE SYNTAX --
        if not text then
            return outputChatBox(error.syntax.." /chat [clear/on/off]",player,255,255,255,true)
        end
        if status == "clear" then
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox(" ")
            outputChatBox("Chat #FF0000Cleared #FFFFFF by "..getPlayerName(player).."#FFFFFF.",getRootElement(),255,255,255,true)
        elseif status == "off" then
            outputChatBox("Chat #FF0000OFF #FFFFFF by "..getPlayerName(player).."#FFFFFF.",getRootElement(),255,255,255,true)
		    addEventHandler("onPlayerChat",root,chatOFF)
        elseif status == "on" then 
		    removeEventHandler("onPlayerChat",root,chatOFF)
            outputChatBox("Chat #00FF00ON #FFFFFF by "..getPlayerName(player).."#FFFFFF.",getRootElement(),255,255,255,true)
        end
    else
        outputChatBox("Access Denied",jugador)
    end
end)

chatOFF = function() cancelEvent() outputChatBox("*** #ff0000CHAT DISABLE #ffffff***",player,255,255,255,true) end


-- GUARDA LOS RANGOS DENTRO DEL ELEMENTO JUGADOR --

saveAllPlayersAdmin = function()
    for _, jugador in pairs(getElementsByType("player"))do
        local cuenta = getPlayerAccount(jugador)
        local admLvl = getAdminLevel(cuenta)
        if admLvl > 1 then
            setElementData(jugador,"admin:level", admLvl)
        end
    end
end


-- VERIFICA EL RANGO DEL JUGADOR --

getAdminLevel = function(account)
    local accName = getAccountName(account)
    if isObjectInACLGroup("user."..accName, aclGetGroup("Admin")) then 
        return 4
    elseif isObjectInACLGroup("user."..accName, aclGetGroup("SuperModerator")) then 
        return 3
    elseif isObjectInACLGroup("user."..accName, aclGetGroup("Moderator")) then 
        return 2
    end
    return 1
end


addEventHandler("onResourceStart",resourceRoot,
function(_,account)
    saveAllPlayersAdmin()
end)
