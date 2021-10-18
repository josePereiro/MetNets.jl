
logspace(start, stop, n = 50; base = 10.0) = base.^range(start, stop, length = n)

"""
    Returns a new dict with symbol keys. 
    It will share the source data.
"""
function to_symbol_dict(src_dict::Dict)
    dict = Dict()
    for (k, dat) in src_dict
        dict[Symbol(k)] = dat
    end
    return dict
end

"""
    Returns dict with symbol keys. 
    It will share the source object data.
"""
function struct_to_dict(obj::T) where T
    dict = Dict()
    for f in fieldnames(T)
        dict[f] = getproperty(obj, f)
    end
    return dict
end

"""
    give the error text as string
"""
function err_str(err; max_len = 10000)
    s = sprint(showerror, err, catch_backtrace())
    return length(s) > max_len ? s[1:max_len] * "\n[...]" : s
end

function get!push!(d; kwargs...)
    for (k, val) in kwargs
        push!(get!(d, k, []), val)
    end
    d
end

"""
    Give the percent [0-1] of zero elements
"""
sparsity(col::AbstractArray{<:Number}) = float(count(iszero, col) / length(col))

"""
    Returns a copy of the given data. If possible the object is
    stored in a more compacted type, e.i: array -> sparse
"""
compressed_copy(dat; sparsity_th = 0.66) = 
    dat isa AbstractArray{<:Number} ? 
        sparsity(dat) > sparsity_th ? sparse(dat) : deepcopy(dat) :
        deepcopy(dat)


function compressed_copy(dict::Dict; sparsity_th = 0.66)
    new_dict = Dict()
    for (k, dat) in dict
        new_dict[k] = compressed_copy(dat; sparsity_th = sparsity_th)
    end
    return new_dict
end
        
"""
    Returns a copy of the given data in a less 
    compressed format, e.i: sparse -> array
"""
uncompressed_copy(dat) = deepcopy(dat)
uncompressed_copy(dat::AbstractSparseArray) = dat |> collect


function uncompressed_copy(dict::Dict)
    new_dict = Dict()
    for (k, dat) in dict
        new_dict[k] = uncompressed_copy(dat)
    end
    return new_dict
end