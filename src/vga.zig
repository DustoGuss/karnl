const fmt = @import("std").fmt;
const Writer = @import("std").io.Writer;

const VGA_WIDTH = 80;
const VGA_HEIGHT = 25;
const VGA_SIZE = VGA_WIDTH * VGA_HEIGHT;

pub const LogLevel = enum 
{
    info,
    warn,
    panic,
};

pub const ConsoleColors = enum(u8) 
{
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    LightBrown = 14,
    White = 15,
};

var row: usize = 0;
var column: usize = 0;
var color = vgaEntryColor(ConsoleColors.LightGray, ConsoleColors.Black);
var buffer = @as([*]volatile u16, @ptrFromInt(0xB8000));

fn vgaEntryColor(fg: ConsoleColors, bg: ConsoleColors) u8 
{
    return @intFromEnum(fg) | (@intFromEnum(bg) << 4);
}

fn vgaEntry(uc: u8, new_color: u8) u16 
{
    const c: u16 = new_color;
    return uc | (c << 8);
}

pub fn initialize() void 
{
    clear();
}

pub fn setColor(new_color: u8) void 
{
    color = new_color;
}

pub fn clear() void 
{
    @memset(buffer[0..VGA_SIZE], vgaEntry(' ', color));
}

pub fn putCharAt(c: u8, new_color: u8, x: usize, y: usize) void 
{
    const index = y * VGA_WIDTH + x;
    buffer[index] = vgaEntry(c, new_color);
}

pub fn putChar(c: u8) void 
{
    if (c == '\n') 
    {
        column = 0;
        row += 1;
        if (row == VGA_HEIGHT) row = 0;
        return;
    }

    putCharAt(c, color, column, row);
    column += 1;
    if (column == VGA_WIDTH) 
    {
        column = 0;
        row += 1;
        if (row == VGA_HEIGHT) row = 0;
    }
}

pub fn puts(data: []const u8) void 
{
    for (data) |c| 
    {
        if (c == 0) break; 
        putChar(c);
    }
}

pub fn color_puts(data: []const u8, fg: ConsoleColors, bg: ConsoleColors) void 
{
    const old_color = color;
    setColor(vgaEntryColor(fg, bg));

    for (data) |c| 
    {
        if (c == 0) break;
        putChar(c);
    }

    setColor(old_color); 
}

pub const writer = Writer(void, error{}, callback){ .context = {} };

fn callback(_: void, string: []const u8) error{}!usize 
{
    puts(string);
    return string.len;
}

pub fn printf(comptime format: []const u8, args: anytype) void 
{
    fmt.format(writer, format, args) catch unreachable;
}

pub fn println(data: []const u8) void 
{
    puts(data);
    putChar('\n');
}

pub fn color_println(data: []const u8, fg: ConsoleColors, bg: ConsoleColors) void 
{
    color_puts(data, fg, bg);
    putChar('\n');
}

pub fn logp(log_emiter: []const u8, tag: LogLevel, data: []const u8, emiter_color: ConsoleColors) void 
{
    puts("[");
    color_puts(log_emiter, emiter_color, ConsoleColors.Black);
    puts("]");
    puts(" (");
    switch (tag)
    {
        LogLevel.info => color_puts("Info", ConsoleColors.LightGreen, ConsoleColors.Green),
        LogLevel.warn => color_puts("Warn", ConsoleColors.LightBrown, ConsoleColors.Brown),
        LogLevel.panic => color_puts("Panic!", ConsoleColors.LightRed, ConsoleColors.Red),
    }
    puts(") - ");
    println(data);
}
