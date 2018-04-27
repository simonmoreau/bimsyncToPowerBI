let
    //Get extension
    GetExtension = (name as text) as text =>
let
    lenght = Text.Length(name),
    position = Text.PositionOf(name, ".", Occurrence.Last),
    extension = if  (lenght - position = 4 or lenght - position = 5)  and position <> -1 then
                    Text.Lower(Text.Range(name,position,lenght-position))
                else
                    "folder"
in
    extension,

	//Get a list of documents for a given projectId and libraryId
	GetDocuments = (projectId as text, libraryId as text, token as text) as list =>
let 
	documents = RESTWPages("/v2/projects/" & projectId & "/libraries/" & libraryId & "/items",token),
	documentsWithProjectId = List.Transform(documents, each Record.AddField(_,"projectId",projectId)),
    documentsWithLibraryId = List.Transform(documentsWithProjectId, each Record.AddField(_,"libraryId",libraryId)),
    documentsWithExtension = List.Transform(documentsWithLibraryId, each Record.AddField(_,"Extension",GetExtension(_[name])))
in
	documentsWithExtension,

    //The main function starts here
    token = GetToken(),
    librariesList = LibrariesList(token),
    documents = List.Combine(List.Transform(librariesList, each GetDocuments(_[projectId],_[id],token))),
    initialTable = Table.FromList(documents , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    fields = Record.FieldNames(documents {0}),
    documentsTable = Table(initialTable,fields)
in
    documentsTable