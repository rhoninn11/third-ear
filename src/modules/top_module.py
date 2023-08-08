import migen as mg  
from src.modules.pwm_generator import PWMGenerator

class TopModule(mg.Module):

    def __init__(self, pwm_value_arr, btn, led):

        pwm_lut_size = len(pwm_value_arr)
        pwm_rom = mg.Array(pwm_value_arr)
        self.index = mg.Signal(max=pwm_lut_size)
        last_index = pwm_lut_size - 1

        
        self.pwm_value = mg.Signal(10)
        self.submodules += PWMGenerator(self.pwm_value, led)

        idx_up = mg.If(self.index == last_index,
                self.index.eq(0)
            ).Else(
                self.index.eq(self.index + 1)
            )
        
        handle_chng = mg.If(btn == 1,
            idx_up
        )
        opt_sel = self.pwm_value.eq(pwm_rom[self.index])
        
        sync_ops = [handle_chng, opt_sel]
        self.sync += sync_ops

