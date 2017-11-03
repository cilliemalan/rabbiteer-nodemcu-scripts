-- publishes temprature and humidity readings via mqtt

-- mqtt details
client = "client"
password = "password"
url = "iot.rabbiteer.io"
-- data and clock pins for sensor
sda = 1
scl = 2

function on_mqtt_connected(m)
    -- read temprature and humidity from the AM2302
    gpio.mode(sda, gpio.OUTPUT, 1)
    gpio.mode(scl, gpio.OUTPUT, 2)
    --setup i2c and connect to the device
    i2c.setup(0, sda, scl, i2c.SLOW)
    am2320.setup()
    -- take a reading every 5 seconds and send via mqtt
    tmr.create():alarm(5000, tmr.ALARM_AUTO, function()
        rh, t = am2320.read()
        m:publish(
            "metric/temprature/" .. client,
            string.format("%s", t/10),
            0, 0)
        m:publish(
            "metric/humidity/" .. client,
            string.format("%s", rh/10),
            0, 0)
    end)
end

function on_mqtt_error(client, reason) print("error"); print(reason);end

m = mqtt.Client(client,60,client,password);
m:connect(url,8883,1,0,on_mqtt_connected,on_mqtt_error)
