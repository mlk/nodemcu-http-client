local testUrl = {}

local subject = require 'http'
local espUnit = require 'espUnit'

function testUrl.testBasicUrl(assertHelper) 
    local url = subject.parseUrl("http://thingies.com/hello")
    assertHelper.areEqual("http", url.scheme)
    assertHelper.areEqual("thingies.com", url.host)
    assertHelper.areEqual("/hello", url.pathAndQueryString)
    assertHelper.areEqual(nil, url.port)
end

function testUrl.testBasicUrlWithPort(assertHelper) 
    local url = subject.parseUrl("http://thingies.com:80/hello")
    assertHelper.areEqual("http", url.scheme)
    assertHelper.areEqual("thingies.com", url.host)
    assertHelper.areEqual("/hello", url.pathAndQueryString)
    assertHelper.areEqual("80", url.port)
end

function testUrl.testBasicUrlWithNoUrl(assertHelper)
    url = subject.parseUrl("http://thingies.com")
    assertHelper.areEqual("http", url.scheme)
    assertHelper.areEqual("thingies.com", url.host)
    assertHelper.areEqual("", url.pathAndQueryString)
    assertHelper.areEqual(nil, url.port)
end

function testUrl.testUrlWithNoUrlAndWithPort(assertHelper) 
    local url = subject.parseUrl("http://thingies.com:80")
    assertHelper.areEqual("http", url.scheme)
    assertHelper.areEqual("thingies.com", url.host)
    assertHelper.areEqual("", url.pathAndQueryString)
    assertHelper.areEqual("80", url.port)
end

function testUrl.testIpAddress(assertHelper) 
    local url = subject.parseUrl("http://10.0.0.0")
    assertHelper.areEqual("http", url.scheme)
    assertHelper.areEqual("10.0.0.0", url.host)
    assertHelper.areEqual("", url.pathAndQueryString)
    assertHelper.areEqual(nil, url.port)
end

function testUrl.testLongPath(assertHelper) 
    local url = subject.parseUrl("http://pi.michael-lloyd-lee.me.uk/nodemcu/test.txt")
    assertHelper.areEqual("http", url.scheme)
    assertHelper.areEqual("pi.michael-lloyd-lee.me.uk", url.host)
    assertHelper.areEqual("/nodemcu/test.txt", url.pathAndQueryString)
    assertHelper.areEqual(nil, url.port)
end
 
espUnit.runTests(testUrl) 

testUrl = nil
