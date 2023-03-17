const std = @import("std");

pub const Debouce = struct {
    const Self = @This();
    timestamp: i64,

    pub fn init() Self {
        return Self{
            .timestamp = 0,
        };
    }

    pub fn doit(self: *Self, ms: i64) ?i64 {
        const current_time = std.time.milliTimestamp();
        const delta_time = current_time - self.timestamp;
        self.timestamp = current_time;

        if (delta_time > ms) {
            return delta_time;
        }
        return null;
    }
};

pub const Throttle = struct {
    const Self = @This();
    timestamp: i64,

    pub fn init() Self {
        return Self{
            .timestamp = 0,
        };
    }

    pub fn doit(self: *Self, ms: i64) ?i64 {
        const current_time = std.time.milliTimestamp();
        const delta_time = current_time - self.timestamp;

        if (delta_time > ms) {
            self.timestamp = current_time;
            return delta_time;
        }
        return null;
    }
};
