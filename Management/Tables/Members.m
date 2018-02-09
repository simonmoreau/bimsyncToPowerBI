let

//Transform a member record
TransformMember = (member as record) as record =>
let
	member1 = Record.AddField(member, "userId", member[user][id]),
	member2 = Record.RemoveFields(member1, "user")
in
	member2,

token = GetToken(),
members = membersList(token),
membersWithUserId = List.Transform(members, each TransformMember(_)),
membersInitialTable = Table.FromList(membersWithUserId, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
membersTable = Table.ExpandRecordColumn(membersInitialTable, "Column1", {"role", "visibility", "projectId", "userId"}, {"role", "visibility", "projectId", "userId"}),
    #"Sorted Rows" = Table.Sort(membersTable,{{"userId", Order.Ascending}})
in
    #"Sorted Rows"