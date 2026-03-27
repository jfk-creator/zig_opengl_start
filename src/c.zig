const builtin = @import("builtin");

pub const c = @cImport({
    @cDefine("GL_GLEXT_PROTOTYPES", "1");
    if (builtin.os.tag == .macos) {
        @cDefine("GLFW_INCLUDE_GLCOREARB", "1");
    }
    @cInclude("GLFW/glfw3.h");
});
