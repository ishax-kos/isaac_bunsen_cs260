#include <cstdlib>
#include <vector>
#include <optional>
#include <time.h>
#include <cassert>

using namespace std;


// A set of numeric constants representing 
// all possible marble colors
enum Color {
    red,
    blue,
    green,
};


// A type representing an individual marble
struct Marble {
    Color color;

    Marble(Color col) {
        color = col;
    }
};


// A collection of marbles based on numeric quantities. 
// Marbles can be red, green or blue.
// There is no handling of integer overflow.
struct Marbles_qty {
    int red;
    int green;
    int blue;

    Marbles_qty(int red_count, int green_count, int blue_count) {
        assert(red_count >= 0);
        assert(green_count >= 0);
        assert(blue_count >= 0);
        red = red_count;
        green = green_count;
        blue = blue_count;
    }

    // Remove a marble from the collection at random. 
    // If there are no marbles, nullopt is returned.
    optional<Marble> pick_marble() {
        int max = red + green + blue;
        if (max == 0) {return nullopt;}
        int index = rand() % max;
        if (index < red) {
            red -= 1;
            return Marble(Color::red);
        }
        index -= red;

        if (index < green) {
            green -= 1;
            return Marble(Color::green);
        } 
        
        else {
            blue -= 1;
            return Marble(Color::blue);
        }
    }


    // Add a marble to the collection given a marble.
    // The marble value is not actually stored, but a 
    // value corresponding to its color is incremented.
    void add_marble(Marble new_marble) {
        switch (new_marble.color) {
            case Color::red:{
                red += 1;
                return;
            }
            case Color::green:{
                green += 1;
                return;
            }
            case Color::blue:{
                blue += 1;
                return;
            }
        }
    }
};



