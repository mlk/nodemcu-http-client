local http = {}

function http.parseUrl(url)
    local components = {}
    components.scheme = string.match(url, "([^:]*):")
    components.host = string.match(url, components.scheme .. "://([^:/]*)[:/]?")
    components.port = string.match(url, components.scheme .. "://" .. components.host .. ":([%d]*)")
    baseUrl = components.scheme .. "://" .. components.host
    if components.port ~= nil then
        baseUrl = baseUrl .. ":" .. components.port
    end
    components.pathAndQueryString = string.sub(url, string.len(baseUrl) + 1)
    return components
end

function http.getContent(url, callWithData)
    local components = http.parseUrl(url)
    if components.port == nil then
        components.port = 80
    else
        components.port = to_number(components.port)
    end
    if components.pathAndQueryString == nil or components.pathAndQueryString == "" then
        components.pathAndQueryString = "/"
    end
    
    
    local conn=net.createConnection(net.TCP, false) 
    conn:on("connection", function(conn) 
        conn:send("GET " .. components.pathAndQueryString .. " HTTP/1.1\r\nHost: " .. components.host .. "\r\n"
            .. "Accept: */*\r\n\r\n")
    end)
    conn:on("receive", function(conn, pl)        
        local data = nil
        local location = string.find(pl, "\r\n\r\n")        
        if location ~= nil then
            data = string.sub(pl, location + 4)
        end
        pl = nil
        collectgarbage()
        conn:close()
        
        callWithData(data)
        
        conn = nil
        data = nil
    end)
    conn:connect(components.port, components.host)
end

return http
