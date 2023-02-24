module queue;
import better_nullable: Nullable_pointer, nullable_pointer;
import std.exception: enforce;

struct Queue(Type) {
    struct Node {
        Nullable_pointer!Node next;
        Type value;
        this (Type value) {
            this.value = value;
        }
    }

    Nullable_pointer!Node top;
    Nullable_pointer!Node bottom;

    void insert_back(Type new_value) {
        if (top.is_some()) {
            auto old_bottom = this.bottom.get();
            old_bottom.next = new Node(new_value);
            this.bottom = old_bottom.next;
        } else {
            top = new Node(new_value);
            bottom = top;
        }
    }
    void pop_front() {
        enforce(top.is_some());
        if (top == bottom) {
            top.nullify();
            bottom.nullify();
        } else {
            top = top.get().next;
        }
    }
    alias popFront = pop_front;

    Type front() {
        enforce(top.is_some());
        return top.get().value;
    }

    bool empty() {
        return !top.is_some();
    }
}


unittest {
    Queue!char queue;
    queue.insert_back('a');
    queue.insert_back('a');
    queue.insert_back('c');
    queue.insert_back('b');
    assert(queue.front == 'a');
    queue.pop_front();
    assert(queue.front == 'a');
    queue.pop_front();
    assert(queue.front == 'c');
    queue.pop_front();
    assert(queue.front == 'b');
    queue.pop_front();
    assert(queue.empty());
    assert(!queue.bottom.is_some());
}
