module OperatorGraph

############################################################
# EXPORTS
############################################################

export Operator
export OperatorEdge
export OperatorGraphState

export add_transition!
export next_operator
export edge_probability
export graph_summary

############################################################
# OPERATOR
############################################################

mutable struct Operator
    id::Int
    name::String
end

############################################################
# EDGE
############################################################

mutable struct OperatorEdge

    from::Int

    to::Int

    op::Operator

    count::Int

end

############################################################
# GRAPH
############################################################

mutable struct OperatorGraphState

    edges::Vector{OperatorEdge}

    nextid::Int

end

OperatorGraphState() = OperatorGraphState(
    OperatorEdge[],
    1
)

############################################################
# ADD TRANSITION
############################################################

function add_transition!(
    G::OperatorGraphState,
    from::Int,
    to::Int,
    op::Operator
)

    for e in G.edges

        if e.from == from &&
           e.to   == to &&
           e.op.name == op.name

            e.count += 1

            return e

        end

    end

    push!(G.edges,
        OperatorEdge(
            from,
            to,
            op,
            1
        )
    )

    G.nextid += 1

    return G.edges[end]

end

############################################################
# NEXT OPERATOR
############################################################

function next_operator(
    G::OperatorGraphState,
    from::Int
)

    best = nothing

    bestcount = -1

    for e in G.edges

        if e.from == from

            if e.count > bestcount

                best = e

                bestcount = e.count

            end

        end

    end

    return best

end

############################################################
# EDGE PROBABILITY
############################################################

function edge_probability(
    G::OperatorGraphState,
    edge::OperatorEdge
)

    total = 0

    for e in G.edges

        if e.from == edge.from

            total += e.count

        end

    end

    if total == 0

        return 0.0

    end

    return edge.count / total

end

############################################################
# SUMMARY
############################################################

function graph_summary(
    G::OperatorGraphState
)

    println()

    println("Operator Graph")

    println("============================")

    for e in G.edges

        println(
            "Q",
            e.from,
            " -- ",
            e.op.name,
            " --> Q",
            e.to,
            "   count=",
            e.count,
            "   prob=",
            round(edge_probability(G,e),digits=3)
        )

    end

    println()

end

end
