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
# DualObjectiveValue is not implemented, so Ipopt does not pass the tests that
# query it.
# TODO: Consider implementing DualObjectiveValue for purely linear problems.
const config_no_duals = MOIT.TestConfig(atol=1e-4, rtol=1e-4, duals=false,
                                        optimal_status=MOI.LOCALLY_SOLVED)

MOI.empty!(optimizer)

@testset "MOI NLP tests" begin
    MOIT.nancb_test(optimizer, config)
end
