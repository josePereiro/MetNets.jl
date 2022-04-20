const ECOLI_MODEL_BIOMASS_IDER = "Biomass_Ecoli_core_w_GAM"
const ECOLI_MODEL_MAT_FILE = abspath(joinpath(@__DIR__, "..", "..", "data", "ecoli_core_model.mat"))

function ecoli_core_model()
    mat_model = MAT.matread(ECOLI_MODEL_MAT_FILE)["model"]
    return MetNet(mat_model; reshape = true)
end