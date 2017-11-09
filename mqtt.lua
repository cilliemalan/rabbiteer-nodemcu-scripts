-- publishes and subscribes on mqtt

client = "<username>"
password = "<password>"
url = "iot.rabbiteer.io"

-- the mqtt client
m = mqtt.Client(
    client,    -- client id
    60,        -- keepalive
    client,    -- username
    password); -- password

-- this will be called when a message is received
function on_mqtt_message(client,topic,message)
    print("got message on " .. topic .. ": " .. message)
end

-- this will be called if there is an error
function on_mqtt_error(client, reason)
    print("error: "..reason);
    node.restart();
end

-- this will be called after connected
function on_mqtt_connected(m)
    print("connected")

    -- subscribe to a channel
    m:subscribe("slack/mqtt", 0)

    -- publish a message to a channel
    m:publish("slack/mqtt", "hello from " .. client, 0, 0)
end

-- connect
m:connect(
    url,                -- host
    8883,               -- port
    1,                  -- secure
    0,                  -- autoreconnect
    on_mqtt_connected,  -- connect callback
    on_mqtt_error)      -- error callback

-- bind message handler
m:on("message", on_mqtt_message)
