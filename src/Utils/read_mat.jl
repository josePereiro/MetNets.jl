# Code derived from metabolicEP (https://github.com/anna-pa-m/Metabolic-EP)

function read_mat(filename::String; model_id = nothing)
    mat_dict = MAT.matread(filename)
    if isnothing(model_id)
        model_id, model_mat = first(mat_dict)
    else
        model_mat = mat_dict[model_id]
    end
    return MetNet(model_mat; reshape = true)
end