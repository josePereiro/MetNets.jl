function test_del_rxn()
    model = MetNets.toy_model()

    M, N = size(model)
    model.S .= rand(M, N)
    model.c .= rand(N)
    model.lb .= -rand(N)
    model.ub .= rand(N)

    for rxn in model.rxns
        MetNets.del_rxn!(model, rxn);
    end

    @test iszero(model.S) 
    @test iszero(model.lb) 
    @test iszero(model.ub) 
    @test iszero(model.c) 
    @test all(model.rxns .== MetNets.EMPTY_SPOT) 
end
test_del_rxn()