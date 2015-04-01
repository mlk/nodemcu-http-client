local simplewificonfig = {}

simplewificonfig.connected = false

function simplewificonfig.setupWifiMode(action)
    if simplewificonfig.connected  then
        action();
        return;
    end
    
    local json = require "cjson"
    file.open("wifi_settings.json","r")
    local theSettings = file.read()
    local settings = json.decode(theSettings)
    file.close()
    
    print("set up wifi mode")
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
