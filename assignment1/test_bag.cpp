#include "bag.cpp"
#include <iostream>
#include <cassert>

// Tests if `Marbles_qty` contains the correct number of marbles.
void test_marble_qty_removal() {
    Marbles_qty bag = Marbles_qty(1, 1, 1);
    srand(time(NULL));
    for (int i = 0; i < 3; i+=1) {
        auto marble = bag.pick_marble();
    }
    auto marble = bag.pick_marble();
    assert(!marble.has_value());
}

void test_marble_qty_add_removal() {
    Marbles_qty bag = Marbles_qty(0, 0, 0);
    optional<Marble> marble_out;

    bag.add_marble(Marble(Color::red));
    marble_out = bag.pick_marble();
    assert(marble_out.has_value());
    assert((*marble_out).color == Color::red);

    bag.add_marble(Marble(Color::green));
    marble_out = bag.pick_marble();
    assert(marble_out.has_value());
    assert((*marble_out).color == Color::green);

    bag.add_marble(Marble(Color::blue));
    marble_out = bag.pick_marble();
    assert(marble_out.has_value());
    assert((*marble_out).color == Color::blue);
}

int main() {
    test_marble_qty_removal();
    test_marble_qty_add_removal();
    cout << "all tests passed" << endl;
    return 0;
}