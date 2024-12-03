using ReversedSeries
using Documenter

DocMeta.setdocmeta!(ReversedSeries, :DocTestSetup, :(using ReversedSeries); recursive=true)

makedocs(;
    modules=[ReversedSeries],
    authors="gg <gg@nowhere> and contributors",
    sitename="ReversedSeries.jl",
    format=Documenter.HTML(;
        canonical="https://g-gundam.github.io/ReversedSeries.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/g-gundam/ReversedSeries.jl",
    devbranch="main",
)
