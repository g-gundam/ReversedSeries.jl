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

Base.length(a::Reversed) = length(a.A)

Base.lastindex(a::Reversed) = length(a)

# This presents a reversed view an entire DataFrame.
"""
$(TYPEDEF)
$(TYPEDFIELDS)

This presents a reversed view of an entire DataFrame.

# Example

```julia-repl
julia> rf = ReversedFrame(btcusd) # btcusd is a DataFrame
julia> rf.ts[1] # the most recent timestamp
julia> rf.ts[2] # the timestamp before that
julia> rf.c[1]  # the close at 1 corresponds with the timestamp at 1
julia> rf.o[1] == btcusd.o[end]
true
```

- Index 1 is the origin and represents the present time.
- Higher indices go back in time.
- This is similar to how series are indexed in TradingView's PineScript except they use a 0-based index.

"""
struct ReversedFrame{df<:DataFrame}
    __df::DataFrame
    __s::Dict

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

# Example

```julia-repl
julia> rf = ReversedFrame(DataFrame(o=[1,2,3]))
julia> rf.o
Reversed{Vector{Int64}}([1, 2, 3])

julia> rf.o[1]
3

```
"""
function Base.getproperty(rf::ReversedFrame, k::Symbol)
    if k == :__df
        getfield(rf, k)
    elseif k == :__s
        getfield(rf, k)
    else
        rf.__s[k]
    end
end

"""$(TYPEDSIGNATURES)

Return a reversed view of a DataFrame column via indexing.

# Example

```julia-repl
julia> rf = ReversedFrame(DataFrame(o=[1,2,3]))
julia> rf[:o]
Reversed{Vector{Int64}}([1, 2, 3])

julia> rf[:o][1]
3
```
"""
Base.getindex(rf::ReversedFrame, k::Symbol) = rf.__s[k]

function Base.show(io::IO, ::MIME"text/plain", rf::ReversedFrame)
    print(reverse(rf.__df))
end

include("utils.jl")

## The following are analysis functions that work on reversed series

## cross

"""$(TYPEDSIGNATURES)

Is series `a` currently greater than series `b`?
"""
function crossed_up_currently(a, b; i::Int=1)
    vals = ismissing.([a[i], b[i]])
    if any(in(vals), 1)
        return false
    end
    return a[i] > b[i]
end
Base.@deprecate crossed_up_now(a, b; i=1) crossed_up_currently(a, b; i=1)

"""$(TYPEDSIGNATURES)

Is series `a` currently less than series `b`?
"""
function crossed_down_currently(a, b; i::Int=1)
    vals = ismissing.([a[i], b[i]])
    if any(in(vals), 1)
        return false
    end
    return a[i] < b[i]
end
Base.@deprecate crossed_down_now(a, b; i=1) crossed_down_currently(a, b; i=1)


"""$(TYPEDSIGNATURES)

Return true if a is currently sloping up.  In other words, `a[i] > a[i+back]`.
"""
function positive_slope_currently(a; i=1, back=1)
    if length(a) < i+back
        return false
    end
    vals = ismissing.([a[1], a[i]])
    if any(in(vals), 1)
        return false
    end
    return a[i] > a[i+back]
end

"""$(TYPEDSIGNATURES)

Return true if a is currently sloping down.  In other words, `a[i] < a[i+back]`.
"""
function negative_slope_currently(a; i=1, back=1)
    if length(a) < i+back
        return false
    end
    vals = ismissing.([a[1], a[i]])
    if any(in(vals), 1)
        return false
    end
    return a[i] < a[i+back]
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

Return true if regular bearish divergence on the given indicator was detected near index 1.
Note that Bollinger Bands are used to help detect divergence, so their presence is required
in the `rf` in addition to the indicator that's being tested for divergence.

# Keyword Arguments

| argument       | default     | description                                 |
|----------------|-------------|:--------------------------------------------|
| indicator      | `:rsi14`    | Name in `rf` of the indicator being tested  |
| high           | `:h`        | Name in `rf` of the OHLCV high value        |
| upper          | `:bb_upper` | Name in `rf` of the upper band of the BBs   |
| lower          | `:bb_lower` | Name in `rf` of the lower band of the BBs   |
| age_threshold  | `1`         | ?                                           |
| gap_threshold  | `(7,30)`    | ?                                           |
| peak_threshold | `9.0`       | ?                                           |

# Example
```julia-repl
julia> regular_bearish_divergence(rf)
```
"""
function regular_bearish_divergence(rf::ReversedFrame;
                                    indicator::Symbol=:rsi14,
                                    high::Symbol=:h,
                                    upper::Symbol=:bb_upper,
                                    lower::Symbol=:bb_lower,
                                    age_threshold::Integer=1,
                                    gap_threshold::Tuple=(7, 30),
                                    peak_threshold::AbstractFloat=9.0)
    osc = indicator # [2024-12-20 Fri 03:17] osc is short for oscillator.  Why did I do this though?
    field_set = rf.__df |> names .|> Symbol |> Set
    need = Set([osc, high, upper])
    if intersect(need, field_set) != need
        @error "Missing Fields" message="The given rf is missing some required columns." need field_set
        false
    end
    (min_gap, max_gap) = gap_threshold
    clusters = find_clusters(rf, 3, high_enough_fn(peak_threshold; high, upper, lower))
    @info clusters

    # not enough local highs detected
    if length(clusters) < 2
        return false
    end

    # most recent detected high is too far in the past
    if clusters[1][1] > age_threshold
        return false
    end

    high0 = find_local_high(rf, clusters[1])
    high1 = find_local_high(rf, clusters[2])
    osc0 = rf[osc][high0]
    osc1 = rf[osc][high1]

    if (high1 - high0 < min_gap)
        if length(clusters) > 2
            high1 = find_local_high(rf, clusters[3])
            if high1 - high0 < min_gap
                return false
            end
            osc1 = rf[osc][high1]
        else
            return false
        end
    end
    if high1 - high0 > max_gap
        return false
    end
    return osc0 < osc1
end

"""$(TYPEDSIGNATURES)

Return true if regular bullish divergence on the given indicator was detected near index 1.
Note that Bollinger Bands are used to help detect divergence, so their presence is required
in the `rf` in addition to the indicator that's being tested for divergence.

# Keyword Arguments

| argument       | default     | description                                 |
|----------------|-------------|:--------------------------------------------|
| indicator      | `:rsi14`    | Name in `rf` of the indicator being tested  |
| low            | `:l`        | Name in `rf` of the OHLCV high value        |
| upper          | `:bb_upper` | Name in `rf` of the upper band of the BBs   |
| lower          | `:bb_lower` | Name in `rf` of the lower band of the BBs   |
| age_threshold  | `1`         | ?                                           |
| gap_threshold  | `(7,30)`    | ?                                           |
| peak_threshold | `9.0`       | ?                                           |

# Example
```julia-repl
julia> regular_bullish_divergence(rf)
```
"""
function regular_bullish_divergence(rf::ReversedFrame;
                                    indicator::Symbol=:rsi14,
                                    low::Symbol=:l,
                                    upper::Symbol=:bb_upper,
                                    lower::Symbol=:bb_lower,
                                    age_threshold::Integer=1,
                                    gap_threshold::Tuple=(7, 30),
                                    peak_threshold::AbstractFloat=9.0)
    osc = indicator
    field_set = rf.__df |> names .|> Symbol |> Set
    need = Set([osc, low, lower])
    if intersect(need, field_set) != need
        @error "Missing Fields" message="The given rf is missing some required columns." need field_set
        return false
    end
    # Also make sure needed fields have non-missing values.
    for n in need
        if ismissing(rf[n][1])
            @info "missing" rf.ts[1] n
            return false
        end
    end
    (min_gap, max_gap) = gap_threshold
    clusters = find_clusters(rf, 3, low_enough_fn(peak_threshold; low, upper, lower))
    if length(clusters) < 2
        return false
    end
    if (clusters[1][1] > age_threshold)
        return false
    end
    low0 = find_local_low(rf, clusters[1])
    low1 = find_local_low(rf, clusters[2])
    osc0 = rf[osc][low0]
    osc1 = rf[osc][low1]
    if low1 - low0 < min_gap
        if length(clusters) > 2
            low1 = find_local_low(rf, clusters[3])
            if low1 - low0 < min_gap
                return false
            end
            osc1 = rf[osc][low1]
        else
            return false
        end
    end
    if low1 - low0 > max_gap
        return false
    end
    return osc0 > osc1
end

# """$(TYPEDSIGNATURES)
# """
# function hidden_bullish()
# end

# """$(TYPEDSIGNATURES)
# """
# function hidden_bearish()
# end

## percents

"""$(TYPEDSIGNATURES)

Return the percent change of series `a` the previous value to the current value.
If you want to compare the current value to a value further in the past, increase the value of `back`.
"""
function percent_change(a; i=1, back=1)
    if ismissing(a[i])
        return missing
    end
    newer = a[i]
    older = a[i+back]
    return ((newer - older) / older) * 100
end

"""$(TYPEDSIGNATURES)

Return the percent difference between `a[i]` and `b[i]`.  If either value is missing, return `missing`.
"""
function percent_difference(a, b; i=1)
    vals = ismissing.([a[i], b[i]])
    if any(in(vals), 1)
        return missing
    end
    ((b[i] - a[i]) / a[i]) * 100
end

## Exports

export Reversed
export ReversedFrame

export crossed_up_currently
export crossed_down_currently
export crossed_up
export crossed_down

export positive_slope_currently
export negative_slope_currently

export regular_bearish_divergence
export regular_bullish_divergence
# export hidden_bullish
# export hidden_bearish

export percent_change
export percent_difference

end
