# TulipCL

App for building a command-line executable of the [Tulip.jl](https://github.com/ds4dm/Tulip.jl) interior-point solver.

## Installation instructions

1. Download and install Julia (version 1.3.1 or newer).

1. Install `PackageCompiler`
    ```bash
    $ julia -e 'using Pkg; Pkg.add("PackageCompiler")'
    ```

1. Clone [this repository](https://github.com/mtanneau/TulipCL) (you can also download it as a ZIP file) and ensure all Julia packages are installed
    ```bash
    $ git clone https://github.com/mtanneau/TulipCL
    $ cd TulipCL
    $ julia --project -e 'using Pkg; Pkg.instantiate()'
    ```

1. Generate precompilation statements
    ```bash
    julia --project --trace-compile=src/precompile.jl src/snoop.jl
    ```

1. Build the command-line executable
    ```julia
    $ julia -q --project
    julia> using PackageCompiler
    julia> create_app(".", "build", force=true, precompile_statements_file="src/precompile.jl", app_name="tulip_cl");
    julia> exit()
    ```
    The executable will be located at `build/bin/tulip_cl`.

    For more information on how to build the app, see [here](https://julialang.github.io/PackageCompiler.jl/dev/apps/).

### Using a different version of Tulip

The `TulipCL` app contains a `Manifest.toml` that specifies the version of Tulip.

To build the executable with a different version/branch of Tulip follow these instructions:

1. Checkout the version/branch of Tulip you want to use, via Julia's `Pkg`.
    * To ensure you're using the latest version:
        ```bash
        julia -e --project 'using Pkg; Pkg.update(); Pkg.instantiate();'
        ```
    * To install a specific branch/version:
        ```
        $ julia -q --project
        julia> ]
        (TulipCL) pkg> add Tulip#master
        ```

3. Follow Steps 4-5 of the installation guide above.

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
| `IterationsLimit` | `Int` | `500` | Maximum number of barrier iterations |
| `Method` | `String` | `HSD` | Interior-point method |

For more information, run `tulip_cl --help`, or look at Tulip's [documentation](https://ds4dm.github.io/Tulip.jl/stable/) for more details on parameters.