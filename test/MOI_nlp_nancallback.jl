using MathOptInterface
const MOI = MathOptInterface
const MOIT = MOI.Test
using Ipopt
using Test

# Without fixed_variable_treatment set, duals are not computed for variables
# that have lower_bound == upper_bound.
const optimizer = Ipopt.Optimizer()

MOI.set(optimizer, MOI.RawParameter("print_level"), 0)
MOI.set(optimizer, MOI.RawParameter("fixed_variable_treatment"),
        "make_constraint")

const config = MOIT.TestConfig(atol=1e-4, rtol=1e-4,
                               optimal_status=MOI.LOCALLY_SOLVED)

const config_INF = MOIT.TestConfig(atol=1e-4, rtol=1e-4,
                               optimal_status=MOI.NORM_LIMIT)


MOI.empty!(optimizer)

# Test doesn't work ATM
#   MathOptInterface.UnsupportedAttribute{MathOptInterface.VariableName}: Attribute MathOptInterface.VariableName() is not supported by the model.
#@testset "MOI NLP test max x" begin
#    MOIT.max_x_is_inf(optimizer, config)
#end

# passes
@testset "MOI NLP test max_x_is_inf" begin
    MOIT.nancb_test(optimizer, config_INF)
end
