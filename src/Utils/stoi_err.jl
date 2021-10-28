stoi_err(S::AbstractMatrix, v::AbstractVector, b::AbstractVector) = S * v - b
stoi_err(S::AbstractMatrix, v::AbstractVector, b::AbstractVector, meti::Int) = @views S[meti, :]' * v - b[meti]

stoi_err(metnet::MetNet, state) = stoi_err(metnet.S, av(state), metnet.b)
stoi_err(metnet::MetNet, state, ider) = 
    stoi_err(metnet.S, av(state), metnet.b, metindex(metnet, ider))

function norm_stoi_err(net::MetNet, v::AbstractVector, meti::Int; 
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

norm_stoi_err(net::MetNet, v::AbstractVector; kwargs...) = 
    [norm_stoi_err(net, v, meti; kwargs...) for meti in eachindex(net.mets)]

norm_stoi_err(net::MetNet, state, meti; kwargs...) = 
    norm_stoi_err(net, av(state), metindex(net, meti); kwargs...)

norm_stoi_err(net::MetNet, state; kwargs...) = 
    norm_stoi_err(net, av(state); kwargs...)
