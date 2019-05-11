using GeoStatsBase
using GeoStatsDevTools

"""Interpolate missing values in GeoArray."""
function interpolate!(ga::GeoArray, solver::T, band=1, symbol=:z) where T<:AbstractSolver
    # Irregular grid
    # TODO Use unstructured GeoStats method
    if is_rotated(ga)
        error("Can't interpolate warped grid yet.")

    # Regular grid
    else
        problemdata = RegularGridData(Dict(symbol=>ga.A[:,:,band]), Tuple(ga.f.translation), (ga.f.linear[1],ga.f.linear[4]))
        problemdomain = RegularGrid(size(z.A[:,:,band]), Tuple(ga.f.translation), (ga.f.linear[1],ga.f.linear[4]))
    end

    problem = EstimationProblem(problemdata, problemdomain, symbol, mapper=CopyMapper())
    solution = solve(problem, solver)

    mask = ismissing.(ga.A)
    ga.A[mask] .= solution[symbol][:mean][mask]
    ga
end
