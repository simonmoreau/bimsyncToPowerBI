let
    Source = (elements as list) => let

//A function to get an value from an arbitrary path of 6 fields
GetValue = (baseRecord as record, field1 as text, field2 as text, field3 as text, field4 as text, field5 as text, field6 as text) as any => 
let
    value =
		Record.FieldOrDefault(
			Record.FieldOrDefault(
				Record.FieldOrDefault
				(
					Record.FieldOrDefault
					(
						Record.FieldOrDefault
						(
						   Record.FieldOrDefault(baseRecord,field1),
						   field2
						),
						field3
					),
					field4
				),
				field5
			),
		field6	
		)
in
    value,

//A function to get an value from an arbitrary path of 3 fields
GetValue3 = (baseRecord as record, field1 as text, field2 as text, field3 as text) as any => 
let
	defaultField = [],
    value =
		Record.FieldOrDefault
		(
			Record.FieldOrDefault
			(
			   Record.FieldOrDefault(baseRecord,field1,Record.AddField(defaultField,field2,[])),
			   field2,Record.AddField(defaultField,field3,[])
			),
			field3
		)
in
    value,

//A function to get an value from an arbitrary path of 2 fields
GetValue2 = (baseRecord as record, field1 as text, field2 as text) as any => 
let
	defaultField = [],
    value =
		Record.FieldOrDefault
		(
		   Record.FieldOrDefault(baseRecord,field1,Record.AddField(defaultField,field2,[])),
		   field2
		)
in
    value,

//A function to generate a list of record based on a list of paths
PathList = (field1Name as text, field2Names as list, field3Name as text, field4Names as list, field5Name as text, field6Name as text) as list =>
let
	field2NamesCount = List.Count(field2Names),
	field4NamesCount = List.Count(field4Names),
	
	list = List.Generate(
	  ()=>[i=0, j=0],
	  each [i] < field2NamesCount,
	  each
	   if [j] < field4NamesCount - 1 then
		[i=[i], j=[j]+1]
	   else
		[i=[i]+1, j=0],
	  each [field1 = field1Name, field2 = field2Names{[i]}, field3 = field3Name,field4 = field4Names{[j]},field5 = field5Name,field6 = field6Name]
	 )
in
	list,

//Generate a list of paths based on a record
PathListFromRecord = (baseRecord as record, field1Name as text,  field3Name as text,  field5Name as text, field6Name as text) as list =>
let
	field2Names = Record.FieldNames(Record.Field(baseRecord,field1Name)),
	field2NamesCount = List.Count(field2Names),

	list = List.Generate(
	()=>[i=0, j=0],
	each [i] < field2NamesCount,
	each
		if [j] < List.Count(Record.FieldNames(GetValue3(baseRecord,field1Name,field2Names{[i]},field3Name))) - 1 then
		[i=[i], j=[j]+1] //Loop on j
		else
		[i=[i]+1, j=0], //Go to the next i
	each [
		field1 = field1Name, field2 = field2Names{[i]}, field3 = field3Name,field4 = Record.FieldNames(GetValue3(baseRecord,field1Name,field2Names{[i]},field3Name)){[j]},field5 = field5Name,field6 = field6Name,
		unit = GetValue(baseRecord,field1Name,field2Names{[i]}, field3Name,Record.FieldNames(GetValue3(baseRecord,field1Name,field2Names{[i]},field3Name)){[j]},field5Name,"unit"),
		ifcType = GetValue(baseRecord,field1Name,field2Names{[i]}, field3Name,Record.FieldNames(GetValue3(baseRecord,field1Name,field2Names{[i]},field3Name)){[j]},field5Name,"ifcType")
		]
	)
in
	list,

//Get all possible path from a list of records
UniquePathListFromRecords = (baseRecords as list, field1Name as text,  field3Name as text,  field5Name as text, field6Name as text) as list =>
let
	allPaths = List.Transform(baseRecords, each PathListFromRecord(_,field1Name,field3Name,field5Name,field6Name)),
	
	allPathsUnique = 
	if List.Count(allPaths) > 0 then
		List.Distinct(List.Combine(allPaths))
	else
		null
in
	allPathsUnique,

//A function to generate a list of record based on a list of paths (3 deep)
PathList3 = (field1Name as text, fieldNames as list, field3Name as text) as list =>
let
	list = List.Transform(fieldNames, each [field1 = field1Name, field2 = _, field3 = field3Name])
in
	list,
	
//A function to retrieve a list of fields on the 3rd rank
GetFieldNames = (baseRecord as record, field1 as text, field2 as text, field3 as text) as list =>
let
	fieldNames = Record.FieldNames(GetValue3(baseRecord, field1,field2,field3))
in
	fieldNames,

//A function to retrieve all possible names for fields on the 3th rank for a list of records
GetAll3FieldNames = (records as list, field1 as text, field2Names as list, field3 as text) as list =>
let
	recordCount = List.Count(records),
	field2NamesCount = List.Count(field2Names),

	allFieldNames = List.Generate(
	  ()=>[i=0, j=0],
	  each [i] < recordCount,
	  each
	   if [j] < field2NamesCount - 1 then
		[i=[i], j=[j]+1]
	   else
		[i=[i]+1, j=0],
	  each Get3FieldNames(records{[i]},field1,field2Names{[j]}, field3)
	 ),

	allFieldNamesUnique = List.Distinct(List.Combine(allFieldNames))
in
	allFieldNamesUnique,

//A function to retrieve all names for fields on the 3th rank for a records
Get3FieldNames = (baseRecord as record, field1 as text, field2 as text, field3 as text) as list =>
let
	allFieldNamesUnique = Record.FieldNames(GetValue3(baseRecord, field1,field2,field3))
in
	allFieldNamesUnique,

//A function to retrieve all possible names for fields on the 3th rank for a list of records
GetAll1FieldNames = (records as list, field1 as text) as list =>
let
	allFieldNames = List.Transform(records, each Record.FieldNames(Record.Field(_,field1))),
	allFieldNamesUnique = List.Distinct(List.Combine(allFieldNames))
in
	allFieldNamesUnique,

//A function to add a new column for every paths in the list (6 deep path)
AddColumns = (initialTable as table, paths as list) as table => 
let
		fieldCount = if List.Count(paths) <> 0 then
		Record.FieldCount(paths{0})
	else
		0,
	properties = if  fieldCount = 3
	then
		List.Accumulate(paths, initialTable , 
			(stateTable, currentPath) => Table.AddColumn(stateTable,
			currentPath[field2], //The name of the column
			each GetValue3([Column1],currentPath[field1],currentPath[field2],currentPath[field3]))) //The function of the column
	else
		List.Accumulate
		(
			paths, initialTable , 
				(stateTable, currentPath) => Table.AddColumn
					(
						stateTable,
						currentPath[field1] & "." &  currentPath[field2] & "." & currentPath[field4] & AddUnit(currentPath) & AddIFCType(currentPath), //The name of the column
						each  GetValue([Column1],currentPath[field1],currentPath[field2],currentPath[field3],currentPath[field4],currentPath[field5],currentPath[field6]), //The path to the value
						AddType(currentPath)//The column type
					)
		) //The function of the column
in
    properties,

//A function to add the unit at the end of the column header
AddUnit = (path as record) as text =>
let
	unitText = if path[unit] <> null
	then
		" (" & path[unit] & ")"
	else
		""
in
	unitText,

//A function to add the unit at the end of the column header
AddIFCType = (path as record) as text =>
let
	ifcType = if path[ifcType] <> null
	then
		" (" & path[ifcType] & ")"
	else
		""
in
	ifcType,

//A function to get the column type base on a path
AddType = (path as record) as type =>
let
	ifcType = if path[ifcType] <> null
	then
		path[ifcType]
	else
		"",
		
	columnType = if 
		ifcType = "IfcLengthMeasure" or 
		ifcType = "IfcAreaMeasure" or
		ifcType = "IfcVolumeMeasure" or
		ifcType = "IfcCountMeasure" or
		ifcType = "IfcCurvatureMeasure" or 
		ifcType = "IfcDimensionCount" or
		ifcType = "IfcInteger" or
		ifcType = "IfcMassMeasure" or 
		ifcType = "IfcMassPerLengthMeasure" or
		ifcType = "IfcNumericMeasure"
	then
		type number
	else if
		ifcType = "IfcBoolean"
	then
		type logical
	else
		type text
in
	columnType,

//The main function
//Everything start here
//Welcome
Source = elements, 
//Create the table
initialTable = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
idTable = Table.AddColumn(initialTable, "objectId", each [Column1][objectId]),
typeTable = Table.AddColumn(idTable, "ifcType", each [Column1][ifcType]),
revisionTable = Table.AddColumn(typeTable , "revisionId", each [Column1][revisionId]),

//Get all attributes paths
attributesNames = GetAll1FieldNames(Source,"attributes"),
attributesPaths = PathList3("attributes",attributesNames,"value"),
attributesTable = AddColumns(revisionTable ,attributesPaths),

//Get all properties paths
propertyPaths = UniquePathListFromRecords(Source,"propertySets","properties","nominalValue","value"),

//Get all quantities paths
quantityPaths = UniquePathListFromRecords(Source,"quantitySets","quantities","value","value"),

//Merge the two lists of paths
pathsList = List.Combine({propertyPaths,quantityPaths}),

newtable = AddColumns(attributesTable,pathsList)
in
newtable
in
    Source