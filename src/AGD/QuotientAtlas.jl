module QuotientAtlas


############################################################
# EXPORTS
############################################################

export QuotientRecord
export QuotientAtlasState

export register_quotient!
export find_quotient
export quotient_count
export atlas_summary

############################################################
# QUOTIENT RECORD
############################################################

mutable struct QuotientRecord

    id::Int

    centroid::Vector{Float64}

    visits::Int

    last_seen::Int

end

############################################################
# ATLAS
############################################################

mutable struct QuotientAtlasState

    records::Vector{QuotientRecord}

    nextid::Int

end

############################################################
# CONSTRUCTOR
############################################################

QuotientAtlasState() = QuotientAtlasState(
    QuotientRecord[],
    1
)

############################################################
# REGISTER
############################################################

function register_quotient!(
    atlas::QuotientAtlasState,
    centroid::Vector{Float64}
)

    q = QuotientRecord(
        atlas.nextid,
        copy(centroid),
        1,
        1
    )

    push!(atlas.records,q)

    atlas.nextid += 1

    return q

end

############################################################
# FIND
############################################################

function find_quotient(
    atlas::QuotientAtlasState,
    id::Int
)

    for q in atlas.records

        if q.id == id
            return q
        end

    end

    return nothing

end

############################################################
# COUNT
############################################################

function quotient_count(
    atlas::QuotientAtlasState
)

    return length(atlas.records)

end

############################################################
# SUMMARY
############################################################

function atlas_summary(
    atlas::QuotientAtlasState
)

    println()

    println("==============================")
    println("Quotient Atlas")
    println("==============================")

    for q in atlas.records

        println(
            "Q",
            q.id,
            " visits=",
            q.visits,
            " last_seen=",
            q.last_seen,
            " centroid=",
            q.centroid
        )

    end

    println()

end

end
