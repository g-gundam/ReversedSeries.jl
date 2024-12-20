"""$(TYPEDSIGNATURES)

Return a function that tries to find lows by their proximity the BB lower bands
"""
function low_enough_fn(threshold::AbstractFloat; low=:l, upper=:bb_upper, lower=:bb_lower)
    return function(rf::ReversedFrame, i::Integer)
        percent_b_low = (rf[low][i] - rf[lower][i]) / (rf[upper][i] - rf[lower][i]) * 100
        return percent_b_low - threshold <= 0.0
    end
end

"""$(TYPEDSIGNATURES)

Return a function that tries to find highs by their proximity the BB upper bands
"""
function high_enough_fn(threshold::AbstractFloat; high=:h, upper=:bb_upper, lower=:bb_lower)
    return function(rf::ReversedFrame, i::Integer)
        percent_b_high = (rf[high][i] - rf[lower][i]) / (rf[upper][i] - rf[lower][i]) * 100
        return percent_b_high + threshold >= 100.0
    end
end


"""$(TYPEDSIGNATURES)

Return a vector of vector of indices of consecutive candles that satisfy the given function.
"""
function find_clusters(rf::ReversedFrame, max::Integer, fn::Function)
    result = []
    cluster = []
    for i in 1:length(rf.c)
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
