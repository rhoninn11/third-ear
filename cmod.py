from migen.build.generic_platform import *
from migen.build.xilinx import XilinxPlatform

_io = [
    ("user_led", 0, Pins("H5"), IOStandard("LVCMOS33")),
    ("user_led", 1, Pins("J4"), IOStandard("LVCMOS33")),
    ("user_led", 2, Pins("T9"), IOStandard("LVCMOS33")),
    ("user_led", 3, Pins("T10"), IOStandard("LVCMOS33")),

    ("clk12", 0, Pins("E3"), IOStandard("LVCMOS33")),

    ("cpu_reset", 0, Pins("C2"), IOStandard("LVCMOS33")),

    ("serial", 0,
        Subsignal("tx", Pins("D4"), IOStandard("LVCMOS33")),
        Subsignal("rx", Pins("D3"), IOStandard("LVCMOS33")),
    ),

    ("user_sw", 0, Pins("A8"), IOStandard("LVCMOS33")),
    ("user_sw", 1, Pins("C11"), IOStandard("LVCMOS33")),
    ("user_sw", 2, Pins("C10"), IOStandard("LVCMOS33")),
    ("user_sw", 3, Pins("A10"), IOStandard("LVCMOS33")),

    ("user_btn", 0, Pins("D9"), IOStandard("LVCMOS33")),
    ("user_btn", 1, Pins("C9"), IOStandard("LVCMOS33")),
    ("user_btn", 2, Pins("B9"), IOStandard("LVCMOS33")),
    ("user_btn", 3, Pins("B8"), IOStandard("LVCMOS33")),
]

class Platform(XilinxPlatform):
    default_clk_name = "clk12"
    default_clk_period = 83.333

    def __init__(self):
        XilinxPlatform.__init__(self, "xc7a35ticsg324-1L", _io, toolchain="vivado")
        self.add_platform_command("set_property CFGBVS VCCO [current_design]")
        self.add_platform_command("set_property CONFIG_VOLTAGE 3.3 [current_design]")
