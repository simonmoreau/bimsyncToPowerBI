let
    Source = (token as text) => let
    projects = RESTWPages("/v2/projects",token)
in
    projects
in
    Source