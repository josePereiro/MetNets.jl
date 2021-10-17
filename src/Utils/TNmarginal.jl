function TNmarginal(model::MetNet, state::AbstractMetState, ider)
    ider = rxnindex(model, ider)
    μ_ = μ(model, state, ider)
    σ_ = σ(model, state, ider)
    return Truncated(Normal(μ_, sqrt(σ_)), lb(model, ider), ub(model, ider)) 
end