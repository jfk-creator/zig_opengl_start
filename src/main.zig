const builtin = @import("builtin");
const c = @import("c.zig").c;

const Vec2 = @import("vec2.zig").Vec2;
const Vec4 = @import("vec4.zig").Vec4;
const renderer = @import("renderer.zig");
const input = @import("input.zig");

pub fn main() !void {
    if (c.glfwInit() == c.GLFW_FALSE) return error.GlfwInitFailed;
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
    c.glfwWindowHint(c.GLFW_SAMPLES, 4);
    if (builtin.os.tag == .macos) {
        c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, c.GL_TRUE);
    }

    const window = c.glfwCreateWindow(800, 600, "Zig OpenGL Starter", null, null) orelse return error.WindowFailed;
    c.glfwMakeContextCurrent(window);
    c.glfwSwapInterval(1);
    renderer.init();

    // Update Helper
    const dt: f32 = 1.0 / 60.0; // Update@60fps 
    var accumulator: f32 = 0.0;

    var player_pos = Vec2.init(400, 300);
    const fixed_speed: f32 = 1000.0; 

    var camera_pos = player_pos; 
    var render_pos = player_pos;
    var camera_zoom: f32 = 1.0;

    var last_frame_time = c.glfwGetTime(); 
    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        c.glfwPollEvents();
        if (input.isKeyDown(window, .escape)) {
            c.glfwSetWindowShouldClose(window, c.GL_TRUE);
        }

        const current_time = c.glfwGetTime();
        var frame_time = @as(f32, @floatCast(current_time - last_frame_time));
        if (frame_time > 0.25) frame_time = 0.25;
        last_frame_time = current_time;
        accumulator += frame_time;

        // Update 
        while (accumulator >= dt) {
            //Player
            const speed = fixed_speed * dt;
            if (input.isKeyDown(window, .w) or input.isKeyDown(window, .up) ) player_pos = player_pos.add(Vec2.init(0, -speed));
            if (input.isKeyDown(window, .s) or input.isKeyDown(window, .down) ) player_pos = player_pos.add(Vec2.init(0, speed));
            if (input.isKeyDown(window, .a) or input.isKeyDown(window, .left) ) player_pos = player_pos.add(Vec2.init(-speed, 0));
            if (input.isKeyDown(window, .d) or input.isKeyDown(window, .right) ) player_pos = player_pos.add(Vec2.init(speed, 0));

            // Camera
            if (input.isKeyDown(window, .q)) camera_zoom -= 1.0 * dt;
            if (input.isKeyDown(window, .e)) camera_zoom += 1.0 * dt;
            if (camera_zoom < 0.1) camera_zoom = 0.1; 

            const alpha = accumulator / dt;
            render_pos = player_pos.lerp(player_pos, alpha);
            camera_pos = camera_pos.lerp(render_pos, 0.1);
            accumulator -= dt;
        }

        var width: c_int = 0;
        var height: c_int = 0;
        c.glfwGetFramebufferSize(window, &width, &height);

        renderer.beginFrame(width, height, camera_pos, camera_zoom);

        renderer.drawCircle(
            Vec2.init(100, 100), Vec2.init(150, 150), Vec2.init(0.5, 0.5), 0, Vec4.init(0.8, 0.0, 1, 1));

        renderer.drawRect(
            Vec2.init(0, 0), 
            Vec2.init(100, 100), 
            Vec2.init(0.5, 0.5),
            0, 
            Vec4.init(1, 0, 0, 1) 
        );

        renderer.drawRect(
            render_pos, 
            Vec2.init(50, 50), 
            Vec2.init(0.5, 0.5),
            0, 
            Vec4.init(0, 0.8, 1, 1) 
        );

        c.glFlush();
        c.glfwSwapBuffers(window);
    }
}


