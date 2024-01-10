const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const build_m4 = b.addSystemCommand(&[_][]const u8{
        b.zig_exe,
        "build-exe",
        "-target",
        "arm-linux-eabihf",
        "-mcpu=cortex_m4",
        "-femit-bin",
        "zig-out",
        "--script",
        "memory.ld",
        "src/main.zig",
    });

    b.default_step.dependOn(&build_m4.step);
}
