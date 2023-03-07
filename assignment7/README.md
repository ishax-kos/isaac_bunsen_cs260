1. Create a design before you begin to code that describes or shows how we can store data in a hash table and what kind of problem we could solve with a hash table.

    There shall be a Hash_table type which has an internal array to hold pointers to the value data. It wont actually store any key data.

    For hashing I will use the mid square method (https://www.geeksforgeeks.org/hash-functions-and-list-types-of-hash-functions/). This will be contained in a hash function.

    If the key type is larger than an int, it will cast it to an int array and sum the entire thing first.

1. Create some tests (at least one per piece of functionality) before you begin coding that you want your hashtable to pass before you start coding.

    See the `unittest` blocks.

1. Create a hashtable that resolves collisions by simply overwriting the old value with the new value, including at least:

    See the file "hash_table.d".

    1. Describe the way that you decide on hashing a value
    (this can be simple or complex based on how interesting you find the topic)

        To hash I value I used a form of the 'mid square' method. I first reduced each value to a set sized integer if it wasnt already. Then I squared the value and shifted it by 1/4 of the total bit width of the integer.

    1. An insert function that places the value at the appropriate location based on its hash value

        See line 21, the `insert` method.

    1. A contains function that returns whether the value is already in the hashtable

        See line 16, the `contains` method. I later misread the prompt and thought it had to return the value at that key, and so I also implemented the `fetch` method at line 37.

    1. (optional) A delete function that removes a value based on its hash and then returns that value…

        See line 31, the `remove` method. `delete` is a default method already.


1. Then create a smarter hashtable (double hashing or chaining) including at least the same functions as the simple hashtable

    See the file "hash_table_improved.d". I added a linked list structure.

1. Compare some information relating to collisions (frequency) and their effect on complexity (of insert and contains methods)

    The complexity for the dumb table is O(n) every time. The addition of lists to handle collisions means that those collisions can pile up and make the hash table O(n).

1. Once you have implemented and tested your code, add to the README file what line(s) of code or inputs and outputs show your work meeting each of the above requirements (or better, include a small screen snip of where it meets the requirement!).
