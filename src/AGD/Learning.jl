module Learning

using ..OperatorAtlas

export LearningState
export observe!
export reward!
export penalty!
export learn!

############################################################
# LEARNING STATE
############################################################

mutable struct LearningState

    observations::Int

    rewards::Int

    penalties::Int

end

LearningState() = LearningState(0,0,0)

############################################################
# REWARD
############################################################

function reward!(
    L::LearningState,
    atlas::OperatorAtlasState,
    name::String
)

    L.observations += 1
    L.rewards += 1

    record_success!(atlas,name)

    return nothing

end

############################################################
# PENALTY
############################################################

function penalty!(
    L::LearningState,
    atlas::OperatorAtlasState,
    name::String
)

    L.observations += 1
    L.penalties += 1

    record_failure!(atlas,name)

    return nothing

end

############################################################
# OBSERVE
############################################################

function observe!(
    L::LearningState,
    atlas::OperatorAtlasState,
    name::String,
    success::Bool
)

    if success
        reward!(L,atlas,name)
    else
        penalty!(L,atlas,name)
    end

end

############################################################
# LEARN
############################################################

function learn!(
    L::LearningState,
    atlas::OperatorAtlasState,
    name::String,
    success::Bool,
    cost::Float64
)

    observe!(
        L,
        atlas,
        name,
        success
    )

    record_cost!(
        atlas,
        name,
        cost
    )

end

end
