module better_nullable;

struct Nullable_discriminated(Type, Type null_state) {
    import std.exception: enforce;
    private Type value = null_state;

    enum typeof(this) none = typeof(this)(null_state);

    this(Type n) {
        value = n;
    }

    bool is_some() const {
        return this.value != null_state;
    }

    ref Type get() {
        enforce(this.is_some());
        return this.value;
    }

    const(Type) get() const {
        enforce(this.is_some());
        return this.value;
    }

    void opAssign(Type value) {
        this.value = value;
    }

    string toString() const {
        import std.conv;
        if (this.is_some()) {return value.to!string();}
        else {return "none";}
    }

    void nullify() {
        this.value = null_state;
    }
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
