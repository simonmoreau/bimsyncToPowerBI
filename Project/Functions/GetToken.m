let
    Source = () => let
	url = "https://binsyncfunction.azurewebsites.net/api/manager/users/",

	GetJson = Web.Contents
	(
		url,
		[
			ManualStatusHandling={500},
                        RelativePath = PowerBISecret
		]
                
	),
	
	GetMetadata = Value.Metadata(GetJson),
	GetResponseStatus = GetMetadata[Response.Status],
	ResultText = if GetResponseStatus=500 then "[]" else Text.FromBinary(GetJson),
	user = Json.Document(GetJson),
	token = user[AccessToken][access_token]
in  
	token
in
    Source