import std.stdio;
import better_nullable;
import std.algorithm.iteration;
import std.algorithm.comparison;
import std.algorithm.searching;
import std.concurrency: Generator, yield;

/++ A Binary tree. +/
struct Tree(Type) {
    /+ Tests for methods are placed after
    their subtree counterparts. +/
    Nullable_pointer!(Node!Type) root;

    /++ Insert a node into the binary tree. +/
    void insert(Type value) {
        this.root.insert!Type(new Node!Type(value));
    }


    /++ Search for a node in the tree and
        remove it if possible. A nullable
        pointer to the node is returned. +/
    Nullable_pointer!Type
    find_and_remove(Type value) {
        return this.root.find_and_remove!Type(value);
    }


    /++ Find a value in the tree.
        Returns a nullable pointer. +/
    Nullable_pointer!Type
    find(Type value) {
        return this.root.find!Type(value);
    }

    /++ Produces a range that fetches values
        in sorted order +/
    auto in_order() {
        return new Generator!(char)(() {
            traverse!(Order.in_, char)(this.root);
        });
    }
    /++ Produces a range that iterates a
        pre-order traversal +/
    auto pre_order() {
        return new Generator!(char)(() {
            traverse!(Order.pre, char)(this.root);
        });
    }
    /++ Produces a range that iterates a
        post-order traversal +/
    auto post_order() {
        return new Generator!(char)(() {
            traverse!(Order.post, char)(this.root);
        });
    }
    /++ Produces a range that iterates the
        tree in breadth-first order +/
    auto breadth_first() {
        return Traversal_breadth_first!Type(this);
    }
}


private:


/++ Node that wraps a value with a pointer
    It has a rank value that is unused. +/
struct Node(Type) {
    Nullable_pointer!(Node)[2] children;
    Type value;
    int rank;

    /++ Node constructor +/
    this(Type value) {
        this.value = value;
    }
}


void insert(Type)(
    ref Nullable_pointer!(Node!Type) node,
    Node!Type* new_node
) {
    if (node.is_some()) {
        auto old = node.get();
        old.children[old.value < new_node.value]
            .insert!Type(new_node)
        ;
    } else {
        node = nullable_pointer(new_node);
    }
}

unittest { /// Test insert overloads
    import std.format;
    Tree!char tree;
    // A root node with no children should be height 0
    tree.insert('b');
    assert (tree.root.get_node_height() == 0);
    // Adding a value greater and a value lesser
    // than the root node should not increase
    // the height more than once.
    tree.insert('a');
    tree.insert('c');
    int len = tree.root.get_node_height();
    assert (1 == len, format!"%s"(len));
}
unittest {
    import std.format;
    Tree!char tree;
    // Without balancing, adding sequential values should
    // increase the height for each value added.
    tree.insert('a');
    tree.insert('b');
    tree.insert('c');
    int len = tree.root.get_node_height();
    assert (2 == len, format!"%s"(len));
}


/++ Remove a node from the sub tree.
    If it does not exist return null,
    if it does, return a pointer to
    it's value.
+/
Nullable_pointer!Type
find_and_remove(Type)(
    ref Nullable_pointer!(Node!Type) node_ref,
    Type value
) {
    if (node_ref.is_some()) {
        auto node = node_ref.get();
        if (node.value != value) {
            return node.children[node.value < value]
                .find_and_remove!Type(value);
        }
        node_ref = node.children[0];
        if (node.children[1].is_some()) {
            if (node_ref.is_some()) {
                node_ref.insert!Type(node.children[1].get());
            } else {
                node_ref = node.children[1];
            }
        }
        return nullable_pointer(&(node.value));
    } else {
        return Nullable_pointer!Type.none;
    }
}

unittest { /// Test removal
    Tree!char tree;
    // If a node is removed it should be null.
    tree.insert('a');
    tree.find_and_remove('a');
    assert(!tree.root.is_some());
    // If a node that doesn't exist is removed
    // it should have no effect.
    tree.insert('b');
    tree.find_and_remove('c');
    assert(tree.root.is_some());
    // When a node is removed, what is returned
    // should be a valid pointer, even if other
    // Nodes have been inserted after it.

    // Child nodes should take the place of
    // parent nodes when the parent is removed.
    tree.insert('c');
    tree.insert('d');
    auto old_value = *tree.find_and_remove('b').get();
    // auto ch = tree.root.get().children;
    assert(tree.root.get().value == 'c');
    assert(old_value == 'b');
}


/++ Find a value in the sub tree.
    Returns a nullable pointer. +/
Nullable_pointer!Type
find(Type)(ref Nullable_pointer!(Node!Type) node_ref, Type value) {
    if (node_ref.is_some()) {
        auto node = node_ref.get();
        if (node.value != value) {
            return node.children[node.value < value].find!Type(value);
        }
        return nullable_pointer(&node.value);
    } else {
        return Nullable_pointer!Type.none;
    }
}

unittest { /// Test find function
    Tree!char tree;
    // If a value is inserted it should be findable.
    tree.insert('b');
    assert(tree.find('b').is_some());
    // If a value is removed and it has no twins,
    // it should not be findable. Its children should
    // still be findable.
    tree.insert('a');
    tree.insert('c');
    tree.find_and_remove('b');
    assert(!tree.find('b').is_some());
    assert(tree.find('a').is_some());
    assert(tree.find('c').is_some());
    // Removed nodes should not be findable even
    // if they weren't the root.
    tree.find_and_remove('a');
    tree.find_and_remove('c');
    assert(!tree.find('a').is_some());
    assert(!tree.find('c').is_some());
}

struct Traversal_node(T) {
    // Traversal_node(T)* last;
}

void traverse_in_order(Type, traversal)(ref Node!Type node) {
    import std.concurrency;
    // import std.stdio;
    writefln!"Pre: %s"(node.value);
    if (node.children[0].is_some()) {
        traverse(*node.children[0].get());
    }
    static if (0) {yeild(node.value);}
    if (node.children[1].is_some()) {
        traverse(*node.children[1].get());
    }
    writefln!"        Post: %s"(node.value);
    // if (node.children[0].is_some()) {
    //     recurse(node.children[0].get());
    // }
}


void traverse(Order order, Type)(Nullable_pointer!(Node!Type) node) {
    if (node.is_some()) {
        import std.concurrency;
        auto some = node.get();
        static if (order == Order.pre) {yield(some.value);}
        traverse!(order, Type)(some.children[0]);
        static if (order == Order.in_) {yield(some.value);}
        traverse!(order, Type)(some.children[1]);
        static if (order == Order.post) {yield(some.value);}
    } else {
        return;
    }
}

enum Order {
    pre,
    in_,
    post,
}

unittest {
    import std.algorithm.comparison;
    // import std.stdio;
    Tree!char tree;

    assert(tree.in_order().empty());
    assert(tree.post_order().empty());
    assert(tree.pre_order().empty());

    // Based on the traversal diagram on wikipedia
    // Are the ranges able to reproduce the same
    // order of letters?
    tree.insert('f');
    tree.insert('b');
    tree.insert('g');
    tree.insert('a');
    tree.insert('d');
    tree.insert('i');
    tree.insert('c');
    tree.insert('e');
    tree.insert('h');
    import std.concurrency;

    assert(equal(tree.in_order(),   "abcdefghi"));
    assert(equal(tree.post_order(), "acedbhigf"));
    assert(equal(tree.pre_order(),  "fbadcegih"));
}


/++
    A traversal struct
    contains a queue and a tree.
    +/
struct Traversal_breadth_first(Type) {
    import queue;
    Tree!Type tree;
    Queue!(Node!Type*) queue_;

    this(Tree!Type tree) {
        this.tree = tree;
        if (tree.root.is_some()) {
            this.queue_.insert_back(tree.root.get());
        }
    }

    Type front() {
        return queue_.front().value;
    }

    void pop_front() {
        auto node = queue_.front();
        queue_.pop_front();
        node.children[]
            .filter!(a=>a.is_some())
            .each!(a=>queue_.insert_back(a.get()));
    }
    alias popFront = pop_front;

    bool empty() {
        return queue_.empty();
    }

}
// void traversal_breadth_first() {
//     Queue!Type queue;
//     root
//         .filter!(a=>a.is_some())
//         .each()
//     ;
// }


unittest {
    import std.algorithm.comparison;
    // import std.stdio;
    Tree!char tree;
    // Based on the traversal diagram on wikipedia
    // Are the ranges able to reproduce the same
    // order of letters as they appear in reading order?
    tree.insert('f');
    tree.insert('b');
    tree.insert('g');
    tree.insert('a');
    tree.insert('d');
    tree.insert('i');
    tree.insert('c');
    tree.insert('e');
    tree.insert('h');
    auto traversal = Traversal_breadth_first!char(tree);
    assert(equal(traversal, "fbgadiceh"));
}


/+
----------------------------------------------------
*** Functions below are intended for future use. ***
----------------------------------------------------
+/


void rotate(int direction, Type)(ref Node!Type* parent) {
    enum d1 = direction;
    enum d0 = 1-direction;
    auto old_parent = parent;
    auto child = old_parent.children[d0].get();

    old_parent.children[d0] = child.children[d1];
    child.children[d1] = old_parent;
    parent = child;
}

unittest { /// Test rotation
    Tree!char tree;
    tree.root = new Node!char('a');
    tree.root.get().children[0] = new Node!char('b');
    tree.root.get().children[0].get().children[0] = new Node!char('c');
    assert (tree.root.get_node_height() == 2);
    tree.root.get().rotate!(1, char);
    assert (tree.root.get_node_height() == 1);
    assert (!tree.root.get().children[0].get().children[0].is_some);
    assert (!tree.root.get().children[0].get().children[1].is_some);
    assert (!tree.root.get().children[1].get().children[0].is_some);
    assert (!tree.root.get().children[1].get().children[1].is_some);
}


// This is used in tests above
int get_node_height(NonNullNode)(NonNullNode node) {
    if (node.is_some()) {
        return node.get().children[]
            .map!(a=>a.get_node_height() + 1)
            .maxElement(-1)
        ;
    } else {
        return -1;
    }
}

unittest { /// test get_node_height
    Tree!char tree;
    tree.root = new Node!char('a');
    assert (tree.root.get_node_height() == 0);
    tree.root.get().children[0] = new Node!char('b');
    tree.root.get().children[0].get().children[0] = new Node!char('c');
    assert (tree.root.get_node_height() == 2);
}
