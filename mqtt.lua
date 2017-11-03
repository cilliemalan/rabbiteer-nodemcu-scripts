-- publishes and subscribes on mqtt

client = "client"
password = "password"
url = "iot.rabbiteer.io"

-- the mqtt client
m = mqtt.Client(client, 60, client, password);

-- handlers
function on_mqtt_online(client) print("online") end
function on_mqtt_offline(client) print("offline") end
function on_mqtt_message(client,topic,message) print("got message on " .. topic .. ": " .. message) end
function on_mqtt_error(client, reason) print("error"); print(reason);end

-- bind the handlers
m:on("connect", on_mqtt_online)
m:on("offline", on_mqtt_offline)
m:on("message", on_mqtt_message)

-- function to call when connected
function on_mqtt_connected(m)
    print("connected")
    -- subscribe to a channel
    m:subscribe("/slack", 0)
    -- publish a message to a channel
    m:publish("/slack", "hello from " .. client, 0, 0)
end

-- connect
m:connect(url, 8883, 1, 0, on_mqtt_connected, on_mqtt_error)

-- function to call when connected
function on_mqtt_connected(client)
    print("connected")
    -- subscribe to a channel
    m:subscribe("/slack", 0)
    -- publish a message to a channel
    m:publish("/slack", "hello from " .. client, 0, 0)
end

