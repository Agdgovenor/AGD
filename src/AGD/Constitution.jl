module Constitution

export ConstitutionRule
export ConstitutionState
export default_constitution

struct ConstitutionRule
    name::String
    description::String
end

mutable struct ConstitutionState
    rules::Vector{ConstitutionRule}
end

function default_constitution()

    ConstitutionState([
        ConstitutionRule(
            "Determinism",
            "Execution is deterministic."
        )
    ])

end

end
