let

//The main function
//Everything start here
//Welcome
Source = [Dashboard= "bimsync"],
sourceWithDate = Record.AddField(Source, "Refresh Date", DateTime.LocalNow()+ #duration(0,2,0,0)),
    #"Converted to Table" = Record.ToTable(sourceWithDate)
in
#"Converted to Table"