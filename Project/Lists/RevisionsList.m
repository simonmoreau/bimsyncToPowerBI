let

token = GetToken(),
Source = RESTWPages("/v2/projects/" & projectId & "/revisions",token),
AddmodelId = List.Transform(Source, each Record.AddField(_,"modelId",_[model][id])),
AdduserId = List.Transform(AddmodelId , each Record.AddField(_,"userId",_[user][id])),
removefields = List.Transform(AdduserId , each Record.RemoveFields(_,{"model","user"}))
in
removefields