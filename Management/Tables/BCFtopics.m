let
BCFToken = GetBCFToken(),
GetJson = BCFTopicsList(BCFToken),
initialTable = Table.FromList(GetJson , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
projectsTable = Table.ExpandRecordColumn(initialTable, "Column1", {"guid", "topic_type", "topic_status", "title", "labels", "creation_date", "creation_author", "modified_date", "description", "bimsync_issue_number", "project_id", "modified_author", "assigned_to", "index", "bimsync_imported_by", "bimsync_imported_at"}, {"guid", "topic_type", "topic_status", "title", "labels", "creation_date", "creation_author", "modified_date", "description", "bimsync_issue_number", "project_id", "modified_author", "assigned_to", "index", "bimsync_imported_by", "bimsync_imported_at"}),
projectsTableWithDates = Table.TransformColumnTypes(projectsTable,{{"creation_date", type datetimezone}, {"modified_date", type datetimezone}}),
projectsTableWithLabels = Table.TransformColumns(projectsTableWithDates, {"labels", each Text.Combine(List.Transform(_, Text.From), ";"), type text}),
projectsTableChangeType = Table.TransformColumnTypes(projectsTableWithLabels,{{"bimsync_issue_number", Int64.Type}})
in
projectsTableChangeType