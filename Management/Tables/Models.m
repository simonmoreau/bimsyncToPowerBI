let

	//Get a list of models for a given projectId
	GetModels = (projectId as text, token as text) as list =>
let 
	models = RESTWPages("/v2/projects/" & projectId & "/models",token),
	modelsWithProjectId = List.Transform(models, each Record.AddField(_,"projectId",projectId))
in
	modelsWithProjectId,

//The main function starts here
token = GetToken(),
projectsList = projectsList(token),

models = List.Combine(List.Transform(projectsList, each GetModels(_[id],token))),
modelsInitialTable = Table.FromList(models, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
modelsTable = Table.ExpandRecordColumn(modelsInitialTable, "Column1", {"id", "name", "projectId"}, {"id", "name", "projectId"})

in
modelsTable