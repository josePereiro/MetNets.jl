function test_getters()
    model = MetNets.toy_model()
    @test MetNets.mets(model) == model.mets
    @test MetNets.rxns(model) == model.rxns

    for (i, rxn) in enumerate(MetNets.rxns(model))
        @test MetNets.ub(model, rxn) == model.ub[i]
        @test MetNets.ub(model, i) == model.ub[i]
        @test MetNets.lb(model, rxn) == model.lb[i]
        @test MetNets.lb(model, i) == model.lb[i]
        @test MetNets.rxns(model, i) == model.rxns[i]
        @test MetNets.rxns(model, rxn) == rxn
    end

    for (i, met) in enumerate(MetNets.mets(model))
        @test MetNets.mets(model, i) == model.mets[i]
        @test MetNets.mets(model, met) == model.mets[i]
    end

end
test_getters()