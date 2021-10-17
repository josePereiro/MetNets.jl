stoi_err(S, v, b) = S * v - b

stoi_err(metnet::MetNet, state) = stoi_err(metnet.S, av(state), metnet.b)
stoi_err(metnet::MetNet, state, ider) = 
    stoi_err(metnet.S, av(state), metnet.b)[metindex(metnet, ider)]

