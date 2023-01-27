To deisign a queue, I will need functions to observe a value, remove from the front, and add to the back of the queue. I will define the queue as a type and have it operate on a node type.

## 'Queue' structure
This will have a head pointer, and a tail pointer. Because it is the sole interface into the data, it will be able to track the length as well.

## 'Node' structure
This is just a pointer and a value.

## Function 'push'
- Takes a value of T, creats a node to hold value. 
- If head and tail are not null:
    - Tail node's pointer now points to new node. Queue's tail is now new node.
- If head and tail are null:
    - Queue's head and tail are now both new node.

## Function 'pop'
- If head is not null:
    - Get next from head
    - Free head
    - Queue's head is now next from old head

## Function 'front'
    - Head's stored value is returned.
