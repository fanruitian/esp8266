1.下载2个lua文件到esp8266，并执行init.lua
2.led_wifi闪烁频率约6hz，这时打开手机wifi，查找以Newind为开头的ssid，连接，密码为0123456789.
3.在浏览器输入192.168.4.1，打开网页，输入您的路由器ssid和password，点击ok摁钮，这时候esp8266重启，led_wifi闪烁频率2hz，稍等一会，led_wifi常亮，即连上了路由器。
4.若不慎输入了错误的ssid和password，需要摁着key按键重新上电即可擦除。