-- read temprature and humidity from the AM2302

--data and clock pins
sda = 1
scl = 2

gpio.mode(sda, gpio.OUTPUT, 1)
gpio.mode(scl, gpio.OUTPUT, 2)

--setup i2c and connect to the device
i2c.setup(0, sda, scl, i2c.SLOW)
am2320.setup()

-- take a reading every 5 seconds and print
tmr.create():alarm(5000, tmr.ALARM_AUTO, function()
    rh, t = am2320.read()
    print(string.format("Humidity: %s%%  Temperature: %s", rh / 10, t / 10))
end)

