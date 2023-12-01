const std = @import("std");

const spelled_digits = [9][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

pub fn solve(input_file: std.fs.File) !u32 {
    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var output: u32 = 0;
    var first_encountered = false;
    var last_num: u8 = undefined;
    var i: usize = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        first_encountered = false;
        last_num = 0;
        i = 0;

        while (i < line.len) : (i += 1) {
            if (line[i] >= '0' and line[i] <= '9') {
                if (!first_encountered) {
                    output = output + ((line[i] - '0') * 10);
                    first_encountered = true;
                }
                last_num = line[i] - '0';
            } else {
                for (spelled_digits, 1..) |digit, j| {
                    if (i + digit.len < line.len and std.mem.eql(u8, digit, line[i .. i + digit.len])) {
                        if (!first_encountered) {
                            output = output + (@as(u8, @intCast(j)) * 10);
                            first_encountered = true;
                        }
                        last_num = @intCast(j);
                        break;
                    }
                }
            }
        }
        output = output + last_num;
    }

    return output;
}

test "second_star_example" {
    const file = try std.fs.cwd().openFile("example_2.txt", .{});
    const output = try solve(file);
    try std.testing.expectEqual(@as(u32, 281), output);
}

test "second_star" {
    const file = try std.fs.cwd().openFile("input2.txt", .{});
    const output = try solve(file);
    try std.testing.expectEqual(@as(u32, 54530), output);
}
