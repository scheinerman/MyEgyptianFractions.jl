module EgyptianFractions

export greedy, representation_check

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
    representation_check(x::Exact, denoms::Vector{T})::Bool where {T<:Integer}

Determine if `x` equals the sum of the reciprocals of the integers in `denoms`.
"""
function representation_check(x::Exact, denoms::Vector{T})::Bool where {T<:Integer}
    s = sum(1//n for n in denoms)
    return s == x
end
"""
    greedy(x)

Return a list of denominators for an Egyptian fraction representation of 
`x`. Note that `x` must be a positive integer or rational number. 
"""
function greedy(x::Exact, used::Set{T}=Set{BigInt}())::Vector{BigInt} where {T<:Integer}
    if x ≤ 0
        throw(DomainError(x, "Argument must be positive"))
    end

    if isempty(used)
        a = _first_available(x, used)
        push!(used, a)
    else
        s = sum(1//n for n in used)
        if s == x
            return sort(collect(used))
        end
        a = _first_available(x - s, used)
        push!(used, a)
    end
    return greedy(x, used)
end

end # module EgyptianFractions
