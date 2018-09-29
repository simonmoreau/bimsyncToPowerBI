let
    BCFToken = GetBCFToken(),
    GetJson = BFCUsersList(BCFToken),
    initialTable = Table.FromList(GetJson , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    disctincTable = Table.Distinct(initialTable),
    userTable = Table.ExpandRecordColumn(disctincTable, "Column1", {"name", "id"},  {"name", "id"})
in
    userTable