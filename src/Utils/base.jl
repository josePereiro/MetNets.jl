import Base.size
import Base.isequal
import Base.==
import Base.hash
import Base.show

# MetNet
size(metnet::MetNet) = size(metnet.S)
size(metnet::MetNet, dim) = size(metnet.S, dim)

function ==(metnet1::MetNet, metnet2::MetNet)
    return metnet1.S == metnet2.S && metnet1.lb == metnet2.lb &&
    metnet1.ub == metnet2.ub && metnet1.mets == metnet2.mets &&
    metnet1.rxns == metnet2.rxns && metnet1.rxns == metnet2.rxns
end

isequal(metnet1::MetNet, metnet2::MetNet) = (metnet1 == metnet2)

hash(m::MetNet, h::Int = 0) = hash((:MetNet, m.S, m.b, m.lb, m.ub, h))

show(io::IO, m::MetNet) = summary(io, m)

# MetStates
show(io::IO, s::AbstractMetState) = _print_state_head(io, s)
