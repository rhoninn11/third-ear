from migen import *
from migen.fhdl import verilog
from platforms.cmod import Platform
from modules.blinker import Blinker
from modules.top_module import TopModule

platform = Platform()

# led = platform.request("user_led")
# my_blinker = Blinker(led, 100000000)

# platform.build(my_blinker)

btn = platform.request("user_btn")
top = TopModule([255, 511, 767, 1023], btn)

platform.build(top)

