let
initialTable = Table.FromList(RevisionsList , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
expandedTable = Table.ExpandRecordColumn(initialTable, "Column1", {"id", "comment", "version", "createdAt", "modelId", "userId"}, {"id", "comment", "version", "createdAt", "modelId", "userId"}),
typeTable = Table.TransformColumnTypes(expandedTable,{{"createdAt", type datetime}})
in
typeTable