# MetNet
mets(metnet::MetNet) = metnet.mets
mets(metnet::MetNet, ider::IDER_TYPE) = metnet.mets[metindex(metnet, ider)]

metscount(metnet::MetNet) = length(metnet.mets)

rxns(metnet::MetNet) = metnet.rxns
rxns(metnet::MetNet, ider::IDER_TYPE) = metnet.rxns[rxnindex(metnet, ider)]

rxnscount(model) = length(model.rxns)

ub(metnet::MetNet) = metnet.ub
ub(metnet::MetNet, ider::IDER_TYPE) = metnet.ub[rxnindex(metnet, ider)]

lb(metnet::MetNet) = metnet.lb
lb(metnet::MetNet, ider::IDER_TYPE) = metnet.lb[rxnindex(metnet, ider)]

b(metnet::MetNet) = metnet.b
b(metnet::MetNet, ider::IDER_TYPE) = metnet.b[rxnindex(metnet, ider)]

bounds(metnet::MetNet, ider::IDER_TYPE) = (idx = rxnindex(metnet, ider); (metnet.lb[idx], metnet.ub[idx]))

S(metnet::MetNet, metider::IDER_TYPE, rxnider::IDER_TYPE) = 
    metnet.S[metindex(metnet, metider), rxnindex(metnet, rxnider)]

rxn_mets(metnet::MetNet, ider::IDER_TYPE) = findall(metnet.S[:,rxnindex(metnet, ider)] .!= 0.0)
rxn_reacts(metnet::MetNet, ider::IDER_TYPE) = findall(metnet.S[:,rxnindex(metnet, ider)] .< 0.0)
rxn_prods(metnet::MetNet, ider::IDER_TYPE) = findall(metnet.S[:,rxnindex(metnet, ider)] .> 0.0)

met_rxns(metnet::MetNet, ider::IDER_TYPE) = findall(metnet.S[metindex(metnet, ider), :] .!= 0.0)

# MetState
# Interface
av(s::AbstractMetState) = error("You must implement a 'av(s::$(typeof(s)))' method")
va(s::AbstractMetState) = error("You must implement a 'va(s::$(typeof(s)))' method")

av(s::Vector{<:Real}) = s
va(s::Vector{<:Real}) = s

# Commons getter interface
for fun_name in [:av, :va]

    @eval begin
        $(fun_name)(state::AbstractMetState, idxs) = 
            $(fun_name)(state)[idxs]
        $(fun_name)(metnet::MetNet, state::AbstractMetState, ider) = 
            $(fun_name)(state)[rxnindex(metnet, ider)]    
        $(fun_name)(metnet::MetNet, state::AbstractMetState, iders::Vector) = 
            [$(fun_name)(metnet, state, ider) for ider in iders]
        $(fun_name)(metnet::MetNet, states::Vector, ider) =
            [$(fun_name)(metnet, state, ider) for state in states]
        $(fun_name)(metnets::Vector, states::Vector, ider) = 
            [$(fun_name)(metnet, state, ider) for (metnet, state) in zip(metnets, states)]
    end
end