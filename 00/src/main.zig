const c = @import("CImport.zig");
const std = @import("std");
const glfw = @import("glfw.zig");
const delay = @import("delay.zig");
const Throttle = delay.Throttle;

const WINDOW_WIDTH = 800;
const WINDOW_HEIGHT = 600;

pub fn main() !void {
    helpPrint();
    var window_hint_list = [_]glfw.Window.Hint{
        glfw.Window.Hint{ .ContextVersionMajor = 3 },
        glfw.Window.Hint{ .ContextVersionMinor = 3 },
        glfw.Window.Hint{
            .OpenGlProfile = glfw.Window.OpenGlProfile.Compact,
        },
        glfw.Window.Hint{
            .OpenGLForwardCompatable = true,
        },
    };

    var window = try glfw.initAndCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "hello glfw", window_hint_list[0..]);
    defer glfw.terminate();

    while (glfw.windowShouldStayOpen()) {
        try inputProcess(window);
        c.glClearColor(0.1, 0.1, 1.0, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);
        try glfw.windowUpdate();
    }
}

var help_throttle = Throttle.init();
fn helpPrint() void {
    if (help_throttle.doit(100)) |delta_time| {
        std.debug.print("[main.helpPrint] {}\n", .{delta_time});
        std.debug.print("   keyboard shortcuts\n", .{});
        std.debug.print("      h for help\n", .{});
        std.debug.print("      x for clear terminal\n", .{});
        std.debug.print("      q for quit\n", .{});
    }
}

fn inputProcess(window: *c.GLFWwindow) glfw.GlfwError!void {
    if (c.glfwGetKey(window, c.GLFW_KEY_H) == c.GLFW_PRESS) {
        helpPrint();
    }
    if (c.glfwGetKey(window, c.GLFW_KEY_Q) == c.GLFW_PRESS) {
        try glfw.windowKill();
    }
}
