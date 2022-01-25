using GitHubActionsUtils
using Test

@testset "GitHubActionsUtils.jl" begin
    @show GitHubActionsUtils.is_github_actions()
    @show GitHubActionsUtils.event_name()
    @show GitHubActionsUtils.is_push()
    @show GitHubActionsUtils.is_pull_request()
    @show GitHubActionsUtils.head_ref()
    @show GitHubActionsUtils.github_ref()
    @show GitHubActionsUtils.is_branch()
    @show GitHubActionsUtils.branch_name()
    @show GitHubActionsUtils.is_tag()
    @show GitHubActionsUtils.tag_name()
end
