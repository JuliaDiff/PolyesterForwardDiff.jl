# PolyesterForwardDiff

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaSIMD.github.io/Polyester.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaSIMD.github.io/Polyester.jl/dev)
[![CI](https://github.com/JuliaSIMD/Polyester.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaSIMD/Polyester.jl/actions/workflows/CI.yml)
[![CI-Nightly](https://github.com/JuliaSIMD/Polyester.jl/actions/workflows/CI-julia-nightly.yml/badge.svg)](https://github.com/JuliaSIMD/Polyester.jl/actions/workflows/CI-julia-nightly.yml)
[![Coverage](https://codecov.io/gh/JuliaSIMD/Polyester.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaSIMD/Polyester.jl)


PolyesterForwardDiff.jl is a parallelized ForwardDiff.jl. That's it. It's super fast. See [this paper for some benchmark results](https://www.biorxiv.org/content/10.1101/2021.11.15.468697v1.abstract).

## Example calls

It's pretty much the same as ForwardDiff.jl except it is threaded. The API is the same for gradients and Jacobians.

```julia
PolyesterForwardDiff.threaded_gradient!(f, dx, x, ForwardDiff.Chunk(8));
PolyesterForwardDiff.threaded_jacobian!(g, dx, x, ForwardDiff.Chunk(8));
PolyesterForwardDiff.threaded_jacobian!(g!, y, dx, x, ForwardDiff.Chunk(8));
```
