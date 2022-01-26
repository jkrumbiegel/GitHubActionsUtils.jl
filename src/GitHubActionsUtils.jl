module GitHubActionsUtils

import GitHub

function get_env(x)
    get(ENV, x, nothing)
end

is_github_actions() = get_env("CI") == "true" && get_env("GITHUB_ACTIONS") == "true"
event_name() = something(get_env("GITHUB_EVENT_NAME"))
is_push() = event_name() == "push"
is_pull_request() = event_name() == "pull_request"
head_ref() = something(get_env("GITHUB_HEAD_REF"))
github_ref() = something(get_env("GITHUB_REF"))
is_branch() = match(r"^refs/heads/(.*)", github_ref()) !== nothing
branch_name() = is_branch() ? match(r"^refs/heads/(.*)", github_ref())[1] : nothing
is_tag() = match(r"^refs/tags/(.*)", github_ref()) !== nothing
tag_name() = is_tag() ? match(r"^refs/tags/(.*)", github_ref())[1] : nothing
pull_request_number() = is_pull_request() ? parse(Int, match(r"^refs/pull/(\d+)/.*", github_ref())[1]) : nothing
pull_request_source() = is_pull_request() ? head_ref() : nothing
repository() = something(get_env("GITHUB_REPOSITORY"))

const _auth = Ref{Any}()

function auth()
    if !isassigned(_auth)
        _auth[] = GitHub.authenticate(ENV["GITHUB_TOKEN"])
    end
    return _auth[]
end

function comment_on_pr(pr_id, comment)
    GitHub.create_comment(repository(), pr_id; auth = auth(), params = :body => comment)
end

is_local_git_branch(branch) = success(`git show-ref refs/heads/$branch`)

function switch_to_or_create_branch(branch; orphan = false)
    if is_local_git_branch(branch)
        run(`git switch $branch`)
    else
        if orphan
            run(`git switch --orphan $branch`)
        else
            run(`git switch -c $branch`)
        end
    end
end

push_git_branch(branch; remote = "origin") = run(`git push $remote $branch`)

function set_github_actions_bot_as_git_user()
    bot_address = "41898282+github-actions[bot]@users.noreply.github.com"
    run(`git config --local user.email $bot_address`)
    run(`git config --local user.name "github-actions"`)
end

end
