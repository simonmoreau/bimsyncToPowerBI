let

//Get a list of GetElementSummary for a given revisionId and projectId
GetElementSummary = (projectId as text, revisionId as text,token as text) as record =>
let 
	elementSummaries = RESTFunctionWithoutPage("/v2/projects/" & projectId & "/ifc/products/ifctypes",revisionId,token),
	elementSummariesWithProjectId = Record.AddField(elementSummaries,"projectId",projectId),
	elementSummariesWithRevisionId = Record.AddField(elementSummariesWithProjectId,"revisionId",revisionId)
in
	elementSummariesWithRevisionId,

//The main function starts here
token = GetToken(),
revisionList = List.Combine(List.Transform(projectsList(token), each revisionsList(_[id],token))),
elementSummaries = List.Transform(revisionList, each GetElementSummary(_[projectId],_[id],token)),
fieldsList =  {"projectId", "revisionId", "IfcProject", "IfcSite", "IfcBuilding", "IfcBuildingStorey", "IfcWindow", "IfcSpace", "IfcWallStandardCase", "IfcOpeningElement", "IfcDoor", "IfcWall", "IfcCovering", "IfcStair", "IfcSlab", "IfcBeam", "IfcColumn", "IfcBuildingElementProxy", "IfcFlowSegment", "IfcFlowFitting", "IfcFlowController", "IfcDistributionPort", "IfcFlowTerminal", "IfcStairFlight", "IfcRailing", "IfcFurnishingElement", "IfcMember", "IfcRoof", "IfcCurtainWall", "IfcPlate", "IfcFooting", "IfcVirtualElement", "IfcElementAssembly", "IfcGrid", "IfcAnnotation", "IfcRamp", "IfcRampFlight", "IfcFlowMovingDevice", "IfcDistributionControlElement", "IfcElectricDistributionPoint", "IfcFlowTreatmentDevice", "IfcEnergyConversionDevice", "IfcFlowStorageDevice", "IfcBuildingElementPart", "IfcDistributionElement", "IfcDiscreteAccessory", "IfcTransportElement", "IfcDistributionChamberElement", "IfcDistributionFlowElement"},
elementSummariesInitialTable = Table.FromList(elementSummaries, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
elementSummariesColumns = Table.ExpandRecordColumn(elementSummariesInitialTable, "Column1", fieldsList,fieldsList)
in
elementSummariesColumns