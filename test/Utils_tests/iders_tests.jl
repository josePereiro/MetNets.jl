function test_iders()
    model = MetNets.toy_model()

    too_big = 100
    negative = -100
    @test_throws ErrorException MetNets.metindex(model, too_big)
    @test_throws ErrorException MetNets.metindex(model, negative)

    @test_throws ErrorException MetNets.rxnindex(model, too_big)
    @test_throws ErrorException MetNets.rxnindex(model, negative)


    for (i, rxn) in enumerate(MetNets.rxns(model))
        @test MetNets.rxnindex(model, i) == i
        @test MetNets.rxnindex(model, rxn) == i
    end

    for (i, met) in enumerate(MetNets.mets(model))
        @test MetNets.metindex(model, i) == i
        @test MetNets.metindex(model, met) == i
    end

    @test_throws ErrorException MetNets.metindex(model, "met_not_in_model")
    @test_throws ErrorException MetNets.rxnindex(model, "rxn_not_in_model")

end
test_iders()