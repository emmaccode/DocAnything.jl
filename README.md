<div align="center">

###### doc anything!

</div>

Build a quick, searchable documentation browser for any module in Julia!
###### step 1: add this package.
```julia
julia> using Pkg; Pkg.add(url = "https://github.com/emmettgb/DocAnything.jl")

julia> ]

pkg> add https://github.com/emmettgb/DocAnything.jl
```
###### step 2: import and start
```julia
julia> using DocAnything

julia> DocAnything.start()
```
###### step 3: load documentation
You can load a given module's documentation using the `load_doc!(::Module)` method. This will be exported by `DocAnything` whenever you use the package.
```julia
julia> using Toolips

julia> load_doc!(Toolips)
Toolips
```
###### step 4: visit your documentation!
