conn     = nil
ssid     = ""
password = ""

title    = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>\r\n"
      .."<meta name='viewport' content='width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui'>\r\n"
 

function start_html_link()
    wifi.setmode(wifi.STATIONAP)
    cfg      = {}
    cfg.ssid = "Newind_"..node.chipid()
    cfg.pwd  = "0123456789"
    wifi.ap.config(cfg)
    print(wifi.ap.getip())


    --  http server
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn1)
        conn = conn1
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
                
                str    = "module attempt to connect router..."
                length = string.len(title)+string.len(str)
                print(length)
                conn:send("HTTP/1.1 200 OK\r\n"
                .."Content-Length: "..length.."\r\n"
                .."Content-Type: text/html\r\n\r\n"
                )
                conn:send(title)
                conn:send(str)
                conn:close()
                
                pwm.setup(led_wifi, 2, 512);
                pwm.start(led_wifi); 
                wifi.sta.config(ssid,password)  
                wifi.setmode(wifi.STATION)
                
                
                
            else
                wifi.sta.getap(listap)
            end
        end)
    end)
end




        
function listap(t)
     
     

    
    form = "<form action='' method='post'>"
    .."<table>"
    .."<tr>"
    .."<td>SSID:</td>"
    .."<td><input name='ssid' type='text' id='ssid' /></td>"
    .."</tr>"
    .."<tr>"
    .."<td>PASSWORD:</td>"
    .."<td><input name='password' type='password' id='password' /></td>"
    .."</tr>"
    .."<tr>"
    .."<td><input name='OK' type='submit' value='OK' onclick='return check_form()'/></td>"
    .."</tr>"
    .."</table>"
    .."</form>\r\n"
    
    
    js = "<script language='javascript'>\r"
    .."function f(node)\r"
    .."{\r"
    .."var tr1 = node.parentNode.parentNode;\r"
    .."document.getElementById('ssid').value=tr1.cells[0].innerText;\r"
    .."document.getElementById('password').focus();\r"        
    .."}\r"
    .."function check_form()\r"
    .."{\r"
    .."if(document.getElementById('ssid').value=='')\r"
    .."{\r"
    .."   alert('please select or input a ssid!')\r"
    .."   return false;\r"
    .."}\r"
    .."if(document.getElementById('password').value=='')\r"
    .."{\r"
    .."   if(confirm('empty password?') == false)\r"
    .."       return false;\r"
    .."   else\r"
    .."     return true;\r"
    .."}\r"
    .."return true;\r"    
    .."}\r"
    .."</script>\r"
    
  aplist = "<h2>Please Select a SSID</h2>"
         .."<table width='100%' border='1' cellspacing='0' cellpadding='0' style='text-align:center'>"   
    
    
  for k,v in pairs(t) do      
      -- m    = string.find(v,",")
      --mode = string.sub(v,0,m-1)
      --if(mode == "0")then
      --mode = "OPEN"
      --elseif(mode =="1")then
      --mode = "WEP"
      --elseif(mode =="2")then
      --mode = "WPA_PSK"
      --elseif(mode =="3")then
      --mode = "WPA2_PSK"
      --elseif(mode=="4")then
      --mode = "WPA_WPA2_PSK"
      --end     
      --v    = string.sub(v,m+1)
      --m    = string.find(v,",")
      --rssi = string.sub(v,1,m-1)
      --if(rssi >= "-30" and rssi <"-41") then
      --rssi = "100%"
      --elseif(rssi >= "-41" and rssi <"-52")then
      --rssi = "90%"
      --elseif(rssi >= "-52" and rssi <"-63")then
      --rssi = "80%"
      --elseif(rssi >= "-63" and rssi <"-75")then
      --rssi = "60%"
      --elseif(rssi >= "-75" and rssi <"-89")then
      --rssi = "40%"
      --elseif(rssi >= "-89")then
      --rssi = "10%"
      --end
  aplist = aplist.." <tr>"
          .."<td>"..k.."</td>"
          -- .."<td>"..mode.."</td>"
          --.."<td>"..rssi.."</td>"
          .."<td><input type='button' value='select' onClick='f(this)'/></td>"
          .."</tr>"
  --         print(k.." : "..mode..","..rssi)
  end
    aplist = aplist.."</table>\r\n"
  
  
  
  length = string.len(title)+string.len(aplist)+string.len(form)+string.len(js)
  print(length)
    conn:send("HTTP/1.1 200 OK\r\n"
    .."Content-Length: "..length.."\r\n"
    .."Content-Type: text/html\r\n\r\n"
    )
    conn:send(title)
    conn:send(aplist)
    conn:send(form)
    conn:send(js)
     
    conn:close()
    
end