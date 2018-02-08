let
    Source = (projectId as text, IfcElement as text, token as text) as list  =>
	let
	
//Check if a revision is one of the two last one for its model
FilterRevision = (revision as record,revisions as list ) as logical => 
let
    revisionInModel = List.Select(revisions , each _[modelId] = revision[modelId]),
	revisionInModelSorted = List.Sort(revisionInModel, (x, y) => Value.Compare(y[createdAt], x[createdAt])),
	result = if List.Contains(List.FirstN(revisionInModelSorted,2), revision)
	then
		true
	else
		false
in
    result,

//Get the last revisions
    LastRevisions = (revisions as list) => 
let
    filteredRevisions = List.Select(revisions , each FilterRevision(_,revisions )) as list 
in
    filteredRevisions ,

//Get a list of elements for a given revision and add the revisionId
GetElementsOfARevision = (revision as record, projectId as text, IfcElement as text, token as text) as list => 
let
	Source = RESTFunction("/v2/projects/" & projectId & "/ifc/products?ifcType=" & IfcElement, revision[id],token),
	SourceWithId = List.Transform(Source, each Record.AddField (_, "revisionId", revision[id] ))
in
    SourceWithId,
	
//Get all the revisions
AllRevisions = (projectId as text, token as text) => 
let
    restquery = RESTWPages("/v2/projects/" & projectId & "/revisions",token),
	AddmodelId = List.Transform(restquery , each Record.AddField(_,"modelId",_[model][id])),
	AdduserId = List.Transform(AddmodelId , each Record.AddField(_,"userId",_[user][id])),
	removefields = List.Transform(AdduserId , each Record.RemoveFields(_,{"model","user"}))
in
    removefields,	

    token = GetToken(),
	allRevisions = AllRevisions(projectId,token),
	lastRevisions = LastRevisions (allRevisions),
    ifcElementsList = List.Combine(List.Transform(lastRevisions, each GetElementsOfARevision( _, projectId, IfcElement,token)))
in
    ifcElementsList
in
    Source