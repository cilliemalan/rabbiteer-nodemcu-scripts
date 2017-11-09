-- This script takes temprature and humidity from an AM2302
-- and sends it out on MQTT every 5 seconds.

-- mqtt details
client = "<username>"
password = "<password>"
url = "iot.rabbiteer.io"

--these are the data and clock pin numbers
sda, scl = 1, 2

-- this will be called after mqtt connect
function on_mqtt_connected(m)
    --setup i2c and connect to the am2320
    i2c.setup(0, sda, scl, i2c.SLOW)
    am2320.setup()

    -- take a reading every 5 seconds and send via mqtt
    tmr.create():alarm(5000, tmr.ALARM_AUTO, function()

        -- take reading
        rh, t = am2320.read()

        -- publish temprature
        m:publish(
            "metric/temprature/" .. client,
            string.format("%s", t/10),
            0, 0)

        -- publish humidity
        m:publish(
            "metric/humidity/" .. client,
            string.format("%s", rh/10),
            0, 0)
    end)
end

-- this will be called on mqtt error
function on_mqtt_error(client, reason)
    print("error: " .. reason);
    node.restart();
end

-- connect to the MQTT broker
m = mqtt.Client(client, 60, client, password)
m:connect(url, 8883, 1, 0, on_mqtt_connected, on_mqtt_error)
