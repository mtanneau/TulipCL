module TulipCL

using Printf

import Tulip
const TLP = Tulip

using ArgParse

function julia_main()::Cint

    try
        tulip_cl()
    catch
        Base.invokelatest(Base.display_error, Base.catch_stack())
        return 1
    end
    return 0
end

function parse_commandline(cl_args)

    s = ArgParseSettings()

    @add_arg_table! s begin
        "--TimeLimit"
            help = "Time limit, in seconds."
            arg_type = Float64
            default = Inf
        "--BarrierIterationsLimit"
            help = "Maximum number of iterations"
            arg_type = Int
            default = 100
        "--Threads"
            help = "Maximum number of threads."
            arg_type = Int
            default = 1
        "--Presolve"
            help = "Presolve level"
            arg_type = Int
            default = 1
        "finst"
            help = "Name of instance file. Only Free MPS format is supported."
            required = true
    end

    return parse_args(cl_args, s)
end

function tulip_cl()
    parsed_args = parse_commandline(ARGS)

    # Read model and solve
    finst = parsed_args["finst"]

    m = TLP.Model{Float64}()
    t = @elapsed TLP.load_problem!(m, finst)

    println("Julia version: ", VERSION)
    println("Problem file : ", finst)
    @printf "Reading time : %.2fs\n\n" t

    # Set parameters
    m.params.OutputLevel = 1
    m.params.TimeLimit = parsed_args["TimeLimit"]
    m.params.Threads = parsed_args["Threads"]
    m.params.Presolve = parsed_args["Presolve"]
    m.params.BarrierIterationsLimit = parsed_args["BarrierIterationsLimit"]

    Tulip.LinearAlgebra.BLAS.set_num_threads(m.params.Threads)

    TLP.optimize!(m)

    return nothing
end

# Run if called directly
if abspath(PROGRAM_FILE) == @__FILE__
    tulip_cl()
end

end # module
