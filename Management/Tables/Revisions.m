let

//The main function starts here
token = GetToken(),
projects = projectsList(token),

revisions  = List.Combine(List.Transform(projects, each revisionsList (_[id],token))),
revisionsTable = Table.FromList(revisions, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
expandedTable = Table.ExpandRecordColumn(revisionsTable, "Column1", {"id", "comment", "version", "createdAt", "projectId", "userId", "modelId"}, {"id", "comment", "version", "createdAt", "projectId", "userId", "modelId"}),
addTypes = Table.TransformColumnTypes(expandedTable,{{"createdAt", type datetime}})
in
addTypes