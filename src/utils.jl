"""$(TYPEDSIGNATURES)

Return a function that tries to find lows by their proximity to the BB lower bands
"""
function low_enough_fn(threshold::AbstractFloat; low=:l, upper=:bb_upper, lower=:bb_lower)
    return function(rf::ReversedFrame, i::Integer)
        percent_b_low = (rf[low][i] - rf[lower][i]) / (rf[upper][i] - rf[lower][i]) * 100
        if ismissing(percent_b_low)
            return false
        end
        return percent_b_low - threshold <= 0.0
    end
end

"""$(TYPEDSIGNATURES)

Return a function that tries to find highs by their proximity to the BB upper bands
"""
function high_enough_fn(threshold::AbstractFloat; high=:h, upper=:bb_upper, lower=:bb_lower)
    return function(rf::ReversedFrame, i::Integer)
        percent_b_high = (rf[high][i] - rf[lower][i]) / (rf[upper][i] - rf[lower][i]) * 100
        if ismissing(percent_b_high)
            return false
        end
        return percent_b_high + threshold >= 100.0
    end
end


"""$(TYPEDSIGNATURES)

Return a vector of vector of indices of consecutive candles that satisfy the given function.
"""
function find_clusters(rf::ReversedFrame, max::Integer, fn::Function; close=:c)
    result = []
    cluster = []
    for i in 1:length(rf[close])
        if fn(rf, i)
            push!(cluster, i)
        else
            if length(cluster) > 0
                push!(result, cluster)
                cluster = []
                if length(result) == max
                    return result
                end
            end
        end
    end
    if length(cluster) > 0
        push!(result, cluster)
    end
    return result
end

"""$(TYPEDSIGNATURES)

Given a collection and a test function, return the index of the
first item that returns true for `testfn(collection[i])`.
If nothing is found, return `missing`.
This is a port of JavaScript's Array.prototype.findIndex.
"""
function find_index(collection::AbstractArray, testfn::Function)
    for i in eachindex(collection)
        if testfn(collection[i])
            return i
        end
    end
    return missing
end

"""$(TYPEDSIGNATURES)

Out of the cluster, which index had the highest close?
"""
function find_local_high(rf, cluster; close=:c)
    closes = map(i -> rf[close][i], cluster)
    highest = maximum(closes)
    highest_index = find_index(closes, c -> c == highest)
    return cluster[highest_index]
end

"""$(TYPEDSIGNATURES)

Out of the cluster, which index had the lowest close?
"""
function find_local_low(rf, cluster; close=:c)
    closes = map(i -> rf[close][i], cluster)
    lowest = minimum(closes)
    lowest_index = find_index(closes, c -> c == lowest)
    return cluster[lowest_index]
end
