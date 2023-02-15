## 1
...

## 2 
The tests are in the 'unittest' blocks. The first one is on line 103.

## 3

### add function
This is the List.insert declaration on line 12.


### remove function
This is the List.remove declaration on line 35.


### get function
This is the List.fetch declaration on line 60.

## 4
All 3 functions iterate through the entire list until the desired spot is found. Therefore they are all O(n).
Note the while(1) loops.


## Installing the compiler
I wrote this in D because I'm behind and I wanted to write it quickly.
D can be gotten here [https://dlang.org/download.html].
Run the tests through the package manager with `dub test` from the `assignment#` directory.
