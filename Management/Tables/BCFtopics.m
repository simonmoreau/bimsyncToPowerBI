let
BCFToken = GetBCFToken(),
GetJson = BCFTopicsList(BCFToken),
initialTable = Table.FromList(GetJson , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
fields = Record.FieldNames(GetJson {0}),
projectsTable = Table(initialTable,fields)

in
    projectsTable