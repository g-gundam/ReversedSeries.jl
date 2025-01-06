using ReversedSeries
using Test

@testset "Analysis" begin
    a = Reversed(1:10)
    b = Reversed(10:-1:1)

    @test crossed_up_currently(a, b) == true
    @test crossed_up_currently(a, b; i=10) == false
    @test crossed_down_currently(a, b; i=10) == true
    @test crossed_down_currently(a, b) == false

    @test positive_slope_currently(a) == true
    @test negative_slope_currently(a) == false
    @test positive_slope_currently(b) == false
    @test negative_slope_currently(b) == true

    @test percent_change(a) == 1/9*100
    @test percent_change(a; back=5) == 100

    @test percent_difference(a, b) == -90.0
    @test percent_difference(b, a) == 900.0
end
