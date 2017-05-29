DROP TABLE IF EXISTS Users CASCADE
;
DROP TABLE IF EXISTS WasteFacilityTypeType CASCADE
;
DROP TABLE IF EXISTS WasteFacility CASCADE
;
DROP TABLE IF EXISTS FacilityOreMineralogy CASCADE
;
DROP TABLE IF EXISTS FacilityWasteType CASCADE
;
DROP TABLE IF EXISTS Geochemistry CASCADE
;
DROP TABLE IF EXISTS ExtractiveDumpSample CASCADE
;
DROP TABLE IF EXISTS PlantWasteProduced CASCADE
;
DROP TABLE IF EXISTS PlantFeedingMaterial CASCADE
;
DROP TABLE IF EXISTS PlantProduct CASCADE
;
DROP TABLE IF EXISTS ProductType CASCADE
;
DROP TABLE IF EXISTS PlantStorage CASCADE
;
DROP TABLE IF EXISTS StorageType CASCADE
;
DROP TABLE IF EXISTS PlantTransport CASCADE
;
DROP TABLE IF EXISTS TransportType CASCADE
;
DROP TABLE IF EXISTS TreatmentRecyclingPlant CASCADE
;
DROP TABLE IF EXISTS ExtractiveDump CASCADE
;
DROP TABLE IF EXISTS SamplingTechniqueType CASCADE
;
DROP TABLE IF EXISTS MunicipalDumpSample CASCADE
;
DROP TABLE IF EXISTS EnergyRecoveryType CASCADE
;
DROP TABLE IF EXISTS CapturedBioGas CASCADE
;
DROP TABLE IF EXISTS Operator CASCADE
;
DROP TABLE IF EXISTS ProvinceType CASCADE
;
DROP TABLE IF EXISTS MunicipalityType CASCADE
;
DROP TABLE IF EXISTS DumpOreMineralogy CASCADE
;
DROP TABLE IF EXISTS OreMineralogyType CASCADE
;
DROP TABLE IF EXISTS EnvironmentalImpactType CASCADE
;
DROP TABLE IF EXISTS FacilityLithology CASCADE
;
DROP TABLE IF EXISTS LithologyType CASCADE
;
DROP TABLE IF EXISTS WasteTypeType CASCADE
;
DROP TABLE IF EXISTS FacilityMiningActivity CASCADE
;
DROP TABLE IF EXISTS  FacilityProcessingActivity CASCADE
;
DROP TABLE IF EXISTS ProcessingActivityTypeType CASCADE
;
DROP TABLE IF EXISTS MiningActivityTypeType CASCADE
;
DROP TABLE IF EXISTS FacilityCommodity CASCADE
;
DROP TABLE IF EXISTS DepositTypeType CASCADE
;
DROP TABLE IF EXISTS MineStatusType CASCADE
;
DROP TABLE IF EXISTS CommodityType CASCADE
;
DROP TABLE IF EXISTS ExtractiveIndustryFacility CASCADE
;
DROP TABLE IF EXISTS UomAreaType CASCADE
;
DROP TABLE IF EXISTS UomWeightType CASCADE
;
DROP TABLE IF EXISTS UomVolumeType CASCADE
;
DROP TABLE IF EXISTS CountryType CASCADE
;
DROP TABLE IF EXISTS LandfillStatusType CASCADE
;
DROP TABLE IF EXISTS LandfillTypeType CASCADE
;
DROP TABLE IF EXISTS LandfillCategoryType CASCADE
;
DROP TABLE IF EXISTS RegionType CASCADE
;
DROP TABLE IF EXISTS EwcType CASCADE
;
DROP TABLE IF EXISTS LandfillEwc CASCADE
;
DROP TABLE IF EXISTS MunicipalConstructionFacility CASCADE
;
DROP TABLE IF EXISTS nutsAll CASCADE
;


CREATE TABLE Users ( 
	userDbk serial NOT NULL PRIMARY KEY,
	userName varchar(150),
	password varchar(50),
	email varchar(50),
	operatorAffiliation integer,
	observations varchar(150)
)
;
ALTER TABLE Users OWNER TO sgadmin
;

CREATE TABLE WasteFacilityTypeType ( 
	wasteFacilityType varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE WasteFacilityTypeType OWNER TO sgadmin
;

CREATE TABLE WasteFacility ( 
	wasteFacilityDbk serial NOT NULL PRIMARY KEY,
	name varchar(75),
	address varchar(150),
	country varchar(2) NOT NULL,
	region varchar(50),
	province varchar(50),
	municipality varchar(50),
	operatorDbk integer,
	status varchar(50),
	depth real,
	uomDepth varchar(50),
	area real,
	uomArea varchar(50),
	volume real,
	uomVolume varchar(50),
	weight real,
	uomWeight varchar(50),
	beginOperation varchar(4),
	endOperation varchar(4),
	isAnalysis boolean,
	sourceAnalysis text,
	images text,
	observations varchar(500),
	wasteFacilityType varchar(50),
	studies varchar(150),
	isDraft boolean,
	geometry geometry(point, 4326),
	stgeom varchar(500)
)
;
ALTER TABLE WasteFacility OWNER TO sgadmin
;

CREATE TABLE FacilityOreMineralogy ( 
	FacilityOreMineralogyDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk integer NOT NULL,
	oreMineralogy varchar(50) NOT NULL
)
;
ALTER TABLE FacilityOreMineralogy OWNER TO sgadmin
;

CREATE TABLE FacilityWasteType ( 
	FacilityWasteTypeDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk integer,
	wasteType varchar(100)
)
;
ALTER TABLE FacilityWasteType OWNER TO sgadmin
;

CREATE TABLE Geochemistry ( 
	geochemistryDbk serial NOT NULL PRIMARY KEY,
	extractiveDumpSampleDbk integer,
	Al varchar(53),
	Al2O3 varchar(53),
	Ca varchar(53),
	CaO varchar(53),
	Fetot varchar(53),
	FeOtot varchar(53),
	Fe2O3tot varchar(53),
	FeO varchar(53),
	Fe2O3 varchar(53),
	K varchar(53),
	K2O varchar(53),
	Mg varchar(53),
	MgO varchar(53),
	Na varchar(53),
	Na2O varchar(53),
	Si varchar(53),
	SiO2 varchar(53),
	Ag varchar(53),
	"as" varchar(53),
	Au varchar(53),
	B varchar(53),
	Ba varchar(53),
	Be varchar(53),
	Bi varchar(53),
	Cd varchar(53),
	Cl varchar(53),
	Co varchar(53),
	Cr varchar(53),
	Cs varchar(53),
	Cu varchar(53),
	F varchar(53),
	Ga varchar(53),
	Ge varchar(53),
	Hf varchar(53),
	Hg varchar(53),
	"in" varchar(53),
	Li varchar(53),
	Mn varchar(53),
	Mo varchar(53),
	Nb varchar(53),
	Ni varchar(53),
	P varchar(53),
	Pb varchar(53),
	Rb varchar(53),
	Re varchar(53),
	S varchar(53),
	Sb varchar(53),
	Se varchar(53),
	Sn varchar(53),
	Sr varchar(53),
	Ta varchar(53),
	Te varchar(53),
	Th varchar(53),
	Tl varchar(53),
	U varchar(53),
	V varchar(53),
	W varchar(53),
	Zn varchar(53),
	Zr varchar(53),
	Sc varchar(53),
	Y varchar(53),
	La varchar(53),
	Ce varchar(53),
	Pr varchar(53),
	Nd varchar(53),
	Sm varchar(53),
	Eu varchar(53),
	Gd varchar(53),
	Tb varchar(53),
	Dy varchar(53),
	Ho varchar(53),
	Er varchar(53),
	Tm varchar(53),
	Yb varchar(53),
	Lu varchar(53),
	Ru varchar(53),
	Rh varchar(53),
	Pd varchar(53),
	Os varchar(53),
	Ir varchar(53),
	Pt varchar(53)
)
;
ALTER TABLE Geochemistry OWNER TO sgadmin
;

CREATE TABLE ExtractiveDumpSample ( 
	extractiveDumpSampleDbk serial NOT NULL PRIMARY KEY,
	extractiveDumpDbk integer,
	sampleCode varchar(50),
	weight real,
	mass real,
	humidity real,
	samplingTechnique varchar(50),
	geometry geometry(point)
)
;
ALTER TABLE ExtractiveDumpSample OWNER TO sgadmin
;

CREATE TABLE PlantWasteProduced ( 
	plantWasteProducedDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk integer NOT NULL,
	ewc varchar(50),
	weight real
)
;
ALTER TABLE PlantWasteProduced OWNER TO sgadmin
;

CREATE TABLE PlantFeedingMaterial ( 
	plantFeedingMaterialDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk integer NOT NULL,
	ewc varchar(50),
	year varchar(4),
	weight real,
	uom varchar(50)
)
;
ALTER TABLE PlantFeedingMaterial OWNER TO sgadmin
;

CREATE TABLE PlantProduct ( 
	plantProductDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk integer NOT NULL,
	product varchar(50),
	byproduct varchar(50),
	weight real,
	uom varchar(50)
)
;
ALTER TABLE PlantProduct OWNER TO sgadmin
;

CREATE TABLE ProductType ( 
	product varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE ProductType OWNER TO sgadmin
;

CREATE TABLE PlantStorage ( 
	plantStorageDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk integer NOT NULL,
	storage varchar(50)
)
;
ALTER TABLE PlantStorage OWNER TO sgadmin
;

CREATE TABLE StorageType ( 
	storage varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE StorageType OWNER TO sgadmin
;

CREATE TABLE PlantTransport ( 
	plantTransportDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk integer NOT NULL,
	transport varchar(50)
)
;
ALTER TABLE PlantTransport OWNER TO sgadmin
;

CREATE TABLE TransportType ( 
	transport varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE TransportType OWNER TO sgadmin
;

CREATE TABLE TreatmentRecyclingPlant ( 
	treatmentRecyclingPlantDbk serial NOT NULL PRIMARY KEY
)
;
ALTER TABLE TreatmentRecyclingPlant OWNER TO sgadmin
;

CREATE TABLE ExtractiveDump ( 
	extractiveDumpDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk integer,
	dumpCode varchar(50),
	lastWasteType varchar(100)
)
;
ALTER TABLE ExtractiveDump OWNER TO sgadmin
;

CREATE TABLE SamplingTechniqueType ( 
	samplingTechnique varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE SamplingTechniqueType OWNER TO sgadmin
;

CREATE TABLE MunicipalDumpSample ( 
	municipalDumpSampleDbk serial NOT NULL PRIMARY KEY,
	municipalConstructionFacilityDbk integer,
	dumpId varchar(50),
	samplingDate date,
	samplingTechnique varchar(50),
	numberSamplingWell bigint,
	samplingDepth varchar(53),
	weightSmallFractions varchar(53),
	weightMediumFractions varchar(53),
	weightBigFractions varchar(53),
	weightMetalBigFraction varchar(53),
	weightEnergyBigFraction varchar(53),
	weightTextileBigFraction varchar(53),
	weightPlasticBigFraction varchar(53),
	weightWoodBigFraction varchar(53),
	weightPaperBigFraction varchar(53),
	weightSoilBigFraction varchar(53),
	weightMetalMediumFraction varchar(53),
	weightEnergyMediumFraction varchar(53),
	weightTextileMediumFraction varchar(53),
	weightPlasticMediumFraction varchar(53),
	weightWoodMediumFraction varchar(53),
	weightPaperMediumFraction varchar(53),
	weightSoilMediumFraction varchar(53),
	compositionSmallFraction varchar(53),
	rareEarthMetalSmallFraction varchar(53),
	platinumGroupMetalSmallFraction varchar(53),
	otherMetalSmallFraction varchar(53),
	calorificValueBigFraction varchar(53),
	calorificValueMediumFraction varchar(53),
	Model3D text,
	thematicMap text,
	gisData text
)
;
ALTER TABLE MunicipalDumpSample OWNER TO sgadmin
;

CREATE TABLE EnergyRecoveryType ( 
	energyRecovery varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE EnergyRecoveryType OWNER TO sgadmin
;

CREATE TABLE CapturedBioGas ( 
	capturedBiogasDbk serial NOT NULL PRIMARY KEY,
	municipalConstructionFacilityDbk integer,
	year varchar(4),
	gasCaptured real,
	uomgascaptured varchar(50)
)
;
ALTER TABLE CapturedBioGas OWNER TO sgadmin
;

CREATE TABLE Operator ( 
	operatorDbk serial NOT NULL PRIMARY KEY,
	nameOperator varchar(150),
	nameIsPrivate boolean,
	postalAddress varchar(150),
	email varchar(50),
	telephoneNumbers varchar(50),
	nameContactPerson varchar(100),
	vat varchar(50),
	description text
)
;
ALTER TABLE Operator OWNER TO sgadmin
;

CREATE TABLE ProvinceType ( 
	province varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text,
	centroid geometry(point),
	geometry geometry(multipolygon)
)
;
ALTER TABLE ProvinceType OWNER TO sgadmin
;

CREATE TABLE MunicipalityType ( 
	municipality varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text,
	geometry geometry(multipolygon)
)
;
ALTER TABLE MunicipalityType OWNER TO sgadmin
;

CREATE TABLE DumpOreMineralogy ( 
	dumpOreMineralogyDbk serial NOT NULL PRIMARY KEY,
	extractiveDumpDbk integer NOT NULL,
	oreMineralogy varchar(50) NOT NULL
)
;
ALTER TABLE DumpOreMineralogy OWNER TO sgadmin
;

CREATE TABLE OreMineralogyType ( 
	oreMineralogy varchar(50) NOT NULL PRIMARY KEY,
	name text,
	formula varchar(50),
	symbol varchar(50),
	description text,
	url text
)
;
ALTER TABLE OreMineralogyType OWNER TO sgadmin
;

CREATE TABLE EnvironmentalImpactType ( 
	environmentalImpact varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE EnvironmentalImpactType OWNER TO sgadmin
;

CREATE TABLE FacilityLithology ( 
	facilityLithologyDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk integer,
	lithology varchar(50)
)
;
ALTER TABLE FacilityLithology OWNER TO sgadmin
;

CREATE TABLE LithologyType ( 
	lithology varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE LithologyType OWNER TO sgadmin
;

CREATE TABLE WasteTypeType ( 
	wasteType varchar(100) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE WasteTypeType OWNER TO sgadmin
;

CREATE TABLE FacilityMiningActivity ( 
	facilityMiningActivityDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk integer,
	miningActivityType varchar(50)
)
;
ALTER TABLE FacilityMiningActivity OWNER TO sgadmin
;

CREATE TABLE  FacilityProcessingActivity ( 
	facilityProcessingActivityDbk serial NOT NULL PRIMARY KEY,
	wasteFacilityDbk integer,
	processingActivityType varchar(50)
)
;
ALTER TABLE  FacilityProcessingActivity OWNER TO sgadmin
;

CREATE TABLE ProcessingActivityTypeType ( 
	processingActivityType varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE ProcessingActivityTypeType OWNER TO sgadmin
;

CREATE TABLE MiningActivityTypeType ( 
	miningActivityType varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE MiningActivityTypeType OWNER TO sgadmin
;

CREATE TABLE FacilityCommodity ( 
	facilityCommodityDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk integer,
	commodity varchar(50),
	mainCommodity boolean
)
;
ALTER TABLE FacilityCommodity OWNER TO sgadmin
;

CREATE TABLE DepositTypeType ( 
	depositType varchar(100) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text,
	depositGroup varchar(50)
)
;
ALTER TABLE DepositTypeType OWNER TO sgadmin
;

CREATE TABLE MineStatusType ( 
	mineStatus varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE MineStatusType OWNER TO sgadmin
;

CREATE TABLE CommodityType ( 
	commodity varchar(50) NOT NULL PRIMARY KEY,
	class_a real,
	class_b real,
	class_c real,
	class_d real,
	unit varchar(50),
	name text,
	description text,
	url text
)
;
ALTER TABLE CommodityType OWNER TO sgadmin
;

CREATE TABLE ExtractiveIndustryFacility ( 
	extractiveIndustryFacilityDbk serial NOT NULL PRIMARY KEY,
	environmentalImpact varchar(50),
	mineralDeposit varchar(100),
	mineStatus varchar(50),
	beginLastExploitation varchar(4),
	endLastExploitation varchar(4),
	mineLastOperator varchar(150),
	isRehabilitation boolean,
	studyDeposit text
)
;
ALTER TABLE ExtractiveIndustryFacility OWNER TO sgadmin
;

CREATE TABLE UomAreaType ( 
	uom varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE UomAreaType OWNER TO sgadmin
;

CREATE TABLE UomWeightType ( 
	uom varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE UomWeightType OWNER TO sgadmin
;

CREATE TABLE UomVolumeType ( 
	uom varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE UomVolumeType OWNER TO sgadmin
;

CREATE TABLE CountryType ( 
	country varchar(2) NOT NULL PRIMARY KEY,
	name text NOT NULL,
	description text,
	url text,
	geometry geometry(multipolygon)
)
;
ALTER TABLE CountryType OWNER TO sgadmin
;

CREATE TABLE LandfillStatusType ( 
	landfillStatus varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE LandfillStatusType OWNER TO sgadmin
;

CREATE TABLE LandfillTypeType ( 
	landfillType varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE LandfillTypeType OWNER TO sgadmin
;

CREATE TABLE LandfillCategoryType ( 
	landfillCategory varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE LandfillCategoryType OWNER TO sgadmin
;

CREATE TABLE RegionType ( 
	region varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text,
	geometry geometry(multipolygon)
)
;
ALTER TABLE RegionType OWNER TO sgadmin
;

CREATE TABLE EwcType ( 
	ewc varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text,
	keywords text
)
;
ALTER TABLE EwcType OWNER TO sgadmin
;

CREATE TABLE LandfillEwc ( 
	landfillEwcDbk serial NOT NULL PRIMARY KEY,
	municipalConstructionFacilityDbk integer NOT NULL,
	ewc varchar(50),
	year varchar(4),
	weight real,
	uom varchar(50)
)
;
ALTER TABLE LandfillEwc OWNER TO sgadmin
;

CREATE TABLE MunicipalConstructionFacility ( 
	municipalConstructionFacilityDbk serial NOT NULL PRIMARY KEY,
	landfillCategory varchar(50),
	landfillType varchar(50),
	energyRecovery varchar(50),
	solarEnergyPlant boolean
)
;
ALTER TABLE MunicipalConstructionFacility OWNER TO sgadmin
;





ALTER TABLE Users ADD CONSTRAINT FK_Users_Operator 
	FOREIGN KEY (operatorAffiliation) REFERENCES Operator (operatorDbk)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_CountryType 
	FOREIGN KEY (country) REFERENCES CountryType (country)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_LandfillStatusType 
	FOREIGN KEY (status) REFERENCES LandfillStatusType (landfillStatus)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_MunicipalityType 
	FOREIGN KEY (municipality) REFERENCES MunicipalityType (municipality)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_ProvinceType 
	FOREIGN KEY (province) REFERENCES ProvinceType (province)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_RegionType 
	FOREIGN KEY (region) REFERENCES RegionType (region)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_UomVolumeType 
	FOREIGN KEY (uomVolume) REFERENCES UomVolumeType (uom)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_UomWeightType 
	FOREIGN KEY (uomWeight) REFERENCES UomWeightType (uom)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_WasteFacilityTypeType 
	FOREIGN KEY (wasteFacilityType) REFERENCES WasteFacilityTypeType (wasteFacilityType)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_UomAreaType 
	FOREIGN KEY (uomArea) REFERENCES UomAreaType (uom)
;

ALTER TABLE WasteFacility ADD CONSTRAINT FK_WasteFacility_Operator 
	FOREIGN KEY (operatorDbk) REFERENCES Operator (operatorDbk)
;

ALTER TABLE FacilityOreMineralogy ADD CONSTRAINT FK_FacilityOreMineralogy_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
;

ALTER TABLE FacilityOreMineralogy ADD CONSTRAINT FK_FacilityOreMineralogy_OreMineralogyType 
	FOREIGN KEY (oreMineralogy) REFERENCES OreMineralogyType (oreMineralogy)
;

ALTER TABLE FacilityWasteType ADD CONSTRAINT FK_FacilityWasteType_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
;

ALTER TABLE FacilityWasteType ADD CONSTRAINT FK_FacilityWasteType_WasteTypeType 
	FOREIGN KEY (wasteType) REFERENCES WasteTypeType (wasteType)
;

ALTER TABLE ExtractiveDumpSample ADD CONSTRAINT FK_ExtractiveDumpSample_Dump 
	FOREIGN KEY (extractiveDumpDbk) REFERENCES ExtractiveDump (extractiveDumpDbk)
;

ALTER TABLE ExtractiveDumpSample ADD CONSTRAINT FK_ExtractiveDumpSample_SamplingTechniqueType 
	FOREIGN KEY (samplingTechnique) REFERENCES SamplingTechniqueType (samplingTechnique)
;

ALTER TABLE PlantWasteProduced ADD CONSTRAINT FK_PlantWasteProduced_EwcType 
	FOREIGN KEY (ewc) REFERENCES EwcType (ewc)
;

ALTER TABLE PlantWasteProduced ADD CONSTRAINT FK_PlantWasteProduced_TreatmentRecyclingPlant 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (treatmentRecyclingPlantDbk)
;

ALTER TABLE PlantFeedingMaterial ADD CONSTRAINT FK_PlantFeedingMaterial_EwcType 
	FOREIGN KEY (ewc) REFERENCES EwcType (ewc)
;

ALTER TABLE PlantProduct ADD CONSTRAINT FK_PlantProduct_ProductType 
	FOREIGN KEY (product) REFERENCES ProductType (product)
;

ALTER TABLE PlantProduct ADD CONSTRAINT FK_PlantProduct_TreatmentRecyclingPlant 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (treatmentRecyclingPlantDbk)
;

ALTER TABLE PlantStorage ADD CONSTRAINT FK_PlantStorage_StorageType 
	FOREIGN KEY (storage) REFERENCES StorageType (storage)
;

ALTER TABLE PlantStorage ADD CONSTRAINT FK_PlantStorage_TreatmentRecyclingPlant 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (treatmentRecyclingPlantDbk)
;

ALTER TABLE PlantTransport ADD CONSTRAINT FK_PlantTransport_TransportType 
	FOREIGN KEY (transport) REFERENCES TransportType (transport)
;

ALTER TABLE TreatmentRecyclingPlant ADD CONSTRAINT FK_TreatmentRecyclingPlant_WasteFacility 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES WasteFacility (wasteFacilityDbk)
;

ALTER TABLE ExtractiveDump ADD CONSTRAINT FK_ExtractiveDump_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
;

ALTER TABLE ExtractiveDump ADD CONSTRAINT FK_ExtractiveDump_WasteTypeType 
	FOREIGN KEY (lastWasteType) REFERENCES WasteTypeType (wasteType)
;

ALTER TABLE MunicipalDumpSample ADD CONSTRAINT FK_MunicipalDataSample_SamplingTechniqueType 
	FOREIGN KEY (samplingTechnique) REFERENCES SamplingTechniqueType (samplingTechnique)
;

ALTER TABLE MunicipalDumpSample ADD CONSTRAINT FK_MunicipalDumpSample_MunicipalConstructionFacility 
	FOREIGN KEY (municipalConstructionFacilityDbk) REFERENCES MunicipalConstructionFacility (municipalConstructionFacilityDbk)
;

ALTER TABLE CapturedBioGas ADD CONSTRAINT FK_CapturedBioGas_MunicipalConstructionFacility 
	FOREIGN KEY (municipalConstructionFacilityDbk) REFERENCES MunicipalConstructionFacility (municipalConstructionFacilityDbk)
;

ALTER TABLE DumpOreMineralogy ADD CONSTRAINT FK_DumpOreMineralogy_Dump 
	FOREIGN KEY (extractiveDumpDbk) REFERENCES ExtractiveDump (extractiveDumpDbk)
;

ALTER TABLE DumpOreMineralogy ADD CONSTRAINT FK_DumpOreMineralogy_OreMineralogyType 
	FOREIGN KEY (oreMineralogy) REFERENCES OreMineralogyType (oreMineralogy)
;

ALTER TABLE FacilityLithology ADD CONSTRAINT FK_FacilityLithology_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
;

ALTER TABLE FacilityLithology ADD CONSTRAINT FK_FacilityLithology_LithologyType 
	FOREIGN KEY (lithology) REFERENCES LithologyType (lithology)
;

ALTER TABLE FacilityMiningActivity ADD CONSTRAINT FK_FacilityMiningActivity_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
;

ALTER TABLE FacilityMiningActivity ADD CONSTRAINT FK_FacilityMiningActivity_MiningActivityTypeType 
	FOREIGN KEY (miningActivityType) REFERENCES MiningActivityTypeType (miningActivityType)
;

ALTER TABLE  FacilityProcessingActivity ADD CONSTRAINT FK_FacilityProcessingActivity_WasteFacility 
	FOREIGN KEY (wasteFacilityDbk) REFERENCES WasteFacility (wasteFacilityDbk)
;

ALTER TABLE FacilityCommodity ADD CONSTRAINT FK_FacilityCommodity_CommodityType 
	FOREIGN KEY (commodity) REFERENCES CommodityType (commodity)
;

ALTER TABLE FacilityCommodity ADD CONSTRAINT FK_FacilityCommodity_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
;

ALTER TABLE ExtractiveIndustryFacility ADD CONSTRAINT FK_ExtractiveIndustryFacility_DepositTypeType 
	FOREIGN KEY (mineralDeposit) REFERENCES DepositTypeType (depositType)
;

ALTER TABLE ExtractiveIndustryFacility ADD CONSTRAINT FK_ExtractiveIndustryFacility_EnvironmentalImpactType 
	FOREIGN KEY (environmentalImpact) REFERENCES EnvironmentalImpactType (environmentalImpact)
;

ALTER TABLE ExtractiveIndustryFacility ADD CONSTRAINT FK_ExtractiveIndustryFacility_WasteFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES WasteFacility (wasteFacilityDbk)
;

ALTER TABLE LandfillEwc ADD CONSTRAINT FK_LandfillEwc_EwcType 
	FOREIGN KEY (ewc) REFERENCES EwcType (ewc)
;

ALTER TABLE LandfillEwc ADD CONSTRAINT FK_LandfillEwc_MunicipalConstructionFacility 
	FOREIGN KEY (municipalConstructionFacilityDbk) REFERENCES MunicipalConstructionFacility (municipalConstructionFacilityDbk)
;

ALTER TABLE MunicipalConstructionFacility ADD CONSTRAINT FK_MunicipalConstructionFacility_LandfillCategoryType 
	FOREIGN KEY (landfillCategory) REFERENCES LandfillCategoryType (landfillCategory)
;

ALTER TABLE MunicipalConstructionFacility ADD CONSTRAINT FK_MunicipalConstructionFacility_LandfillTypeType 
	FOREIGN KEY (landfillType) REFERENCES LandfillTypeType (landfillType)
;

ALTER TABLE MunicipalConstructionFacility ADD CONSTRAINT FK_MunicipalConstructionFacility_EnergyRecoveryType 
	FOREIGN KEY (energyRecovery) REFERENCES EnergyRecoveryType (energyRecovery)
;

ALTER TABLE MunicipalConstructionFacility ADD CONSTRAINT FK_MunicipalConstructionFacility_WasteFacility 
	FOREIGN KEY (municipalConstructionFacilityDbk) REFERENCES WasteFacility (wasteFacilityDbk)
;


-- Addtition of table NutsAll

CREATE TABLE "nutsAll" (
    id integer NOT NULL,
    geom geometry(MultiPolygon,4326),
    nuts_id character varying(14),
    stat_levl_ integer,
    shape_area numeric,
    shape_len numeric
);


ALTER TABLE "nutsAll" OWNER TO sgadmin;

CREATE SEQUENCE "nutsAll_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "nutsAll_id_seq" OWNER TO sgadmin;

ALTER SEQUENCE "nutsAll_id_seq" OWNED BY "nutsAll".id;

ALTER TABLE ONLY "nutsAll" ALTER COLUMN id SET DEFAULT nextval('"nutsAll_id_seq"'::regclass);

ALTER TABLE ONLY "nutsAll"
    ADD CONSTRAINT "nutsAll_pkey" PRIMARY KEY (id);

