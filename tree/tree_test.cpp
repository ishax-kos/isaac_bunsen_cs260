#include <cstdio>
#include <cassert>
#include "tree.cpp"


void unittest_bs_node() {
    Bs_node<int> tree = Bs_node(6);
    tree.insert(7);
    tree.insert(1);

    if (tree.child_l) {
        (tree.child_l)->datum;
    }
}


int main() {
    unittest_bs_node();
    return 0;
}
