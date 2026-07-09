module MethodTheory

############################################################
# CORE MODULES
############################################################

include("AGD/Types.jl")
include("AGD/Metric.jl")
include("AGD/Constitution.jl")
include("AGD/Quotients.jl")
include("AGD/QuotientAtlas.jl")
include("AGD/OperatorGraph.jl")
include("AGD/OperatorAtlas.jl")
include("AGD/Governor.jl")
include("AGD/Learning.jl")
include("AGD/Persistence.jl")
include("AGD/Runtime.jl")

############################################################
# IMPORTS
############################################################

using .Types
using .Metric
using .Constitution
using .Quotients
using .QuotientAtlas
using .OperatorGraph
using .OperatorAtlas
using .Governor
using .Learning
using .Persistence
using .Runtime

############################################################
# EXPORT MODULES
############################################################

export Types
export Metric
export Constitution
export Quotients
export QuotientAtlas
export OperatorGraph
export OperatorAtlas
export Governor
export Learning
export Persistence
export Runtime

############################################################
# VERSION
############################################################

const AGD_VERSION = v"0.1.0"

export AGD_VERSION

end
