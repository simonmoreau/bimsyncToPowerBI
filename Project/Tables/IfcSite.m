let
    token = GetToken(),
    ifcType = "IfcSite",
    ifcElements = GetElements(projectId, ifcType , token ),
    result = if ifcElements = null or List.Count(ifcElements) = 0
	then
		null
	else
		GetTableFromIfcElements(ifcElements ),
    test = Table.AddColumn(result, "Test", each [Column1][attributes][RefLatitude][value]{0}[value])
in
    test