let
	url = "https://helloworldfrombim42.azurewebsites.net/api/bimsyncRefresh",

	GetJson = Web.Contents
	(
		url,
		[
			Query=[refresh="yes"],
			ManualStatusHandling={500}
		]
	),
	
	GetMetadata = Value.Metadata(GetJson),
	GetResponseStatus = GetMetadata[Response.Status],
	ResultText = if GetResponseStatus=500 then "[]" else Text.FromBinary(GetJson),
	token = Text.Remove(ResultText,"""")
in  
	token