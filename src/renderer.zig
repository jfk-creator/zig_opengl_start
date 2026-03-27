const std = @import("std");
const builtin = @import("builtin");
const c = @import("c.zig").c;

const Vec2 = @import("vec2.zig").Vec2;
const Vec4 = @import("vec4.zig").Vec4;
const math = @import("mathHelper.zig");

const tri_verts = [_]Vec2{ Vec2.init(0.0, 0.5), Vec2.init(-0.5, -0.5), Vec2.init(0.5, -0.5) };
const rect_verts = [_]Vec2{
    Vec2.init(-0.5, 0.5), Vec2.init(-0.5, -0.5), Vec2.init(0.5, -0.5),
    Vec2.init(-0.5, 0.5), Vec2.init(0.5, -0.5),  Vec2.init(0.5, 0.5),
};
const circle_segments = 32;
const circle_verts = genCircle(circle_segments);

fn genCircle(comptime segments: usize) [segments * 3]Vec2 {
    var verts: [segments * 3]Vec2 = undefined;
    const step = (2.0 * std.math.pi) / @as(f32, @floatFromInt(segments));
    for (0..segments) |i| {
        const a1 = @as(f32, @floatFromInt(i)) * step;
        const a2 = @as(f32, @floatFromInt(i + 1)) * step;
        verts[i * 3 + 0] = Vec2.init(0.0, 0.0);
        verts[i * 3 + 1] = Vec2.init(@cos(a1) * 0.5, @sin(a1) * 0.5);
        verts[i * 3 + 2] = Vec2.init(@cos(a2) * 0.5, @sin(a2) * 0.5);
    }
    return verts;
}

const all_verts = tri_verts ++ rect_verts ++ circle_verts;

var shader_program: c.GLuint = 0;
var u_model_loc: c.GLint = 0;
var u_proj_loc: c.GLint = 0;
var u_color_loc: c.GLint = 0;
var vao: c.GLuint = 0;
var vbo: c.GLuint = 0;

const vertex_shader_src =
    \\#version 330 core
    \\layout (location = 0) in vec2 aPos;
    \\uniform mat4 uModel;
    \\uniform mat4 uProj;
    \\void main() { gl_Position = uProj * uModel * vec4(aPos, 0.0, 1.0); }
;

const fragment_shader_src =
    \\#version 330 core
    \\out vec4 FragColor;
    \\uniform vec4 uColor;
    \\void main() { FragColor = uColor; }
;

fn compileShader(src: [*c]const u8, shader_type: c.GLenum) c.GLuint {
    const shader = c.glCreateShader(shader_type);
    c.glShaderSource(shader, 1, &src, null);
    c.glCompileShader(shader);
    return shader;
}

pub fn init() void {
    const vs = compileShader(vertex_shader_src, c.GL_VERTEX_SHADER);
    const fs = compileShader(fragment_shader_src, c.GL_FRAGMENT_SHADER);
    shader_program = c.glCreateProgram();
    c.glAttachShader(shader_program, vs);
    c.glAttachShader(shader_program, fs);
    c.glLinkProgram(shader_program);
    c.glDeleteShader(vs);
    c.glDeleteShader(fs);

    u_model_loc = c.glGetUniformLocation(shader_program, "uModel");
    u_proj_loc = c.glGetUniformLocation(shader_program, "uProj");
    u_color_loc = c.glGetUniformLocation(shader_program, "uColor");

    c.glGenVertexArrays(1, &vao);
    c.glGenBuffers(1, &vbo);
    c.glBindVertexArray(vao);
    c.glBindBuffer(c.GL_ARRAY_BUFFER, vbo);
    c.glBufferData(c.GL_ARRAY_BUFFER, @intCast(all_verts.len * @sizeOf(Vec2)), &all_verts, c.GL_STATIC_DRAW);
    c.glVertexAttribPointer(0, 2, c.GL_FLOAT, c.GL_FALSE, @sizeOf(Vec2), null);
    c.glEnableVertexAttribArray(0);
}

pub fn beginFrame(width: c_int, height: c_int) void {
    c.glViewport(0, 0, width, height);
    c.glClearColor(0.1, 0.1, 0.15, 1.0);
    c.glClear(c.GL_COLOR_BUFFER_BIT);
    c.glUseProgram(shader_program);
    c.glBindVertexArray(vao);

    const proj = math.ortho(0.0, @floatFromInt(width), @floatFromInt(height), 0.0);
    c.glUniformMatrix4fv(u_proj_loc, 1, c.GL_FALSE, &proj[0]);
}

fn drawShape(offset: c.GLint, count: c.GLsizei, pos: Vec2, size: Vec2, origin: Vec2, rot: f32, color: Vec4) void {
    const model = math.getModelMatrix(pos, size, origin, rot);
    c.glUniformMatrix4fv(u_model_loc, 1, c.GL_FALSE, &model[0]);
    c.glUniform4f(u_color_loc, color.v[0], color.v[1], color.v[2], color.v[3]);
    c.glDrawArrays(c.GL_TRIANGLES, offset, count);
}

pub fn drawTriangle(pos: Vec2, size: Vec2, origin: Vec2, rot: f32, color: Vec4) void {
    drawShape(0, tri_verts.len, pos, size, origin, rot, color);
}
pub fn drawRect(pos: Vec2, size: Vec2, origin: Vec2, rot: f32, color: Vec4) void {
    drawShape(tri_verts.len, rect_verts.len, pos, size, origin, rot, color);
}
pub fn drawCircle(pos: Vec2, size: Vec2, origin: Vec2, rot: f32, color: Vec4) void {
    drawShape(tri_verts.len + rect_verts.len, circle_verts.len, pos, size, origin, rot, color);
}
