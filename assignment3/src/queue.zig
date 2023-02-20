const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;

// A data structure that operates on a first in - first out basis.
pub fn Queue(comptime T: type, comptime allocator: Allocator) type {
    // This is returning a type. I think the methods
    // Are actually static members holding function pointers.
    return struct {
        head: ?*Node(T),
        tail: ?*Node(T),


        // Create a new queue.
        pub fn new_empty() @This() {
            return @This() {
                .head = null,
                .tail = null,
            };
        }

        // Get the front element of a queue.
        // This dereferences one pointer. O(n)
        pub fn front(self:@This()) ?T {
            if (self.head) |head| {
                return head.value;
            }
            else {
                return null;
            }
        }

        // Add a new element to the queue at the back.
        // This just operates on a set number of pointers. O(n)
        pub fn push_back(self: *@This(), value: T) !void {
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

        // Remove an element from the queue at the front.
        // This operates on a set number of pointers. O(n)
        pub fn pop_front(self: *@This()) void {
            if (self.head) |head| {
                var tail = self.tail.?;
                if (head == tail) {
                    // If there is only one element left in the queue, null it out.
                    allocator.destroy(head);
                    self.head = null;
                    self.tail = null;
                    return;
                }
                var old_head = head;
                self.head = head.next;
                allocator.destroy(old_head);
            }
        }
    };
}

// A datatype that stores an internal element of a queue.
fn Node(comptime T: type) type {
    return struct {
        next: ?*Node(T),
        value: T,
    };
}


// I had a nice blob of text here but I lost it allong with all my comments when I popped stash allong with a bunch of work.
// I dont know why this line has to be this way. Its from https://ziglearn.org/chapter-2/
var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
const test_alloc: Allocator = arena.allocator();

const expect = @import("std").testing.expect;
test "Test pop, push, and peek" {
    const Queue_i32 = Queue(i32, test_alloc);
    var queue: Queue_i32 = Queue_i32.new_empty();
    try queue.push_back(55);
    try queue.push_back(2);
    try expect(queue.front().? == 55);
    queue.pop_front();
    try expect(queue.front().? == 2);
}
