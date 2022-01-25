module GitHubActionsUtils

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
end
