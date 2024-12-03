# ReversedSeries

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://g-gundam.github.io/ReversedSeries.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://g-gundam.github.io/ReversedSeries.jl/dev/)
[![Build Status](https://github.com/g-gundam/ReversedSeries.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/g-gundam/ReversedSeries.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/g-gundam/ReversedSeries.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/g-gundam/ReversedSeries.jl)

Provide a read-only view of a series indexed in reverse 

## Why?

PineScript is the language used by TradingView that allows users of
their platform to implement their own indicators and trading
strategies.  In this langauge, all series are indexed such that index
0 represents the current moment in time, and time goes backwards as
the index increases.  This way of viewing price and indicator data
makes it a lot easier to write code to analyze the markets.  With index
0 being NOW across all the series, it's very easy to get oriented in time.

> When writing code to analyze the markets in Julia, I wanted that same convenience.
