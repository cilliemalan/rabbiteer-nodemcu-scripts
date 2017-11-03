-- dispaly something on the OLED display

-- data and clock pins
sda = 1 -- SDA Pin
scl = 2 -- SCL Pin

function init_OLED(sda,scl)
     sla = 0x3C
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla)
     disp:setFont(u8g.font_6x10)
     disp:setFontRefHeightExtendedText()
     disp:setDefaultForegroundColor()
     disp:setFontPosTop()
     --Rotate Display if needed
     --disp:setRot180()
end

function print_OLED(message)
   disp:firstPage()
   repeat
     disp:drawFrame(2,2,126,62)
     disp:drawStr(30, 30, message)
     disp:drawDisc(15,34, 6, u8g.DRAW_UPPER_LEFT + u8g.DRAW_LOWER_RIGHT)
     disp:drawDisc(113,34, 6, u8g.DRAW_UPPER_LEFT + u8g.DRAW_LOWER_RIGHT)
   until disp:nextPage() == false
end

-- Main Program 
str1="Hello World!!"
init_OLED(sda,scl)
print_OLED(str1) 
