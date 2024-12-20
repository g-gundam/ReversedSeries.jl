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
