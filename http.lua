local http = {}

function http.parseUrl(url)
    components = {}
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
    components = http.parseUrl(url)
    if components.port == nil then
        components.port = 80
    else
        components.port = to_number(components.port)
    end
    if components.pathAndQueryString == nil or components.pathAndQueryString == "" then
        components.pathAndQueryString = "/"
    end
    
    print("path: " .. components.pathAndQueryString)
    
    conn=net.createConnection(net.TCP, false) 
    conn:on("connection", function(conn) 
        conn:send("GET " .. components.pathAndQueryString .. " HTTP/1.1\r\nHost: " .. components.host .. "\r\n"
            .. "Accept: */*\r\n\r\n")
    end)
    conn:on("receive", function(conn, pl)
        local location = string.find(pl, "\r\n\r\n")
        local data = nil
        if location ~= nil then
            data = string.sub(pl, location + 4)
        end
        callWithData(data)
        conn:close()
        conn = nil
    end)
    conn:connect(components.port, components.host)
end



return http
