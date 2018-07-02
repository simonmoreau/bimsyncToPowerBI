let

//Get a list of GetElementSummary for a given revisionId and projectId
GetElementsFromProject = (projectId as text,token as text) as list =>
let 
    ifcType = "IfcColumn",
    ifcElements = GetElements(projectId, ifcType , token ),
    result = if ifcElements = null or List.Count(ifcElements) = 0
	then
		null
	else
		ifcElements
in
	result,

//The main function starts here
token = GetToken(),
ifcElements = List.Combine(List.Transform(projectsList(token), each GetElementsFromProject(_[id],token))),

elementTable = GetTableFromIfcElements(ifcElements)

in
elementTable