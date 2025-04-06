const vga = @import("./vga.zig");
const kio = @import("./kio.zig");
const mem = @import("std").mem;

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

const MultibootHeader = packed struct 
{
    magic: i32 = MAGIC,
    flags: i32,
    checksum: i32,
    padding: u32 = 0,
};

export var multiboot: MultibootHeader align(4) linksection(".multiboot") = 
.{
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;

// We specify that this function is "naked" to let the compiler know
// not to generate a standard function prologue and epilogue, since
// we don't have a stack yet.
export fn _start() callconv(.Naked) noreturn 
{
    asm volatile (
        \\ movl %[stack_top], %%esp
        \\ movl %%esp, %%ebp
        \\ call %[kmain:P]
        :
        : [stack_top] "i" (@as([*]align(16) u8, @ptrCast(&stack_bytes)) + @sizeOf(@TypeOf(stack_bytes))),
          [kmain] "X" (&kmain),
        :
    );
}

fn print_shell_prompt() void 
{
    vga.color_puts("knl@karnl", vga.ConsoleColors.LightRed, vga.ConsoleColors.Black);
    vga.println("~");
    vga.puts("$ ");
}

fn kmain() callconv(.C) void 
{
    vga.initialize(); 
    vga.logp("kmain", vga.LogLevel.info, "Kernel core successfully loaded.", vga.ConsoleColors.LightGreen);
    vga.logp("kio", vga.LogLevel.info, "Loading I/O services...", vga.ConsoleColors.LightGreen);
    kio.initialize();
    vga.putChar('\n');
    print_shell_prompt();

    var last_scancode: u8 = 0;

    while (true)
    {
        const raw = kio.inb(0x60);

        if (raw != last_scancode)
        {
            last_scancode = raw;

            if ((raw & 0x80) == 0)
            {
                const key = kio.keymap[raw];
                if (key == '\n')
                {
                    vga.putChar('\n');
                    print_shell_prompt();
                }
                else if (key != 0)
                {
                    vga.putChar(key);
                }
            }
        }
    }

}