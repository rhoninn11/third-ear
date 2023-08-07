import migen as mg

class Blinker(mg.Module):
    def __init__(self, led, maxperiod):
        counter = mg.Signal(max=maxperiod+1)
        period = mg.Signal(max=maxperiod+1)
        
        counter_mng = mg.If(counter == 0,
            led.eq(~led),
            counter.eq(period)
        ).Else(
            counter.eq(counter - 1)
        )  

        self.sync += counter_mng