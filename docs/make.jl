using PolyesterForwardDiff
using Documenter

DocMeta.setdocmeta!(Polyester, :DocTestSetup, :(using PolyesterForwardDiff); recursive=true)

makedocs(;
    modules=[PolyesterForwardDiff],
    authors="Chris Elrod <elrodc@gmail.com> and contributors",
    repo="https://github.com/JuliaSIMD/PolyesterForwardDiff.jl/blob/{commit}{path}#{line}",
    sitename="PolyesterForwardDiff.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaSIMD.github.io/PolyesterForwardDiff.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaSIMD/PolyesterForwardDiff.jl",
)
