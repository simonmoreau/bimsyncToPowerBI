let
	token = GetToken(),
    Source = projectsList(token),
    table = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expandedtable = Table.ExpandRecordColumn(table, "Column1", {"id", "name", "description", "createdAt", "updatedAt"}, {"id", "name", "description", "createdAt", "updatedAt"}),
	addTypes = Table.TransformColumnTypes(expandedtable,{{"createdAt", type datetime},{"updatedAt", type datetime}})
in
    addTypes