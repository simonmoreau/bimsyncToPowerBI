let
Source = (relativePath as text, token as text) => let
	
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
				RelativePath = relativePath
			]
		),

Source = Json.Document(GetJson )
in
Source
in
    Source