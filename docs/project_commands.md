# Creating a project

Follow the steps below to create a new julia project

```
julia> using Pkg
julia> Pkg.activate("MyAPIProject")
julia> Pkg.add("HTTP")
julia> Pkg.add("JSON")
```

# View installed packages

```
julia> ]
(@v1.10) pkg>  status

```