module MetNets

    import MAT
    import SparseArrays
    
    using Serialization

    # Types
    include("Types/Rxns.jl")
    include("Types/Mets.jl")
    include("Types/MetNet.jl")
    include("Types/MetStates.jl")
    
    # Utils    
    include("Utils/iders.jl") # Need to be included first
    include("Utils/balance_str.jl")
    include("Utils/base.jl")
    include("Utils/check_dims.jl")
    include("Utils/clampfields.jl")
    include("Utils/compressed_model.jl")
    include("Utils/defaults.jl")
    include("Utils/del_blocked.jl")
    include("Utils/del_met.jl")
    include("Utils/del_rxn.jl")
    include("Utils/del_void_rxns_mets.jl")
    include("Utils/extended_model.jl")
    include("Utils/fixxing.jl")
    include("Utils/force_dims.jl")
    include("Utils/getter.jl")
    include("Utils/interchange_rxn.jl")
    include("Utils/invert_bkwds.jl")
    include("Utils/invert_rxn.jl")
    include("Utils/make_intake_info_compat.jl")
    include("Utils/queries.jl")
    include("Utils/read_mat.jl")
    include("Utils/rxn_str.jl")
    include("Utils/scale_polytope.jl")
    include("Utils/search.jl")
    include("Utils/set_met.jl")
    include("Utils/set_rxn.jl")
    include("Utils/setter.jl")
    include("Utils/similar_rxns.jl")
    include("Utils/sparse.jl")
    include("Utils/split_revs.jl")
    include("Utils/stoi_err.jl")
    include("Utils/summary.jl")
    include("Utils/TNmarginal.jl")
    include("Utils/update.jl")
    include("Utils/well_scaled_model.jl")
    
    # Test
    include("Test/ecoli_core.jl")
    include("Test/lineal_model.jl")
    include("Test/toy_model.jl")
    

end
