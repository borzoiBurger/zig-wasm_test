const std = @import("std");

pub fn build(b: *std.Build) void {
    const wasm = b.option(bool, "wasm", "target wasm") orelse false;
    var target: std.Build.ResolvedTarget = undefined;
    if (wasm) {
        target = b.resolveTargetQuery(.{
            .cpu_arch = .wasm32, //
            .os_tag = .wasi, // freestanding having trouble despite in 'zig target'?
        });
    } else {
        target = b.graph.host;
    }

    // const optimize: std.builtin.OptimizeMode = .ReleaseSmall;

    const exe = b.addExecutable(.{
        .name = "hello",
        .root_source_file = b.path("hello.zig"),
        .target = target, //
        // .optimize = optimize,
    });
    // exe.entry = .disabled;

    if (!wasm) {
        const run_exe = b.addRunArtifact(exe);
        const run_step = b.step("run", "Run the application");
        run_step.dependOn(&run_exe.step);
    }

    b.installArtifact(exe);
}
