let
BCFToken = GetBCFToken(),
GetJson = BCFTopicsList(BCFToken),
initialTable = Table.FromList(GetJson , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
fields = Record.FieldNames(GetJson {0}),
projectsTable = Table(initialTable,fields),
projectsTableWithDates = Table.TransformColumnTypes(projectsTable,{{"creation_date", type datetimezone}, {"modified_date", type datetimezone}}),
projectsTableWithLabels = Table.TransformColumns(projectsTableWithDates, {"labels", each Text.Combine(List.Transform(_, Text.From), ";"), type text})
in
projectsTableWithLabels