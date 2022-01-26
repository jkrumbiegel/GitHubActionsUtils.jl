using GitHubActionsUtils
using Test

using Luxor

@testset "GitHubActionsUtils.jl" begin

    # move up from the `test` folder to the main repo
    cd("..")

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
    @show GitHubActionsUtils.pull_request_number()
    @show GitHubActionsUtils.pull_request_source()
    @show GitHubActionsUtils.repository()

    if GitHubActionsUtils.is_pull_request()
        pr_number = GitHubActionsUtils.pull_request_number()

        image_branch_name = "pr$(pr_number)-test-images"

        GitHubActionsUtils.set_github_actions_bot_as_git_user()
        GitHubActionsUtils.switch_to_or_create_branch(image_branch_name; orphan = true)

        image_path = "image.png"
        @png juliacircles() 400 400 image_path

        run(`git add -A`)
        run(`git commit -m "create testimages"`)

        GitHubActionsUtils.push_git_branch(image_branch_name)

        commit_hash = chomp(read(`git rev-parse HEAD`, String))

        image_url = string(
            "https://raw.githubusercontent.com/",
            GitHubActionsUtils.repository(),
            "/",
            commit_hash,
            "/",
            image_path
        )

        GitHubActionsUtils.comment_on_pr(
            pr_number,
            """
            This comment is auto-generated from a CI run with version $VERSION.

            Here's an image:
            ![an image]($image_url)
            """
        )
    end
end
