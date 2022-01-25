using GitHubActionsUtils
using Documenter

DocMeta.setdocmeta!(GitHubActionsUtils, :DocTestSetup, :(using GitHubActionsUtils); recursive=true)

makedocs(;
    modules=[GitHubActionsUtils],
    authors="Julius Krumbiegel <julius.krumbiegel@gmail.com> and contributors",
    repo="https://github.com/jkrumbiegel/GitHubActionsUtils.jl/blob/{commit}{path}#{line}",
    sitename="GitHubActionsUtils.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jkrumbiegel.github.io/GitHubActionsUtils.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jkrumbiegel/GitHubActionsUtils.jl",
    devbranch="main",
)
