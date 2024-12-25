using ReversedSeries
using Test

@testset "Analysis" begin
    a = Reversed(1:10)
    @test percent_change(a) == 1/9*100
    @test percent_change(a; back=5) == 100
end
