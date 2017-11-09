-- subscribes to temprature and humidity readings via mqtt
client = "client"
password = "password"
url = "iot.rabbiteer.io"

-- the sensor to listen for temprature updates from
sensor = "cillie"

-- data and clock pins for sensor
sda, scl = 1, 2

-- init OLED display
sla = 0x3C
i2c.setup(0, sda, scl, i2c.SLOW)
disp = u8g.ssd1306_128x64_i2c(sla)
disp:setFont(u8g.font_6x10)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()

-- initial temp and humi
temp = "__._"
humi = "__._"

-- print the current temp and humi
function print_OLED()
    disp:firstPage()
    repeat
      disp:drawFrame(2,2,126,62)
      disp:drawStr(10, 10, "temprature: " .. temp .. " C")
      disp:drawStr(10, 20, "humidity:   " .. humi .. " %")
    until disp:nextPage() == false
end

-- topics to listen for updates from
temp_topic = "metric/temprature/" .. sensor;
humi_topic = "metric/humidity/" .. sensor;

-- this will be called when an MQTT message is received
function on_mqtt_message(client,topic,message)
    -- update temp if it's temp topic
    if topic == temp_topic then
        temp = message;
    end

    -- update humi if it's humi topic
    if topic == humi_topic then
        humi = message;
    end

    -- update display
    print_OLED()
end

-- this will be called once mqtt is connected
function on_mqtt_connected(m)
    print("connected");
    -- subscribe to temp & humi channels
    m:subscribe(temp_topic, 0)
    m:subscribe(humi_topic, 0)
end

-- this will be called on mqtt error
function on_mqtt_error(client, reason)
    print("error: " .. reason);
    node.restart();
end

-- connect to mqtt server
m = mqtt.Client(client,60,client,password);
m:connect(url,8883,1,0,on_mqtt_connected,on_mqtt_error)
m:on("message", on_mqtt_message)

-- print initial (blank) values
print_OLED()
