--configure wifi

wifi_cfg = {
    ssid = "<ssid>",
    pwd = "<pwd>",
    save = true
}

-- configure this device to connect to this access point.
-- settings are persisted across reboots.

wifi.setmode(wifi.STATION)
wifi.sta.config(wifi_cfg)
