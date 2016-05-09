---------------------------------------------------------------------------------
-- SCENE NAME
-- Scene notes go here
---------------------------------------------------------------------------------
local json = require("json")
local http = require("socket.http")
local ltn12 = require("ltn12")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Clear previous scene
storyboard.removeAll()

-- local forward references should go here --
local myText
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
--connect to the server to authenticate user
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
        print("response body = ", response_body[1])

        myText = display.newText( "Hello", 0, 0, native.systemFont, 12 )
        myText.x = 50 ; myText.y = 50
        myText:setFillColor( 1, 1, 1 )
        myText.anchorX = 0

        -- Change the text
        if code==201 then
        myText.text =name.. " Connected"
      end

end

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view
  connectToServer("mom")

end


-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
  local group = self.view

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view

  group:insert( myText )

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view

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