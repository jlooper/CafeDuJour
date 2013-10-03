local json = require("json")
local mime = require("mime")

APPID = 'your-app-id'
RESTAPIKEY = 'your-rest-api-key'

local homePageImages = {}
local image,suffix

local function init()

    local function networkListener( event )
                
        if ( event.isError ) then
            print( "Network error - download failed" )
        elseif ( event.phase == "ended" ) then
            print( "displaying response image file" )                           
         
            image = display.newImageRect( "bg.png", system.TemporaryDirectory, 360, 570 )
            image:setReferencePoint( display.CenterReferencePoint )
            image.x = display.contentCenterX
            image.y = display.contentCenterY
   
                
        end
    end

	local function parseNetworkListener(event)

        t = json.decode(event.response)
        r = t.results
        
        for i=1,#r do
            --print(r[i].background_image.url)
            t = r[i].background_image.url
            
            if i == 1 then
                suffix = ".png"           
            elseif i == 2 then
                suffix = "@2x.png"
            elseif i == 3 then
                suffix = "@4x.png"
            end

        local params = {}
        params.progress = true

            network.download(
                t,
                "GET",
                networkListener,
                params,
                "bg"..suffix,
                system.TemporaryDirectory
            )
                
        end
                
     end

        headers = {}
        headers["X-Parse-Application-Id"] = APPID
        headers["X-Parse-REST-API-Key"] = RESTAPIKEY
        headers["Content-Type"] = "application/json"

        local params = {}
        params.headers = headers
 
        network.request( "https://api.parse.com/1/classes/coffee" ,"GET", parseNetworkListener,  params)


end

    
  

init()

            