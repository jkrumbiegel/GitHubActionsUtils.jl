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

is_git_branch(branch) = success(`git show-ref refs/heads/$branch`)

function make_or_switch_to_orphan_branch(branch)
    if is_git_branch(branch)
        run(`git switch $branch`)
    else
        run(`git switch --orphan -c $branch`)
    end
end

end
