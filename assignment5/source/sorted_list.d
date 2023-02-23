import std.stdio;
import better_nullable;
import std.algorithm.iteration;
import std.algorithm.comparison;
import std.algorithm.searching;
import std.format;

struct Tree(Type) {
    private enum nil_element = Type.init;
    Nullable_pointer!(Node!Type) root;

    void insert(Type value) {
        if (this.root.is_some()) {
            this.root.get().insert(new Node!Type(value));
        } else {
            this.root = new Node!Type(value);
        }
    }


    Nullable_pointer!(Node!Type) remove_if_found(Type value) {
        return this.root.remove_if_found!Type(value);
    }

    bool contains_value(Type value) {
        return this.root.contains_value!Type(value);
    }
}

private
struct Node(Type) {
    Nullable_pointer!(Node)[2] children;
    Type value;
    int rank;

    this(Type value) {
        this.value = value;
    }
}


private:


int get_node_height(Type)(Node!(Type)* node) {
    return node.children[]
        .filter!(a=>a.is_some())
        .map!(a=>a.get().get_node_height() + 1)
        .maxElement(0)
    ;
}

/// test get_node_height
unittest {
    Tree!char tree;
    tree.root = new Node!char('a');
    assert (tree.root.get().get_node_height() == 0);
    tree.root.get().children[0] = new Node!char('b');
    tree.root.get().children[0].get().children[0] = new Node!char('c');
    assert (tree.root.get().get_node_height() == 2);
}



void insert(Type)(Node!Type* parent, Node!Type* new_node) {
    // Node!(Type)* current_node = node.;
    auto node = &parent.children[parent.value > new_node.value];

    if (node.is_some()) {
        node.get().insert(new_node);
    } else {
        *node = new_node;
    }
}

/// Test insert overloads
unittest {
    Tree!char tree;
    tree.insert('b');
    assert (tree.root.get().get_node_height() == 0);
    tree.insert('a');
    tree.insert('c');
    int len = tree.root.get().get_node_height();
    assert (1 == len, format!"%s"(len));
}
unittest {
    Tree!char tree;
    tree.insert('a');
    tree.insert('b');
    tree.insert('c');
    int len = tree.root.get().get_node_height();
    assert (2 == len, format!"%s"(len));
}


void rotate(int direction, Type)(ref Node!Type* parent) {
    enum d1 = direction;
    enum d0 = 1-direction;
    auto old_parent = parent;
    auto child = old_parent.children[d0].get();

    old_parent.children[d0] = child.children[d1];
    child.children[d1] = old_parent;
    parent = child;
}


/// Test rotation
unittest {
    Tree!char tree;
    tree.root = new Node!char('a');
    tree.root.get().children[0] = new Node!char('b');
    tree.root.get().children[0].get().children[0] = new Node!char('c');
    assert (tree.root.get().get_node_height() == 2);
    tree.root.get().rotate!(1, char);
    assert (tree.root.get().get_node_height() == 1);
    assert (!tree.root.get().children[0].get().children[0].is_some);
    assert (!tree.root.get().children[0].get().children[1].is_some);
    assert (!tree.root.get().children[1].get().children[0].is_some);
    assert (!tree.root.get().children[1].get().children[1].is_some);
}



Nullable_pointer!(Node!Type) remove_if_found(Type)(
    ref Nullable_pointer!(Node!Type) node_ref,
    Type value
) {
    if (node_ref.is_some()) {
        auto node = node_ref.get();
        if (node.value != value) {
            return node.children[node.value > value].remove_if_found!Type(value);
        }
        node_ref = node.children[0];
        if (node.children[1].is_some()) {
            if (node_ref.is_some()) {
                node_ref.get().insert!Type(node.children[1].get());
            } else {
                node_ref = node.children[1];
            }
        }
        return nullable_pointer(node);
    } else {
        return Nullable_pointer!(Node!Type).none;
    }
}

/// Test removal
unittest {
    Tree!char tree;
    tree.insert('a');
    tree.remove_if_found('a');
    assert(!tree.root.is_some());
    tree.insert('b');
    tree.remove_if_found('c');
    assert(tree.root.is_some());
    tree.insert('c');
    tree.insert('d');
    auto old_node = tree.remove_if_found('b').get();
    // auto ch = tree.root.get().children;
    assert(tree.root.get().value == 'c');
    assert(old_node.value == 'b');
}


bool contains_value(Type)(ref Nullable_pointer!(Node!Type) node_ref, Type value) {
    if (node_ref.is_some()) {
        auto node = node_ref.get();
        if (node.value != value) {
            return node.children[node.value > value].contains_value!Type(value);
        }
        return true;
    } else {
        return false;
    }
}

/// Test contains function
unittest {
    Tree!char tree;
    tree.insert('b');
    assert(tree.contains_value('b'));
    tree.insert('a');
    tree.insert('c');
    tree.remove_if_found('b');
    assert(!tree.contains_value('b'));
    assert(tree.contains_value('a'));
    assert(tree.contains_value('c'));
    tree.remove_if_found('a');
    tree.remove_if_found('c');
    assert(!tree.contains_value('a'));
    assert(!tree.contains_value('c'));
}
