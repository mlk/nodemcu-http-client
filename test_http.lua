function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local simplewificonfig = require 'simplewificonfig'

simplewificonfig.setupWifiMode(function(ip) 
    print("My IP is: " .. ip)
    
    local subject = require 'http'
    local espUnit = require 'espUnit'
    local testHttp = {}

    function testHttp.testGetContentOnSmallPlainText(assertHelper) 
        assertHelper.callback = true
        content = subject.getContent("http://pi.michael-lloyd-lee.me.uk/nodemcu/test.txt", function(content)
            assertHelper.areEqual("Hello", trim(content))
            assertHelper.printResults()
        end)        
    end
    
    function testHttp.test404Return404Content(assertHelper) 
        assertHelper.callback = true
        content = subject.getContent("http://pi.michael-lloyd-lee.me.uk/nodemcu/idontexist", function(content)
            assertHelper.contains("404", content)
            assertHelper.printResults()
        end)            
    end
    
    espUnit.runTests(testHttp) 
end)
