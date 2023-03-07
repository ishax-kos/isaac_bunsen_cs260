module hash_table_improved;
import better_nullable;
import std.traits;
import std.algorithm: fold;
import std.exception: enforce;


alias Hash_type = long;


/++ A data structure implementing a hash table. +/
struct Hash_table(Key, Value) {
    private alias Nulla_node = Nullable_pointer!Node;
    Nullable_pointer!(Node)[] memory = new Nullable_pointer!Node[](32);
    long length;

    /++ Tests whether a key exists in the list. +/
    bool contains(Key key) {
        Nulla_node node = memory[hash(key) % memory.length];
        while (node.is_some()) {
            auto some_node = node.get();
            if (some_node.key == key) {return true;}
            else {node = some_node.next;}
        }
        return false;
    }

    /++ Insert a new value or overwrite an exiting value in the hash map. +/
    void insert(Key key, Value value) {
        Hash_type position = hash(key) % memory.length;
        Nulla_node old_node = memory[position];
        Node* node = new Node(key, value);
        node.next = old_node;
        memory[position] = nullable_pointer(node);
        length += 1;
    }

    /++ Remove a key from the hash map. +/
    void remove(Key key) {
        Nulla_node* prev_n = &memory[hash(key) % memory.length];
        if (!prev_n.is_some()) {
            return;
        }

        if (prev_n.get().key == key) {
            *prev_n = prev_n.get().next;
            length -= 1;
            return;
        }

        Node* prev = memory[hash(key) % memory.length].get();
        Nulla_node node = prev.next;

        while (node.is_some()) {
            auto some_node = node.get();
            if (some_node.key == key) {
                prev.remove_next();
                length -= 1;
                return;
            }
            else {
                prev = some_node;
                node = some_node.next;
            }

        }
    }

    /++ Fetches a value from the table. +/
    Value fetch(Key key) {
        Nulla_node node = memory[hash(key) % memory.length];
        while (node.is_some()) {
            auto some_node = node.get();
            if (some_node.key == key) {return some_node.value;}
            else {node = some_node.next;}
        }
        enforce(false);
        assert(0);
    }

    /++ Hashes a value+/
    private static
    Hash_type hash(Key)(Key value) {
        Hash_type a = reduce_value(value);
        a = a * a;
        return a >>> (Hash_type.sizeof*2);
    }


    struct Node {
        Nullable_pointer!Node next;
        Key key;
        Value value;
        this (Key key, Value value) {
            this.key = key;
            this.value = value;
        }

        void remove_next() {
            enforce(this.next.is_some());
            this.next = this.next.get().next;
        }
    }
}

unittest {
    import std.format;
    import std.stdio;
    import std.complex;

    alias Creal = Complex!real;
    auto foo = Hash_table!(string, Creal)();

    foo.memory.length = 2;
    foo.insert("", Creal(1.0, 0.0));
    foo.insert("1", Creal(5.0, -2));
    foo.insert("12", Creal(5.1, -4));
    foo.insert("123", Creal(5.3, -5));
    foo.insert("1234", Creal(5.4, -6));
    foo.insert("12345", Creal(5.7, -7));
    foo.insert("123456", Creal(5.9, -8));

    assert(foo.length == 7, format!"%s"(foo.length));

    assert(foo.contains(""));
    assert(foo.contains("1"));
    assert(foo.contains("12"));
    assert(foo.contains("123"));
    assert(foo.contains("1234"));
    assert(foo.contains("12345"));
    assert(foo.contains("123456"));

    foo.remove("");
    assert(foo.length == 6, format!"%s"(foo.length));
    foo.remove("1");
    assert(foo.length == 5, format!"%s"(foo.length));
    foo.remove("12");
    assert(foo.length == 4, format!"%s"(foo.length));
    foo.remove("123");
    assert(foo.length == 3, format!"%s"(foo.length));
    foo.remove("1234");
    assert(foo.length == 2, format!"%s"(foo.length));
    foo.remove("12345");
    assert(foo.length == 1, format!"%s"(foo.length));
    foo.remove("123456");
    assert(foo.length == 0, format!"%s"(foo.length));


    assert(!foo.contains(""));
    assert(!foo.contains("1"));
    assert(!foo.contains("12"));
    assert(!foo.contains("123"));
    assert(!foo.contains("1234"));
    assert(!foo.contains("12345"));
    assert(!foo.contains("123456"));
}

private:


/++ These are helper functions to ensure that a value is
    the right size for the hashing implementation type.
    This one in particular takes an array of bytes that
    either used to be a struct or an array. +/
Hash_type reduce_byte_array(ubyte[] ubyte_array) {
    Hash_type* int_pointer = cast(Hash_type*) ubyte_array.ptr;
    long int_length = ubyte_array.length / Hash_type.sizeof;

    Hash_type end = 0;
    foreach (i, byte_; ubyte_array[int_length*Hash_type.sizeof..$]) {
        (cast(ubyte*) &end)[i] = byte_;
    }
    /// End which represents the remainder bytes of the
    /// byte array, is used here as the seed value.
    return int_pointer[0..int_length]
        .fold!((a, b) => b ^ a + 1)(
            -end
        )
    ;
}


/// Reduce something that fits in Hash_type already.
Hash_type reduce_value(Type)(Type value)
if (Type.sizeof <= Hash_type.sizeof) {
    Hash_type ret = 0;
    *(cast(Type*) &ret) = value;
    return ret;
}
unittest {
    Hash_type foo = 11;
    assert(reduce_value(foo) == foo);
    byte bar = 6;
    assert(reduce_value(bar) == bar);
}


/// Reduce an array.
Hash_type reduce_value(Type)(Type value) if (isArray!Type) {
    return reduce_byte_array(cast(ubyte[]) value);
}

unittest {
    import std.format;
    ubyte[] foo = [1, 0, 0, 0, 0, 0, 0, 0, 2];
    ubyte[] bar = [1, 0, 0, 0, 0, 0, 0, 2];
    auto result_foo = reduce_value(foo);
    auto result_bar = reduce_value(bar);
    assert(result_foo != result_bar, format!"%s != %s"(result_foo, result_bar));
}


/// Reduce a struct.
Hash_type reduce_value(Type)(Type value)
if (!isArray!Type && Type.sizeof > Hash_type.sizeof) {
    return reduce_byte_array(
        (cast(ubyte*) &value)[0..Type.sizeof]
    );
}

unittest {
    import std.format;
    align(1) struct Foo {
        align(1):
        Hash_type a;
        ushort b;
    }
    Hash_type stack_data = -1;
    Foo foo = Foo(1, 1);
    Foo bar = Foo(0, 2);
    Hash_type stack_data2 = -1;
    auto result0 = reduce_value(foo);
    auto result1 = reduce_value(bar);
    assert(result0 != result1, format!"%s != %s"(result0, result1));
}
