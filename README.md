# ReversedSeries

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://g-gundam.github.io/ReversedSeries.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://g-gundam.github.io/ReversedSeries.jl/dev/)
[![Build Status](https://github.com/g-gundam/ReversedSeries.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/g-gundam/ReversedSeries.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/g-gundam/ReversedSeries.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/g-gundam/ReversedSeries.jl)

Provide a read-only view of a series indexed in reverse 

## Why?

[PineScript](https://www.pinecoders.com/) is the language used by TradingView that allows users of
their platform to implement their own indicators and trading
strategies.  In this langauge, all series are indexed such that index
0 represents the current moment in time, and time goes backwards as
the index increases.  This way of viewing price and indicator data
makes it a lot easier to write code to analyze the markets.  With index
0 being NOW across all the series, it's very easy to get oriented in time.

> When writing code to analyze the markets in Julia, I wanted that same convenience.

In Julia, the index would be 1 instead of 0, but close enough.  Also, if any
PineScript needs to be ported to Julia, this makes the translation a little easier.

## Types

### Reversed

The `Reversed` type lets you wrap anything arraylike in a struct that
can be indexed in reverse.

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

### ReversedFrame

The `ReversedFrame` type takes a DataFrame and wraps each of its series in `Reversed`
and makes them indexable by symbol.

```julia-repl
julia> rf = ReversedFrame(btcusd) # btcusd is a DataFrame
julia> rf.ts[1] # the most recent timestamp
julia> rf.ts[2] # the timestamp before that
julia> rf.c[1]  # the close at 1 corresponds with the timestamp at 1
julia> rf.o[1] == btcusd.o[end]
true
```
