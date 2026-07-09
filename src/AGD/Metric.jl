module Metric

using LinearAlgebra

export MetricSpace,
       euclidean,
       squared_distance,
       weighted_distance,
       normalize_vector,
       centroid_update

############################################################
# METRIC SPACE
############################################################

mutable struct MetricSpace
    dimension::Int
    weights::Vector{Float64}
end

MetricSpace(d::Int) = MetricSpace(d, ones(d))

############################################################
# EUCLIDEAN DISTANCE
############################################################

function euclidean(a::AbstractVector,b::AbstractVector)
    @assert length(a)==length(b)
    sqrt(sum((a .- b).^2))
end

############################################################
# SQUARED DISTANCE
############################################################

function squared_distance(a::AbstractVector,b::AbstractVector)
    @assert length(a)==length(b)
    sum((a .- b).^2)
end

############################################################
# WEIGHTED DISTANCE
############################################################

function weighted_distance(
    M::MetricSpace,
    a::AbstractVector,
    b::AbstractVector)

    @assert length(a)==length(b)
    @assert length(a)==M.dimension

    sqrt(sum(M.weights .* (a .- b).^2))
end

############################################################
# NORMALIZATION
############################################################

function normalize_vector(v::AbstractVector)

    n = norm(v)

    if n == 0.0
        return copy(v)
    end

    return v ./ n
end

############################################################
# CENTROID UPDATE
############################################################

function centroid_update(
    centroid::Vector{Float64},
    sample::Vector{Float64},
    α::Float64=0.15)

    @assert length(centroid)==length(sample)

    centroid .= (1-α).*centroid .+ α.*sample

    return centroid
end

end
