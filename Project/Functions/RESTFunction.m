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

		JsonText = Text.FromBinary(GetJson),
		GetText1 = Text.Replace (Text.Replace (Text.Replace (JsonText," : " ,":")," :",":"),": ",":"),
		GetText2 = Text.Replace (GetText1, """ifcType"":""IfcPropertySingleValue"",""ifcType"":""IfcPropertySingleValue""","""ifcType"":""IfcPropertySingleValue""" ),
		GetText3 = Text.Replace (GetText2, """ifcType"":""IfcPropertyEnumeratedValue"",""ifcType"":""IfcPropertyEnumeratedValue""","""ifcType"":""IfcPropertyEnumeratedValue""" ),
		Source = Json.Document(GetText3 )
	in  
		Source,
		
	//Get the page number for a given ressource
	GetItemCount = () as number =>
	let
		url = "https://bimsyncmanagerapi.azurewebsites.net",

		GetJson = Web.Contents
		(
			url,
			[
				Query = 
				[
					ressource=relativePath,
					revision=revisionId,
                    PBCode=PowerBISecret
				],
				RelativePath = "/api/users/pages"
			]
		),

		text = Text.FromBinary(GetJson),
		Source = Number.FromText(Text.Remove(text,""""))
	in  
		Source,

	//Get Page count
	ItemCount = GetItemCount(),
	PageCount = Number.RoundUp(ItemCount/1000),
	PageIndices = { 1 .. PageCount},
	
	Entities = if ItemCount > 0
	then
		 List.Union(List.Transform(PageIndices, each GetPage(_)))
	else
		{}

	in
	Entities
in
Source