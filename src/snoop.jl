import TulipCL

FDIR = joinpath(dirname(pathof(TulipCL.Tulip)), "../examples/dat")

# Run all example problems
for finst in readdir(FDIR)
    empty!(ARGS)
    append!(ARGS, ["--Threads", "1", "--TimeLimit", "10.0", "--Presolve", "1", joinpath(FDIR, finst)])
    TulipCL.julia_main()
end