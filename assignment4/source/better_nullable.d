module better_nullable;

struct Nullable_discriminated(Type, Type null_state) {
    import std.exception: enforce;
    private Type value = null_state;

    enum typeof(this) none = typeof(this)(null_state);

    this(Type n) {
        value = n;
    }

    bool is_some() {
        return this.value != null_state;
    }

    Type get() {
        enforce(this.is_some);
        return this.value;
    }
    // import std.traits: isCallable, ReturnType;
    // auto match(handlers...)() if (handlers.length == 2) {
    //     // static assert(isCallable!(handlers[0]), "Argument 1 of match must be callable!");
    //     // static assert(isCallable!(handlers[1]), "Argument 2 of match must be callable!");
    //     // static assert(is(ReturnType!(handlers[0]) == ReturnType!(handlers[1])), "Predicates must return the same type.");
    //     if (this.isNull) {
    //         return handlers[1]();
    //     } else {
    //         return handlers[0](this.value);
    //     }
    // }
}


alias Nullable_pointer(NonPtr) = Nullable_discriminated!(NonPtr*, cast(NonPtr*) null);


import std.traits: isPointer, PointerTarget;
auto nullable_pointer(Type)(Type val) {
    static if (isPointer!Type) {
        return Nullable_pointer!(PointerTarget!Type)(val);
    }
    else {
        return (Nullable_pointer!Type) {value: new Type(val);};
    }
}



private struct Non_null_ptr(T) if (isPointer!T) {
    T value;
    alias value this;
}