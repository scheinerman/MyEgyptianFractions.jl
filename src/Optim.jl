# Use optimization methods to find an EgyptianFraction representation

"""
    optimal(x::Exact, d_max::Int, min_terms::Bool=true)

Use integer programming to find an Egyptian fraction representation of `x`
with denominators from `1` to `d_max`. With `min_terms` set to `true`, 
return a representation with as few terms as possible.

An error is thrown if no representation is possible. 
"""
function optimal(x::Exact, d_max::Int, min_terms::Bool=true)
    if x ≤ 0
        throw(DomainError(x, "Argument must be positive"))
    end

    MOD = Model(get_solver())
    @variable(MOD, ind[1:d_max], Bin)   # indicator[j] means 1//j is part of the representation

    a = numerator(x)
    b = denominator(x)

    M = lcm(1:d_max)

    coef = [M * b ÷ d for d in 1:d_max]

    @constraint(MOD, sum(M * b * ind[d] / d for d in 1:d_max) == M * a)

    if min_terms
        @objective(MOD, Min, sum(ind))
    end

    optimize!(MOD)
    status = Int(termination_status(MOD))

    if status ≠ 1
        error(
            "Cannot find an Egyptian fraction represention for $x with maximum denominator $d_max",
        )
    end

    return findall(value.(ind) .> 0)
end
