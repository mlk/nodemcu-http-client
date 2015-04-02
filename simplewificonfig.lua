local simplewificonfig = {}

simplewificonfig.connected = false

function simplewificonfig.setupWifiMode(action)
    if wifi.sta.getip() ~= nil  then
        action(wifi.sta.getip())
        return
    end
    
    local json = require "cjson"
    file.open("wifi_settings.json","r")
    local theSettings = file.read()
    local settings = json.decode(theSettings)
    file.close()
    
    wifi.setmode(wifi.STATION)
    wifi.sta.config(settings.sid,settings.password)
    
    wifi.sta.connect()
    tmr.alarm(1, 1000, 1, function()
        if wifi.sta.getip() ~= nil then
            simplewificonfig.connected = true
            tmr.stop(1)
            action(wifi.sta.getip())
        end
    end) 
end     

return simplewificonfig 
