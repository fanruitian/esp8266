wifi.setmode(wifi.SOFTAP)
cfg      = {}
cfg.ssid = "Newind_"..node.chipid()
cfg.pwd  = "0123456789"
wifi.ap.config(cfg)
print(wifi.ap.getip())






html = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>\r\n"
        .."<meta name='viewport' content='width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui'>\r\n"
        .."<form action='' method='post'>"
        .."<table>"
        .."<tr>"
        .."<td>SSID:</td>"
        .."<td><input name='ssid' type='text' /></td>"
        .."</tr>"
        .."<tr>"
        .."<td>PASSWORD:</td>"
        .."<td><input name='password' type='password' /></td>"
        .."</tr>"
        .."<tr>"
        .."<td><input name='OK' type='submit' value='OK' /></td>"
        .."</tr>"
        .."</table>"
        .."</form>"

--  http server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
        --print(payload)
        setstate = "..."
        k        = string.find(payload,"ssid")
        if k then
            str=string.sub(payload,k)
            --print(str)
            m = string.find(str,"&")
            n = string.find(str,"&",m+1)            
            -- print(m)
            strssid = 'ssid='..'"'..string.sub(str,6,(m-1))..'"'
            ssid    =  string.sub(str,6,(m-1))
            print(strssid)
           -- print(n)
            strpass  = 'password="'..string.sub(str,(m+10),n-1)..'"'
            password = string.sub(str,(m+10),n-1)
            print(strpass)

            file.remove("info.lua")
            file.open("info.lua","w+")
            file.writeline(strssid)
            file.writeline(strpass)
            file.writeline("configed = '1'")        
            file.close()
            print("store ok")
            node.restart()
        end
        conn:send("HTTP/1.1 200 OK\r\n"
        .."Content-Length: "..string.len(html).."\r\n"
        .."Content-Type: text/html\r\n\r\n"
        ..html
        )
        conn:close()

    end)
end)