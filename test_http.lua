function areEqual(expected, actual) 
    if expected ~= actual then
        if expected == nil then
            expected = "<nil>"
        end
        if actual == nil then
            actual = "<nil>"
        end
        print("**** TEST FAILED ****")
        print("   expected \"" .. expected .. "\" actual \"" .. actual .. "\"")
    end
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

swc = require 'simplewificonfig'

swc.setupWifiMode(function(ip) 
print("My IP is: " .. ip)
local http = require 'http'
url = http.parseUrl("http://thingies.com/hello")
areEqual("http", url.scheme)
areEqual("thingies.com", url.host)
areEqual("/hello", url.pathAndQueryString)
areEqual(nil, url.port)

print("test: with port")
url = http.parseUrl("http://thingies.com:80/hello")
areEqual("http", url.scheme)
areEqual("thingies.com", url.host)
areEqual("/hello", url.pathAndQueryString)
areEqual("80", url.port)

print("test: no path")
url = http.parseUrl("http://thingies.com")
areEqual("http", url.scheme)
areEqual("thingies.com", url.host)
areEqual("", url.pathAndQueryString)
areEqual(nil, url.port)

print("test: no path with port")
url = http.parseUrl("http://thingies.com:80")
areEqual("http", url.scheme)
areEqual("thingies.com", url.host)
areEqual("", url.pathAndQueryString)
areEqual("80", url.port)

print("test: ip")
url = http.parseUrl("http://10.0.0.0")
areEqual("http", url.scheme)
areEqual("10.0.0.0", url.host)
areEqual("", url.pathAndQueryString)
areEqual(nil, url.port)

print("test: path")
url = http.parseUrl("http://pi.michael-lloyd-lee.me.uk/nodemcu/test.txt")
areEqual("http", url.scheme)
areEqual("pi.michael-lloyd-lee.me.uk", url.host)
areEqual("/nodemcu/test.txt", url.pathAndQueryString)
areEqual(nil, url.port)


content = http.getContent("http://pi.michael-lloyd-lee.me.uk/nodemcu/test.txt", function(content)
    print("test: getContent on small plain text")
    areEqual("Hello", trim(content))
end)

end)
