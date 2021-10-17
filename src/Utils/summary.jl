const WARN_COLOR = :yellow
const INFO_COLOR = :blue
const ERROR_COLOR = :red

function _print_summary_head(io::IO)
    print(io, "SUMMARY (color code: ")
    printstyled(io, "warning", color = WARN_COLOR)
    printstyled(io, ", info", color = INFO_COLOR)
    printstyled(io, ", error", color = ERROR_COLOR)
    println(io, ")")
end

"""
    Print useful info about the given metnet.
"""
function summary(io::IO, metnet::MetNet)
    _print_summary_head(io)
    printstyled(io, "model size: $(size(metnet))", "\n", color = INFO_COLOR)
    _summary_bound_state(io, metnet)
end
summary(metnet::MetNet) = summary(stdout, metnet)

function _summary_bound_state(io::IO, metnet::MetNet)
    PRINT_MAX = 50 # TODO make this global?
    M, N = size(metnet)

    all(iszero(metnet.lb)) && all(iszero(metnet.ub)) && 
        (printstyled(io, "lb and ub boths has only zero elements", "\n", color = ERROR_COLOR); return)
    
    # single checks
    for (name, col) in zip(["lb", "ub"], [metnet.lb, metnet.ub])
        _print_col_summary(io, col, name; expected_l = N, PRINT_MAX = PRINT_MAX)
    end

    # Counple checks
    line_count = 0
    for (i, rxn) in enumerate(metnet.rxns)
        lb = metnet.lb[i]
        ub = metnet.ub[i]
        lb > ub && (printstyled(io, "rxn($i): ($rxn), lb ($lb) > ub ($ub)", 
            "\n", color = ERROR_COLOR); line_count += 1)
        lb > 0.0 && (printstyled(io, "rxn($i): ($rxn), lb ($lb) > 0.0", 
            "\n", color = WARN_COLOR); line_count += 1)
        ub < 0.0 && (printstyled(io, "rxn($i): ($rxn), ub ($ub) < 0.0", 
            "\n", color = WARN_COLOR);  line_count += 1)
        lb == ub && (printstyled(io, "rxn($i): ($rxn), lb ($lb) == ub ($ub)", 
            "\n", color = WARN_COLOR); line_count += 1)
        # TODO implement correctly the rev array
        # (isrev(metnet, i) ⊻ metnet.rev[i]) && 
        #         (printstyled(io, "rxn($i): ($rxn), rev and bounds missmatch", "\n", 
        #                 color = ERROR_COLOR); line_count += 1)

        if line_count > PRINT_MAX
            printstyled(io, "PRINT_MAX $PRINT_MAX reached!!! ... ", "\n", color = WARN_COLOR)
            break;
        end
        flush(stdout)
    end


    revscount(metnet) > 0 && printstyled(io, "revscount: $(revscount(metnet))", "\n", color = WARN_COLOR)
    fwds_boundedcount(metnet) > 0 && printstyled(io, "fwds_bounded: $(fwds_boundedcount(metnet))", "\n", color = INFO_COLOR)
    bkwds_boundedcount(metnet) > 0 && printstyled(io, "bkwds_bounded: $(bkwds_boundedcount(metnet))", "\n", color = WARN_COLOR)
    blockscount(metnet) > 0 && printstyled(io, "blocks: $(blockscount(metnet))", "\n", color = WARN_COLOR)
    fixxedscount(metnet) > 0 && printstyled(io, "fixxed: $(fixxedscount(metnet))", "\n", color = INFO_COLOR)

    return nothing
end

function _print_col_summary(io::IO, col, name; 
        expected_l = length(col), 
        PRINT_MAX = 50)

        length(col) != expected_l && (printstyled(io, 
            " $name: ($(length(col))) != N ($expected_l), dimention missmatch", 
            "\n", color = ERROR_COLOR); return)
    
        unique_ = sort!(unique(col))
        length(unique_) < PRINT_MAX ?
            printstyled(io, " $name: $(length(unique_)) unique elment(s): ", unique_, "\n", color = INFO_COLOR) :
            printstyled(io, " $name: $(length(unique_)) unique elment(s): min: ", 
                first(unique_), " mean: ", mean(col),
                " max: ", last(unique_), "\n", color = INFO_COLOR)

end

function _print_rxn_summary(io::IO, metnet, ider)
    idx = rxnindex(metnet, ider)
    printstyled(io, " rxn[$idx]: ", metnet.rxns[idx], " (", get(metnet.rxnNames, idx, ""), ")\n", color = INFO_COLOR)
    printstyled(io, " lb: ", metnet.lb[idx], ", ub: ", metnet.ub[idx], "\n" , color = INFO_COLOR)
    printstyled(io, " ", rxn_str(metnet, idx), "\n" , color = INFO_COLOR)
end

function _print_met_summary(io::IO, metnet, ider)
    idx = metindex(metnet, ider)
    printstyled(io, " met[$idx]: ", metnet.mets[idx], " (", get(metnet.metNames, idx, ""), ")\n", color = INFO_COLOR)
    printstyled(io, " ", balance_str(metnet, ider), color = INFO_COLOR)
end

function summary(io::IO, model::MetNet, ider::IDER_TYPE)
    _print_summary_head(io)
    try
        _print_rxn_summary(io, model, ider)
    catch end
    try
        _print_met_summary(io, model, ider)
    catch end
end
summary(model::MetNet, ider::IDER_TYPE) = summary(stdout, model, ider)

function summary(io::IO, model::MetNet, state::AbstractMetState;
        PRINT_MAX = 50, 
        digits = 4)
    _print_summary_head(io)
    _print_state_head(io, state)
    _print_state_stats(io, model, state, PRINT_MAX)
    _print_state_exchanges_info(model, state, digits)
end
summary(model::MetNet, state::AbstractMetState) = summary(stdout, model, state)

function _print_state_stats(io::IO, model::MetNet, state::AbstractMetState, PRINT_MAX)
    println(io, "State stats:")
    av_ = av(state)
    va_ = va(state)
    for (name, col) in zip(["av", "va"], [av_, va_])
        _print_col_summary(io, col, name; expected_l = size(model, 2), PRINT_MAX)
    end
end

function _print_state_head(io, state)
    println(io, " Not implemented for $(typeof(state))!!!")
end

function _print_state_exchanges_info(io::IO, model::MetNet, state::AbstractMetState, digits = 3)
    println(io, "Exchange info:")
    exchs_ = model.rxns[exchanges(model)] |> sort
    for sense in [1, -1]
        for ider in exchs_
            av_ = av(model, state, ider)
            if sense * av_ > 0
                av_ = round(av_, digits = digits)
                va_ = round(va(model, state, ider), digits = digits)
                rstr = rxn_str(model, ider)
                rbounds = round.(bounds(model, ider), digits = digits)
                printstyled(io, " $ider => av: $av_, va: $va_, bounds: $(rbounds), eq: $(rstr)\n", color = INFO_COLOR)
            end
        end
        println(io)
    end
end