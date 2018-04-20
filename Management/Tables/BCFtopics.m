let
IssueBoardList = BCFIssueBoardList(BCFToken),

topicsList = List.Combine(List.Transform(IssueBoardList, each BCFREST("/bcf/beta/projects/" & _[project_id] &"/topics",BCFToken))),
initialTable = Table.FromList(topicsList , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
fields = Record.FieldNames(topicsList {0}),
projectsTable = Table(initialTable,fields)
in
    projectsTable