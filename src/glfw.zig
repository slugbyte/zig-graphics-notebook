// INMPORT
const std = @import("std");
const c = @import("CImport.zig");

var window_handle: ?*c.GLFWwindow = null;

// TYPE
pub const GlfwError = error{
    InitGLFWFailure,
    InitGlFailure,
    InitWindowFailure,
    WindowNotFound,
    NotInitailized,
    PlatformError,
};

pub const Version = struct {
    const Self = @This();
    major: i32,
    minor: i32,
    revision: i32,

    pub fn init() Self {
        var major: i32 = 0;
        var minor: i32 = 0;
        var revision: i32 = 0;

        c.glfwGetVersion(&major, &minor, &revision);
        return Self{
            .major = major,
            .minor = minor,
            .revision = revision,
        };
    }
};

pub const Window = struct {
    pub const Size = struct {
        width: u32,
        height: u32,
    };

    pub const OpenGlProfile = enum(i32) {
        Any = c.GLFW_OPENGL_ANY_PROFILE,
        Compact = c.GLFW_OPENGL_COMPAT_PROFILE,
        Core = c.GLFW_OPENGL_CORE_PROFILE,
    };

    pub const HintName = enum(c_int) {
        ContextVersionMajor = c.GLFW_CONTEXT_VERSION_MAJOR,
        ContextVersionMinor = c.GLFW_CONTEXT_VERSION_MINOR,
        OpenGlProfile = c.GLFW_OPENGL_PROFILE,
        OpenGLForwardCompatable = c.GLFW_OPENGL_FORWARD_COMPAT,
    };

    pub const Hint = union(HintName) {
        ContextVersionMajor: i32,
        ContextVersionMinor: i32,
        OpenGlProfile: OpenGlProfile,
        OpenGLForwardCompatable: bool,
    };

    pub fn hint(h: Hint) void {
        switch (h) {
            .ContextVersionMajor => |value| {
                std.debug.print("[glfw.Window.hint] GLFW_CONTEXT_VERSION_MAJOR {}\n", .{value});
                c.glfwWindowHint(@enumToInt(h), value);
            },
            .ContextVersionMinor => |value| {
                std.debug.print("[glfw.Window.hint] GLFW_CONTEXT_VERSION_MINOR {}\n", .{value});
                c.glfwWindowHint(@enumToInt(h), value);
            },
            .OpenGlProfile => |value| {
                std.debug.print("[glfw.Window.hint] GLFW_OPENGL_PROFILE {}\n", .{value});
                c.glfwWindowHint(@enumToInt(h), @enumToInt(value));
            },
            .OpenGLForwardCompatable => |value| {
                std.debug.print("[glfw.Window.hint] GLFW_OPENGL_FORWARD_COMPAT {}\n", .{value});
                c.glfwWindowHint(@enumToInt(h), if (value) c.GLFW_TRUE else c.GLFW_FALSE);
            },
        }
    }
};

// PRIVATE
fn init() GlfwError!void {
    const glfw_version = Version.init();
    std.debug.print("[glfw.init] version: {}.{}.{}\n", .{
        glfw_version.major,
        glfw_version.minor,
        glfw_version.revision,
    });

    const is_init_ok = c.glfwInit();
    if (is_init_ok == c.GLFW_FALSE) {
        return GlfwError.InitGLFWFailure;
    }
}

fn initGL() GlfwError!void {
    std.debug.print("[glfw.initGL]\n", .{});
    const is_glad_load_ok = c.gladLoadGL(@ptrCast(c.GLADloadfunc, &c.glfwGetProcAddress));
    if (is_glad_load_ok == 0) {
        return GlfwError.InitGlFailure;
    }
}

fn windowCreate(width: u32, height: u32, title: [*c]const u8) GlfwError!*c.GLFWwindow {
    std.debug.print("[glfw.windowCreate] width: {}, height: {}, title: {s}\n", .{ width, height, title });
    var maby_window = c.glfwCreateWindow(@intCast(c_int, width), @intCast(c_int, height), title, null, null);
    if (maby_window) |window| {
        return window;
    }
    return GlfwError.InitWindowFailure;
}

fn window_resize_callback(_: ?*c.GLFWwindow, resize_width: c_int, resize_height: c_int) callconv(.C) void {
    std.debug.print("[glfw.window_resize_callback] width: {}, height: {}\n", .{ resize_width, resize_height });
    c.glViewport(0, 0, resize_width, resize_height);
}

// PUBLIC
pub fn initAndCreateWindow(width: u32, height: u32, title: [*c]const u8, window_hint_list: []Window.Hint) GlfwError!*c.GLFWwindow {
    std.debug.print("[glfw.initAndCreateWindow]\n", .{});

    try init();
    for (window_hint_list) |window_hint| {
        Window.hint(window_hint);
    }

    const handle = try windowCreate(width, height, title);
    window_handle = handle;
    c.glfwMakeContextCurrent(window_handle);
    try initGL();

    _ = c.glfwSetFramebufferSizeCallback(window_handle, @ptrCast(c.GLFWframebuffersizefun, &window_resize_callback));

    return handle;
}

pub fn terminate() void {
    std.debug.print("[glfw.terminate]\n", .{});
    if (window_handle) |window| {
        c.glfwDestroyWindow(window);
    }
    c.glfwTerminate();
}

pub fn windowShouldStayOpen() bool {
    if (window_handle) |window| {
        return c.glfwWindowShouldClose(window) == 0;
    } else {
        return false;
    }
    // std.debug.print("[glfw.windowShouldStayOpen]\n", .{});
}

pub fn windowUpdate() GlfwError!void {
    if (window_handle) |window| {
        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    } else {
        return GlfwError.WindowNotFound;
    }
}

pub fn windowKill() GlfwError!void {
    std.debug.print("[glfw.windowKill]\n", .{});
    if (window_handle) |window| {
        c.glfwSetWindowShouldClose(window, c.GLFW_TRUE);
    } else {
        return GlfwError.WindowNotFound;
    }
}
