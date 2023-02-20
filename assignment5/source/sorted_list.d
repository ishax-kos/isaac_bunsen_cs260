import std.stdio;
import better_nullable;
import std.algorithm.iteration;

struct Tree(Type) {

    Nullable_pointer!(Node!Type) root;
}

private
struct Node(Type) {
    Nullable_pointer!(Node)[2] children;
    Type value;
    int rank;
}


// void insert(Type)(ref Tree!Type tree, Type value) {
//     tree.
// }

private
Node!(Type)* fetch_position(Type)(Node!(Type)* node, Type value) {
    Node!(Type)* current_node = node;
    while(1) {
        /// This is using a boolean as an array index
        auto next_node = current_node.children[
            value < current_node.value
        ];
        if (next_node.is_some) {
            current_node = next_node.get();
        } else {
            break;
        }
    }
    return current_node;
}


private
int get_root_length(Node!(Type)* node) {
    node.children[]
        .filter!(a=>a.is_some)
        .map!(a=>a.get().get_root_length())
    ;
}
