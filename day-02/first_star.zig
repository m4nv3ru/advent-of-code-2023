const std = @import("std");

const NumericInput = struct {
    value: u32,
    length: u32,
};

fn read_u8(start: u32, data: []const u8, delimiter: u8) !NumericInput {
    std.log.info("Trying to parse {c}", .{data[start]});
    var i: u32 = start;
    while (i < data.len and data[i] != delimiter) {
        i += 1;
    }
    return NumericInput{ .value = try std.fmt.parseUnsigned(u32, data[start..i], 10), .length = i - start };
}

fn solve_1(file: std.fs.File, red: u8, green: u8, blue: u8) !u32 {
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var i: u32 = 0;

    var output: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        i = 5;
        const game = try read_u8(5, line, ':');
        i += game.length + 2;

        var invalid: bool = false;
        while (i < line.len) {
            const amount = try read_u8(i, line, ' ');
            i += amount.length + 1;

            if (line[i] == 'r' and amount.value > red) {
                invalid = true;
            } else if (line[i] == 'g' and amount.value > green) {
                invalid = true;
            } else if (line[i] == 'b' and amount.value > blue) {
                invalid = true;
            }

            if (invalid) {
                i = @as(u32, @intCast(line.len));
            } else {
                while (i < line.len and line[i] != ',' and line[i] != ';') {
                    i += 1;
                }
            }
            i += 2;
        }

        if (!invalid) {
            output += game.value;
        }
    }

    return output;
}

test "first_star_example" {
    const file = try std.fs.cwd().openFile("example_1.txt", .{});

    try std.testing.expectEqual(@as(u32, 8), try solve_1(file, 12, 13, 14));
}

test "first_star" {
    const file = try std.fs.cwd().openFile("input1.txt", .{});

    try std.testing.expectEqual(@as(u32, 1931), try solve_1(file, 12, 13, 14));
}
