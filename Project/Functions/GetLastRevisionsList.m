let
    Source = (revisionsList as list) => let

//Check if a revision is one of the two last one for its model
FilterRevision = (revision as record,revisionsList as list ) as logical => 
let
    revisionInModel = List.Select(revisionsList, each _[modelId] = revision[modelId]),
	revisionInModelSorted = List.Sort(revisionInModel, (x, y) => Value.Compare(y[createdAt], x[createdAt])),
	result = if List.Contains(List.FirstN(revisionInModelSorted,3), revision)
	then
		true
	else
		false
in
    result,

    revisions = List.Select(revisionsList , each FilterRevision(_,RevisionsList)) as list 
in
    revisions
in
    Source