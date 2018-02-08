let
token = GetToken(),
memberList = membersList(token),
usersList = List.Distinct(List.Transform(memberList,each _[user])),

initialTable = Table.FromList(usersList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
expandedTable = Table.ExpandRecordColumn(initialTable, "Column1", {"id", "name", "username", "createdAt"}, {"id", "name", "username", "createdAt"}),
addTypes = Table.TransformColumnTypes(expandedTable,{{"createdAt", type datetime}})
in
addTypes