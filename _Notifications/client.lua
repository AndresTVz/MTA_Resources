local sx, sy = guiGetScreenSize();
local relativeScale, relativeFontScale = math.min(math.max(sx/1600,0.5),1), math.min(math.max(sx/1600,0.85),1);




local colors = {
    default = {255,255,255},
    success = {5,255,5},
    info = {0,55,255},
    warn = {255,255,55},
    error = {255,55,0},
}


local notifications = {}

notifications.list = {} -- here u save all notifications

-- DESIGN -- 
notifications.padding = 10
notifications.offset = 90 * relativeScale
notifications.offsetWidth = 5
-- TEXT
notifications.font = "default-bold"
notifications.fontScale = 1 * relativeFontScale
notifications.fontHeight = dxGetFontHeight(notifications.fontScale,notifications.font)

notifications.width, notifications.height = math.floor(360 * relativeScale), math.floor(notifications.fontHeight + notifications.padding * 2)
-- SETTINGS
notifications.max = 6 -- MAX NOTIFICATIONS TO SHOW
notifications.interpolator = "Linear" -- interpolator
notifications.timeMaxToShow = 2500 -- mseconds


local math_min = math.min

function addNotification(text,type,animate)

	
	if not (text and type and animate)then 
        return outputDebugString("Syntax Error: \n --->> ( \"text\", Type: [\"default,success,info,warn,error\"], animate [true o false])",4)
    end

    local notification = {}
    local description = text


    -- TIMERS
    notification.appearTick = getTickCount()
    notification.animationTick = getTickCount()

    notification.fadeTick = getTickCount()
    notification.progressFade = 0
    notification.progressFadeToGo = 1

    notification.alphaTick = 0
    notification.progressAlpha = 0
    notification.progressAlphaToGo = 0

    notification.display = true -- if not show the notifications the value for default = true

    notification.text = description:gsub("#%x%x%x%x%x%x", "") -- CLEAN TEXT OF COLOR CODE #FFFFFF
    notification.offset = notifications.offset
    notification.animate = animate and true or false

    notification.textWidth = dxGetTextWidth(notification.text,notifications.fontScale,notifications.font) -- WITH THIS U HAVE THE LEN OF THE TEXT IN PX

    notification.width = notification.textWidth + notifications.padding * 3
    notification.height = notifications.height
    notification.offsetX = sx - ( notification.width + notifications.offsetWidth)
    notification.color = type


    table.insert(notifications.list, 1, notification) -- is important the second value.
    --iprint(notification)

    if #notifications.list > notifications.max then
        for i , notification in pairs(notifications.list)do
            if i > notifications.max and notification.display then
                notification.fadeTick = getTickCount()
                notification.alphaTick = getTickCount()
                notification.display = false
            end
        end
    elseif #notifications.list == 1 then 
        addEventHandler("onClientRender",root,drawNotification)
    end
end
addEvent("add:notification",true)
addEventHandler("add:notification",localPlayer,addNotification)

function drawNotification()

    local currentTick = getTickCount()
    local offsetY = notifications.offset


    for i, notification in pairs(notifications.list)do

		-- SI SE CUMPLE ESTA FUNCION CORRE EL CONTADOR PARA APARECER LA NOTIFICACION 
		if currentTick - notification.appearTick > notifications.timeMaxToShow and notification.display then
			notification.alphaTick = getTickCount()
			notification.display = false
		end


		local fadeTick = notification.fadeTick or 0
		notification.progressFade = interpolateBetween(notification.progressFade or 0, 0, 0, notification.progressFadeToGo, 0, 0, math_min(1000, currentTick - fadeTick)/1000, notifications.interpolator)
		if notification.display and notification.progressFade >= 0.8 and notification.progressAlphaToGo == 0 then
			notification.alphaTick = getTickCount()
			notification.progressAlphaToGo = 1
		end

		-- desvanecer
		local alphaTick = notification.alphaTick or 0
		notification.progressAlpha= interpolateBetween(notification.progressAlpha or 0, 0, 0, notification.display and notification.progressAlphaToGo or 0, 0, 0, math_min(2000, currentTick - alphaTick)/2000, notifications.interpolator)
		if not notification.display and notification.progressAlpha <= 0.2 and notification.progressFadeToGo == 1 then
			notification.fadeTick = getTickCount()
			notification.progressFadeToGo = 0
		end	


        local r,g,b = colors[notification.color][1] or 255, colors[notification.color][2] or 255, colors[notification.color][3] or 255

        dxDrawCurvedRectangle(notification.offsetX, offsetY, notification.width, notification.height, tocolor(0,0,0,190 * notification.progressFade * notification.progressAlpha), true )
        dxDrawStartCurvedRectangle(notification.offsetX, offsetY, notification.width, notification.height, tocolor(r,g,b,255 * notification.progressFade * notification.progressAlpha), true )

        dxDrawText(notification.text, notification.offsetX, offsetY, notification.offsetX + notification.width, offsetY + notification.height, tocolor(255,255,255,255 * notification.progressFade * notification.progressAlpha),notifications.fontScale, notifications.font,"center","center", false,false,true,true)
        
        offsetY = math.ceil(offsetY + notification.height + notifications.offsetWidth)

        if not notification.display and notification.progressAlpha == 0 then
            notifications.list[i] = nil
            if #notifications.list == 0 then
                removeEventHandler("onClientRender", root, drawNotification)
                outputDebugString("["..getResourceName(getThisResource()).."] Notifications were removed.",4)
            end
        end
    end
end



-- THIS FUNCTION IS FOR MAKE A  Curved Rectangle
function dxDrawCurvedRectangle(x, y, width, height, color, postGUI)
	if type(x) ~= "number" or type(y) ~= "number" or type(width) ~= "number" or type(height) ~= "number" then
		return
	end
	local color = color or tocolor(114, 137, 218, 255)
	local postGUI = type(postGUI) == "boolean" and postGUI or false
	local edgeSize = height/2
	width = width - height
	dxDrawImageSection(x, y, edgeSize, edgeSize, 0, 0, 33, 33, "img/edge.png", 0, 0, 0, color, postGUI)
	dxDrawImageSection(x, y + edgeSize, edgeSize, edgeSize, 0, 33, 33, 33, "img/edge.png", 0, 0, 0, color, postGUI)
	dxDrawImageSection(x + width + edgeSize, y, edgeSize, edgeSize, 43, 0, 33, 33, "img/edge.png", 0, 0, 0, color, postGUI)
	dxDrawImageSection(x + width + edgeSize, y + edgeSize, edgeSize, edgeSize, 43, 33, 33, 33, "img/edge.png", 0, 0, 0, color, postGUI)

	if width > 0 then
		dxDrawImageSection(x + edgeSize, y, width, height, 33, 0, 10, 66, "img/edge.png", 0, 0, 0, color, postGUI)
	end
end

-- THIS FUNCTION IS FOR MAKE A  Start Curved Rectangle
function dxDrawStartCurvedRectangle(x, y, width, height, color, postGUI)
	if type(x) ~= "number" or type(y) ~= "number" or type(width) ~= "number" or type(height) ~= "number" then
		return
	end
	local color = color or tocolor(114, 137, 218, 255)
	local postGUI = type(postGUI) == "boolean" and postGUI or false
	local edgeSize = height/2
	width = width - height
	dxDrawImageSection(x, y, edgeSize, edgeSize, 0, 0, 33, 33, "img/startedge.png", 0, 0, 0, color, postGUI)
	dxDrawImageSection(x, y + edgeSize, edgeSize, edgeSize, 0, 33, 33, 33, "img/startedge.png", 0, 0, 0, color, postGUI)
	dxDrawImageSection(x + width + edgeSize, y, edgeSize, edgeSize, 43, 0, 33, 33, "img/startedge.png", 0, 0, 0, color, postGUI)
	dxDrawImageSection(x + width + edgeSize, y + edgeSize, edgeSize, edgeSize, 43, 33, 33, 33, "img/startedge.png", 0, 0, 0, color, postGUI)

	if width > 0 then
		dxDrawImageSection(x + edgeSize, y, width, height, 33, 0, 10, 66, "img/startedge.png", 0, 0, 0, color, postGUI)
	end
end
