module list;


struct List(Type) {
    import better_nullable;
    import std.exception: enforce;

    bool empty() {
        return !node_front.is_some;
    }

    void insert(int position, Type value) {
        enforce(0 <= position, "Position cannot be negative (for now).");
        if (position == 0) {
            node_front = nullable_pointer(new Node(node_front, value));
        }
        else {
            enforce(node_front.is_some, "Empty list can only grow from 0!");
            Node* current_node = node_front.get;
            /// This operates on a nodes next property and must therefore
            /// be ahead by 1.
            int pos = 1;
            while (1) {
                if (pos == position) {break;}
                pos += 1;
                enforce(current_node.next.is_some, "Index exceeds end of list");
                current_node = current_node.next.get;
            }
            current_node.next = nullable_pointer(new Node(current_node.next, value));
        }
    }
    // void insert_front(Type value) {}
    // void insert_back(Type value) {}

    void remove(int position) {
        enforce(0 <= position, "Position cannot be negative (for now).");
        enforce(!this.empty, "Cannot remove from an empty list");

        if (position == 0) {
            node_front = node_front.get.next;
            return;
        }

        Node* current_node = node_front.get;
        /// This operates on a nodes next property and must therefore
        /// be ahead by 1.
        int pos = 1;
        while (1) {
            if (pos == position) {break;}
            pos += 1;
            enforce(current_node.next.is_some, "Index exceeds end of list");
            current_node = current_node.next.get;
        }
        enforce (current_node.next.is_some, "Tried to remove beyond end of list!");
        current_node.next = current_node.next.get.next;
    }
    // void remove_front() {}
    // void remove_back() {}

    Type fetch(int position) {
        enforce(0 <= position, "Position cannot be negative (for now).");
        enforce(!this.empty, "Getting value in empty list!");

        Node* current_node = node_front.get;
        int pos = 0;
        while (1) {
            if (pos == position) {break;}
            pos += 1;
            enforce(current_node.next.is_some, "Index exceeds end of list");
            current_node = current_node.next.get;
        }
        return current_node.value;
    }
    // Type front() {}
    // Type back() {}

    struct Node {
        /// The reference to the next node.
        Nullable_pointer!Node next;
        /// Node* prev;
        Type value;

        this(Type value) {
            this.value = value;
            this.next = Nullable_pointer!Node.none;
        }
        this(Nullable_pointer!Node next, Type value) {
            this.value = value;
            this.next = next;
        }
    }

    private:
    Nullable_pointer!Node node_front;
    // Node* node_back;
    // Node* seek;
}


version(unittest) {
    import std.format;
}


unittest {
    List!int foo;

    foo.insert(0, 3);
    foo.insert(0, 4);
    foo.insert(1, 7);
    assert(foo.fetch(0) == 4, format!"value: %s"(foo.fetch(0)));
    assert(foo.fetch(1) == 7, format!"value: %s"(foo.fetch(1)));
    assert(foo.fetch(2) == 3, format!"value: %s"(foo.fetch(2)));
    foo.remove(2);
    assert(foo.fetch(1) == 7, format!"value: %s"(foo.fetch(1)));

    try {
        foo.remove(2);
        assert(false);
    } catch(Exception e) {}
    foo.remove(0);
    assert(foo.fetch(0) == 7, format!"value: %s"(foo.fetch(0)));
    foo.remove(0);
}


unittest {
    List!int foo;
    foo.insert(0, 11);

    try {
        foo.insert(2, 77);
        assert(false);
    } catch(Exception e) {}
    try {
        foo.fetch(2);
        assert(false);
    } catch(Exception e) {}
    try {
        foo.remove(-1);
        assert(false);
    } catch(Exception e) {}

}
