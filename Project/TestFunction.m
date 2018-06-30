let
    		url = "https://api.bimsync.com",

		GetJson = Web.Contents
		(
			url,
			[
				Headers = 
				[
					#"Authorization"="Bearer " & "vZilKdwxN9BJhJBLEx7i4w",
					#"Content-Type"="application/json"
				],
				RelativePath = "/v2/projects/134c9142631f4b9c8cb905653f54e44b/ifc/products?ifcType=IfcSpace",
				Query = 
				[
					revision = "6d4f0c182ba343ee958ef0320eab47d6",
					page=Number.ToText(1),
					pageSize=Number.ToText(100)
				]
			]
		),

		JsonText = Text.FromBinary(GetJson),
		GetText1 = Text.Replace (Text.Replace (Text.Replace (JsonText," : " ,":")," :",":"),": ",":"),
		GetText2 = Text.Replace (GetText1, """ifcType"":""IfcPropertySingleValue"",""ifcType"":""IfcPropertySingleValue""","""ifcType"":""IfcPropertySingleValue""" ),
		GetText3 = Text.Replace (GetText2, """ifcType"":""IfcPropertyEnumeratedValue"",""ifcType"":""IfcPropertyEnumeratedValue""","""ifcType"":""IfcPropertyEnumeratedValue""" ),
		Source = Json.Document(GetText3 )
in
    Source