#include <optional>

using std::optional;


// template<typename T>
// struct Option_p {
//     unique_ptr<T> ptr;
//     T& unwrap() {
//         return ptr;
//     }
// };


template<typename T>
struct Bs_node {
    T datum;
    char rank;
    
    optional<unique_ptr<Bs_node>> child_l;
    optional<unique_ptr<Bs_node>> child_r;

    Bs_node(T value) {
        datum = value;
    }

    void insert(T value) {
        if (value < this->datum) {
            this->child_l = new Bs_node<T>(value);
            return;
        }
        if (value > this->datum) {
            this->child_r = new Bs_node<T>(value);
            return;
        }
    }

    ~Bs_node() {
        if (this->child_l.has_value) {
            this
        }
        if (this->child_r.has_value) {
            
        }
    }
};


template<typename T>
struct Bs_tree {
    optional<Bs_node<T>> trunk;

    void insert(T value) {
        if (!trunk.has_value()) {
            trunk = Bs_node<T>(value);
        }
        else {
            trunk->insert(value);
        }
    }
};



