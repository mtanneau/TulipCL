module TulipCL

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
        "--Threads"
            help = "Maximum number of threads."
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

    println("Julia version: ", VERSION)

    # Read model and solve
    finst = parsed_args["finst"]

    m = TLP.Model{Float64}()
    println(finst)
    t = @elapsed TLP.loadproblem!(m, finst)
    println("Reading time (s): $t")

    # Set parameters
    m.env.verbose = true
    m.env.time_limit = parsed_args["TimeLimit"]
    m.env.threads = parsed_args["Threads"]

    println("\n$(m.name)")

    TLP.optimize!(m)

    return nothing
end

# Run if called directly
if abspath(PROGRAM_FILE) == @__FILE__
    tulip_cl()
end

end # module
