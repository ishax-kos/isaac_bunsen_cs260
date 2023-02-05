const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;

pub fn Queue(comptime T: type) type {
    return struct {
        head: ?*Node(T),
        tail: ?*Node(T),


        pub fn new_empty() Queue(T) {
            return Queue(T) {
                .head = null,
                .tail = null,
            };
        }

        pub fn front(self:Queue(T)) ?T {
            if (self.head) |head| {
                return head.value;
            }
            else {
                return null;
            }
        }
        
        pub fn push_back(self: *Queue(T), value: T) !void {
            var new_node: *Node(T) = try allocator.create(Node(T));
            new_node.next = self.tail;
            new_node.value = value;
            if (self.tail) |tail| {
                tail.next = new_node;
            } else {
                self.head = new_node;
            }
            self.tail = new_node;
        }

        pub fn pop_front(self: *Queue(T)) void {
            if (self.head) |head| {
                const tail = self.tail.?;
                if (head == tail) {
                    // If there is only one element left in the queue, null it out.
                    allocator.free(head);
                    allocator.free(tail);
                    self.head = null;
                    self.tail = null;
                }
                else {
                    var old_head = head;
                    self.head = head.next;
                    allocator.free(old_head);
                }
            }
        }
    };
}


fn Node(comptime T: type) type {
    return struct {
        next: ?*Node(T),
        value: T,
    };
}

var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
var allocator: Allocator = arena.allocator();

const expect = @import("std").testing.expect;
test "see if anything works" {
    var queue: Queue(i32) = Queue(i32).new_empty();
    try queue.push_back(55);
    try queue.push_back(2);
    queue.pop_front();
    try expect(queue.front().? == 55);
    try expect(queue.front().? == 2);
}
