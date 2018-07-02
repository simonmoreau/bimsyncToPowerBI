let


//The main function
//Everything start here
//Welcome
token = GetToken(),
Source = RESTWPages("/v2/projects/" & projectId & "/models",token),// Json.Document(GetText ),

initialTable = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Columns" = Table.RenameColumns(initialTable,{{"Column1", "Model"}}),
    #"Expanded Model" = Table.ExpandRecordColumn(#"Renamed Columns", "Model", {"id", "name"}, {"Model.id", "Model.name"})
in
    #"Expanded Model"