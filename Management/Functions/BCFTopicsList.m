let
    Source = (token as text) => let
    
    //Get a list of topics for a given board ID
    GetTopics = (boardId as text, token as text) as list =>
    let 
	    topics = BCFREST("/bcf/beta/projects/" & boardId &"/topics",token),
	    topicsWithBoardId = List.Transform(topics, each Record.AddField(_,"project_id",boardId))
    in
	    topicsWithBoardId,

    IssueBoardList = BCFIssueBoardList(token),

    topicsList = List.Combine(List.Transform(IssueBoardList, each GetTopics(_[project_id],token)))
in
    topicsList
in
    Source