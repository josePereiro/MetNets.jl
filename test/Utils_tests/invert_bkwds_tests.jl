function tests_invert_bkwds()
    model = MetNets.toy_model()
    
    bkwd_idxs = MetNets.bkwds_bounded(model)
    rename = (rxn) -> string(rxn, "_REV")
    new_model = MetNets.invert_bkwds(model; rename)

    for rxn_i in bkwd_idxs
        @test all(new_model.S[:,rxn_i] .== -model.S[:,rxn_i])
        @test new_model.lb[rxn_i] == -model.ub[rxn_i]
        @test new_model.ub[rxn_i] == -model.lb[rxn_i]
        @test new_model.rxns[rxn_i] == rename(model.rxns[rxn_i])
        @test new_model.rxnNames[rxn_i] == model.rxnNames[rxn_i]
    end
end
tests_invert_bkwds()