import std.stdio;
import better_nullable;
import std.algorithm.iteration;
import std.algorithm.comparison;
import std.algorithm.searching;
import std.format;

struct Tree(Type) {

    Nullable_pointer!(Node!Type) root;
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


private
int get_root_length(Type)(Node!(Type)* node) {
    return node.children[]
        .filter!(a=>a.is_some())
        .map!(a=>a.get().get_root_length() + 1)
        .maxElement(0)
    ;
}

/// test get_root_length
unittest {
    Tree!char tree;
    tree.root = new Node!char('a');
    assert (tree.root.get().get_root_length() == 0);
    tree.root.get().children[0] = new Node!char('b');
    tree.root.get().children[0].get().children[0] = new Node!char('c');
    assert (tree.root.get().get_root_length() == 2);
}


void insert(Type)(ref Tree!Type tree, Type value) {
    if (tree.root.is_some()) {
        tree.root.get().insert(new Node!Type(value));
    } else {
        tree.root = new Node!Type(value);
    }
}

private
void insert(Type)(Node!Type* parent, Node!Type* new_node) {
    // Node!(Type)* current_node = node.;
    auto node = &parent.children[parent.value > new_node.value];

    if (node.is_some()) {
        node.get().insert(new_node);
    } else {
        *node = new_node;
    }
}


unittest {
    Tree!char tree;
    tree.insert('b');
    assert (tree.root.get().get_root_length() == 0);
    tree.insert('a');
    tree.insert('c');
    int len = tree.root.get().get_root_length();
    assert (1 == len, format!"%s"(len));
}
unittest {
    Tree!char tree;
    tree.insert('a');
    tree.insert('b');
    tree.insert('c');
    int len = tree.root.get().get_root_length();
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


unittest {
    Tree!char tree;
    tree.root = new Node!char('a');
    tree.root.get().children[0] = new Node!char('b');
    tree.root.get().children[0].get().children[0] = new Node!char('c');
    assert (tree.root.get().get_root_length() == 2);
    tree.root.get().rotate!(1, char);
    assert (tree.root.get().get_root_length() == 1);
    assert (!tree.root.get().children[0].get().children[0].is_some);
    assert (!tree.root.get().children[0].get().children[1].is_some);
    assert (!tree.root.get().children[1].get().children[0].is_some);
    assert (!tree.root.get().children[1].get().children[1].is_some);
}



void remove(Type)(Node!Type* parent, Node!Type* new_node) {
    // Node!(Type)* current_node = node.;
    auto node = &parent.children[parent.value > new_node.value];

    if (node.is_some()) {
        node.get().insert(new_node);
    } else {
        *node = new_node;
    }
}



// private
// Node!(Type)* fetch_position(Type)(Node!(Type)* node, Type value) {
//     Node!(Type)* current_node = node;
//     while(1) {
//         /// This is using a boolean as an array index
//         auto next_node = current_node.children[
//             value < current_node.value
//         ];
//         if (next_node.is_some) {
//             current_node = next_node.get();
//         } else {
//             break;
//         }
//     }
//     return current_node;
// }
