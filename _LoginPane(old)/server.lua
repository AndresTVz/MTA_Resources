addEvent("auth:login",true)
addEventHandler("auth:login", root,
function(username,password)
    logOut(source)
    local account = getAccount(username,password)
    if account then
        if logIn(source,account,password) then
            -- NOTIFICATIONS
            triggerClientEvent(source,"add:notification",source,"Successfully logIn", "success", true)
            triggerClientEvent(source,"add:notification",source,"Welcome "..getPlayerName(source) , "success", true)
            
            -- CLOSE THE LOGINPANEL
            triggerClientEvent(source,"close:login",source)
        end
    else
        triggerClientEvent(source,"add:notification",source,"Invalid username or password, try again!", "error", true)
    end
end)


addEvent("auth:register",true)
addEventHandler("auth:register", root,
function(username,password)
    local account = getAccount( username )
    if not account then
        if addAccount(username,password)then 
            -- NOTIFICATIONS
            triggerClientEvent(source,"add:notification",source,"Successfully Register", "success", true)
            -- CLOSE THE LOGINPANEL
            triggerClientEvent(source,"close:login",source)
        end
    else
        triggerClientEvent(source,"add:notification",source,"This user already exist!", "error", true)
    end
end)
