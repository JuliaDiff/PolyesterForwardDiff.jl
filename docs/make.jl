using PolyesterForwardDiff
using Documenter

DocMeta.setdocmeta!(PolyesterForwardDiff, :DocTestSetup,
    :(using PolyesterForwardDiff); recursive=true)

makedocs(;
    modules=[PolyesterForwardDiff],
    authors="Chris Elrod <elrodc@gmail.com> and contributors",
    repo="https://github.com/JuliaDiff/PolyesterForwardDiff.jl/blob/{commit}{path}#{line}",
    sitename="PolyesterForwardDiff.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://juliadiff.org/PolyesterForwardDiff.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaDiff/PolyesterForwardDiff.jl",
)
