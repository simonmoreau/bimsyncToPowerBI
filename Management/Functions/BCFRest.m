let
Source = (relativePath as text, bcfToken as text) => let
	
		url = "https://bcf.bimsync.com",

		GetJson = Web.Contents
		(
			url,
			[
				Headers = 
				[
					#"Authorization"="Bearer " & bcfToken,
					#"Content-Type"="application/json"
				],
				RelativePath = relativePath,
				ManualStatusHandling={500}
			]
		),
		GetMetadata = Value.Metadata(GetJson),
		GetResponseStatus = GetMetadata[Response.Status],
		ResultJsontext = if GetResponseStatus=500 then "[]" else Text.FromBinary(GetJson),
		Source = Json.Document(ResultJsontext )
in
Source
in
    Source