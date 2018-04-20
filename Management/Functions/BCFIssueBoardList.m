let
    Source = (token as text) => let
    projects = BCFREST("/bcf/beta/projects",token)
in
    projects
in
    Source