local simplewificonfig = require 'simplewificonfig'
local http = require 'http'
local json = require "cjson"
--  Sample of using the Dweet.IO API to publish Dweets and read in the latest dweet.
--  NOTE: At the moment the http API does not support chunked responses. As such the 
-- "listen" API from dweet.io is not supported.

simplewificonfig.setupWifiMode(function(ip) 
    print("My IP is: " .. ip)

    http.postContent("http://dweet.io/dweet/for/esp-test", "{\"content\": true}", "application/json", function(data) 
        local result = json.decode(data.content)
        print("the post " .. result.this)
    end)

    http.getContent("http://dweet.io/get/latest/dweet/for/esp-test", function(data) 
        local result = json.decode(data.content)
        print("the get " .. result.this .. " on " .. result.with[1].created .. " with the content " )
        print(result.with[1].content.content)
    end)

end)
    