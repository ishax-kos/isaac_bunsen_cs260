const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;



pub fn Queue(comptime T: type) type {
    return struct {
        head: ?*Node(T),
        tail: ?*Node(T),
        allocator: *Allocator,


        pub fn init(allocator: *Allocator) Queue(T) {
            return Queue(T) {
                .head = null,
                .tail = null,
                .allocator = allocator
            };
        }

        pub fn front() ?T {
            if (.head) |head| {
                return head.value;
            }
            else {
                return null;
            }
        }
        
        pub fn push_back(value: T) void {
            var new_node: *Node(T) = try .allocator
                .allocate(Node(.tail, value));
            .tail.next = new_node;
            (.tail) = new_node;
            if (!.head) {
                (.head) = new_node;
            }
        }

        pub fn pop_front() void {
            if (!.head) {return;}
            var old_head = .head;
            (.head) = .head.next;
            .allocator.free(old_head);
        }
    };
}


const expect = @import("std").testing.expect;
test "see if anything works" {

    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();

    // const allocator = arena.allocator();

    // const ptr = try allocator.create(i32);
    // std.debug.print("ptr={*}\n", .{ptr});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    var allocator = arena.allocator();
    var queue = Queue(i32).init(&allocator);
    queue.push_back(55);
    try expect(queue.front() == 55);
}


fn Node(comptime T: type) type {
    return struct {
        next: ?*Node(T),
        value: T,
    };
}