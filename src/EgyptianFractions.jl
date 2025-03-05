module EgyptianFractions

using ChooseOptimizer
using JuMP

export greedy, reciprocal_sum, representation_check, optimal

Exact = Union{Integer,Rational}

"""
    _first_available(x::Exact, used::Set{Int})

Find the first positive integer `n` that is *not* in the set `used`
such that `1/n ≤ x`.
"""
function _first_available(x::Exact, used::Set{T}) where {T<:Integer}
    result = BigInt(ceil(1//x))

    while result ∈ used
        result += 1
    end

    return result
end

"""
    reciprocal_sum(denoms::Vector{T})::Rational{BigInt} where {T<:Integer}

Return the sum of the reciprocals of the elements of `denoms`.
"""
function reciprocal_sum(denoms::Vector{T})::Rational{BigInt} where {T<:Integer}
    return sum(1//big(n) for n in denoms)
end

"""
    representation_check(x::Exact, denoms::Vector{T})::Bool where {T<:Integer}

Determine if `x` equals the sum of the reciprocals of the integers in `denoms`.
"""
function representation_check(x::Exact, denoms::Vector{T})::Bool where {T<:Integer}
    return x == reciprocal_sum(denoms)
end

include("Greedy.jl")
include("Optim.jl")

end # module EgyptianFractions
