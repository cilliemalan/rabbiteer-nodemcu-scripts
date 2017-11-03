-- subscribes to temprature and humidity readings via mqtt
client = "client"
password = "password"
url = "iot.rabbiteer.io"
sensor = "harrier"

-- data and clock pins for sensor
sda = 1
scl = 2

-- init OLED display
sla = 0x3C
i2c.setup(0, sda, scl, i2c.SLOW)
disp = u8g.ssd1306_128x64_i2c(sla)
disp:setFont(u8g.font_6x10)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()
--Rotate Display if needed
--disp:setRot180()

temp = "__._"
humi = "__._"

function print_OLED()
    disp:firstPage()
    repeat
      disp:drawFrame(2,2,126,62)
      disp:drawStr(10, 10, "temprature: " .. temp .. " C")
      disp:drawStr(10, 20, "humidity:   " .. humi .. " %")
    until disp:nextPage() == false
end

print_OLED()

temp_topic = "metric/temprature/" .. sensor;
humi_topic = "metric/humidity/" .. sensor;

function on_mqtt_message(client,topic,message)
    if topic == temp_topic then
        temp = message;
    end
    if topic == humi_topic then
        humi = message;
    end
    print_OLED()
end

-- mqtt connect handler
function on_mqtt_connected(m)
    print("connected");
    -- subscribe to temp & humi channels
    m:subscribe(temp_topic, 0)
    m:subscribe(humi_topic, 0)
end

-- listen mqtt
function on_mqtt_error(client, reason) print("error"); print(reason);end
m = mqtt.Client(client,60,client,password);
m:connect(url,8883,1,0,on_mqtt_connected,on_mqtt_error)
m:on("message", on_mqtt_message)

