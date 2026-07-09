module Governor

export GovernorState
export decide!
export update!
export policy_summary

############################################################
# GOVERNOR STATE
############################################################

mutable struct GovernorState
    adapt_threshold::Float64
    reroute_threshold::Float64

    stay_count::Int
    adapt_count::Int
    reroute_count::Int
end

GovernorState() = GovernorState(
    1.05,
    1.20,
    0,
    0,
    0
)

############################################################
# DECISION
############################################################

function decide!(g::GovernorState,
                 current::Float64,
                 predicted::Float64)

    if predicted > current * g.reroute_threshold
        g.reroute_count += 1
        return :reroute

    elseif predicted > current * g.adapt_threshold
        g.adapt_count += 1
        return :adapt

    else
        g.stay_count += 1
        return :stay
    end
end

############################################################
# UPDATE POLICY
############################################################

function update!(g::GovernorState,error::Float64)

    if error > 0.50
        g.adapt_threshold =
            max(1.01,
                g.adapt_threshold-0.01)

        g.reroute_threshold =
            max(1.05,
                g.reroute_threshold-0.02)

    else
        g.adapt_threshold =
            min(1.20,
                g.adapt_threshold+0.005)

        g.reroute_threshold =
            min(1.50,
                g.reroute_threshold+0.01)
    end

end

############################################################
# SUMMARY
############################################################

function policy_summary(g::GovernorState)

    println()
    println("Governor Summary")
    println("-------------------------")
    println("Stay      : ",g.stay_count)
    println("Adapt     : ",g.adapt_count)
    println("Reroute   : ",g.reroute_count)
    println("Adapt Thr : ",g.adapt_threshold)
    println("Route Thr : ",g.reroute_threshold)

end


############################################################
# POLICY SCORE
############################################################

export policy_score

function policy_score(
    confidence::Float64,
    cost::Float64;
    α=1.0,
    β=0.5
)

    return α*confidence - β*cost

end

############################################################
# CHOOSE BEST
############################################################

export choose_best

function choose_best(scores::Dict{String,Float64})

    isempty(scores) && return nothing

    best_name = first(keys(scores))
    best_score = scores[best_name]

    for (k,v) in scores

        if v > best_score
            best_name = k
            best_score = v
        end

    end

    return best_name,best_score

end

end
