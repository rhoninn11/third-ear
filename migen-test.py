from migen import *
from migen.fhdl import verilog
from cmod import Platform
from migen.sim.core import run_simulation

platform = Platform()
led = platform.request("user_led")

class Blinker(Module):
    def __init__(self, led, maxperiod):
        self.counter = Signal(max=maxperiod+1)
        period = Signal(max=maxperiod+1)
        self.comb += period.eq(maxperiod)
        self.sync += If(
            self.counter == 0,
                led.eq(~led),
                self.counter.eq(period)
                    ).Else(
                self.counter.eq(self.counter - 1))
        


led = Signal()
my_blinker = Blinker(led, 100000000)

dut = my_blinker
def testbanch()
# print(verilog.convert(my_blinker, ios={led}))

# platform.build(my_blinker)
run_simulation(my_blinker, ncycles=200, vcd_name="ledblinker.vcd")

