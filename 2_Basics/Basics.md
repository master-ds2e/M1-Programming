Operations
==========

Arithmetic Operations
---------------------

Python and R can both work as classical calculator, using "+", "-", "\*" and "/" you can do arithmetic operations in both language.

``` python
# Python 

1+2
## 3
1-2
## -1
1/2
## 0.5
1*2
## 2
```

``` r
# R

1+2
## [1] 3
1-2
## [1] -1
1/2
## [1] 0.5
1*2
## [1] 2
```

You can also apply exponantiation, Modulo and floor division easily in both language. Please note that in R you can writte the exponantiation "^". You cannot do that in Python (it is used for antoher operation) but both use "\*\*" for exponantiation. Use this one for clarity.

``` python
# Python 

2**8 # exponantiation
## 256
2^8 == 2**8 # False
## False
8%3 # modulo
## 2
8//3 # floor division
## 2
```

``` r
# R

2**8 # exponantiation
## [1] 256
2^8 == 2**8 # TRUE
## [1] TRUE
8%%3 # modulo
## [1] 2
8%/%3 # floor division
## [1] 2
```

Comparison Operators
--------------------

In order to compare some values we can use comparison operators to investigate in a given value is equal to, not equal, greater than ... etc

Theses operators are the same in both language.

``` python
# Python 

2==8
## False
2!=8
## True
2<8
## True
2>8
## False
2<=8
## True
```

``` r
# R

2==8
## [1] FALSE
2!=8
## [1] TRUE
2<8
## [1] TRUE
2>8
## [1] FALSE
2<=8
## [1] TRUE
```

Objects & Variables
===================

ref used : <https://www.practicaldatascience.org/html/vars_v_objects.html>

Variables are used to store data. In Python and R, we do not need to declare a variable before assigning a value to this variable. You can think of a variable as a name to refers to an object. There is a big difference between python and R on the way the computer is storing object and variables that we will see in the end of the section.

Difference between R and Python
-------------------------------

In R, a variable and an object are the same things, they refers to the same entities. If you assign to a new variable a variable that already exist, it will refers to two different objects.

Things in Python are more conventional, but since some people learned R before Python it's important to notice that variables refers to an objet but they are still two entities. It means that two variables can refer to a single object. If two variables are pointing the same object, the modification made with one variable will be also available when using the other variable.There some In R two variable can refers to the same object, but once one variable is changed, a new space in the memomry is allocated to a new object. However not all data-type of Python are muttable. Examples are provided later.

textual and numerical variables
-------------------------------

In R textual data are called 'character', in Python it is a string, abbreviate as 'str'. " or ' are used when you set a textual variable in both laguage, but you can also set a variable to textual variable if needed.

Numerical variables a decomposed in three types. In Python you'll have integer, float and complex. In R float is called 'double', reffering to double precision floating point. Without entering into details it means that the number have a precision up to 15 decimals. Float can refers to a precision of 7 decimals, however in Python the data-type 'float' has a precision of 15 numbers. They are ways to get more precisions using Numpy for example.

Finaly you can check easily the data-type of the variable that you are dealing by asking the language with the command 'type' in Python, or 'typeof' in R.

``` python
# Python 
import sys 
sys.float_info.dig # number of decimals
## 15
a = 1
type(a)
## <class 'int'>
b = 1.1
type(b)
## <class 'float'>
c = 1.1+2j
type(c)
## <class 'complex'>
```

``` r
# R

a = 1
typeof(a)
## [1] "double"
a_int = 1L
typeof(a_int)
## [1] "integer"

b = 1.1
typeof(b)
## [1] "double"

c = 1.1+2i
typeof(c)
## [1] "complex"
```

Other Data-Type
---------------

refused : <https://thomas-cokelaer.info/tutorials/python/lists.html>

There is a lot of datatype in both language that we will discover along the course, for now we will focus only on basic data-type that are directly available without using anyother package or library. In Python the most common are List, Turple, sets, Dictionnary. While in R you will have Vector, Matrix, List, Data frame and factor.

### Lists

Keep in mind that Lists are mutable, as discussed in the Section "Difference between R and Python"

``` python

a = [1, 2, 3]
a.count(2) # count elements of the list which are exactly equal to 2
## 1
a.sort(reverse = True)
a
# access the element of a list
## [3, 2, 1]
a[0]
## 3
a.index(3)
## 0
a[1:]
## [2, 1]
a[:1]
## [3]
a[0:-1]
## [3, 2]
a[:]

# modify
## [3, 2, 1]
b = [0, 0, 0]
a.append(b)
a
## [3, 2, 1, [0, 0, 0]]
a.extend([4, 5, 6])
a
## [3, 2, 1, [0, 0, 0], 4, 5, 6]
a += [7,8] # works as extend
a
## [3, 2, 1, [0, 0, 0], 4, 5, 6, 7, 8]
a.insert(2,[1,2])
a
## [3, 2, [1, 2], 1, [0, 0, 0], 4, 5, 6, 7, 8]
a.remove(b)
a
## [3, 2, [1, 2], 1, 4, 5, 6, 7, 8]
a = a*2 # replicate the list n times
len(a) # number of elements in the list

# mutable
## 18
a = [1,2,3]
b = a
b[0] = 12
a
## [12, 2, 3]
```

Turples
-------

The main difference between Lists and Turples is the fact that Turples is an immutable type of data making it faster to use.

``` python
# Python

a = (1, 2, 3)
a.count(2) # count elements of the turple which are exactly equal to 2
## 1
a
# access the element of a turple
## (1, 2, 3)
a[0]
## 1
a.index(3)
## 2
a[1:]
## (2, 3)
a[:1]
## (1,)
a[0:-1]
## (1, 2)
a[:]

# modify
## (1, 2, 3)
a += (4,5) 
a
## (1, 2, 3, 4, 5)
a = a*2 # replicate the turple n times
len(a) # number of elements in the turple

# immutable
## 10
a = (1,2,3)
b = a
b[0] = 12
## Error in py_call_impl(callable, dots$args, dots$keywords): TypeError: 'tuple' object does not support item assignment
## 
## Detailed traceback: 
##   File "<string>", line 1, in <module>
a
## (1, 2, 3)
```

dictionaries
------------

Dictionary refers to a way of storing data that is not sorted. It works with key and value associate with this key.

``` python
# Python

a = {'a':1, 'b':2, 'c':3}
# access the element of a dictionary
a.keys()
## dict_keys(['a', 'b', 'c'])
a['a']
## 1
a.values()
## dict_values([1, 2, 3])
a.items()
## dict_items([('a', 1), ('b', 2), ('c', 3)])
a.has_key('d') # check if the key 'd' exists
## Error in py_call_impl(callable, dots$args, dots$keywords): AttributeError: 'dict' object has no attribute 'has_key'
## 
## Detailed traceback: 
##   File "<string>", line 1, in <module>
a.get('a')
## 1
a.get('d',4) # if the key is not detected
## 4
a.pop('a') # pop will use the corresponding value to the key a and remove the pair (key, value).
## 1
a
## {'b': 2, 'c': 3}
a.popitem('b')
## Error in py_call_impl(callable, dots$args, dots$keywords): TypeError: popitem() takes no arguments (1 given)
## 
## Detailed traceback: 
##   File "<string>", line 1, in <module>
a

# modify
## {'b': 2, 'c': 3}
a += (4,5) 
## Error in py_call_impl(callable, dots$args, dots$keywords): TypeError: unsupported operand type(s) for +=: 'dict' and 'tuple'
## 
## Detailed traceback: 
##   File "<string>", line 1, in <module>
a
## {'b': 2, 'c': 3}
a = a*2 # replicate the turple n times
## Error in py_call_impl(callable, dots$args, dots$keywords): TypeError: unsupported operand type(s) for *: 'dict' and 'int'
## 
## Detailed traceback: 
##   File "<string>", line 1, in <module>
len(a) # number of elements in the turple

# mutable
## 2
a = {'a':1, 'b':2, 'c':3}
b = a
b['b'] = [12,14]
a
## {'a': 1, 'b': [12, 14], 'c': 3}
```

control flow
============

``` python
# Python 
evens = []
for i in range(10):
    if i % 2 == 0:
        evens.append(i)
evens
# beter to writte this
## [0, 2, 4, 6, 8]
[i for i in range(10) if i % 2 == 0]
## [0, 2, 4, 6, 8]
```

``` r
lala = 1+1
lala
```

    ## [1] 2

Dealing with strings
====================

<https://thomas-cokelaer.info/tutorials/python/strings.html>
