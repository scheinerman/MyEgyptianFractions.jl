# EgyptianFractions
Just for fun, [Egyptian fractions](https://en.wikipedia.org/wiki/Egyptian_fraction) in Julia.


## What are Egyptian Fractions?

An Egyptian fraction representation of a rational number $x$, expresses $x$ as the sum of 
reciprocals of distinct positive integers. 
For example, $\frac37 = \frac13 + \frac1{11} + \frac{1}{231}$.  

## Greedy Method

This is a method proposed by Fibonacci. To write $x$ as an Egyptian fraction, choose the smallest 
positive $n$ such that $x \le \frac1n$. The fraction $\frac1n$ is the first summand in the represenation
and the remaining terms are given by the greedy method applied to $x - \frac1n$. This algorithm is guaranteed to terminate. 
See [this page](https://en.wikipedia.org/wiki/Greedy_algorithm_for_Egyptian_fractions) 
for more information.

Use `greedy(x)` to return a list of the denominators in a greedy Egyptian fraction representation of `x`.
```
julia> using EgyptianFractions

julia> greedy(3//7)
3-element Vector{BigInt}:
   3
  11
 231

julia> 1//3 + 1//11 + 1//231
3//7
```
Note that the denominators can become very large:
```
julia> greedy(7//2)
22-element Vector{BigInt}:
                     1
                     2
                     3
                     4
                     5
                     6
                     7
                     8
                     9
                    10
                    11
                    12
                    13
                    14
                    15
                    16
                    17
                    18
                   205
                 72083
            7894115294
 333156570077494122960
```

## More to Come?

We hope to add other methods. 