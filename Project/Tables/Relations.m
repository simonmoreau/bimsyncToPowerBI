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

//Get a list of elements for a given revision and add the revisionId
GetElementsOfARevision = (revision as record, projectId as text, token as text) as list => 
let
	Source = RESTFunction("/v2/projects/" & projectId & "/ifc/products/relations", revision[id],token),
	SourceWithId = List.Transform(Source, each Record.AddField (_, "revisionId", revision[id] ))
in
    SourceWithId,
	
//The request to retrieve a page of relationshiop
token = GetToken(),
revisionsList = LastRevisions(AllRevisions(projectId ,token )),
Entities    = List.Combine(List.Transform(revisionsList, each GetElementsOfARevision(_,projectId,token))),
Table       = Table.FromList(Entities, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
Fields      = Record.FieldNames(Entities{0}),
FinalTable  = AddFields(Table,Fields),
ExpandedParent = Table.ExpandRecordColumn(FinalTable, "parent", {"url", "objectId", "name", "ifcType"}, {"parent.url", "parent.objectId", "parent.name", "parent.ifcType"}),
ExtractedValues = Table.TransformColumns(ExpandedParent, {"zones", each if List.Count(_) <> 0 then _{0} else null}),
Expandedzones = Table.ExpandRecordColumn(ExtractedValues, "zones", {"url", "objectId", "name", "ifcType"}, {"zones.url", "zones.objectId", "zones.name", "zones.ifcType"}),
ExtractedGroupsValues = Table.TransformColumns(Expandedzones, {"groups", each if List.Count(_) <> 0 then _{0} else null}),
ExpandedGroups = Table.ExpandRecordColumn(ExtractedGroupsValues, "groups", {"url", "objectId", "name", "ifcType"}, {"groups.url", "groups.objectId", "groups.name", "groups.ifcType"})
in
ExpandedGroups