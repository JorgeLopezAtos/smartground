DROP TABLE IF EXISTS TechLineOutput CASCADE
;
DROP TABLE IF EXISTS TechLineInput CASCADE
;
DROP TABLE IF EXISTS TechLineStep CASCADE
;
DROP TABLE IF EXISTS CustomTechLine CASCADE
;
DROP TABLE IF EXISTS CustomMaterial CASCADE
;
DROP TABLE IF EXISTS PlantEquipment CASCADE
;
DROP TABLE IF EXISTS CustomEquipment CASCADE
;
DROP TABLE IF EXISTS PlantCapability CASCADE
;
DROP TABLE IF EXISTS CustomSubcapability CASCADE
;
DROP TABLE IF EXISTS SubCapabilityType CASCADE
;
DROP TABLE IF EXISTS CapabilityType CASCADE
;
DROP TABLE IF EXISTS LandfillSampleGroupType CASCADE
;
DROP TABLE IF EXISTS GeochemistryGroupType CASCADE
;
DROP TABLE IF EXISTS GeochemistryType CASCADE
;
DROP TABLE IF EXISTS LandfillSampleFraction CASCADE
;
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
DROP TABLE IF EXISTS GeochemistrySample CASCADE
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
DROP TABLE IF EXISTS LandfillSample CASCADE
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
DROP TABLE IF EXISTS LandfillFacility CASCADE
;
DROP TABLE IF EXISTS FacilityFile CASCADE
;

CREATE TABLE TechLineOutput ( 
	techLineOutputDbk serial NOT NULL PRIMARY KEY,
	customTechLineDbk serial,
	customMaterialDbk integer,
	product varchar(50),
	outputPercent real,
	productionCost real
)
;
ALTER TABLE TechLineOutput OWNER TO sgadmin
;

CREATE TABLE TechLineInput ( 
	techLineInputDbk serial NOT NULL PRIMARY KEY,
	customTechLineDbk serial,
	customMaterialDbk integer,
	product varchar(50),
	inputPercent real
)
;
ALTER TABLE TechLineInput OWNER TO sgadmin
;

CREATE TABLE TechLineStep ( 
	techLineStepDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk serial,
	customTechLineDbk integer,
	IsImplemented boolean,
	year varchar(4),
	customEquipmentDbk integer,
	customSubcapabilityDbk integer,
	subcapability varchar(50),
	plantTransportDbk integer,
	isOnsite boolean
)
;
ALTER TABLE TechLineStep OWNER TO sgadmin
;

CREATE TABLE CustomTechLine ( 
	customTechLineDbk serial NOT NULL PRIMARY KEY,
	OperatorDbk varchar(100),
	name varchar(50),
	initialFacility varchar(75),
	IsImplemented boolean,
	FNPV_C real,
	FNPV_K real,
	ENPV real,
	financialFeasibility text,
	yearFinancial varchar(4),
	env_gwp real,
	env_agri_land real,
	env_gwp_exl real,
	env_adp_fossil real,
	env_faetp real,
	env_ep real,
	env_htp real,
	env_ion_rad real,
	env_maetp real,
	env_marine_eutr real,
	env_adp real,
	env_natur_land real,
	env_part_mat real,
	env_pocp real,
	env_ap real,
	env_tetp real,
	env_urna_land real,
	env_wd real,
	env_odp real,
	env_normalizedWeighted real,
	yearEnvironmental varchar(4),
	method text,
	description text
)
;
ALTER TABLE CustomTechLine OWNER TO sgadmin
;

CREATE TABLE CustomMaterial ( 
	customMaterialDbk serial NOT NULL PRIMARY KEY,
	operatorDbk varchar(100),
	customMaterial varchar(50),
	description varchar(150)
)
;
ALTER TABLE CustomMaterial OWNER TO sgadmin
;

CREATE TABLE PlantEquipment ( 
	plantEquipmentDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk serial,
	customEquipmentDbk serial
)
;
ALTER TABLE PlantEquipment OWNER TO sgadmin
;

CREATE TABLE CustomEquipment ( 
	customEquipmentDbk serial NOT NULL PRIMARY KEY,
	operatorDbk varchar(100),
	customEquipment varchar(50),
	description varchar(150),
	capacity real,
	operationCost real
)
;
ALTER TABLE CustomEquipment OWNER TO sgadmin
;

CREATE TABLE PlantCapability ( 
	plantCapabilityDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk integer,
	customSubcapabilityDbk integer,
	subcapability varchar(50)
)
;
ALTER TABLE PlantCapability OWNER TO sgadmin
;

CREATE TABLE CustomSubcapability ( 
	customSubcapabilityDbk serial NOT NULL PRIMARY KEY,
	operatorDbk varchar(100),
	capability varchar(50),
	customSubcapability varchar(50)
)
;
ALTER TABLE CustomSubcapability OWNER TO sgadmin
;

CREATE TABLE SubCapabilityType ( 
	subcapability varchar(50) NOT NULL PRIMARY KEY,
	capability varchar(50),
	name text,
	description text,
	url text
)
;
ALTER TABLE SubCapabilityType OWNER TO sgadmin
;

CREATE TABLE CapabilityType ( 
	capability varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE CapabilityType OWNER TO sgadmin
;

CREATE TABLE LandfillSampleGroupType ( 
	landfillSampleGroup varchar(50) NOT NULL PRIMARY KEY,
	name text,
	description text,
	url text
)
;
ALTER TABLE LandfillSampleGroupType OWNER TO sgadmin
;

CREATE TABLE GeochemistryGroupType ( 
	geochemistryGroup varchar(53) NOT NULL PRIMARY KEY,
	name text,
	description text,
	factor real,
	url text
)
;
ALTER TABLE GeochemistryGroupType OWNER TO sgadmin
;

CREATE TABLE GeochemistryType ( 
	geochemistry varchar(53) NOT NULL PRIMARY KEY,
	name text,
	description text,
	geochemistryGroup varchar(53),
	url text
)
;
ALTER TABLE GeochemistryType OWNER TO sgadmin
;

CREATE TABLE LandfillSampleFraction ( 
	landfillSampleFractionDbk serial NOT NULL PRIMARY KEY,
	landfillSampleDbk serial,
	landfillSampleGroup varchar(50),
	sampleValue varchar(15)
)
;
ALTER TABLE LandfillSampleFraction OWNER TO sgadmin
;

CREATE TABLE Users ( 
	userDbk serial NOT NULL PRIMARY KEY,
	userName varchar(150),
	password varchar(50),
	email varchar(50),
	operatorAffiliation varchar(100),
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
	name varchar(200),
	address varchar(150),
	country varchar(2) NOT NULL,
	region varchar(50),
	province varchar(50),
	municipality varchar(50),
	operatorDbk varchar(100),
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
	studies text,
	isDraft boolean,
	geometry geometry(point, 4326),
	stgeom varchar(500)
)
;
ALTER TABLE WasteFacility OWNER TO sgadmin
;

CREATE TABLE FacilityFile ( 
	facilityFileDbk serial NOT NULL PRIMARY KEY,
	wasteFacilityDbk serial,
	fileName varchar(200)
)
;
ALTER TABLE FacilityFile OWNER TO sgadmin
;

CREATE TABLE FacilityOreMineralogy ( 
	FacilityOreMineralogyDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk serial,
	oreMineralogy varchar(50) NOT NULL
)
;
ALTER TABLE FacilityOreMineralogy OWNER TO sgadmin
;

CREATE TABLE FacilityWasteType ( 
	FacilityWasteTypeDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk serial,
	wasteType varchar(100)
)
;
ALTER TABLE FacilityWasteType OWNER TO sgadmin
;

CREATE TABLE GeochemistrySample ( 
	geochemistrySampleDbk serial NOT NULL PRIMARY KEY,
	extractiveDumpSampleDbk integer,
	geochemistry varchar(53),
	sampleValue varchar(53)
)
;
ALTER TABLE GeochemistrySample OWNER TO sgadmin
;

CREATE TABLE ExtractiveDumpSample ( 
	extractiveDumpSampleDbk serial NOT NULL PRIMARY KEY,
	extractiveDumpDbk serial,
	sampleCode varchar(50),
	mass real,
	bulkDensity real,
	humidity real,
	samplingTechnique varchar(50),
	geometry geometry(point),
	stgeom varchar(500)
)
;
ALTER TABLE ExtractiveDumpSample OWNER TO sgadmin
;

CREATE TABLE PlantWasteProduced ( 
	plantWasteProducedDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk serial NOT NULL,
	ewc varchar(50),
	weight real
)
;
ALTER TABLE PlantWasteProduced OWNER TO sgadmin
;

CREATE TABLE PlantFeedingMaterial ( 
	plantFeedingMaterialDbk serial NOT NULL PRIMARY KEY,
	treatmentRecyclingPlantDbk serial NOT NULL,
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
	treatmentRecyclingPlantDbk serial NOT NULL,
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
	treatmentRecyclingPlantDbk serial NOT NULL,
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
	treatmentRecyclingPlantDbk serial NOT NULL,
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
	treatmentRecyclingPlantDbk serial NOT NULL PRIMARY KEY,
	economyIncome real,
	employmentEducation real,
	landuseTerritory real,
	demography real,
	environmentHealth real,
	yearSLCA real
)
;
ALTER TABLE TreatmentRecyclingPlant OWNER TO sgadmin
;

CREATE TABLE ExtractiveDump ( 
	extractiveDumpDbk serial NOT NULL PRIMARY KEY,
	extractiveIndustryFacilityDbk serial,
	dumpCode varchar(50),
	lastWasteType varchar(100),
	volume real,
	bulkDensity real
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

CREATE TABLE LandfillSample ( 
	landfillSampleDbk serial NOT NULL PRIMARY KEY,
	landfillFacilityDbk serial,
	sampleId varchar(50),
	samplingDate date,
	samplingTechnique varchar(50),
	numberSamplingWell bigint,
	samplingDepth varchar(53),
	Model3D text,
	thematicMap text,
	gisData text
)
;
ALTER TABLE LandfillSample OWNER TO sgadmin
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
	landfillFacilityDbk serial,
	year varchar(4),
	gasCaptured real,
	uomgascaptured varchar(50)
)
;
ALTER TABLE CapturedBioGas OWNER TO sgadmin
;

CREATE TABLE Operator ( 
	operatorDbk varchar(100) NOT NULL PRIMARY KEY,
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
	extractiveDumpDbk serial NOT NULL,
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
	extractiveIndustryFacilityDbk serial,
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
	extractiveIndustryFacilityDbk serial,
	miningActivityType varchar(50)
)
;
ALTER TABLE FacilityMiningActivity OWNER TO sgadmin
;

CREATE TABLE  FacilityProcessingActivity ( 
	facilityProcessingActivityDbk serial NOT NULL PRIMARY KEY,
	wasteFacilityDbk serial,
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
	extractiveIndustryFacilityDbk serial,
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
	landfillFacilityDbk serial,
	ewc varchar(50),
	year varchar(4),
	weight real,
	uom varchar(50)
)
;
ALTER TABLE LandfillEwc OWNER TO sgadmin
;

CREATE TABLE LandfillFacility ( 
	LandfillFacilityDbk serial NOT NULL PRIMARY KEY,
	landfillCategory varchar(50),
	landfillType varchar(50),
	energyRecovery varchar(50),
	solarEnergyPlant boolean
)
;
ALTER TABLE LandfillFacility OWNER TO sgadmin
;

/* 

ALTER TABLE TechLineOutput ADD CONSTRAINT PK_TechLineOutput 
	PRIMARY KEY (techLineOutputDbk)
;


ALTER TABLE TechLineInput ADD CONSTRAINT PK_TechLineInput 
	PRIMARY KEY (techLineInputDbk)
;


ALTER TABLE TechLineStep ADD CONSTRAINT PK_TechLineStep 
	PRIMARY KEY (techLineStepDbk)
;


ALTER TABLE CustomTechLine ADD CONSTRAINT PK_CustomTechLine 
	PRIMARY KEY (customTechLineDbk)
;


ALTER TABLE CustomMaterial ADD CONSTRAINT PK_CustomMaterial 
	PRIMARY KEY (customMaterialDbk)
;


ALTER TABLE PlantEquipment ADD CONSTRAINT PK_PlantCapability 
	PRIMARY KEY (plantEquipmentDbk)
;


ALTER TABLE CustomEquipment ADD CONSTRAINT PK_CustomEquipment 
	PRIMARY KEY (customEquipmentDbk)
;


ALTER TABLE PlantCapability ADD CONSTRAINT PK_PlantCapability 
	PRIMARY KEY (plantCapabilityDbk)
;


ALTER TABLE CustomSubcapability ADD CONSTRAINT PK_CustomSubcapability 
	PRIMARY KEY (customSubcapabilityDbk)
;


ALTER TABLE SubCapabilityType ADD CONSTRAINT PK_SubCapabilityType 
	PRIMARY KEY (subcapability)
;


ALTER TABLE CapabilityType ADD CONSTRAINT PK_CapabilityType 
	PRIMARY KEY (capability)
;


ALTER TABLE LandfillSampleGroupType ADD CONSTRAINT PK_LandfillSampleGroupType 
	PRIMARY KEY (landfillSampleGroup)
;


ALTER TABLE GeochemistryGroupType ADD CONSTRAINT PK_GeochemistryGroupType 
	PRIMARY KEY (geochemistryGroup)
;


ALTER TABLE GeochemistryType ADD CONSTRAINT PK_GeochemistryType 
	PRIMARY KEY (geochemistry)
;


ALTER TABLE LandfillSampleFraction ADD CONSTRAINT PK_LandfillSampleFraction 
	PRIMARY KEY (landfillSampleFractionDbk)
;


ALTER TABLE Users ADD CONSTRAINT PK_Users 
	PRIMARY KEY (userDbk)
;


ALTER TABLE WasteFacilityTypeType ADD CONSTRAINT PK_WasteDataDomainType 
	PRIMARY KEY (wasteFacilityType)
;


ALTER TABLE WasteFacility ADD CONSTRAINT PK_WasteFacility 
	PRIMARY KEY (wasteFacilityDbk)
;


ALTER TABLE FacilityOreMineralogy ADD CONSTRAINT PK_FacilityOreMineralogy 
	PRIMARY KEY (FacilityOreMineralogyDbk)
;


ALTER TABLE FacilityWasteType ADD CONSTRAINT PK_FacilityWasteType 
	PRIMARY KEY (FacilityWasteTypeDbk)
;


ALTER TABLE GeochemistrySample ADD CONSTRAINT PK_GeochemistrySample 
	PRIMARY KEY (geochemistrySampleDbk)
;


ALTER TABLE ExtractiveDumpSample ADD CONSTRAINT PK_ExtractiveDumpSample 
	PRIMARY KEY (extractiveDumpSampleDbk)
;


ALTER TABLE PlantWasteProduced ADD CONSTRAINT PK_PlantWasteProduced 
	PRIMARY KEY (plantWasteProducedDbk)
;


ALTER TABLE PlantFeedingMaterial ADD CONSTRAINT PK_PlantFeedingMaterial 
	PRIMARY KEY (plantFeedingMaterialDbk)
;


ALTER TABLE PlantProduct ADD CONSTRAINT PK_PlantProduct 
	PRIMARY KEY (plantProductDbk)
;


ALTER TABLE ProductType ADD CONSTRAINT PK_ProductType 
	PRIMARY KEY (product)
;


ALTER TABLE PlantStorage ADD CONSTRAINT PK_PlantStorage 
	PRIMARY KEY (plantStorageDbk)
;


ALTER TABLE StorageType ADD CONSTRAINT PK_StorageType 
	PRIMARY KEY (storage)
;


ALTER TABLE PlantTransport ADD CONSTRAINT PK_PlantTransport 
	PRIMARY KEY (plantTransportDbk)
;


ALTER TABLE TransportType ADD CONSTRAINT PK_TransportType 
	PRIMARY KEY (transport)
;


ALTER TABLE TreatmentRecyclingPlant ADD CONSTRAINT PK_TreatmentRecyclingPlant 
	PRIMARY KEY (treatmentRecyclingPlantDbk)
;


ALTER TABLE ExtractiveDump ADD CONSTRAINT PK_ExtractiveDump 
	PRIMARY KEY (extractiveDumpDbk)
;


ALTER TABLE SamplingTechniqueType ADD CONSTRAINT PK_SamplingTechniqueType 
	PRIMARY KEY (samplingTechnique)
;


ALTER TABLE LandfillSample ADD CONSTRAINT PK_LandfillSample 
	PRIMARY KEY (landfillSampleDbk)
;


ALTER TABLE EnergyRecoveryType ADD CONSTRAINT PK_EnergyRecoveryType 
	PRIMARY KEY (energyRecovery)
;


ALTER TABLE CapturedBioGas ADD CONSTRAINT PK_CapturedBioGas 
	PRIMARY KEY (capturedBiogasDbk)
;


ALTER TABLE Operator ADD CONSTRAINT PK_Operator 
	PRIMARY KEY (operatorDbk)
;


ALTER TABLE ProvinceType ADD CONSTRAINT PK_ProvinceType 
	PRIMARY KEY (province)
;


ALTER TABLE MunicipalityType ADD CONSTRAINT PK_MunicipalityType 
	PRIMARY KEY (municipality)
;


ALTER TABLE DumpOreMineralogy ADD CONSTRAINT PK_DumpOreMineralogy 
	PRIMARY KEY (dumpOreMineralogyDbk)
;


ALTER TABLE OreMineralogyType ADD CONSTRAINT PK_OreMineralogyType 
	PRIMARY KEY (oreMineralogy)
;


ALTER TABLE EnvironmentalImpactType ADD CONSTRAINT PK_EnvironmentalImpactType 
	PRIMARY KEY (environmentalImpact)
;


ALTER TABLE FacilityLithology ADD CONSTRAINT PK_FacilityLithology 
	PRIMARY KEY (facilityLithologyDbk)
;


ALTER TABLE LithologyType ADD CONSTRAINT PK_LithologyType 
	PRIMARY KEY (lithology)
;


ALTER TABLE WasteTypeType ADD CONSTRAINT PK_WasteTypeType 
	PRIMARY KEY (wasteType)
;


ALTER TABLE FacilityMiningActivity ADD CONSTRAINT PK_FacilityMiningActivity 
	PRIMARY KEY (facilityMiningActivityDbk)
;


ALTER TABLE  FacilityProcessingActivity ADD CONSTRAINT PK_FacilityProcessingActivity 
	PRIMARY KEY (facilityProcessingActivityDbk)
;


ALTER TABLE ProcessingActivityTypeType ADD CONSTRAINT PK_ProcessingActivityTypeType 
	PRIMARY KEY (processingActivityType)
;


ALTER TABLE MiningActivityTypeType ADD CONSTRAINT PK_MiningActivityTypeType 
	PRIMARY KEY (miningActivityType)
;


ALTER TABLE FacilityCommodity ADD CONSTRAINT PK_FacilityCommodity 
	PRIMARY KEY (facilityCommodityDbk)
;


ALTER TABLE DepositTypeType ADD CONSTRAINT PK_DepositTypeType 
	PRIMARY KEY (depositType)
;


ALTER TABLE MineStatusType ADD CONSTRAINT PK_FacilityStatusType 
	PRIMARY KEY (mineStatus)
;


ALTER TABLE CommodityType ADD CONSTRAINT PK_CommodityType 
	PRIMARY KEY (commodity)
;


ALTER TABLE ExtractiveIndustryFacility ADD CONSTRAINT PK_ExtractiveIndustryFacility 
	PRIMARY KEY (extractiveIndustryFacilityDbk)
;


ALTER TABLE UomAreaType ADD CONSTRAINT PK_UomAreaType 
	PRIMARY KEY (uom)
;


ALTER TABLE UomWeightType ADD CONSTRAINT PK_UomWeightType 
	PRIMARY KEY (uom)
;


ALTER TABLE UomVolumeType ADD CONSTRAINT PK_UomVolumeType 
	PRIMARY KEY (uom)
;


ALTER TABLE CountryType ADD CONSTRAINT PK_CountryType 
	PRIMARY KEY (country)
;


ALTER TABLE LandfillStatusType ADD CONSTRAINT PK_LandfillStatusType 
	PRIMARY KEY (landfillStatus)
;


ALTER TABLE LandfillTypeType ADD CONSTRAINT PK_LandfillTypeType 
	PRIMARY KEY (landfillType)
;


ALTER TABLE LandfillCategoryType ADD CONSTRAINT PK_LandfillCategoryType 
	PRIMARY KEY (landfillCategory)
;


ALTER TABLE RegionType ADD CONSTRAINT PK_RegionType 
	PRIMARY KEY (region)
;


ALTER TABLE EwcType ADD CONSTRAINT PK_EwcType 
	PRIMARY KEY (ewc)
;


ALTER TABLE LandfillEwc ADD CONSTRAINT PK_LandfillEwc 
	PRIMARY KEY (landfillEwcDbk)
;


ALTER TABLE LandfillFacility ADD CONSTRAINT PK_LandfillFacility 
	PRIMARY KEY (LandfillFacilityDbk)
;

ALTER TABLE  FacilityFiles ADD CONSTRAINT PK_FacilityFiles 
	PRIMARY KEY (facilityFileDbk)
;
*/


ALTER TABLE TechLineOutput ADD CONSTRAINT FK_TechLineOutput_CustomMaterial 
	FOREIGN KEY (customMaterialDbk) REFERENCES CustomMaterial (customMaterialDbk)
;

ALTER TABLE TechLineOutput ADD CONSTRAINT FK_TechLineOutput_CustomTechLine 
	FOREIGN KEY (customTechLineDbk) REFERENCES CustomTechLine (customTechLineDbk)
ON DELETE CASCADE
;

ALTER TABLE TechLineInput ADD CONSTRAINT FK_TechLineInput_CustomMaterial 
	FOREIGN KEY (customMaterialDbk) REFERENCES CustomMaterial (customMaterialDbk)
;

ALTER TABLE TechLineInput ADD CONSTRAINT FK_TechLineInput_CustomTechLine 
	FOREIGN KEY (customTechLineDbk) REFERENCES CustomTechLine (customTechLineDbk)
ON DELETE CASCADE
;

ALTER TABLE TechLineStep ADD CONSTRAINT FK_TechLineStep_CustomEquipment 
	FOREIGN KEY (customEquipmentDbk) REFERENCES CustomEquipment (customEquipmentDbk)
;

ALTER TABLE TechLineStep ADD CONSTRAINT FK_TechLineStep_CustomSubcapability 
	FOREIGN KEY (customSubcapabilityDbk) REFERENCES CustomSubcapability (customSubcapabilityDbk)
;

ALTER TABLE TechLineStep ADD CONSTRAINT FK_TechLineStep_PlantTransport 
	FOREIGN KEY (plantTransportDbk) REFERENCES PlantTransport (plantTransportDbk)
;

ALTER TABLE TechLineStep ADD CONSTRAINT FK_TechLineStep_SubCapabilityType 
	FOREIGN KEY (subcapability) REFERENCES SubCapabilityType (subcapability)
;

ALTER TABLE TechLineStep ADD CONSTRAINT FK_TechLineStep_TreatmentRecyclingPlant 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (treatmentRecyclingPlantDbk)
ON DELETE CASCADE
;

ALTER TABLE TechLineStep ADD CONSTRAINT FK_TechLineStep_CustomTechLine 
	FOREIGN KEY (customTechLineDbk) REFERENCES CustomTechLine (customTechLineDbk)
ON DELETE CASCADE;

ALTER TABLE CustomTechLine ADD CONSTRAINT FK_CustomTechLine_Operator 
	FOREIGN KEY (OperatorDbk) REFERENCES Operator (operatorDbk)
ON DELETE CASCADE
;

ALTER TABLE CustomMaterial ADD CONSTRAINT FK_CustomMaterial_Operator 
	FOREIGN KEY (operatorDbk) REFERENCES Operator (operatorDbk)
ON DELETE CASCADE
;

ALTER TABLE PlantEquipment ADD CONSTRAINT FK_PlantEquipment_CustomEquipment 
	FOREIGN KEY (customEquipmentDbk) REFERENCES CustomEquipment (customEquipmentDbk)
;

ALTER TABLE CustomEquipment ADD CONSTRAINT FK_CustomEquipment_Operator 
	FOREIGN KEY (operatorDbk) REFERENCES Operator (operatorDbk)
;

ALTER TABLE PlantCapability ADD CONSTRAINT FK_PlantCapability_CustomSubcapability 
	FOREIGN KEY (customSubcapabilityDbk) REFERENCES CustomSubcapability (customSubcapabilityDbk)
ON DELETE CASCADE
;

ALTER TABLE PlantCapability ADD CONSTRAINT FK_PlantCapability_SubCapabilityType 
	FOREIGN KEY (subcapability) REFERENCES SubCapabilityType (subcapability)
;

ALTER TABLE CustomSubcapability ADD CONSTRAINT FK_CustomSubcapability_CapabilityType 
	FOREIGN KEY (capability) REFERENCES CapabilityType (capability)
;

ALTER TABLE CustomSubcapability ADD CONSTRAINT FK_CustomSubcapability_Operator 
	FOREIGN KEY (operatorDbk) REFERENCES Operator (operatorDbk)
ON DELETE CASCADE
;

ALTER TABLE SubCapabilityType ADD CONSTRAINT FK_SubCapabilityType_CapabilityType 
	FOREIGN KEY (capability) REFERENCES CapabilityType (capability)
;

ALTER TABLE GeochemistryType ADD CONSTRAINT FK_GeochemistryType_GeochemistryGroupType 
	FOREIGN KEY (geochemistryGroup) REFERENCES GeochemistryGroupType (geochemistryGroup)
;

ALTER TABLE LandfillSampleFraction ADD CONSTRAINT FK_LandfillSampleFraction_LandfillSampleGroup 
	FOREIGN KEY (landfillSampleGroup) REFERENCES LandfillSampleGroupType (landfillSampleGroup)
;

ALTER TABLE LandfillSampleFraction ADD CONSTRAINT FK_LandfillSampleFraction_LandfillSample 
	FOREIGN KEY (landfillSampleDbk) REFERENCES LandfillSample (landfillSampleDbk)
ON DELETE CASCADE
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
ON DELETE CASCADE
;

ALTER TABLE FacilityOreMineralogy ADD CONSTRAINT FK_FacilityOreMineralogy_OreMineralogyType 
	FOREIGN KEY (oreMineralogy) REFERENCES OreMineralogyType (oreMineralogy)
;

ALTER TABLE FacilityWasteType ADD CONSTRAINT FK_FacilityWasteType_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE FacilityWasteType ADD CONSTRAINT FK_FacilityWasteType_WasteTypeType 
	FOREIGN KEY (wasteType) REFERENCES WasteTypeType (wasteType)
;

ALTER TABLE GeochemistrySample ADD CONSTRAINT FK_GeochemistrySample_GeochemistryType 
	FOREIGN KEY (geochemistry) REFERENCES GeochemistryType (geochemistry)
;

ALTER TABLE ExtractiveDumpSample ADD CONSTRAINT FK_ExtractiveDumpSample_Dump 
	FOREIGN KEY (extractiveDumpDbk) REFERENCES ExtractiveDump (extractiveDumpDbk)
ON DELETE CASCADE
;

ALTER TABLE ExtractiveDumpSample ADD CONSTRAINT FK_ExtractiveDumpSample_SamplingTechniqueType 
	FOREIGN KEY (samplingTechnique) REFERENCES SamplingTechniqueType (samplingTechnique)
;

ALTER TABLE PlantWasteProduced ADD CONSTRAINT FK_PlantWasteProduced_EwcType 
	FOREIGN KEY (ewc) REFERENCES EwcType (ewc)
;

ALTER TABLE PlantWasteProduced ADD CONSTRAINT FK_PlantWasteProduced_TreatmentRecyclingPlant 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (treatmentRecyclingPlantDbk)
ON DELETE CASCADE
;

ALTER TABLE PlantFeedingMaterial ADD CONSTRAINT FK_PlantFeedingMaterial_EwcType 
	FOREIGN KEY (ewc) REFERENCES EwcType (ewc)
;

ALTER TABLE PlantProduct ADD CONSTRAINT FK_PlantProduct_ProductType 
	FOREIGN KEY (product) REFERENCES ProductType (product)
;

ALTER TABLE PlantProduct ADD CONSTRAINT FK_PlantProduct_TreatmentRecyclingPlant 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (treatmentRecyclingPlantDbk)
ON DELETE CASCADE
;

ALTER TABLE PlantStorage ADD CONSTRAINT FK_PlantStorage_StorageType 
	FOREIGN KEY (storage) REFERENCES StorageType (storage)
;

ALTER TABLE PlantStorage ADD CONSTRAINT FK_PlantStorage_TreatmentRecyclingPlant 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (treatmentRecyclingPlantDbk)
ON DELETE CASCADE
;

ALTER TABLE PlantTransport ADD CONSTRAINT FK_PlantTransport_TransportType 
	FOREIGN KEY (transport) REFERENCES TransportType (transport)
;

ALTER TABLE TreatmentRecyclingPlant ADD CONSTRAINT FK_TreatmentRecyclingPlant_WasteFacility 
	FOREIGN KEY (treatmentRecyclingPlantDbk) REFERENCES WasteFacility (wasteFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE ExtractiveDump ADD CONSTRAINT FK_ExtractiveDump_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE ExtractiveDump ADD CONSTRAINT FK_ExtractiveDump_WasteTypeType 
	FOREIGN KEY (lastWasteType) REFERENCES WasteTypeType (wasteType)
;

ALTER TABLE LandfillSample ADD CONSTRAINT FK_LandfillSample_SamplingTechniqueType 
	FOREIGN KEY (samplingTechnique) REFERENCES SamplingTechniqueType (samplingTechnique)
;

ALTER TABLE LandfillSample ADD CONSTRAINT FK_LandfillSample_LandfillFacility 
	FOREIGN KEY (landfillFacilityDbk) REFERENCES LandfillFacility (LandfillFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE CapturedBioGas ADD CONSTRAINT FK_CapturedBioGas_LandfillFacility 
	FOREIGN KEY (landfillFacilityDbk) REFERENCES LandfillFacility (LandfillFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE DumpOreMineralogy ADD CONSTRAINT FK_DumpOreMineralogy_Dump 
	FOREIGN KEY (extractiveDumpDbk) REFERENCES ExtractiveDump (extractiveDumpDbk)
ON DELETE CASCADE
;

ALTER TABLE DumpOreMineralogy ADD CONSTRAINT FK_DumpOreMineralogy_OreMineralogyType 
	FOREIGN KEY (oreMineralogy) REFERENCES OreMineralogyType (oreMineralogy)
;

ALTER TABLE FacilityLithology ADD CONSTRAINT FK_FacilityLithology_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE FacilityLithology ADD CONSTRAINT FK_FacilityLithology_LithologyType 
	FOREIGN KEY (lithology) REFERENCES LithologyType (lithology)
;

ALTER TABLE FacilityMiningActivity ADD CONSTRAINT FK_FacilityMiningActivity_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE FacilityMiningActivity ADD CONSTRAINT FK_FacilityMiningActivity_MiningActivityTypeType 
	FOREIGN KEY (miningActivityType) REFERENCES MiningActivityTypeType (miningActivityType)
;

ALTER TABLE  FacilityProcessingActivity ADD CONSTRAINT FK_FacilityProcessingActivity_WasteFacility 
	FOREIGN KEY (wasteFacilityDbk) REFERENCES WasteFacility (wasteFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE FacilityCommodity ADD CONSTRAINT FK_FacilityCommodity_CommodityType 
	FOREIGN KEY (commodity) REFERENCES CommodityType (commodity)
;

ALTER TABLE FacilityCommodity ADD CONSTRAINT FK_FacilityCommodity_ExtractiveIndustryFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES ExtractiveIndustryFacility (extractiveIndustryFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE ExtractiveIndustryFacility ADD CONSTRAINT FK_ExtractiveIndustryFacility_DepositTypeType 
	FOREIGN KEY (mineralDeposit) REFERENCES DepositTypeType (depositType)
;

ALTER TABLE ExtractiveIndustryFacility ADD CONSTRAINT FK_ExtractiveIndustryFacility_EnvironmentalImpactType 
	FOREIGN KEY (environmentalImpact) REFERENCES EnvironmentalImpactType (environmentalImpact)
;

ALTER TABLE ExtractiveIndustryFacility ADD CONSTRAINT FK_ExtractiveIndustryFacility_WasteFacility 
	FOREIGN KEY (extractiveIndustryFacilityDbk) REFERENCES WasteFacility (wasteFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE LandfillEwc ADD CONSTRAINT FK_LandfillEwc_EwcType 
	FOREIGN KEY (ewc) REFERENCES EwcType (ewc)
;

ALTER TABLE LandfillEwc ADD CONSTRAINT FK_LandfillEwc_LandfillFacility 
	FOREIGN KEY (landfillFacilityDbk) REFERENCES LandfillFacility (LandfillFacilityDbk)
ON DELETE CASCADE
;

ALTER TABLE LandfillFacility ADD CONSTRAINT FK_LandfillFacility_LandfillCategoryType 
	FOREIGN KEY (landfillCategory) REFERENCES LandfillCategoryType (landfillCategory)
;

ALTER TABLE LandfillFacility ADD CONSTRAINT FK_LandfillFacility_LandfillTypeType 
	FOREIGN KEY (landfillType) REFERENCES LandfillTypeType (landfillType)
;

ALTER TABLE LandfillFacility ADD CONSTRAINT FK_LandfillFacility_EnergyRecoveryType 
	FOREIGN KEY (energyRecovery) REFERENCES EnergyRecoveryType (energyRecovery)
;

ALTER TABLE LandfillFacility ADD CONSTRAINT FK_LandfillFacility_WasteFacility 
	FOREIGN KEY (LandfillFacilityDbk) REFERENCES WasteFacility (wasteFacilityDbk)
ON DELETE CASCADE
;


-- manual addition because of problem with Enterprise Architect

ALTER TABLE PlantCapability ADD CONSTRAINT FK_PlantCapability_TreatmentRecyclingPlant 
	FOREIGN KEY (TreatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (TreatmentRecyclingPlantDbk)
ON DELETE CASCADE
;

ALTER TABLE PlantEquipment ADD CONSTRAINT FK_PlantEquipment_TreatmentRecyclingPlant 
	FOREIGN KEY (TreatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (TreatmentRecyclingPlantDbk)
ON DELETE CASCADE
;

ALTER TABLE PlantFeedingMaterial ADD CONSTRAINT FK_PlantFeedingMaterial_TreatmentRecyclingPlant 
	FOREIGN KEY (TreatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (TreatmentRecyclingPlantDbk)
ON DELETE CASCADE
;

ALTER TABLE PlantTransport ADD CONSTRAINT FK_PlantTransport_TreatmentRecyclingPlant 
	FOREIGN KEY (TreatmentRecyclingPlantDbk) REFERENCES TreatmentRecyclingPlant (TreatmentRecyclingPlantDbk)
ON DELETE CASCADE
;

ALTER TABLE GeochemistrySample ADD CONSTRAINT FK_GeochemistrySample_ExtractiveDumpSample 
	FOREIGN KEY (ExtractiveDumpSampleDbk) REFERENCES ExtractiveDumpSample (ExtractiveDumpSampleDbk)
ON DELETE CASCADE
;

ALTER TABLE FacilityFile ADD CONSTRAINT FK_FacilityFile_WasteFacility 
	FOREIGN KEY (wasteFacilityDbk) REFERENCES WasteFacility (wasteFacilityDbk)
ON DELETE CASCADE
;



