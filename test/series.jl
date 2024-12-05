using ReversedSeries
using Test

@testset "Reversed" begin
    a = [1, 2, 3]
    ra = Reversed(a)
    @test ra[1] == a[3]
end
