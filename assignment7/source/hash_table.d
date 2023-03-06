module hash_table;
import better_nullable;
import std.traits;
import std.algorithm: sum;

struct Hash_table(Key, Value) {
    Nullable_pointer!Entry[] memory;

    struct Entry {
        Nullable_pointer!Entry next;
        Value value;
    }


    ref Value index(Key key) {
        return memory[isaac_hash(key) % memory.length];
    }



}


int isaac_crunch(Type)(Type value) if (Type.sizeof <= int.sizeof) {
    int ret = 0;
    *(cast(Type*) &ret) = value;
    return ret;
}


int isaac_crunch_bytes(ubyte[] ubyte_array) {
    debug { import std.stdio : writeln; try { writeln(ubyte_array); } catch (Exception) {} }
    int* int_pointer = cast(int*) ubyte_array.ptr;
    long int_length = ubyte_array.length / int.sizeof;

    int end = 0;
    foreach (i, byte_; ubyte_array[int_length*int.sizeof..$]) {
        (cast(ubyte*) &end)[i] = byte_;
    }

    return int_pointer[0..int_length].sum() + end;
}

int isaac_crunch(Type)(Type value) if (isArray!Type) {
    return isaac_crunch_bytes(cast(ubyte[]) value);
}

int isaac_crunch(Type)(Type value) if (!isArray!Type && Type.sizeof > int.sizeof) {
    return isaac_crunch_bytes((cast(ubyte*) &value)[0..Type.sizeof]);
}

unittest {
    int foo = 11;
    assert(isaac_crunch(foo) == foo);
}
unittest {
    ubyte[] foo = [1, 0, 0, 0, 2];
    assert(isaac_crunch(foo) == 3);
    foo = [1, 0, 0, 2];
    assert(isaac_crunch(foo) != 3);
}
unittest {
    import std.format;
    align(1) struct Foo {
        align(1):
        int a;
        ushort b;
    }
    int stack_data = -1;
    Foo foo = Foo(1, 1);
    int stack_data2 = -1;
    auto result = isaac_crunch(foo);
    assert(result == 2, format!"%s"(result));
}
