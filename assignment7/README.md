1. Create a design before you begin to code that describes or shows how we can store data in a hash table and what kind of problem we could solve with a hash table.

    There shall be a Hash_table type which has an internal array to hold pointers to the value data. It wont actually store any key data.

    For hashing I will use the mid square method (https://www.geeksforgeeks.org/hash-functions-and-list-types-of-hash-functions/). This will be contained in a hash function.

    If the key type is larger than an int, it will cast it to an int array and sum the entire thing first.

1. Create some tests (at least one per piece of functionality) before you begin coding that you want your hashtable to pass before you start coding.

1. Create a hashtable that resolves collisions by simply overwriting the old value with the new value, including at least:

    1. Describe the way that you decide on hashing a value
    (this can be simple or complex based on how interesting you find the topic)

    1. An insert function that places the value at the appropriate location based on its hash value

    1. A contains function that returns whether the value is already in the hashtable

    1. (optional) A delete function that removes a value based on its hash and then returns that value…

1. Then create a smarter hashtable (double hashing or chaining) including at least the same functions as the simple hashtable

1. Compare some information relating to collisions (frequency) and their effect on complexity (of insert and contains methods)

1. Once you have implemented and tested your code, add to the README file what line(s) of code or inputs and outputs show your work meeting each of the above requirements (or better, include a small screen snip of where it meets the requirement!).
