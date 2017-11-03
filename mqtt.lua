-- publishes and subscribes on mqtt

client = "client"
password = "password"
url = "iot.rabbiteer.io"

-- the mqtt client
m = mqtt.Client(
    client,    -- client id
    60,        -- keepalive
    client,    -- username
    password); -- password

-- handlers
function on_mqtt_message(client,topic,message) print("got message on " .. topic .. ": " .. message) end
function on_mqtt_error(client, reason) print("error"); print(reason);end

-- function to call when connected
function on_mqtt_connected(m)
    print("connected")
    -- subscribe to a channel
    m:subscribe("/slack", 0)
    -- publish a message to a channel
    m:publish("/slack", "hello from " .. client, 0, 0)
end

-- bind the handlers
m:on("message", on_mqtt_message)

-- connect
m:connect(
    url,                -- host
    8883,               -- port
    1,                  -- secure
    0,                  -- autoreconnect
    on_mqtt_connected,  -- connect callback
    on_mqtt_error)      -- error callback

