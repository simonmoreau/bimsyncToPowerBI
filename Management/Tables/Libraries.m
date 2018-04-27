let
    token = GetToken(),
    GetJson = LibrariesList(token),
    initialTable = Table.FromList(GetJson , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    fields = Record.FieldNames(GetJson {0}),
    projectsTable = Table(initialTable,fields)
in
    projectsTable