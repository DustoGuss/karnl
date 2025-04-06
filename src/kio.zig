const vga = @import("vga.zig");

pub fn inb(port: u16) u8 
{
    var result: u8 = 0;
    asm volatile (
        \\ inb %dx, %al
        : [result] "={al}" (result)
        : [port] "{dx}" (port)
    );
    return result;
}

pub const keymap: [128]u8 = [_]u8
{
    0, 27, '1','2','3','4','5','6','7','8','9','0','-','=','\x08', // Backspace
    '\t', // Tab
    'q','w','e','r','t','y','u','i','o','p','[',']','\n', // Enter
    0, // Control
    'a','s','d','f','g','h','j','k','l',';','\'','`',
    0, // Left Shift
    '\\','z','x','c','v','b','n','m',',','.','/',
    0, // Right Shift
    '*',
    0, // Alt
    ' ', // Spacebar
    0, // Caps Lock
    // Remaining: function keys, etc. (ignored here)
} ++ [_]u8{0} ** (128 - 59); 

pub fn read_key() u8 
{
    const scancode = inb(0x60);
    if (scancode & 0x80 != 0)
    {
        return 0;
    } 
    else 
    {
        return keymap[scancode];
    }
}

pub fn initialize() void 
{
    const test_scancode = inb(0x60);
    _ = test_scancode; 
    vga.logp("kio", vga.LogLevel.info, "I/O services were successfully loaded.", vga.ConsoleColors.LightGreen);
}