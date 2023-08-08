import migen as mg

class PWMGenerator(mg.Module):
    def __init__(self, pwm_value, pwm_out, width=10):
        # Wejście: wartość PWM od 0 do 1023
        self.pwm_value = mg.Signal(width)
        max_value = (1 << width) - 1
        # Wyjście: sygnał PWM
        self.pwm_out = mg.Signal()

        # Wewnętrzny licznik o tej samej szerokości co wejście
        counter = mg.Signal(width)

        # Logika synchroniczna
        self.comb += self.pwm_value.eq(pwm_value)
        self.comb += pwm_out.eq(self.pwm_value)

        pwm_logic = mg.If(counter <= self.pwm_value,
                self.pwm_out.eq(1)
            ).Else(
                self.pwm_out.eq(0)
            )
        
        cntr_ctrl = mg.If(counter == max_value,
                counter.eq(0)
            ).Else(
                counter.eq(counter + 1)
            )

        self.sync += [pwm_logic, cntr_ctrl]
    
