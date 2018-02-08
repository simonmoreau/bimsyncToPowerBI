let

//Get a list of models for a given projectId
GetModels = (projectId as text, token as text) as list =>
let 
	models = RESTWPages("/v2/projects/" & projectId & "/models",token,1),
	modelsWithProjectId = List.Transform(models, each Record.AddField(_,"projectId",projectId))
in
	modelsWithProjectId,

//The main function starts here
token = GetToken(),
projects = projectsList(token),

models = List.Combine(List.Transform(projects, each GetModels(_[id],token))),
modelTable = Table.FromList(models, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
expandedTable = Table.ExpandRecordColumn(modelTable, "Column1", {"id", "name", "projectId"}, {"id", "name", "projectId"})

in
expandedTable