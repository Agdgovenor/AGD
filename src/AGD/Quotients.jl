module Quotients

using ..Metric

export Quotient
export QuotientSpace
export nearest_class
export project!
export compression_ratio

############################################################
# QUOTIENT
############################################################

mutable struct Quotient
    id::Int
    centroid::Vector{Float64}
    visits::Int
end

############################################################
# QUOTIENT SPACE
############################################################

mutable struct QuotientSpace
    metric::MetricSpace
    threshold::Float64
    classes::Vector{Quotient}
end

function QuotientSpace(dimension::Int;
                       threshold::Float64=1.0)

    QuotientSpace(
        MetricSpace(dimension),
        threshold,
        Quotient[]
    )

end

############################################################
# NEAREST CLASS
############################################################

function nearest_class(Q::QuotientSpace,
                       x::Vector{Float64})

    isempty(Q.classes) && return (0, Inf)

    best = 0
    bestdist = Inf

    for q in Q.classes

        d = weighted_distance(Q.metric,
                              x,
                              q.centroid)

        if d < bestdist
            bestdist = d
            best = q.id
        end

    end

    return best,bestdist

end

############################################################
# PROJECT
############################################################

function project!(Q::QuotientSpace,
                  x::Vector{Float64})

    if isempty(Q.classes)

        push!(Q.classes,
            Quotient(
                1,
                copy(x),
                1
            )
        )

        return 1

    end

    id,d = nearest_class(Q,x)

    if d <= Q.threshold

        q = Q.classes[id]

        centroid_update(
            q.centroid,
            x
        )

        q.visits += 1

        return id

    end

    newid = length(Q.classes)+1

    push!(Q.classes,
        Quotient(
            newid,
            copy(x),
            1
        )
    )

    return newid

end

############################################################
# COMPRESSION
############################################################

function compression_ratio(Q::QuotientSpace)

    total = sum(q.visits for q in Q.classes)

    if total==0
        return 0.0
    end

    return length(Q.classes)/total

end

end
