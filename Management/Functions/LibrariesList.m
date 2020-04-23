let
    Source = (token as any) => let

    //Get a list of libraries for a given projectId
    GetLibraries = (projectId as text) as list =>
    let 
        libraries = RESTWPages("/v2/projects/" & projectId & "/libraries",token),
        // Filter only document library
        documentLibraries = List.Select(libraries, each Record.Field(_,"type") = "document"),
        librariesWithProjectId = List.Transform(documentLibraries, each Record.AddField(_,"projectId",projectId))
    in
        librariesWithProjectId,

    //The main function starts here
    projects = projectsList(token),
    libraries = List.Combine(List.Transform(projects, each GetLibraries(_[id])))
in
    libraries
in
    Source