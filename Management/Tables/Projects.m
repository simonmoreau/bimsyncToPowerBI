let

//The main function
//Everything start here
//Welcome
token = GetToken(),
projectsList = projectsList(token),
projectsInitialTable = Table.FromList(projectsList , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
projectsTable = Table.ExpandRecordColumn(projectsInitialTable, "Column1", {"id", "name", "description", "createdAt", "updatedAt"}, {"id", "name", "description", "createdAt", "updatedAt"}),
    #"Changed Type" = Table.TransformColumnTypes(projectsTable,{{"createdAt", type datetime}, {"updatedAt", type datetime}})
in
#"Changed Type"