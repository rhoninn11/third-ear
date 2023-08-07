from migen.build.generic_platform import *
from migen.build.xilinx import XilinxPlatform

_io = [
    ("clk12", 0, Pins("L17"), IOStandard("LVCMOS33")),

    ("user_led", 0, Pins("A17"), IOStandard("LVCMOS33")),
    ("user_led", 1, Pins("C16"), IOStandard("LVCMOS33")),

    ("rgb_led", 0,
        Subsignal("r", Pins("B17")),
        Subsignal("g", Pins("B16")),
        Subsignal("b", Pins("C17")),
        IOStandard("LVCMOS33"),
    ),

    ("user_btn", 0, Pins("A18"), IOStandard("LVCMOS33")),
    ("user_btn", 1, Pins("B18"), IOStandard("LVCMOS33")),


    ("serial", 0,
        Subsignal("tx", Pins("J17"), IOStandard("LVCMOS33")),
        Subsignal("rx", Pins("J18"), IOStandard("LVCMOS33")),
    ),

]

_connectors = [
    ("pmoda", "G17 G19 N18 L18 H17 H19 J19 K18"),
]

class Platform(XilinxPlatform):
    default_clk_name = "clk12"
    default_clk_period = 83.333

    def __init__(self):
        XilinxPlatform.__init__(self, "xc7a35tcpg236-1", _io, toolchain="vivado")
        self.add_platform_command("set_property CFGBVS VCCO [current_design]")
        self.add_platform_command("set_property CONFIG_VOLTAGE 3.3 [current_design]")
