module MetNets

    import MAT
    import SparseArrays
    
    using Serialization

    # Types
    include("Types/Rxns.jl")
    include("Types/Mets.jl")
    include("Types/MetNet_type.jl")

    # Utils
    include("Utils/base.jl")
    include("Utils/defaults.jl")
    include("Utils/iders.jl")
    include("Utils/setter.jl")
    include("Utils/getter.jl")
    include("Utils/queries.jl")
    include("Utils/read_mat.jl")
    include("Utils/summary.jl")
    include("Utils/split_revs.jl")
    include("Utils/update.jl")
    include("Utils/set_met.jl")
    include("Utils/set_rxn.jl")
    include("Utils/invert_bkwds.jl")
    include("Utils/make_intake_info_compat.jl")
    include("Utils/invert_rxn.jl")
    include("Utils/rxn_str.jl")
    include("Utils/search.jl")
    include("Utils/interchange_rxn.jl")
    include("Utils/del_rxn.jl")
    include("Utils/del_void_rxns_mets.jl")
    include("Utils/balance_str.jl")
    include("Utils/del_blocked.jl")
    include("Utils/del_met.jl")
    include("Utils/similar_rxns.jl")
    include("Utils/clampfields.jl")
    include("Utils/extended_model.jl")
    include("Utils/well_scaled_model.jl")
    include("Utils/sparse.jl")
    include("Utils/compressed_model.jl")
    include("Utils/check_dims.jl")
    include("Utils/fix_dims.jl")
    include("Utils/fixxing.jl")
    include("Utils/scale_polytope.jl")
    
    # Test
    include("Test/ecoli_core.jl")
    include("Test/lineal_model.jl")
    include("Test/toy_model.jl")
    

end
