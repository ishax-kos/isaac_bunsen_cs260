## 1 Readme created

## 2 Design
### 1. some way of representing marbles
A marble will have a color and no other properties. A number of marbles might be represented by a counter of a specified color.

### 2. a way to add new marbles into the bag
I might have a type with a field for each unique marble type. A marble with a given color could then be passed to this type by a function and the function will categorize the marble and increment that field.

### 3. a way to remove a marble out of the bag
A random number 'i' is generated, and then restrained to a range between zero and the number of marbles in the collection. The number of marbles in the collection can be found by adding together each field. For each field 'f', if 'i' is less than 'f', then the marble selected is represented by that field. 'f' is then decremented and a corresponding marble is generated and returned. If the number is greater or equal to 'f', 'f' is subtracted from 'i'. This repeats for each field. if 'i' is greater than the semifinal field, 'i' is no longer needed, as it must fall in the final field. In this case it need not be decremented, a marble matching the final field can be returned.

## 3 Implementaion
see bag.cpp


## 4 Unit Testing
see test_bag.cpp


## 5 Satisfied requirements

2.1 is satisfied by line 31 by the 'Marble' struct, and at line 32-34 where marbles are represented by color and quantity inside the 'Marbles_qty'


2.2 is statisfied by the constructor at line 36, and by the function 'add_marble' at line 72.


2.3 is satisfied by the 'pick_marble' function at line 47.


2.4 are satisfied by the file 'test_marble.cpp'


3 I interpreted 'simple' as being simple in program logic. My random number limits don't account for modulo divisor bias and my 'pick_marble' is more concise and efficient than it is readable. Instead of using some kind of vector of marble objects, I used quantities.

4, see 2.4

5 CICULAR DEPENDANCY. EXIT STATUS 342843116

## 6 Submission
