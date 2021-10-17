stoi_err(S::Matrix, v::Vector, b::Vector) = S * v - b
stoi_err(S::Matrix, v::Vector, b::Vector, meti::Int) = @views S[meti, :]' * v - b[meti]

stoi_err(metnet::MetNet, state::AbstractMetState) = stoi_err(metnet.S, av(state), metnet.b)
stoi_err(metnet::MetNet, state::AbstractMetState, ider) = 
    stoi_err(metnet.S, av(state), metnet.b, metindex(metnet, ider))

function norm_stoi_err(net::MetNet, v::Vector, meti::Int; 
        normfun = (metv) -> mean(abs, metv)
    )
    rxnis = MetNets.met_rxns(net, meti)
    metv = net.S[meti, rxnis] .* v[rxnis]
    err = sum(metv) - net.b[meti]
    iszero(err) && return err
    ref = normfun(metv)
    iszero(ref) && return err
    return err / ref
end

norm_stoi_err(net::MetNet, v::Vector; kwargs...) = 
    [norm_stoi_err(net, v, meti; kwargs...) for meti in eachindex(net.mets)]

norm_stoi_err(net::MetNet, state::AbstractMetState, meti; kwargs...) = 
    norm_stoi_err(net, av(state), metindex(net, meti); kwargs...)

norm_stoi_err(net::MetNet, state::AbstractMetState; kwargs...) = 
    norm_stoi_err(net, av(state); kwargs...)
