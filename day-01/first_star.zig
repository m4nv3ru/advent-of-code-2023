const std = @import("std");

pub fn solve(input_file: std.fs.File) !u32 {
    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var output: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var first_encountered = false;
        var last_num: u8 = undefined;
        for (line) |c| {
            if (c >= '0' and c <= '9') {
                if (!first_encountered) {
                    output = output + ((c - '0') * 10);
                    first_encountered = true;
                }
                last_num = c;
            }
        }
        output = output + (last_num - '0');
    }

    return output;
}

test "first_star_example" {
    const file = try std.fs.cwd().openFile("example_1.txt", .{});
    const output = try solve(file);
    try std.testing.expectEqual(@as(u32, 142), output);
}

test "first_star" {
    const file = try std.fs.cwd().openFile("input.txt", .{});
    const output = try solve(file);
    try std.testing.expectEqual(@as(u32, 56049), output);
}
