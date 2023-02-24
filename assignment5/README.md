# Assignment 5
    1.  Follow along with the in-class exercise on this, do your best to get it working, and turn in what you come up with here!

    1.  Be sure to include at least one test for each function or piece of functionality that should verify that your code is working!  No slacking 🙂, you should start writing some tests before you write your implementations (just spend a few minutes thinking about the design and then write a few tests using natural language (English is preferred for me to be able to read it 🙂 ))

See blocks marked as `unittest`. I have public methods in the tree struct as well as private subtree functions. Both are tested at the latter site. Comments inside the unittest describe the tests in the following lines until their matching assert statements are found.

    1.  Create an array-based list or a linked-list (**and a bonus for attempting both**) that:

I have created a binary search tree instead.

        1.  automatically inserts values in the correct position based on some order of sorting (perhaps ascending integers or lexicographical sorting of words)

`insert` on line 15 and 82 adds new nodes to the collection.

        1.  efficiently searches for elements (likely binary search for the array list, but what about the linked-list?)

`find` on line 32 and 181 finds nodes in the collection.

`find_and_remove` on line 23 and 128 removes nodes from the collection.


    1.  Make a chart to compare the algorithmic complexity (use Big-O notation) of your insert, remove, and search algorithms you used for your structures


### Table, Complexity
| Function | Worst Case |
| - | - |
| insert | O(n) |
| find_and_remove | O(n) |
| find | O(n) |

The tree has no balancing set up so it should get pretty bad. If it were balanced, each would be O(log(n))

    1.  Once you have implemented and tested your code, add to the README file what line(s) of code or inputs and outputs show your work meeting each of the above requirements (or better, include a small screen snip of where it meets the requirement!).


# Assignment 6

    1. Create some tests (at least one per function) that you want your Binary Search Tree (BST) to pass before you start coding.

As assignment 5. See blocks marked as `unittest`.

    1. Implement a binary search tree that includes:

    1. nodes to store values,

`Node` at line 70. The array of children is statically sized. I could have made it into two variables and it would have the same effect. The utility is that I only had to implement the unused rotate once to fit both directions. I wanted to implement it as a WAVL tree, so you can see it contains a rank value which is unused.

    1. an add function that adds a new value in the appropriate location based on our ordering rules, (I likely used less than or equal to going to the left and greater than values going to the right)

See assigment5. `insert` on 82. This one went through a few iterations. I didn't implement any choice in comparison function. You're stuck with `<`.

    1. a remove function that finds and removes a value and then picks an appropriate replacement node (successor is a term often used for this)

See assigment5 `find_and_remove` on 128.

    1. we have at least one tree traversal function (I recommend starting with an in-order traversal!)
           - **Bonus** if you implement the three common traversals (pre-order, post-order, in-order)
           - **More Bonus** if you also include a breadth-first traversal (sometimes called a level-order search)

I implemented everything 😨. Its all there. "pre-order, post-order, in-order" are covered by the `traverse` template on line 238. The `Tree` struct wraps this in three aptly named methods. The breadth first traversal is wrapped up in a struct `Traversal_breadth_first` on line 293.

    1. Analyze and compare the complexity of insert and search as compared to a binary tree without any order in its nodes.

    insert: O(log(n)) assuming the tree is balanced.
    find: O(log(n)) assuming the tree is balanced.
    The complexity would be good in theory, but its kinda bad, because I didn't implement balancing.

    1. Once you have implemented and tested your code, add to the README file what line(s) of code or inputs and outputs show your work meeting each of the above requirements (or better, include a small screen snip of where it meets the requirement!).


I've been using my own style on assignments. I hope thats fine.
 -  `Types_like_this`
 -  `values_like_this`
 -  `chaining`<br>
    ____`.like()`<br>
    ____`.this()`<br>
    `;`
 -  `functions_like_this() {`<br>
    `}`
 -  `or_like_this(`<br>
    ____`a,`<br>
    ____`b,`<br>
    `) {`<br>
    `}`
 -  `constant_like_this`
 -  indented parens get their own line.


D style is a bit different https://dlang.org/dstyle.html


to run all tests do `dub test`
