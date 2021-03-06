---------------------------------------------------------------------------------
-- SCENE NAME
-- Scene notes go here
---------------------------------------------------------------------------------
local widget =require("widget")
local storyboard = require( "storyboard" )
local networking=require("networking")
local scene = storyboard.newScene()

-- Clear previous scene
storyboard.removeAll()

-- local forward references should go here --
local myText =display.newText( "", 0, 0, native.systemFont, 12 )
        myText.x = 50 ; myText.y = 50
        myText:setFillColor( 1, 1, 1 )
        myText.anchorX = 0
local breadButton
local cheeseButton
local backButton
local doneButton
local imageTable={}
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
--connect to the server to authenticate user

--check sandwich status

local function SandwitchComplete(i_status)
  local URL = "http://localhost:60000/BoggleService.svc/games"

  local headers = {}

  local body={
  Name=i_status
  }
  headers["Content-Type"] = "application/json"
  headers["application-type"] = "REST"
  headers["Content-Length"] = string.len(json.encode( body ))

  local params = {}
  params.headers = headers
  params.body=json.encode( body )
  print(params.headers)
  print(params.body)


  response_body = {}
         local body, code, headers = http.request{
                             url = URL ,
                             method = "PUT",
                             headers = params.headers,
                             source = ltn12.source.string(params.body),
                             sink = ltn12.sink.table(response_body)
                             }
         responseTable=json.decode(response_body[1])
        print("response body = ",responseTable.Name )
  if(responseTable.Name=="Cheese Sandwich") then
  myText.text="make a ".. responseTable.Name
  end
  if(i_status=="done") then
      storyboard.gotoScene( "scene_results" )
    end
end


local function joinGame(i_userToken)
  local URL = "http://localhost:60000/BoggleService.svc/games"

  local headers = {}

  local body={
  UserToken=i_userToken
  }
  headers["Content-Type"] = "application/json"
  headers["application-type"] = "REST"
  headers["Content-Length"] = string.len(json.encode( body ))

  local params = {}
  params.headers = headers
  params.body=json.encode( body )
  print(params.headers)
  print(params.body)


  response_body = {}
         local body, code, headers = http.request{
                             url = URL ,
                             method = "POST",
                             headers = params.headers,
                             source = ltn12.source.string(params.body),
                             sink = ltn12.sink.table(response_body)
                             }
         print("Body = ", body)
         print("code = ", code)
         print("headers = ", headers[1])
         responseTable=json.decode(response_body[1])
        print("response body = ",responseTable.GameID )




end
local function connectToServer(name)

  local URL = "http://localhost:60000/BoggleService.svc/users"

  local headers = {}

  local body={
  Nickname=name
  }
  headers["Content-Type"] = "application/json"
  headers["application-type"] = "REST"
  headers["Content-Length"] = string.len(json.encode( body ))

  local params = {}
  params.headers = headers
  params.body=json.encode( body )
  print(params.headers)
  print(params.body)


  response_body = {}
         local body, code, headers = http.request{
                             url = URL ,
                             method = "POST",
                             headers = params.headers,
                             source = ltn12.source.string(params.body),
                             sink = ltn12.sink.table(response_body)
                             }
         print("Body = ", body)
         print("code = ", code)
         print("headers = ", headers[1])
         responseTable=json.decode(response_body[1])
        print("response body = ",responseTable.UserToken )

      joinGame(responseTable.UserToken)

end

local function handleButtonEventBread(event)
  local phase=event.phase
  if "ended"==phase then
    table.insert(imageTable,display.newImageRect( "bread.png", 200, 200 ))
    imageTable[#imageTable].x=display.contentCenterX
    imageTable[#imageTable].y= display.contentCenterY
    myText.text="Bread gives you instant energy"
  end
end

local function handleButtonEventCheese(event)
  local phase=event.phase
  if "ended"==phase then
    table.insert(imageTable,display.newImageRect( "cheese.png", 200, 200 ))
    imageTable[#imageTable].x=display.contentCenterX
    imageTable[#imageTable].y= display.contentCenterY
    myText.text="Cheese makes your bones strong"
  end
end

local function handleButtonEventBack(event)
  local phase=event.phase
  if "ended"==phase then
    storyboard.gotoScene( "scene_splash" )
  end
end

local function handleButtonEventDone(event)
  local phase=event.phase
  if "ended"==phase then
  networking.SandwitchComplete("done")
  end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view
  networking.connectToServer("child")

  breadButton=widget.newButton({
   left=10,
    top=100,
    width=50,
    height=50,
    defaultFile="bread.png",
    onEvent=handleButtonEventBread
  })

  cheeseButton=widget.newButton({
    left=10,
     top=160,
     width=50,
     height=50,
    defaultFile="cheese.png",
    onEvent=handleButtonEventCheese
  })
  backButton=widget.newButton({
   left=10,
    top=400,
    width=50,
    height=50,
    defaultFile="button.png",
    label="Back",
    onEvent=handleButtonEventBack
  })
  doneButton=widget.newButton({
   left=220,
    top=400,
    width=50,
    height=50,
    defaultFile="button.png",
    label="done",
    onEvent=handleButtonEventDone
  })

  local myClosure = function() return networking.SandwitchComplete( "" ) end

  timer.performWithDelay( 2000, myClosure,0)

end


-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
  local group = self.view

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view

  group:insert( myText )
  group:insert(breadButton)
  group:insert(cheeseButton)

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view
  for i=1,#imageTable do
    imageTable[i]:removeSelf()
  end

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
  local group = self.view

end


-- Called prior to the removal of scene's "view" (display view)
function scene:destroyScene( event )
  local group = self.view

end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
  local group = self.view
  local overlay_name = event.sceneName  -- name of the overlay scene

end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
  local group = self.view
  local overlay_name = event.sceneName  -- name of the overlay scene

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene
