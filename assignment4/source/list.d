module list;


struct List(Type) {
    import std.typecons: NullableRef, nullableRef;
    
    void insert(int position, Type value) {}
    // void insert_front(Type value) {}
    // void insert_back(Type value) {}
    void remove(int position) {}
    // void remove_front() {}
    // void remove_back() {}
    Type fetch(int position) {
        Node current_node = node_front;
        int pos = 0;
        while (pos < position) {
            pos += 1;
            current_node = current_node.next;
        }
        return current_node.value;
    }
    // Type front() {}
    // Type back() {}

    struct Node {
        NullableRef!Node next;
        // Node* prev;
        Type value;
    }

    private:
    NullableRed!Node node_front;
    // Node* node_back;
    // Node* seek;
}


unittest {
    List!int foo;
    // import std.stdio;
	// writeln("Edit source/app.d to start your project.");
}
