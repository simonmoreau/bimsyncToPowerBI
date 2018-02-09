let
    Source = (projectId as text, token as text) as list =>
let 
	revisions = RESTWPages("/v2/projects/" & projectId & "/revisions",token),
	revisionsWithProjectId = List.Transform(revisions, each Record.AddField(_,"projectId",projectId)),
	revisionWithUserId = List.Transform(revisionsWithProjectId, each Record.AddField(_,"userId",_[user][id])),
	revisionWithModelId = List.Transform(revisionWithUserId, each Record.AddField(_,"modelId",_[model][id])),
	revisionWithoutFiedls = List.Transform(revisionWithModelId, each Record.RemoveFields(_,{"model","user"}))
in
	revisionWithoutFiedls
in
    Source