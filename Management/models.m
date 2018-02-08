let

//A function to add a new column for every attributes in the ifcCategory  
    AddFields = (initialTable as table, fieldsNames as list) as table => 
let
                properties = List.Accumulate(fieldsNames, initialTable , 
        (state, current) => Table.AddColumn(state, current, each Record.FieldOrDefault([Column1],current)))
      in
          properties,


GetModels = (projectId as text) as list =>
let
url = "https://api.bimsync.com/v2/projects/" & projectId & "/models",
 // Uses the bimsync revision method to obtain a list of revisions
GetJson = Web.Contents(url,
     [
         Headers = [#"Authorization"="Bearer " & token,
                    #"Content-Type"="application/json"],
ManualStatusHandling={500}
     ]
 ),
GetMetadata = Value.Metadata(GetJson),
    GetResponseStatus = GetMetadata[Response.Status],
    Source = if GetResponseStatus=500 then Json.Document("[]") else Json.Document(GetJson),
	addProjectId = List.Transform(Source, each Record.AddField(_,"projectId",projectId))
in
addProjectId,

     url = "https://api.bimsync.com/v2/projects",
 // Uses the bimsync  oauth2/token method to obtain a bearer token
 GetJson = Web.Contents(url,
     [
         Headers = [#"Authorization"="Bearer " & token,
                    #"Content-Type"="application/json"]
     ]
 ),
Source = Json.Document(GetJson),
projectIdList = List.Transform(Source, each _[id]),

modelList = List.Combine(List.Transform(projectIdList, each GetModels(_))),

initialTable = Table.FromList(modelList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
fields = Record.FieldNames(modelList{0}),
projectsTable = AddFields(initialTable,fields)

in
projectsTable 