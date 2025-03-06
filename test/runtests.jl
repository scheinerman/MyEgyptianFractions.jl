using Test
using MyEgyptianFractions

@testset "Greedy" begin
    A = Set([2//3, 3, 50//11, 5//16, 1//5])
    for a in A
        D = greedy(a)
        @test representation_check(a, D)
    end
end

@testset "Optimal" begin
    a = 3//7
    D = optimal(a, 25)
    @test representation_check(a, D)

    D = optimal(a, 25, false)

    @test representation_check(a, D)
end
