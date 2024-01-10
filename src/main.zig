pub const RCC_BASE = 0x4002_3800;
pub const GPIOC_BASE = 0x4002_0800;

pub const RCC_AHB1ENR = @as(*volatile u32, @ptrFromInt(RCC_BASE + 0x30));

pub const GpioPort = struct {
    mode: *volatile u32,
    idr: *volatile u32,
    odr: *volatile u32,
    bsrr: *volatile u32,
    otyper: *volatile u32,
    ospeedr: *volatile u32,
    pupdr: *volatile u32,
    lockr: *volatile u32,
    afrl: *volatile u32,
    afrh: *volatile u32,

    fn init(comptime base_address: u32) GpioPort {
        return comptime GpioPort{
            .mode = @as(*volatile u32, @ptrFromInt(base_address + 0x00)),
            .otyper = @as(*volatile u32, @ptrFromInt(base_address + 0x04)),
            .ospeedr = @as(*volatile u32, @ptrFromInt(base_address + 0x08)),
            .pupdr = @as(*volatile u32, @ptrFromInt(base_address + 0x0C)),
            .idr = @as(*volatile u32, @ptrFromInt(base_address + 0x10)),
            .odr = @as(*volatile u32, @ptrFromInt(base_address + 0x14)),
            .bsrr = @as(*volatile u32, @ptrFromInt(base_address + 0x18)),
            .lockr = @as(*volatile u32, @ptrFromInt(base_address + 0x1C)),
            .afrl = @as(*volatile u32, @ptrFromInt(base_address + 0x20)),
            .afrh = @as(*volatile u32, @ptrFromInt(base_address + 0x24)),
        };
    }
};

fn bit_set(comptime bit: u32) u32 {
    return comptime 1 << bit;
}

pub export fn main() void {
    const gpio_c = GpioPort.init(GPIOC_BASE);

    const pin_to_bang = 14;

    RCC_AHB1ENR.* |= @as(u32, 0b1 << 2); // Enable GPIOC clk
    gpio_c.mode.* |= @as(u32, 0b01 << (pin_to_bang * 2)); // Set the mode to output
    gpio_c.otyper.* &= ~@as(u32, bit_set(pin_to_bang)); // Clear the bit corresponding to GPIOC14
    gpio_c.ospeedr.* &= ~@as(u32, 0b11 << (pin_to_bang * 2)); //Clear ospeedr bits
    gpio_c.odr.* |= @as(u32, bit_set(pin_to_bang)); // Set the bit corresponding to GPIOC14

    while (true) {
        var i: u32 = 0;
        gpio_c.odr.* ^= @as(u32, bit_set(pin_to_bang)); // Toggle the bit corresponding to GPIOC14
        while (i < 1000_000) { // Wait a bit
            i += 1;
        }
    }
}
