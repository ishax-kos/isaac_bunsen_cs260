module hash_table;
import better_nullable;
import std.traits;
import std.algorithm: fold;


alias Hash_type = long;


/++ A data structure implementing a hash table. +/
struct Hash_table(Key, Value) {
    Nullable_pointer!Value[] memory = new Nullable_pointer!Value[](32);
    long length;

    /++ Tests whether a key exists in the list. +/
    bool contains(Key key) {
        return memory[hash(key) % memory.length].is_some();
    }

    /++ Insert a new value or overwrite an exiting value in the hash map. +/
    void insert(Key key, Value value) {
        if (!contains(key)) {
            length += 1;
        }
        auto new_value = new Value();
        *new_value = value;
        memory[hash(key) % memory.length] = nullable_pointer(new_value);
    }

    /++ Remove a key from the hash map. +/
    void remove(Key key) {
        length -= 1;
        return memory[hash(key) % memory.length].nullify();
    }

    /++ Fetches a value from the table. +/
    Value fetch(Key key) {
        import std.exception: enforce;
        enforce(contains(key));
        return *(memory[hash(key) % memory.length].get());
    }

    /++ Hashes a value+/
    private static
    Hash_type hash(Key)(Key value) {
        Hash_type a = reduce_value(value);
        a = a * a;
        return a >>> (Hash_type.sizeof*2);
    }
}

unittest {
    import std.format;
    import std.stdio;
    auto foo = Hash_table!(string, float)();


    foo.insert("", 1.0);
    foo.insert("225m4", 5.0);
    foo.insert("werwerhsfgh", 5.1);
    foo.insert("opiuvbnmbnyopiu", 5.3);
    foo.insert("2werss5e44e5yw2", 5.4);
    foo.insert("bncm_fshrthrtoods", 5.7);
    foo.insert("fosrthsrthrs o8908944 ", 5.9);

    // writefln!"%064b"(foo.hash(""));
    // writefln!"%064b"(foo.hash("225m44e567uyfr64uhtf"));
    // writefln!"%064b"(foo.hash("werwerhsfghshsrths522"));
    // writefln!"%064b"(foo.hash("opiuvbnmbnyopiu"));
    // writefln!"%064b"(foo.hash("2werss5e44e5yw2"));
    // writefln!"%064b"(foo.hash("bncm_fshrthrtoods"));
    // writefln!"%064b"(foo.hash("fosrthsrthrs o8908944 "));

    assert(foo.contains("225m4"));

    /// Risky!
    assert(foo.length == 7, format!"%s"(foo.length));

    foo.remove("");
    assert(!foo.contains(""));
}


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


/// Reduce something that fits in Hash_type already
Hash_type reduce_value(Type)(Type value) if (Type.sizeof <= Hash_type.sizeof) {
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


/// Reduce an array
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


/// Reduce a struct
Hash_type reduce_value(Type)(Type value) if (!isArray!Type && Type.sizeof > Hash_type.sizeof) {
    return reduce_byte_array((cast(ubyte*) &value)[0..Type.sizeof]);
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
