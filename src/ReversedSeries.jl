module ReversedSeries

using DocStringExtensions
using DataFrames
using Chain
using DataStructures

## structs

# This presents a reversed view of anything array-like.
# https://discourse.julialang.org/t/how-to-create-a-reversed-view-that-allows-for-growing-arrays/96148/2
"""
$(TYPEDEF)
$(TYPEDFIELDS)

This presents a reversed view of anything array-like.

Credit: [@simsurace](https://discourse.julialang.org/t/how-to-create-a-reversed-view-that-allows-for-growing-arrays/96148/2)

# Example

```julia-repl
julia> a = [1, 2, 3]
julia> r = Reversed(a)
julia> r[1]
3
julia> r[3]
1
julia> a[end] == r[1]
true
```
"""
struct Reversed{T<:AbstractArray}
    A::T
end

Base.getindex(a::Reversed, i::Int) = a.A[end-i+1]

# This presents a reversed view an entire DataFrame.
"""
$(TYPEDEF)
$(TYPEDFIELDS)

This presents a reversed view of an entire DataFrame.

# Example

```julia-repl
julia> rf = ReversedFrame(btcusd) # btcusd is a DataFrame
julia> rf[:ts][1] # the most recent timestamp
julia> rf[:ts][2] # the timestamp before that
julia> rf[:c][1] # the close at 1 corresponds with the timestamp at 1
julia> rf[:o][1] == btcusd.o[end]
true
```

- Index 1 is the origin and represents the present time.
- Higher indices go back in time.
- This is similar to how series are indexed in TradingView's PineScript except they use a 0-based index.

"""
struct ReversedFrame{df<:DataFrame}
    df::DataFrame
    s::Dict

    function ReversedFrame(df::DataFrame)
        s = Dict{Symbol,Any}()
        keys = @chain df names map(Symbol, _)
        for k in keys
            s[k] = Reversed(df[!, k])
        end
        return new{typeof(df)}(df, s)
    end
end

"""$(TYPEDSIGNATURES)

Return a reversed view of a DataFrame column via key.
"""
function Base.getproperty(rf::ReversedFrame, k::Symbol)
    if k == :df
        getfield(rf, k)
    elseif k == :s
        getfield(rf, k)
    else
        rf.s[k]
    end
end

function Base.show(io::IO, ::MIME"text/plain", rf::ReversedFrame)
    print(reverse(rf.df))
end

"""$(TYPEDSIGNATURES)

Return a reversed view of a DataFrame column via indexing.
"""
Base.getindex(rf::ReversedFrame, k::Symbol) = rf.s[k]

## cross

"""$(TYPEDSIGNATURES)

Is series `a` currently greater than series `b`?
"""
function crossed_up_now(a, b; i::Int=1)
    vals = ismissing.([a[i], b[i]])
    if any(in(vals), 1)
        return false
    end
    return a[i] > b[i]
end

"""$(TYPEDSIGNATURES)

Is series `a` currently less than series `b`?
"""
function crossed_down_now(a, b; i::Int=1)
    vals = ismissing.([a[i], b[i]])
    if any(in(vals), 1)
        return false
    end
    return a[i] < b[i]
end

"""$(TYPEDSIGNATURES)

Did series a become greater than series b at index i.
"""
function crossed_up(a, b; i::Int=1)
    vals = ismissing.([a[i], b[i], a[i+1], b[i+1]])
    if any(in(vals), 1)
        return false
    end
    return a[i] > b[i] && a[i+1] <= b[i+1]
end

"""$(TYPEDSIGNATURES)

Did series a become less than series b at index i.
"""
function crossed_down(a, b; i::Int=1)
    vals = ismissing.([a[i], b[i], a[i+1], b[i+1]])
    if any(in(vals), 1)
        return false
    end
    return a[i] < b[i] && a[i+1] >= b[i+1]
end

## divergence

"""$(TYPEDSIGNATURES)
"""
function regular_bearish()
end

"""$(TYPEDSIGNATURES)
"""
function regular_bullish()
end

# """$(TYPEDSIGNATURES)
# """
# function hidden_bullish()
# end

# """$(TYPEDSIGNATURES)
# """
# function hidden_bearish()
# end

## sr


## Exports

export Reversed
export ReversedFrame

export crossed_up_now
export crossed_down_now
export crossed_up
export crossed_down

export regular_bearish
export regular_bullish
# export hidden_bullish
# export hidden_bearish

end
