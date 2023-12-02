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

fn solve(file: std.fs.File) !u32 {
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var i: u32 = 0;

    var output: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        i = 5;
        const game = try read_u8(5, line, ':');
        i += game.length + 2;

        var max_red: u32 = 0;
        var max_green: u32 = 0;
        var max_blue: u32 = 0;

        while (i < line.len) {
            const amount = try read_u8(i, line, ' ');
            i += amount.length + 1;

            if (line[i] == 'r' and amount.value > max_red) {
                max_red = amount.value;
            } else if (line[i] == 'g' and amount.value > max_green) {
                max_green = amount.value;
            } else if (line[i] == 'b' and amount.value > max_blue) {
                max_blue = amount.value;
            }

            while (i < line.len and line[i] != ',' and line[i] != ';') {
                i += 1;
            }
            i += 2;
        }

        output += max_red * max_green * max_blue;
    }

    return output;
}

test "second_star_example" {
    const file = try std.fs.cwd().openFile("example_1.txt", .{});

    try std.testing.expectEqual(@as(u32, 2286), try solve(file));
}

test "second_star" {
    const file = try std.fs.cwd().openFile("input2.txt", .{});

    try std.testing.expectEqual(@as(u32, 83105), try solve(file));
}
