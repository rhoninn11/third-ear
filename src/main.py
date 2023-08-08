import migen as mg
from platforms.cmod import Platform
from modules.blinker import Blinker
from modules.top_module import TopModule
from modules.pwm_generator import PWMGenerator

platform = Platform()

# led = platform.request("user_led")
# my_blinker = Blinker(led, 100000000)

# platform.build(my_blinker)

btn = platform.request("user_btn")
led = platform.request("user_led")
pwm_value = mg.C(21)
top = TopModule([255, 511, 767, 1023], btn, led)

platform.build(top)


# led = platform.request("user_led")
# pwm_value = mg.C(21)
# pwm_gen = PWMGenerator(pwm_value, led)

# platform.build(pwm_gen)


