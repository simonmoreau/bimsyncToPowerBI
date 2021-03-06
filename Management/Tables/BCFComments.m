let

    //Get a list of BCF Comment for a given boardId and topicId
    GetComments = (boardId as text, topicId as text,token as text) as list =>
    let 
	    bcfComments = BCFREST("/bcf/beta/projects/" & boardId &"/topics/" & topicId &"/comments",token),
	    bcfCommentsWithBoardId = List.Transform(bcfComments, each Record.AddField(_,"boardId",boardId))
    in
	    bcfCommentsWithBoardId,

    BCFToken = GetBCFToken(),
    topicsList = BCFTopicsList(BCFToken),
    commentsList = List.Combine(List.Transform(topicsList,  each GetComments(_[project_id],_[guid],BCFToken))),

    initialTable = Table.FromList(commentsList , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    projectsTable = Table.ExpandRecordColumn(initialTable, "Column1", {"guid", "date", "author", "comment", "topic_guid", "viewpoint_guid", "boardId", "modified_date", "modified_author", "status", "verbal_status"}, {"guid", "date", "author", "comment", "topic_guid", "viewpoint_guid", "boardId", "modified_date", "modified_author", "status", "verbal_status"}),
    projectsTableWithDate = Table.TransformColumnTypes(projectsTable,{{"date", type datetimezone}})
in
    projectsTableWithDate