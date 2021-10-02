local window


addEvent("open:login", true)
addEventHandler("open:login", root,
function()

    --- Components

    showChat(false)
    showCursor(true)
    setPlayerHudComponentVisible("all",false)
    guiSetInputMode("no_binds")

    local x, y, width, height = getWindowSize(400,230)

    -- WINDOW 
    window = guiCreateWindow( x, y, width, height, "Welcome to AndresTVz Server", false)
    guiWindowSetMovable(window,false)
    guiWindowSetSizable(window,false)

    -- USERNAME

    local userLabel = guiCreateLabel( 15, 30, width - 20, 30, "Username", false, window)
    local userEdit = guiCreateEdit( 15, 50, width - 20, 30, "", false, window)



    -- PASSWORD

    local passLabel = guiCreateLabel( 15, 90, width - 20, 30, "Password", false, window)
    local passEdit = guiCreateEdit( 15, 110, width - 20, 30, "", false, window)
    guiEditSetMasked(passEdit,true)


    

    -- BUTTONS


    local loginButton = guiCreateButton( 15, 150, width - 10 , 30, "Login", false, window)

    -- LOGIN BUTTON FUNCTION
    addEventHandler("onClientGUIClick", loginButton, function(button,state)
        if button ~= "left" and state ~= "up" then
            return
        end    
        local username = guiGetText(userEdit)
        local password = guiGetText(passEdit)
        if charMin(username) and charMin(password)  then
            triggerServerEvent("auth:login", localPlayer, username, password)
        end
    end)

    -- REGISTER BUTTON FUNCTION

    local registerButton = guiCreateButton( 15, 190, width - 10 , 30, "Register", false, window)

    addEventHandler("onClientGUIClick", registerButton, function(button,state)
        if button ~= "left" and state ~= "up" then
            return
        end
        local username = guiGetText(userEdit)
        local password = guiGetText(passEdit)
        if charMin(username) and charMin(password) and passMin(password) then
            triggerServerEvent("auth:register", localPlayer, username, password)
        end

    end)

end)


addEventHandler("onClientResourceStart", resourceRoot,
function()
    triggerEvent("open:login", localPlayer)
end)

addEvent("close:login",true)
addEventHandler("close:login", root,
function()
    destroyElement(window)
    showCursor(false)
    showChat(true)
    guiSetInputMode("allow_binds")
end)

function getWindowSize(width, height)
    local screen = Vector2(guiGetScreenSize())
    local x, y = (screen.x / 2) - (width / 2), (screen.y / 2) - (height / 2)
    return x, y, width, height
end

function charMin(value) return type(value) == "string" and string.len(value) > 1 end
function passMin(value) return string.len(value) > 6 end
