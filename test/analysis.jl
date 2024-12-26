using ReversedSeries
using Test

@testset "Analysis" begin
    a = Reversed(1:10)
    b = Reversed(10:-1:1)
    @test crossed_up_currently(a, b) == true
    @test crossed_up_currently(a, b; i=10) == false
    @test crossed_down_currently(a, b; i=10) == true
    @test crossed_down_currently(a, b) == false

    @test percent_change(a) == 1/9*100
    @test percent_change(a; back=5) == 100
end
