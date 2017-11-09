-- This script reads temprature and humidity from an AM2320
-- every 5 seconds and prints it out.

--these are the data and clock pin numbers
sda, scl = 1, 2

--setup i2c and connect to the device
i2c.setup(0, sda, scl, i2c.SLOW);
am2320.setup();

function gettemp()
    rh, t = am2320.read()
    print(string.format("Humidity: %s%%  Temperature: %s", rh / 10, t / 10))
end

-- take a reading right now and print
gettemp();

-- take a reading every 5 seconds and print
tmr.create():alarm(5000, tmr.ALARM_AUTO, gettemp)
