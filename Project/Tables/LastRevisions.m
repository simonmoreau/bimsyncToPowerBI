let

//Check if a revision is one of the two last one for its model
FilterRevision = (revision as record,revisionsList as list ) as logical => 
let
    revisionInModel = List.Select(revisionsList, each _[modelId] = revision[modelId]),
	revisionInModelSorted = List.Sort(revisionInModel, (x, y) => Value.Compare(y[createdAt], x[createdAt])),
	result = if List.Contains(List.FirstN(revisionInModelSorted,NumberOfRevisions), revision)
	then
		true
	else
		false
in
    result,

LastRevisionsList = List.Select(RevisionsList, each FilterRevision(_,RevisionsList)),
initialTable = Table.FromList(LastRevisionsList , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
expandedTable = Table.ExpandRecordColumn(initialTable, "Column1", {"id", "comment", "version", "createdAt", "modelId", "userId"}, {"id", "comment", "version", "createdAt", "modelId", "userId"}),
typeTable = Table.TransformColumnTypes(expandedTable,{{"createdAt", type datetime}})
in
typeTable