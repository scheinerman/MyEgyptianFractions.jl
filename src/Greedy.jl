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
