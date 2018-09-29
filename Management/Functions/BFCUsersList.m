let
    Source = (token as text) => let
    
    //Get a list of users for a given board ID
    GetUsers = (boardId as text, token as text) as list =>
    let 
	    users = BCFREST("/bcf/beta/projects/" & boardId &"/extensions/users",token)
    in
	    users,

    IssueBoardList = BCFIssueBoardList(token),

    usersList = List.Combine(List.Transform(IssueBoardList, each GetUsers(_[project_id],token)))
in
    usersList
in
    Source