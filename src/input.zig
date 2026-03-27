const c = @import("c.zig").c;
pub const Key = enum(c_int) {
    a = c.GLFW_KEY_A, b = c.GLFW_KEY_B, c = c.GLFW_KEY_C, d = c.GLFW_KEY_D,
    e = c.GLFW_KEY_E, f = c.GLFW_KEY_F, g = c.GLFW_KEY_G, h = c.GLFW_KEY_H,
    i = c.GLFW_KEY_I, j = c.GLFW_KEY_J, k = c.GLFW_KEY_K, l = c.GLFW_KEY_L,
    m = c.GLFW_KEY_M, n = c.GLFW_KEY_N, o = c.GLFW_KEY_O, p = c.GLFW_KEY_P,
    q = c.GLFW_KEY_Q, r = c.GLFW_KEY_R, s = c.GLFW_KEY_S, t = c.GLFW_KEY_T,
    u = c.GLFW_KEY_U, v = c.GLFW_KEY_V, w = c.GLFW_KEY_W, x = c.GLFW_KEY_X,
    y = c.GLFW_KEY_Y, z = c.GLFW_KEY_Z,

    zero  = c.GLFW_KEY_0, one   = c.GLFW_KEY_1, two   = c.GLFW_KEY_2,
    three = c.GLFW_KEY_3, four  = c.GLFW_KEY_4, five  = c.GLFW_KEY_5,
    six   = c.GLFW_KEY_6, seven = c.GLFW_KEY_7, eight = c.GLFW_KEY_8,
    nine  = c.GLFW_KEY_9,

    f1 = c.GLFW_KEY_F1, f2 = c.GLFW_KEY_F2, f3 = c.GLFW_KEY_F3, f4 = c.GLFW_KEY_F4,
    f5 = c.GLFW_KEY_F5, f6 = c.GLFW_KEY_F6, f7 = c.GLFW_KEY_F7, f8 = c.GLFW_KEY_F8,
    f9 = c.GLFW_KEY_F9, f10 = c.GLFW_KEY_F10, f11 = c.GLFW_KEY_F11, f12 = c.GLFW_KEY_F12,

    up = c.GLFW_KEY_UP, down = c.GLFW_KEY_DOWN, 
    left = c.GLFW_KEY_LEFT, right = c.GLFW_KEY_RIGHT,

    shift_left   = c.GLFW_KEY_LEFT_SHIFT,
    shift_right  = c.GLFW_KEY_RIGHT_SHIFT,
    ctrl_left    = c.GLFW_KEY_LEFT_CONTROL,
    ctrl_right   = c.GLFW_KEY_RIGHT_CONTROL,
    alt_left     = c.GLFW_KEY_LEFT_ALT,
    alt_right    = c.GLFW_KEY_RIGHT_ALT,
    super_left   = c.GLFW_KEY_LEFT_SUPER, 
    super_right  = c.GLFW_KEY_RIGHT_SUPER,

    space     = c.GLFW_KEY_SPACE,
    escape    = c.GLFW_KEY_ESCAPE,
    enter     = c.GLFW_KEY_ENTER,
    tab       = c.GLFW_KEY_TAB,
    backspace = c.GLFW_KEY_BACKSPACE,
    insert    = c.GLFW_KEY_INSERT,
    delete    = c.GLFW_KEY_DELETE,
    page_up   = c.GLFW_KEY_PAGE_UP,
    page_down = c.GLFW_KEY_PAGE_DOWN,
    home      = c.GLFW_KEY_HOME,
    end       = c.GLFW_KEY_END,
    caps_lock = c.GLFW_KEY_CAPS_LOCK,

    num_0 = c.GLFW_KEY_KP_0, num_1 = c.GLFW_KEY_KP_1, num_2 = c.GLFW_KEY_KP_2,
    num_3 = c.GLFW_KEY_KP_3, num_4 = c.GLFW_KEY_KP_4, num_5 = c.GLFW_KEY_KP_5,
    num_6 = c.GLFW_KEY_KP_6, num_7 = c.GLFW_KEY_KP_7, num_8 = c.GLFW_KEY_KP_8,
    num_9 = c.GLFW_KEY_KP_9,
    num_add      = c.GLFW_KEY_KP_ADD,
    num_subtract = c.GLFW_KEY_KP_SUBTRACT,
    num_multiply = c.GLFW_KEY_KP_MULTIPLY,
    num_divide   = c.GLFW_KEY_KP_DIVIDE,
    num_decimal  = c.GLFW_KEY_KP_DECIMAL,
    num_enter    = c.GLFW_KEY_KP_ENTER,
};

pub fn isKeyDown(window: *c.GLFWwindow, key: Key) bool {
    return c.glfwGetKey(window, @intFromEnum(key)) == c.GLFW_PRESS;
}
