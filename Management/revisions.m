let

//Get a list of models for a given projectId
GetRevisions = (projectId as text, token as text) as list =>
let 
	revisions = RESTWPages("/v2/projects/" & projectId & "/revisions",token,1),
	revisionsWithProjectId = List.Transform(revisions, each Record.AddField(_,"projectId",projectId)),
	revisionWithUserId = List.Transform(revisionsWithProjectId, each Record.AddField(_,"userId",_[user][id])),
	revisionWithModelId = List.Transform(revisionWithUserId, each Record.AddField(_,"modelId",_[model][id])),
	revisionWithoutFiedls = List.Transform(revisionWithModelId, each Record.RemoveFields(_,{"model","user"}))
in
	revisionWithoutFiedls,

//The main function starts here
projects = projectsList(),

token = RefreshingToken();
revisions  = List.Combine(List.Transform(projects, each GetRevisions (_[id],token))),
revisionsTable = Table.FromList(revisions, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
expandedTable = Table.ExpandRecordColumn(revisionsTable, "Column1", {"id", "comment", "version", "createdAt", "projectId", "userId", "modelId"}, {"id", "comment", "version", "createdAt", "projectId", "userId", "modelId"}),
addTypes = Table.TransformColumnTypes(expandedTable,{{"createdAt", type datetime}})
in
addTypes