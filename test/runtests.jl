using ReversedSeries
using DataFrames
using Dates

using Test

@testset "Reversed" begin
    a = [1, 2, 3]
    ra = Reversed(a)
    @test ra[1] == a[3]
end

@testset "ReversedFrame" begin
    df = DataFrame(
        ts=[DateTime("2023-08-15T00:00:00"), DateTime("2023-08-15T00:01:00"), DateTime("2023-08-15T00:02:00"), DateTime("2023-08-15T00:03:00"), DateTime("2023-08-15T00:04:00")],
        o=[29404.75911336, 29403.04042329, 29403.93319979, 29405.0820587, 29404.38160413],
        h=[29406.52232887, 29404.22747867, 29405.20890149, 29405.65741941, 29404.67747468],
        l=[29400.3644731, 29398.61537222, 29403.72149026, 29404.41312685, 29404.29206289],
        c=[29403.02151407, 29403.82700593, 29405.14662533, 29404.41312685, 29404.47987758],
        v=[0.0, 0.0, 0.0, 0.0, 0.0]
    )
    rf = ReversedFrame(df)
    @test df == rf.df
    @test df.ts[1] == rf.ts[5]
    @test df.o[5] == rf.o[1]
end
