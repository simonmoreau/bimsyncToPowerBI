let
Source = (relativePath as text, revisionId as text, token as text) => let
	
	//A single call to the bimsync API
	GetPage = (Index) =>
	let
		url = "https://api.bimsync.com",

		GetJson = Web.Contents
		(
			url,
			[
				Headers = 
				[
					#"Authorization"="Bearer " & token,
					#"Content-Type"="application/json"
				],
				RelativePath = relativePath,
				Query = 
				[
					revision = revisionId,
					page=Number.ToText(Index),
					pageSize=Number.ToText(1000)
				]
			]
		),

		GetText = Text.Replace (Text.FromBinary(GetJson), """ifcType"":""IfcPropertySingleValue"",""ifcType"":""IfcPropertySingleValue"",","""ifcType"":""IfcPropertySingleValue""," ),
		Source = Json.Document(GetText )
	in  
		Source,
		
	//Get the page number for a given ressource
	GetItemCount = () as number =>
	let
		url = "https://bimsyncmanagerapi.azurewebsites.net/api/users/pages",

		GetJson = Web.Contents
		(
			url,
			[
				Query = 
				[
					ressource=relativePath,
					revision=revisionId,
                                        PBCode=PowerBISecret
				]
			]
		),

		text = Text.FromBinary(GetJson),
		Source = Number.FromText(Text.Remove(text,""""))
	in  
		Source,

	//Get Page count
	ItemCount = GetItemCount(),
	PageCount = Number.Round(ItemCount/1000, 0, 0),
	PageIndices = { 0 .. PageCount},
	
	Entities = if ItemCount > 0
	then
		 List.Union(List.Transform(PageIndices, each GetPage(_)))
	else
		{}

	in
	Entities
in
Source