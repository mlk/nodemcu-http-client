function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local simplewificonfig = require 'simplewificonfig'

simplewificonfig.setupWifiMode(function(ip) 
    print("My IP is: " .. ip)
    print(node.heap())
    local subject = require 'http'
    local espUnit = require 'espUnit'
    print(node.heap())
    
    local testHttp = {} 


    function testHttp.testGetContentOnSmallPlainText(assertHelper) 
        assertHelper.callback = true
        content = subject.getContent("http://pi.michael-lloyd-lee.me.uk/nodemcu/test.txt", function(data)
            assertHelper.areEqual("Hello", trim(data.content))
            assertHelper.areEqual("200", trim(data.status))
            assertHelper.printResults()
        end)        
    end
    
    function testHttp.test404Return404Content(assertHelper) 
        assertHelper.callback = true
        content = subject.getContent("http://pi.michael-lloyd-lee.me.uk/nodemcu/idontexist", function(data)
            assertHelper.contains("404", data.content)
            assertHelper.areEqual("404", trim(data.status))
            assertHelper.printResults()
        end)            
    end

    function testHttp.testPost(assertHelper) 
        assertHelper.callback = true
        content = subject.postContent("http://pi.michael-lloyd-lee.me.uk/nodemcu/test.php", "name=Michael", nil, function(data)
            assertHelper.areEqual("Hello Michael!", trim(data.content))
            assertHelper.areEqual("200", trim(data.status))
            assertHelper.printResults()
        end)            
    end
    
    espUnit.runTests(testHttp) 
end)
