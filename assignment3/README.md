# Requirements 

1. Based on what we know about linked lists, stacks, and queues, design a linked queue (a queue using a linked-list to store the data in the structure)

-- See last assignment

1. Design, implement, and test a Queue data structure that:

    
    1. uses a linked-list to store values in the queue
    - See line 5 of src/queue.zig

        
    1. has an enqueue method that will appropriately add a value to the back of the queue as an appropriate element
    - See line 29 of src/queue.zig

        
    1. has a dequeue method that will appropriately remove an element from the front of the queue and return its value
    - See line 42 of src/queue.zig
    I actually skipped out on the return part. That functionality must be obtained using .front()

        
    1. Optionally has a peek method that returns the value at the front of the queue without removing it
        Bonus if you also create an array based Queue!
    - See line 19 of src/queue.zig


1. Analyze the complexity of your implementations (at least the run-time of the add, remove, and peek methods).
(Note that we will often consider operations not having to do with the structure as O(1), even if they might be expensive operations in terms of real-time or space used)
(Note that if you are not in class when we talk about Asymptotic Big-O notation, you can find tons of good examples online)
- See line 18, 28, and 41 of src/queue.zig

1. Tests: Be sure to include at least one test for each piece of functionality that should verify that your code is working!
- See line 75 of src/queue.zig

1. Be sure to commit changes regularly to your git repo