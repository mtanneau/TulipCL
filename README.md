# TulipCL

App for building a command-line executable of the [Tulip.jl](https://github.com/ds4dm/Tulip.jl) interior-point solver.

## Installation instructions

1. Download and install Julia 1.3.1 or later.

1. Install `PackageCompiler`
    ```julia
    $ julia -q
    > using Pkg
    > Pkg.add("PackageCompiler")
    ```

1. Clone [this repository](https://github.com/mtanneau/TulipCL)
    ```bash
    git clone https://github.com/mtanneau/TulipCL
    ```
    You can also download it as a ZIP file.

1. Build the command-line executable
    ```julia
    $ julia -q --project
    julia> using PackageCompiler
    julia> create_app(".", "build", precompile_execution_file="src/snoop.jl", app_name="tulip_cl");
    julia> exit()
    ```
    The executable will be located at `build/bin/tulip_cl`.

    For more information on how to build the app, see [here](https://julialang.github.io/PackageCompiler.jl/dev/apps/).


## Running the command-line executable

Once the build step is performed, the executable can be called from the command line as follows:
```bash
tulip_cl [options] finst
```
where `finst` is the problem file. For instance,
```bash
tulip_cl --Threads 1 --TimeLimit 3600 afiro.mps
```
will solve the problem `afiro.mps` using one thread and up to 1 hour of computing time.

Currently, possible user options are

| Option name | Type | Default | Description |
|-------------|------|---------|-------------|
| `Presolve`  | `Int`     | `1`   | Set to `0` to disable presolve, `1` to activate it |
| `Threads`   | `Int`     | `1`   | Maximum number of threads |
| `TimeLimit` | `Float64` | `Inf` | Time limit, in seconds |

For more information, run `tulip_cl --help`, or look at Tulip's [documentation](https://ds4dm.github.io/Tulip.jl/stable/) for more details on parameters.

## Using a different version of Tulip

The `TulipCL` app contains a `Manifest.toml` that specifies the version of Tulip.
By default, the latest tagged release is used (if not, you may have compatibility restrictions).

To build the executable with a different version/branch of Tulip, simply edit the `Manifest.toml` (through Julia's `Pkg`) before building the executable.
For instance, to use the `master` branch of Tulip.jl:
```
$ julia -q --project
julia> ]
(TulipCL) pkg> add Tulip#master
```
then follw the installation steps above.