let
    Source = (token as text) => let
    
    //Get a list of topics for a given board ID
    GetTopics = (boardId as text, token as text) as list =>
    let 
	    topics = BCFREST("/bcf/beta/projects/" & boardId &"/topics",BCFToken),
	    topicsWithBoardId = List.Transform(topics, each Record.AddField(_,"project_id",boardId))
    in
	    topicsWithBoardId,

    IssueBoardList = BCFIssueBoardList(BCFToken),

    topicsList = List.Combine(List.Transform(IssueBoardList, each GetTopics(_[project_id],BCFToken)))
in
    topicsList
in
    Source