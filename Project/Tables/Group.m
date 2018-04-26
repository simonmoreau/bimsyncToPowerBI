let
//A function to add a new column for every attributes in the ifcCategory  
    AddFields = (initialTable as table, fieldsNames as list) as table => 
let
        properties = List.Accumulate(fieldsNames, initialTable , 
        (state, current) => Table.AddColumn(state, current, each Record.FieldOrDefault([Column1],current)))
in
          properties,
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

//Get all the revisions
AllRevisions = (projectId as text, token as text) => 
let
    restquery = RESTWPages("/v2/projects/" & projectId & "/revisions",token),
	AddmodelId = List.Transform(restquery , each Record.AddField(_,"modelId",_[model][id])),
	AdduserId = List.Transform(AddmodelId , each Record.AddField(_,"userId",_[user][id])),
	removefields = List.Transform(AdduserId , each Record.RemoveFields(_,{"model","user"}))
in
    removefields,

//The request to retrieve a page of groups
token = GetToken(),
revisionsList = LastRevisions(AllRevisions(projectId ,token )),
Entities    = List.Combine(List.Transform(revisionsList, each RESTFunction("/v2/projects/" & projectId & "/ifc/groups", _[id],token))),
Table       = Table.FromList(Entities, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
Fields      = Record.FieldNames(Entities{0}),
FinalTable  = AddFields(Table,Fields),
ExpandedTable = Table.ExpandRecordColumn(FinalTable, "attributes", {"GlobalId", "Name", "Description"}, {"attributes.GlobalId", "attributes.Name", "attributes.Description"}),
    #"Expanded attributes.GlobalId" = Table.ExpandRecordColumn(ExpandedTable, "attributes.GlobalId", {"value"}, {"attributes.GlobalId.value"}),
    #"Expanded attributes.Name" = Table.ExpandRecordColumn(#"Expanded attributes.GlobalId", "attributes.Name", {"value"}, {"attributes.Name.value"}),
    #"Expanded attributes.Description" = Table.ExpandRecordColumn(#"Expanded attributes.Name", "attributes.Description", {"value"}, {"attributes.Description.value"})
in
#"Expanded attributes.Description"