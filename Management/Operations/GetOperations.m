let
    Source = AnalysisServices.Databases("http://rubi/activitecommerciale/Rapports/Datamart_Pricing_Advisor_DATAMART.xlsx", [TypedMeasureColumns=true]),
    Datamart_Pricing_Advisor_DATA_407af5e4f1144cd390d2b97212471e0c_a9b233c3996842b697ada6edcc356403_SSPM = Source{[Name="Datamart_Pricing_Advisor_DATA_407af5e4f1144cd390d2b97212471e0c_a9b233c3996842b697ada6edcc356403_SSPM"]}[Data],
    Model1 = Datamart_Pricing_Advisor_DATA_407af5e4f1144cd390d2b97212471e0c_a9b233c3996842b697ada6edcc356403_SSPM{[Id="Model"]}[Data],
    Model2 = Model1{[Id="Model"]}[Data],
    //Retrive the list of operation for the data cube
    Columns = Cube.Transform(Model2,
        {
            {Cube.AddAndExpandDimensionColumn, "[D_SUPER_ORGA]", {
                 "[D_SUPER_ORGA].[CODE_CI].[CODE_CI]", 
                 "[D_SUPER_ORGA].[CODE_UC].[CODE_UC]", 
                 "[D_SUPER_ORGA].[Operation].[BI]", 
                 "[D_SUPER_ORGA].[Operation].[France Internationnal]", 
                 "[D_SUPER_ORGA].[Operation].[Région]", 
                 "[D_SUPER_ORGA].[Operation].[Agence]", 
                 "[D_SUPER_ORGA].[Operation].[Operation]", 
                 "[D_SUPER_ORGA].[OPERATION_ID].[OPERATION_ID]",
                 "[D_SUPER_ORGA].[ADRESSE].[ADRESSE]",
                 "[D_SUPER_ORGA].[CP].[CP]",
                 "[D_SUPER_ORGA].[DATE_CE].[DATE_CE]",
                 "[D_SUPER_ORGA].[DATE_PC_DEPOT].[DATE_PC_DEPOT]",
                 "[D_SUPER_ORGA].[DATE_ACHAT_TERRAIN].[DATE_ACHAT_TERRAIN]",
                 "[D_SUPER_ORGA].[DATE_PC_PURGE].[DATE_PC_PURGE]",
                 "[D_SUPER_ORGA].[DATE_DEMARRAGE_TRAVAUX].[DATE_DEMARRAGE_TRAVAUX]"
}}
		}),

    //Add the type date on date columns
    TypedColumns = Table.TransformColumnTypes(Columns,{
        {"[D_SUPER_ORGA].[DATE_CE].[DATE_CE]", type date},
        {"[D_SUPER_ORGA].[DATE_PC_DEPOT].[DATE_PC_DEPOT]", type date},
        {"[D_SUPER_ORGA].[DATE_ACHAT_TERRAIN].[DATE_ACHAT_TERRAIN]", type date},
        {"[D_SUPER_ORGA].[DATE_PC_PURGE].[DATE_PC_PURGE]", type date},
        {"[D_SUPER_ORGA].[DATE_DEMARRAGE_TRAVAUX].[DATE_DEMARRAGE_TRAVAUX]", type date}
}),
    resultingTable = Table.AddIndexColumn(TypedColumns, "Index", 0, 1)
in
    resultingTable