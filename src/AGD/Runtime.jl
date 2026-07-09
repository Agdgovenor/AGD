module Runtime

using ..Metric
using ..Quotients
using ..OperatorGraph
using ..Governor

export RuntimeState
export initialize!
export step!
export summary

############################################################
# RUNTIME STATE
############################################################

mutable struct RuntimeState

    metric::Metric.MetricSpace

    quotient_space::Quotients.QuotientSpace

    operator_graph::OperatorGraph.OperatorGraphState

    governor::Governor.GovernorState

    previous_qid::Int

    steps::Int

end

############################################################
# INITIALIZE
############################################################

function initialize!(dimension::Int;
                     threshold=1.5)

    RuntimeState(

        Metric.MetricSpace(dimension),

        Quotients.QuotientSpace(
            Metric.MetricSpace(dimension),
            threshold,
            Quotients.Quotient[]
        ),

        OperatorGraph.OperatorGraphState(
            OperatorGraph.OperatorEdge[],
            1
        ),

        Governor.GovernorState(),

        0,

        0
    )

end

############################################################
# STEP
############################################################

function step!(rt::RuntimeState,
               ψ::Vector{Float64})

    qid = Quotients.project!(
        rt.quotient_space,
        ψ
    )

    if rt.previous_qid != 0 &&
       rt.previous_qid != qid

        op = OperatorGraph.Operator(
            rt.operator_graph.nextid,
            "Δ$(rt.previous_qid)_$(qid)"
        )

        OperatorGraph.add_transition!(
            rt.operator_graph,
            rt.previous_qid,
            qid,
            op
        )

    end

    rt.previous_qid = qid

    rt.steps += 1

    return qid

end

############################################################
# SUMMARY
############################################################

function summary(rt::RuntimeState)

    println()
    println("==============================")
    println("AGD Runtime Summary")
    println("==============================")

    println("Steps               : ",rt.steps)

    println("Quotient Classes    : ",
        length(rt.quotient_space.classes))

    println("Operator Edges      : ",
        length(rt.operator_graph.edges))

end

end
