let

    //Get a list of BCF Comment for a given boardId and topicId
    GetComments = (boardId as text, topicId as text,token as text) as list =>
    let 
	    bcfComments = BCFREST("/bcf/beta/projects/" & boardId &"/topics/" & topicId &"/comments",BCFToken),
	    bcfCommentsWithBoardId = List.Transform(bcfComments, each Record.AddField(_,"boardId",boardId))
    in
	    bcfCommentsWithBoardId,

    topicsList = BCFTopicsList(BCFToken),
    commentsList = List.Combine(List.Transform(topicsList,  each GetComments(_[project_id],_[guid],BCFToken))),

    initialTable = Table.FromList(commentsList , Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    fields = {"guid","verbal_status","status","date","author","comment","topic_guid","viewpoint_guid", "boardId"},
    projectsTable = Table(initialTable,fields)
in
    projectsTable