# MyEgyptianFractions
Just for fun, [Egyptian fractions](https://en.wikipedia.org/wiki/Egyptian_fraction) in Julia.
There is also a [registered Julia package](https://github.com/reallyasi9/EgyptianFractions.jl) to 
compute Egyptian fractions.


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
julia> using MyEgyptianFractions

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

## Integer Programming Method

The function `optimal` finds Egyptian fraction representations using integer programming. 
The basic invocation is `optimal(x, d_max)` where `x` is the (positive)
rational number to be represented and `d_max` is the largest allowable denominator. 

The output will be a list of integers the sum of whose reciprocals is `x`, or an error
is thrown if no representation is possible.

By default, `optimal` seeks a representation with as few terms as possible. However, 
if called as `optimal(x, d_max, false)` no minimization is sought.

```
julia> optimal(3//7,30)
3-element Vector{Int64}:
  4
  7
 28

julia> optimal(3//7,30,false)
5-element Vector{Int64}:
  7
  9
 14
 18
 21
```

Note that `greedy` returns a result for $\frac37$ that uses a large denominator.
```
julia> greedy(3//7)
3-element Vector{BigInt}:
   3
  11
 231
```

If `d_max` is too small, no representation may be possible. But if `d_max` is set to 
a large value, then `optimal` may require an enormous amount of time to find a representation.


> **WARNING**: Output from this function might be wrong because the IP solver does not use exact arithmetic. 


### Using other solvers

By default, we use the `HiGHS` optimizer. Use of the `Gurobi` optimizer (if available) is better (faster, fewer errors).
Here is how to switch to `Gurobi` (or another solver).

```
julia> using MyEgyptianFractions

julia> using ChooseOptimizer, Gurobi

julia> set_solver(Gurobi)

julia> optimal(3//7,30)
Set parameter Username
Set parameter LicenseID to value XXXXXXX
Academic license - for non-commercial use only - expires XXXX-XX-XX
3-element Vector{Int64}:
  4
  7
 28
```




### A cautionary tale

Typically, Egyptian fractions would be used for values stricly between 0 and 1, but we can try other values. For example, here we find a representation for 3:
```
julia> greedy(3)
13-element Vector{BigInt}:
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
    15
   230
 57960
```
The `optimal` method with the `HiGHS` solve gives an incorrect answer:
```
julia> optimal(3,25)
15-element Vector{Int64}:
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
 15
 18
 20
 22
 24

julia> reciprocal_sum(ans)
491//154
```

However, if we use the Gurobi solver, we get a correct result:
```
julia> using Gurobi, ChooseOptimizer

julia> set_solver(Gurobi)

julia> optimal(3,25)
Set parameter Username
Set parameter LicenseID to value XXXXXXXX
Academic license - for non-commercial use only - expires XXXX-XX-XX
13-element Vector{Int64}:
  1
  2
  3
  4
  5
  6
  8
  9
 10
 15
 18
 20
 24

julia> reciprocal_sum(ans)
3//1
```
Moral to the story: Check results with `reciprocal_sum` (or `representation_check`).



## Handy Functions

* If `denoms` is a list of posive integers, `reciprocal_sum(denoms)` returns the sum of the reciprocals of the elements of `denoms`.

* Use `representation_check(denoms, x)` to check if `x` equals the sum of the reciprocals of the integers in `denoms`.
