let
Source = (relativePath as text, token as text, PageCount as any) => let
	
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
				ManualStatusHandling={500}
			]
		),
		
		GetMetadata = Value.Metadata(GetJson),
		GetResponseStatus = GetMetadata[Response.Status],
		ResultJsontext = if GetResponseStatus=500 then "[]" else Text.FromBinary(GetJson),
		GetText = Text.Replace (ResultJsontext, """ifcType"":""IfcPropertySingleValue"",""ifcType"":""IfcPropertySingleValue"",","""ifcType"":""IfcPropertySingleValue""," ),
		Source = Json.Document(GetText )
	in  
		Source,

	//For now, page count is more intuitive than anything
	PageIndices = { 0 .. PageCount},
	Pages       = List.Transform(PageIndices, each GetPage(_)),
	Entities    = List.Union(Pages)

	in
	Entities
in
Source