let
    Source = (token as any) => let

//Get a list of models for a given projectId
GetMembers = (projectId as text) as list =>
let 
	members = RESTWPages("/v2/projects/" & projectId & "/members",token),
	membersWithProjectId = List.Transform(members, each Record.AddField(_,"projectId",projectId))
in
	membersWithProjectId,

//The main function starts here
projects = projectsList(token),

members = List.Combine(List.Transform(projects, each GetMembers(_[id])))

in
members
in
    Source