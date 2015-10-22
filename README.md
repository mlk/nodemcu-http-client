# nodemcu-http-client
Basic HTTP client written in eLua for the NodeMCU [ http://nodemcu.com/index_en.html ] IoT firmware.

This currently supports enough of HTTP 1.0 for it to be able to interact with web servers.

# Example

```
local http = require 'http'

http.postContent("http://example.com/example-post", "{\"content\": true}", "application/json", function(data) 
    print("Returned Status: " .. data.status)
    print("Returned Content " .. data.content)
end)


```

# LICENSE

This software is under an MIT-style license. This means you can do as you wish with it, but you should including the LICENSE file. 
