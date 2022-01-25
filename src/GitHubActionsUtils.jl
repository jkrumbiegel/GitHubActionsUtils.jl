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
is_branch() = something(get_env("GITHUB_REF_TYPE")) == "branch"
branch_name() = is_branch() ? match(r"^refs/heads/(.*)", github_ref())[1] : nothing
is_tag() = something(get_env("GITHUB_REF_TYPE")) == "tag"
tag_name() = is_tag() ? match(r"^refs/tags/(.*)", github_ref())[1] : nothing

end
