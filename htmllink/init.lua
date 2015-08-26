led_wifi      = 1
key           = 2
led           = 6--9
key_led_state = 2--2: not press;1:press on;0:press off;3:http send

i       = 0 
j       = 0
disconn = 0 


gpio.mode(led_wifi, gpio.OUTPUT)
gpio.mode(led, gpio.OUTPUT)
gpio.mode(key, gpio.INPUT)

dofile("routerset.lua")
 
if(file.open("info.lua", "r")==nil) then
    file.close()  
    file.open("info.lua", "w+")
    file.writeline("configed = '0'")
    file.writeline("ssid     = '".."1234567890".."'")
    file.writeline("password = '".."1234567890".."'")
    file.close()  
end    
 
if(gpio.read(key)==0) then
    print("reset key pressed ");
    file.open("info.lua", "w+")
    file.writeline("configed = '0'")
    file.writeline("ssid     = '".."1234567890".."'")
    file.writeline("password = '".."1234567890".."'")
    file.close()  
end

gpio.mode(key,gpio.INT)
    function pin1cb(level)
        if(gpio.read(led)==0)then
            print("key,led==0")
            key_led_state = 1
            gpio.write(led, gpio.HIGH)
        else
            print("key,led==1")
            key_led_state = 0
            gpio.write(led, gpio.LOW)
        end 
    end
gpio.trig(key, "up",pin1cb)

function to_view_state()
    tmr.alarm(1, 500, 1, function() 
        -- print(wifi.sta.status())
        --[[
        if (wifi.sta.getip() ~= nil) then
            print("Config done, IP is "..wifi.sta.getip())
            pwm.close(led_wifi);
            gpio.write(led_wifi, gpio.LOW);  

            file.open("info.lua", "w+")
            file.writeline("configed = '1'")
            file.writeline("ssid     = '"..ssid.."'")
            file.writeline("password = '"..password.."'")
            file.close()  
            tmr.stop(1)

            tmr.alarm(2, 1500, 1, function() 
                j = j+1;
                print(j);                   
                if(j>20) then
                    print(j.." time disconnect,attempt restart")
                    node.restart()
                end                    
                if (disconn == 0) then 
                    toconn()
                    print("disconn==0")
                    
                else
                    toget()
                     print("disconn==1")   
                end
            end)
        end
        ]]--
    end)
end



print("Starting...")
wifi.setmode(wifi.STATION)
dofile("info.lua");

--configed = "0";
print(configed)
if(configed == "0") then
    print("html")
    pwm.setup(led_wifi, 6, 512);
    pwm.start(led_wifi); 
    start_html_link();   
    to_view_state()
else
    print("manual");
    pwm.setup(led_wifi, 2, 512);
    pwm.start(led_wifi); 
    wifi.sta.config(ssid,password)  
    to_view_state()
end









function toconn()
    conn = net.createConnection(net.TCP, false) 
    
    --conn:on("receive", function(conn, pl) print(string.match(pl,"%b{}"))
    conn:on("receive", function(conn, pl) 
        local data  = string.match(pl,"%b{}")
        if(data ~= nil) then   
            print(string.match(pl,"%b{}"))
            local value = string.sub(data,2,2)
            
            j = 0;
            
            if (key_led_state == 3) then
                key_led_state = 2
            elseif(key_led_state == 1) then
                value = "9"
            elseif(key_led_state == 0) then
                value = "9"
            end
            
            
            --  print(value)   
            if (value=="1") then    --value is a srting so you can't use value = 1
                --print("\r\n"..content.."\r\n") 
                --   print("value=1") 
                gpio.write(led, gpio.HIGH);
                -- print("IO"..led1..":"..gpio.read(led1));
            elseif(value=="0") then
                --   print("value=0")
                gpio.write(led, gpio.LOW);
                -- print("IO"..led1..":"..gpio.read(led1));
            end
            
        end
    end)
    
    conn:on("disconnection", function(conn, pl) print("disconnection") disconn=0 conn:close() 
    end)
    
    conn:on("connection", function(conn, pl) disconn=1 toget() 
    end)
    
    conn:connect(80,"web.nenewind.com") 
end

function toget() 
    conn:send("GET /wechat_chip_get.php?device=hardware&chip_id="..node.chipid().."&key_led_state="..key_led_state.." HTTP/1.1\r\n"
    .."Host: web.nenewind.com\r\n"
    .."User-Agent: Newind_SmartWIFI"
    .."Connection: keep-alive\r\n"
    .."Cache-Control: no-cache\r\n\r\n")
    key_led_state = 3; 
   -- i             = i+1
   -- print(i)
end



