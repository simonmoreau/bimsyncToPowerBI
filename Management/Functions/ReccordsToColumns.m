//A function to add a new column for every attributes in the record
let
    Table = (initialTable as table, fieldsNames as list) as table =>
let
    properties = List.Accumulate(
        fieldsNames,
        initialTable,
        (state, current) => Table.AddColumn(state, current, each Record.FieldOrDefault([Column1],current))
        )
in
    properties
in
    Table