const std = @import("std");

fn linkDependencies(step: *std.Build.Step.Compile, target: std.Build.ResolvedTarget) void {
    step.linkLibC();
    if (target.result.os.tag == .macos) {
        step.linkFramework("OpenGL");
        step.linkFramework("Cocoa");
        step.linkFramework("IOKit");
        step.linkFramework("CoreVideo");
        step.linkFramework("CoreFoundation");
        step.linkSystemLibrary("glfw");
    } else if (target.result.os.tag == .linux) {
        step.linkSystemLibrary("glfw");
        step.linkSystemLibrary("GL");
    }
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "gl_starter",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    linkDependencies(exe, target);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    linkDependencies(unit_tests, target);

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
