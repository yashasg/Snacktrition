local networking={}

local myText =display.newText( "", 0, 0, native.systemFont, 12 )
        myText.x = 50 ; myText.y = 450
        myText:setFillColor( 1, 1, 1 )
        myText.anchorX = 0

local json = require("json")
local http = require("socket.http")
local ltn12 = require("ltn12")
local storyboard = require( "storyboard" )
function networking.SandwitchComplete(i_status)
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
  if(responseTable.Name=="done") then
    myText.text=""
    storyboard.gotoScene( "scene_results" )
end


end


 function networking.RequestASandwitch(i_Sandwitch)
  local URL = "http://localhost:60000/BoggleService.svc/games"

  local headers = {}

  local body={
  Name=i_Sandwitch
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
         print("Body = ", body)
         print("code = ", code)
         print("headers = ", headers[1])
         responseTable=json.decode(response_body[1])
        print("response body = ",responseTable.Name )

end



function networking.joinGame(i_userToken)
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
 function networking.connectToServer(name)

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



        -- Change the text

      networking.joinGame(responseTable.UserToken)

end

return networking
