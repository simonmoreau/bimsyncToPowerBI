let
    Source = () => let
	url = "https://bimsyncmanagerapi.azurewebsites.net",

	GetJson = Web.Contents
	(
		url,
		[
			Query=[PBCode=PowerBISecret],
			ManualStatusHandling={500},
                        RelativePath = "/api/users/powerbi"
		]
                
	),
	
	GetMetadata = Value.Metadata(GetJson),
	GetResponseStatus = GetMetadata[Response.Status],
	ResultText = if GetResponseStatus=500 then "[]" else Text.FromBinary(GetJson),
	token = Text.Remove(ResultText,"""")
in  
	token
in
    Source