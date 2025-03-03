using Test
using EgyptianFractions

@testset "Greedy" begin
    A = Set([2//3, 3, 50//11, 5//16, 1//5])
    for a in A
        D = greedy(a)
        @test representation_check(a, D)
    end
end
