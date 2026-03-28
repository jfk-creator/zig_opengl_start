const std = @import("std");
const Vec2 = @import("vec.zig").Vec2;

pub fn ortho(left: f32, right: f32, bottom: f32, top: f32) [16]f32 {
    var m = std.mem.zeroes([16]f32);
    m[0] = 2.0 / (right - left);
    m[5] = 2.0 / (top - bottom);
    m[10] = -1.0;
    m[12] = -(right + left) / (right - left);
    m[13] = -(top + bottom) / (top - bottom);
    m[15] = 1.0;
    return m;
}

pub fn getModelMatrix(pos: Vec2, size: Vec2, origin: Vec2, rot: f32) [16]f32 {
    const cr = @cos(rot);
    const sr = @sin(rot);
    return .{
        size.x() * cr,  size.x() * sr,  0.0, 0.0,
        -size.y() * sr, size.y() * cr,  0.0, 0.0,
        0.0,            0.0,            1.0, 0.0,
        pos.x() - (origin.x() * size.x() * cr - origin.y() * size.y() * sr),
        pos.y() - (origin.x() * size.x() * sr + origin.y() * size.y() * cr),
        0.0,            1.0,
    };
}

pub fn getViewMatrix(cam_pos: Vec2, zoom: f32, screen_width: f32, screen_height: f32) [16]f32 {
    var m = std.mem.zeroes([16]f32);
    

    m[0] = zoom;
    m[5] = zoom;
    m[10] = 1.0;
    m[15] = 1.0;


    m[12] = (screen_width / 2.0) - (cam_pos.x() * zoom);
    m[13] = (screen_height / 2.0) - (cam_pos.y() * zoom);

    return m;
}
