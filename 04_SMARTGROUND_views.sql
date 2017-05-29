
CREATE OR REPLACE FUNCTION uniq_words(text)
RETURNS text AS $$
SELECT array_to_string(ARRAY(SELECT DISTINCT trim(x) FROM
unnest(string_to_array($1,' ')) x),' ')
$$ LANGUAGE sql;

ALTER FUNCTION uniq_words(text) OWNER TO sgadmin;


-- ******* WasteFacilityAllTypes
CREATE OR REPLACE VIEW WasteFacilityAllTypes_vw AS
SELECT 
	CASE WHEN m.landfillCategory IS NULL THEN '' ELSE m.landfillCategory END || 
	CASE WHEN m.landfillType IS NULL THEN '' ELSE m.landfillType END || 
	CASE WHEN f.oreMinerals IS NULL THEN '' ELSE f.oreMinerals END || 
	CASE WHEN ww.wasteType IS NULL THEN '' ELSE ww.wasteType END || 
	CASE WHEN a.miningActivityType IS NULL THEN '' ELSE a.miningActivityType END || 
	CASE WHEN h.hostRock IS NULL THEN '' ELSE h.hostRock END || 
	CASE WHEN r.commodity IS NULL THEN '' ELSE r.commodity END ||
	CASE WHEN e.ewckeywords IS NULL THEN '' ELSE e.ewckeywords END ||
	CASE WHEN tt.transport IS NULL THEN '' ELSE tt.transport END ||
	CASE WHEN ts.storage IS NULL THEN '' ELSE ts.storage END ||
	CASE WHEN tp.treatmentproducts IS NULL THEN '' ELSE tp.treatmentproducts END ||
	CASE WHEN te.EwcTreatmentkeywords IS NULL THEN '' ELSE te.EwcTreatmentkeywords END as Filter, -- big concatenation to search relevant keyword

	w.wasteFacilityDbk, 
	w.name, 
	w.wasteFacilityType as Category, 
	w.address, 
	CASE WHEN o.nameIsPrivate = 'Y' THEN null ELSE o.nameOperator END as nameOperator, -- if the name of operator is private it is not shown
	
	CASE WHEN (m.landfillCategory || ', ' || m.landfillType = ', ') THEN NULL
						WHEN (m.landfillCategory IS NULL) THEN m.landfillType
						WHEN (m.landfillType IS NULL) THEN m.landfillCategory
						ELSE m.landfillCategory || ', ' || m.landfillType
						END as Subcategories, -- concatenation MSW category & type

-- Info to be displayed in the alltypes list of resulsts						
	
	e.ewckeywords,
	'; ' || e.ewc as ewc,   -- concatenation to enable search of first numbers of the codes, e.g. search "; 12" for chapter 12
	r.commodity,
	f.OreMinerals,
	ww.wasteType,
	a.miningActivityType,
	h.hostRock,
	
--Geographic columns:	
	c.country as countrycode,
	c.name as countryname,
	rr.region as regioncode,
	rr.name as regionname,
	p.province as provincecode,
	p.name as provincename,
	mm.municipality as municipalitycode,
	mm.name as municipalityname,
--common attributes:
	w.depth,
	w.area,
	w.volume,
	w.weight,
	w.beginOperation,
	w.endOperation,
	w.isAnalysis,
	w.sourceAnalysis,
	w.images,
	w.observations,
	w.status,
	w.studies,
	w.isdraft,
	
-- Operator attributes
	o.postalAddress as OperatorAddress,
	o.email as OperatorEmail,
	o.telephoneNumbers as OperatorTelephone,
	o.nameContactPerson as OperatorContact,
	o.Description as OperatorDescription,

	pp.processingActivityType,
-- MSW attributes	
	m.landfillCategory,
	m.landfillType,
	m.solarEnergyPlant,
	m.energyRecovery,
	CASE WHEN (m.energyRecovery IS NULL OR m.energyRecovery = 'nosystem') THEN 'N'
						ELSE 'Y'
						END as IsEnergyRecovery, -- 

-- Mining attributes
	ee.environmentalImpact,
	ee.mineralDeposit,
	ee.mineStatus,
	ee.beginLastExploitation,
	ee.endLastExploitation,
	ee.mineLastOperator,
	ee.isRehabilitation,
	ee.studyDeposit,
-- Dump samples
    ds.IsSample,  -- yes if there is samples either in MSW (MunicipalDumpSample) or Mining (ExtractiveDumpSample)
	ds.NumberMiningSamples,    -- if usefull we can merge both number samples into one column
	ds.NumberMSWSamples,
-- Biogas measurements
	b.IsBiogas,
	b.NumberBiogasMeasurements,
	
-- Treatment plants
	'; ' || te.EwcTreatment as EwcTreatment,   -- concatenation to enable search of first numbers of the codes, e.g. search "; 12" for chapter 12
	te.EwcTreatmentkeywords,
	tt.transport,
	ts.storage,
	tp.treatmentproducts,
	CASE WHEN (w.wasteFacilityType = 'Landfill') THEN m.landfillCategory
						ELSE w.wasteFacilityType
						END as MapLayers, 
	
    w.geometry
FROM  WasteFacility w 
LEFT OUTER JOIN ExtractiveIndustryFacility ee on (ee.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)
LEFT OUTER JOIN (  -- if we don't need to concatenate landfillcategory & landfilltype we can get rid of this select, a join of the whole table will do
		SELECT m.municipalConstructionFacilityDbk,
				m.energyRecovery,
				m.solarEnergyPlant,
				m.landfillCategory,
				m.landfillType
		FROM  MunicipalConstructionFacility m) as m
ON (m.municipalConstructionFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN Operator o on (o.operatorDbk = w.operatorDbk)
LEFT OUTER JOIN CountryType c ON (c.country = w.country)
LEFT OUTER JOIN RegionType rr ON (rr.region = w.region)
LEFT OUTER JOIN ProvinceType p ON (p.province = w.province)
LEFT OUTER JOIN MunicipalityType mm ON (mm.municipality = w.municipality)


LEFT OUTER JOIN (
		SELECT  wasteFacilityDbk, 
				string_agg(processingActivityType, ', ') as processingActivityType
		FROM  FacilityProcessingActivity
		GROUP BY wasteFacilityDbk) as pp
ON (w.wasteFacilityDbk = pp.wasteFacilityDbk)

LEFT OUTER JOIN (
		SELECT m.municipalConstructionFacilityDbk, string_agg(e.ewc, '; ') as ewc, 
		uniq_words(string_agg(t.keywords, ' ')) as ewckeywords
				
		FROM  MunicipalConstructionFacility m 
		LEFT OUTER JOIN LandfillEwc e on (m.municipalConstructionFacilityDbk = e.municipalConstructionFacilityDbk)
		LEFT OUTER JOIN EwcType t ON (e.ewc = t.ewc)
		GROUP BY m.municipalConstructionFacilityDbk) as e
ON (e.municipalConstructionFacilityDbk = w.wasteFacilityDbk)


LEFT OUTER JOIN (
		SELECT e.extractiveIndustryFacilityDbk, 
				string_agg(r.commodity, ', ') AS commodity

		FROM  ExtractiveIndustryFacility e 
		LEFT OUTER JOIN FacilityCommodity r on (e.extractiveIndustryFacilityDbk = r.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) as r 
ON (r.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN (
		SELECT e.extractiveIndustryFacilityDbk, 
				string_agg(f.oreMineralogy, ', ') as OreMinerals
				
		FROM  ExtractiveIndustryFacility e 
		LEFT OUTER JOIN FacilityOreMineralogy f on (e.extractiveIndustryFacilityDbk = f.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) as f
ON (f.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN (
		SELECT e.extractiveIndustryFacilityDbk, 
				string_agg(f.wasteType, ', ') as wasteType
		FROM  ExtractiveIndustryFacility e 
		LEFT OUTER JOIN FacilityWasteType f on (e.extractiveIndustryFacilityDbk = f.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) as ww 
ON (ww.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN (
		SELECT e.extractiveIndustryFacilityDbk, 
				string_agg(f.miningActivityType, ', ') as miningActivityType
		FROM  ExtractiveIndustryFacility e 
		LEFT OUTER JOIN FacilityMiningActivity f on (e.extractiveIndustryFacilityDbk = f.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) as a
ON (a.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN (
		SELECT e.extractiveIndustryFacilityDbk, 
				string_agg(f.lithology, ', ') as hostRock
		FROM  ExtractiveIndustryFacility e 
		LEFT OUTER JOIN FacilityLithology f on (e.extractiveIndustryFacilityDbk = f.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) as h
ON (h.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN(
		SELECT 
			w.wasteFacilityDbk, 
			CASE WHEN MAX(md.extractiveDumpDbk) IS NULL AND MAX(ds.dumpId) IS NULL THEN 'N' ELSE 'Y' END as IsSample,
			count(md.extractiveDumpSampleDbk) AS NumberMiningSamples,
			count(ds.municipalDumpSampleDbk) AS NumberMSWSamples
			
		FROM  WasteFacility w 
		LEFT OUTER JOIN ExtractiveDump d ON (d.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)
		LEFT OUTER JOIN extractiveDumpSample md ON (md.extractiveDumpDbk = d.extractiveDumpDbk)
		LEFT OUTER JOIN MunicipalDumpSample ds ON (ds.municipalConstructionFacilityDbk = w.wasteFacilityDbk)
		GROUP BY w.wasteFacilityDbk) as ds
ON (ds.wasteFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN(
		SELECT 
			w.wasteFacilityDbk, 
			CASE WHEN MAX(c.gasCaptured) IS NULL THEN 'N' ELSE 'Y' END as IsBiogas,
			count(c.gasCaptured) AS NumberBiogasMeasurements
		FROM  WasteFacility w 
		LEFT OUTER JOIN CapturedBioGas c ON (c.municipalConstructionFacilityDbk = w.wasteFacilityDbk)
		GROUP BY w.wasteFacilityDbk) as b
ON (b.wasteFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN (
	SELECT codes.treatmentRecyclingPlantDbk, 
		string_agg(codes.ewc, '; ') as EwcTreatment, 
		uniq_words(string_agg(t.keywords, ' ')) as EwcTreatmentkeywords 
	FROM  (
		select treatmentRecyclingPlantDbk, ewc
		from plantFeedingMaterial 
		union 
		select treatmentRecyclingPlantDbk, ewc from 
		plantWasteProduced 
		group by treatmentRecyclingPlantDbk, ewc
		order by treatmentrecyclingplantDbk, ewc) as codes
	LEFT OUTER JOIN EwcType t ON (codes.ewc = t.ewc)
	GROUP BY codes.treatmentRecyclingPlantDbk
	ORDER BY codes.treatmentRecyclingPlantDbk) as te
ON (te.treatmentRecyclingPlantDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
				string_agg(transport, ', ') as transport
		FROM  PlantTransport
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as tt
ON (w.wasteFacilityDbk = tt.treatmentRecyclingPlantDbk)


LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
				string_agg(storage, ', ') as storage
		FROM  PlantStorage
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as ts
ON (w.wasteFacilityDbk = ts.treatmentRecyclingPlantDbk)

LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
				string_agg(product, ', ') || ', ' || string_agg(byproduct, ', ') as treatmentproducts
		FROM  PlantProduct
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as tp
ON (w.wasteFacilityDbk = tp.treatmentRecyclingPlantDbk)


ORDER BY w.wasteFacilityDbk
;



-- **** WasteFacilityArea

--***********************
-- ALL waste facilities
-- one row per facility
-- includes country, region, province, municipality
CREATE OR REPLACE VIEW WasteFacilityArea_vw AS
SELECT w.wasteFacilityDbk, w.country, w.wasteFacilityType as Type, c.name as CountryName, w.region, r.name as RegionName, w.province, p.name as ProvinceName, w.municipality, m.name as MunicipalityName, w.geometry
FROM WasteFacility w, CountryType c, ProvinceType p, MunicipalityType m, RegionType r 
WHERE  w.country=c.country AND
w.province=p.province AND
w.municipality = m.municipality AND
w.region = r.region
ORDER BY w.wasteFacilityDbk
;



-- **** MunicipalFacilityDetail_vw

--***********************
CREATE OR REPLACE VIEW MunicipalFacilityDetail_vw AS
SELECT
    w.wasteFacilityDbk,
	w.name,
	w.address,
	c.name as CountryName,
	r.name as RegionName,
	p.name as ProvinceName,
	m.name as MunicipalityName,
	w.depth,
	w.area,
	w.volume,
	w.weight,
	w.beginOperation,
	w.endOperation,
	w.isAnalysis,
	w.sourceAnalysis,
	w.images,
	w.observations,
	w.wasteFacilityType,
	w.status,
	w.studies,
	w.geometry,
	w.stgeom,
	
	o.nameOperator as OperatorName,
	o.postalAddress as OperatorAddress,
	o.email as OperatorEmail,
	o.telephoneNumbers as OperatorTelephone,
	o.nameContactPerson as OperatorContact,
	o.Description as OperatorDescription,

	-- pp.processingActivityType, MSW landfill do not have processing activity
	
	mm.landfillCategory,
	mm.landfillType,
	mm.energyRecovery,
	mm.solarEnergyPlant

FROM  WasteFacility w 
LEFT OUTER JOIN Operator o ON (o.operatorDbk = w.operatorDbk)
LEFT OUTER JOIN CountryType c ON (w.country=c.country)
LEFT OUTER JOIN ProvinceType p ON (w.province=p.province)
LEFT OUTER JOIN MunicipalityType m ON (w.municipality = m.municipality)
LEFT OUTER JOIN  RegionType r ON (w.region = r.region)
LEFT OUTER JOIN (
		SELECT  wasteFacilityDbk, 
				string_agg(processingActivityType, ', ') as processingActivityType
		FROM  FacilityProcessingActivity
		GROUP BY wasteFacilityDbk
		ORDER BY wasteFacilityDbk) as pp
ON (w.wasteFacilityDbk = pp.wasteFacilityDbk)
LEFT OUTER JOIN municipalConstructionFacility mm ON (w.wasteFacilityDbk = mm.municipalConstructionFacilityDbk)
ORDER BY wasteFacilityDbk
;



-- **** LandfillEwcDetail_vw

-- assume that if endyear is null there is only one row per ewccode (per facility)
--***********************
CREATE OR REPLACE VIEW LandfillEwcDetail_vw AS
SELECT
    m.municipalConstructionFacilityDbk as FacilityId,
	e.landfillEwcDbk,
	e.ewc,
	e.year,
	e.weight,
	et.name as description,
	w.geometry
FROM WasteFacility w 
INNER JOIN MunicipalConstructionFacility m ON (w.wasteFacilityDbk = m.municipalConstructionFacilityDbk)
INNER JOIN LandfillEwc e ON (e.municipalConstructionFacilityDbk = m.municipalConstructionFacilityDbk)
LEFT OUTER JOIN EwcType et ON (et.ewc = e.ewc)
order by FacilityId
;


-- **** MunicipalDumpSampleDetail_vw

--***********************
CREATE OR REPLACE VIEW MunicipalDumpSampleDetail_vw AS
SELECT
	d.municipalConstructionFacilityDbk as FacilityId,
	d.dumpId,
	d.samplingDate,
	d.samplingTechnique,
	d.numberSamplingWell,
	d.samplingDepth,
	d.weightSmallFractions,
	d.weightMediumFractions,
	d.weightBigFractions,
	d.weightMetalBigFraction,
	d.weightEnergyBigFraction,
	d.weightTextileBigFraction,
	d.weightPlasticBigFraction,
	d.weightWoodBigFraction,
	d.weightPaperBigFraction,
	d.weightSoilBigFraction,
	d.weightMetalMediumFraction,
	d.weightEnergyMediumFraction,
	d.weightTextileMediumFraction,
	d.weightPlasticMediumFraction,
	d.weightWoodMediumFraction,
	d.weightPaperMediumFraction,
	d.weightSoilMediumFraction,
	d.compositionSmallFraction,
	d.rareEarthMetalSmallFraction,
	d.platinumGroupMetalSmallFraction,
	d.otherMetalSmallFraction,
	d.calorificValueBigFraction,
	d.calorificValueMediumFraction,
	d.Model3D,
	d.thematicMap,
	d.gisData,	
	w.geometry
FROM WasteFacility w 
INNER JOIN MunicipalConstructionFacility m ON (w.wasteFacilityDbk = m.municipalConstructionFacilityDbk)
INNER JOIN MunicipalDumpSample d ON (d.municipalConstructionFacilityDbk = m.municipalConstructionFacilityDbk)
ORDER BY d.municipalDumpSampleDbk
;


-- **** CapturedBioGasDetail_vw

--***********************
CREATE OR REPLACE VIEW CapturedBioGasDetail_vw AS
SELECT
	c.municipalConstructionFacilityDbk as FacilityId,
	c.year,
	c.gasCaptured,
	w.geometry
FROM WasteFacility w 
INNER JOIN MunicipalConstructionFacility m ON (w.wasteFacilityDbk = m.municipalConstructionFacilityDbk)
INNER JOIN CapturedBioGas c ON (c.municipalConstructionFacilityDbk = m.municipalConstructionFacilityDbk)

ORDER BY FacilityId
;

-- **** CountryDistinct_vw

--***********************
CREATE OR REPLACE VIEW CountryDistinct_vw AS
SELECT DISTINCT
	c.name as countryname,
	c.country as countrycode,
	--n.geometry
	MAX(w.geometry)::geometry as geometry -- geometry column is needed to publish it via GeoServer. Any geometry will do, like max
FROM WasteFacility w
LEFT OUTER JOIN CountryType c ON (c.country = w.country)
--LEFT OUTER JOIN NUTSType n ON (n.nuts_id = c.country)  -- idea to create NutsType table
GROUP BY countryname, countrycode  -- this aggregation is needed to obtain the max geometry
ORDER BY countryname
;

-- **** RegionDistinct_vw

--***********************
CREATE OR REPLACE VIEW RegionDistinct_vw AS
SELECT DISTINCT
	r.name as regionname,
	r.region as regioncode,
	c.country as countrycode,
	MAX(w.geometry)::geometry as geometry -- geometry column is needed to publish it via GeoServer. Any geometry will do, like max
FROM WasteFacility w
LEFT OUTER JOIN RegionType r ON (r.region = w.region)
LEFT OUTER JOIN CountryType c ON (c.country = w.country)
GROUP BY regionname, regioncode, countrycode  -- this aggregation is needed to obtain the max geometry
ORDER BY regionname
;

-- **** ProvinceDistinct_vw

--***********************
CREATE OR REPLACE VIEW ProvinceDistinct_vw AS
SELECT DISTINCT
	p.name as provincename,
	p.province as provincecode,
	r.region as regioncode,
	MAX(w.geometry)::geometry as geometry -- geometry column is needed to publish it via GeoServer. Any geometry will do, like max	
FROM WasteFacility w
LEFT OUTER JOIN ProvinceType p ON (p.province = w.province)
LEFT OUTER JOIN RegionType r ON (r.region = w.region)
LEFT OUTER JOIN CountryType c ON (c.country = w.country)
GROUP BY provincename, provincecode, regioncode  -- this aggregation is needed to obtain the max geometry
ORDER BY provincename
;

-- **** MunicipalityDistinct_vw

--***********************
CREATE OR REPLACE VIEW MunicipalityDistinct_vw AS
SELECT DISTINCT
	m.name as municipalityname,
	m.municipality as municipalitycode,
	p.province as provincecode,
	MAX(w.geometry)::geometry as geometry -- geometry column is needed to publish it via GeoServer. Any geometry will do, like max	
FROM WasteFacility w
LEFT OUTER JOIN MunicipalityType m ON (m.municipality = w.municipality)
LEFT OUTER JOIN ProvinceType p ON (p.province = w.province)
LEFT OUTER JOIN RegionType r ON (r.region = w.region)
LEFT OUTER JOIN CountryType c ON (c.country = w.country)
GROUP BY municipalityname, municipalitycode, provincecode  -- this aggregation is needed to obtain the max geometry
ORDER BY municipalityname
;





-- **** ExtractiveIndustryFacilityDetail_vw

--***********************
CREATE OR REPLACE VIEW ExtractiveIndustryFacilityDetail_vw AS
SELECT
    w.wasteFacilityDbk,
	w.name,
	w.address,
	c.name as CountryName,
	r.name as RegionName,
	p.name as ProvinceName,
	m.name as MunicipalityName,
	w.depth,
	w.area,
	w.volume,
	w.weight,
	w.beginOperation,
	w.endOperation,
	w.isAnalysis,
	w.sourceAnalysis,
	w.images,
	w.observations,
	w.wasteFacilityType,
	w.status,
	w.studies,
	w.geometry,
	w.stgeom,
	
	o.nameOperator as OperatorName,
	o.postalAddress as OperatorAddress,
	o.email as OperatorEmail,
	o.telephoneNumbers as OperatorTelephone,
	o.nameContactPerson as OperatorContact,
	o.Description as OperatorDescription,

	pp.processingActivityType,
	
	e.environmentalImpact,
	e.mineralDeposit,
	e.mineStatus,
	e.beginLastExploitation,
	e.endLastExploitation,
	e.mineLastOperator,
	e.isRehabilitation,
	e.studyDeposit,
	
	rr.RelevantElements,
	mm.MainCommodity,
	
	f.OreMineralogy,
	
	ww.WasteType

FROM  WasteFacility w 
LEFT OUTER JOIN Operator o ON (o.operatorDbk = w.operatorDbk)
LEFT OUTER JOIN CountryType c ON (w.country=c.country)
LEFT OUTER JOIN ProvinceType p ON (w.province=p.province)
LEFT OUTER JOIN MunicipalityType m ON (w.municipality = m.municipality)
LEFT OUTER JOIN  RegionType r ON (w.region = r.region)
LEFT OUTER JOIN (
		SELECT  wasteFacilityDbk, 
				string_agg(processingActivityType, ', ') as processingActivityType
		FROM  FacilityProcessingActivity
		GROUP BY wasteFacilityDbk
		ORDER BY wasteFacilityDbk) as pp
ON (w.wasteFacilityDbk = pp.wasteFacilityDbk)
INNER JOIN ExtractiveIndustryFacility e ON (w.wasteFacilityDbk = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN (
		SELECT 	e.extractiveIndustryFacilityDbk,
				string_agg(r.commodity, ', ') as RelevantElements
		FROM ExtractiveIndustryFacility e
		LEFT OUTER JOIN FacilityCommodity r on (e.extractiveIndustryFacilityDbk = r.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) AS rr
ON (rr.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN (
		SELECT  r.extractiveIndustryFacilityDbk AS Id, 
				string_agg(r.commodity, ', ') AS MainCommodity
        FROM    FacilityCommodity r
        WHERE   r.mainCommodity = 'TRUE'
        GROUP BY r.extractiveIndustryFacilityDbk) as mm
ON (mm.Id = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN (
		SELECT 	e.extractiveIndustryFacilityDbk,
				string_agg(f.oreMineralogy, ', ') as OreMineralogy
		FROM ExtractiveIndustryFacility e
		LEFT OUTER JOIN FacilityOreMineralogy f on (e.extractiveIndustryFacilityDbk = f.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) AS f
ON (f.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN (
		SELECT 	e.extractiveIndustryFacilityDbk,
				string_agg(f.wasteType, ', ') as WasteType
		FROM ExtractiveIndustryFacility e
		LEFT OUTER JOIN FacilityWasteType f on (e.extractiveIndustryFacilityDbk = f.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) AS ww
ON (ww.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)

ORDER BY wasteFacilityDbk
;

-- **** ExtractiveDumpDetail_vw

--***********************

CREATE OR REPLACE VIEW ExtractiveDumpDetail_vw AS
SELECT
    e.extractiveIndustryFacilityDbk,
	d.extractiveDumpDbk,
	f.OreMineralogy,
	d.lastWasteType,
	w.geometry
FROM  ExtractiveIndustryFacility e 
INNER JOIN ExtractiveDump d ON (d.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN (
		SELECT 	d.extractiveDumpDbk,
			string_agg(f.oreMineralogy, ', ') as OreMineralogy
		FROM ExtractiveDump d
		LEFT OUTER JOIN DumpOreMineralogy f on (d.extractiveDumpDbk = f.extractiveDumpDbk)
		GROUP BY d.extractiveDumpDbk) AS f
ON (d.extractiveDumpDbk = f.extractiveDumpDbk)
LEFT OUTER JOIN wastefacility w ON (w.wastefacilityDbk = e.ExtractiveIndustryFacilityDbk)
ORDER BY extractiveDumpDbk
;


	
-- **** ExtractiveSampleDetail_vw

--***********************

CREATE OR REPLACE VIEW ExtractiveSampleDetail_vw AS
SELECT
    d.extractiveIndustryFacilityDbk,
	d.extractiveDumpDbk,
	m.sampleCode,
	m.weight,
	m.mass,
	m.humidity,
	m.samplingTechnique,
	m.geometry as geometrySample,
	w.geometry as geometryFacility
	
FROM WasteFacility w
INNER JOIN ExtractiveIndustryFacility e ON (w.wasteFacilityDbk = e.extractiveIndustryFacilityDbk)
INNER JOIN ExtractiveDump d ON (d.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
INNER JOIN extractiveDumpSample m ON (m.extractiveDumpDbk = d.extractiveDumpDbk)

ORDER BY extractiveDumpSampleDbk
;



-- **** CommoditiesDistinct_vw
-- list of commodities in FacilityCommodity, commodities used by the facilities
--***********************
CREATE OR REPLACE VIEW CommoditiesDistinct_vw AS
SELECT DISTINCT
	r.commodity,
	c.description
FROM FacilityCommodity r
LEFT OUTER JOIN CommodityType c ON (c.commodity = r.commodity)
ORDER BY commodity
;



-- **** OreMineralogyDistinct_vw
-- it includes values from 2 tables: dumporemineralogy and facilityoremineralogy, in case some mineral is only in one table
--***********************
CREATE OR REPLACE VIEW OreMineralogyDistinct_vw AS
select distinct 
	d.oremineralogy,
	o.symbol -- instead of description, because description is empty
from dumporemineralogy d
LEFT OUTER JOIN OreMineralogyType o ON (o.oreMineralogy = d.oreMineralogy)
union 
select 
	f.oremineralogy,
	o.symbol -- instead of description, because description is empty
from facilityoremineralogy f
LEFT OUTER JOIN OreMineralogyType o ON (o.oreMineralogy = f.oreMineralogy)
order by oremineralogy
;


-- **** WasteTypeDistinct_vw

--***********************
CREATE OR REPLACE VIEW WasteTypeDistinct_vw AS
SELECT DISTINCT
	f.wasteType,
	w.description
FROM FacilityWasteType f 
LEFT OUTER JOIN WasteTypeType w ON (w.wasteType = f.wasteType)
ORDER BY f.wasteType
;


-- **** MiningActivityDistinct_vw

--***********************
CREATE OR REPLACE VIEW MiningActivityDistinct_vw AS
SELECT DISTINCT
	f.miningActivityType,
	m.description
FROM FacilityMiningActivity f 
LEFT OUTER JOIN MiningActivityTypeType m ON (f.miningActivityType = m.miningActivityType)
ORDER BY f.miningActivityType
;

-- **** LithologyDistinct_vw

--***********************
CREATE OR REPLACE VIEW LithologyDistinct_vw AS
SELECT DISTINCT
	f.lithology,
	l.description
FROM FacilityLithology f 
LEFT OUTER JOIN LithologyType l ON (l.lithology = f.lithology)
ORDER BY f.lithology
;




-- **** GeoChemistryDetail_vw

--***********************

CREATE OR REPLACE VIEW GeoChemistryDetail_vw AS
SELECT
    d.extractiveIndustryFacilityDbk,
	d.extractiveDumpDbk,
	g.extractiveDumpSampleDbk,
	g.Al,
	g.Al2O3,
	g.Ca,
	g.CaO,
	g.Fetot,
	g.FeOtot,
	g.Fe2O3tot,
	g.FeO,
	g.Fe2O3,
	g.K,
	g.K2O,
	g.Mg,
	g.MgO,
	g.Na,
	g.Na2O,
	g.Si,
	g.SiO2,
	g.Ag,
	g.As,
	g.Au,
	g.B,
	g.Ba,
	g.Be,
	g.Bi,
	g.Cd,
	g.Cl,
	g.Co,
	g.Cr,
	g.Cs,
	g.Cu,
	g.F,
	g.Ga,
	g.Ge,
	g.Hf,
	g.Hg,
	g.In, 
	g.Li,
	g.Mn,
	g.Mo,
	g.Nb,
	g.Ni,
	g.P,
	g.Pb,
	g.Rb,
	g.Re,
	g.S,
	g.Sb,
	g.Se,
	g.Sn,
	g.Sr,
	g.Ta,
	g.Te,
	g.Th,
	g.Tl,
	g.U,
	g.V,
	g.W,
	g.Zn,
	g.Zr,
	g.Sc,
	g.Y,
	g.La,
	g.Ce,
	g.Pr,
	g.Nd,
	g.Sm,
	g.Eu,
	g.Gd,
	g.Tb,
	g.Dy,
	g.Ho,
	g.Er,
	g.Tm,
	g.Yb,
	g.Lu,
	g.Ru,
	g.Rh,
	g.Pd,
	g.Os,
	g.Ir,
	g.Pt,
	m.geometry -- geometry of the sample
FROM WasteFacility w
INNER JOIN ExtractiveIndustryFacility e ON (w.wasteFacilityDbk = e.extractiveIndustryFacilityDbk)
INNER JOIN ExtractiveDump d ON (d.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
INNER JOIN extractiveDumpSample m ON (m.extractiveDumpDbk = d.extractiveDumpDbk)
INNER JOIN Geochemistry g ON (g.extractiveDumpSampleDbk = m.extractiveDumpSampleDbk)

ORDER BY geochemistryDbk
;


-- **** EwcDistinct_vw

--***********************
CREATE OR REPLACE VIEW EwcDistinct_vw AS
SELECT DISTINCT
	m.ewc,
	e.name
FROM LandfillEwc m 
LEFT OUTER JOIN EwcType e ON (m.ewc = e.ewc)
ORDER BY ewc
;



-- **** LandfillTypeDistinct_vw

--***********************
CREATE OR REPLACE VIEW LandfillTypeDistinct_vw AS
SELECT DISTINCT
	m.landfillType
FROM MunicipalConstructionFacility m 
LEFT OUTER JOIN LandfillTypeType l ON (m.landfillType = l.landfillType)
ORDER BY landfillType
;


-- **** EnergyRecoveryTypeDistinct_vw

--***********************
CREATE OR REPLACE VIEW EnergyRecoveryTypeDistinct_vw AS
SELECT DISTINCT
	m.energyRecovery
FROM MunicipalConstructionFacility m 
LEFT OUTER JOIN EnergyRecoveryType e ON (m.energyRecovery = e.energyRecovery)
ORDER BY energyRecovery
;

-- **** LandfillCategoryDistinct_vw

--***********************
CREATE OR REPLACE VIEW LandfillCategoryDistinct_vw AS
SELECT DISTINCT
	m.landfillCategory
FROM MunicipalConstructionFacility m 
LEFT OUTER JOIN LandfillCategoryType l ON (m.landfillcategory = l.landfillcategory)
ORDER BY landfillcategory
;


-- **** MineStatusDistinct_vw

--***********************
CREATE OR REPLACE VIEW MineStatusDistinct_vw AS
SELECT DISTINCT
	e.mineStatus
FROM ExtractiveIndustryFacility e
LEFT OUTER JOIN MineStatusType m ON (m.mineStatus = e.mineStatus)
ORDER BY mineStatus
;


-- **** EnvironmentalImpactDistinct_vw

--***********************
CREATE OR REPLACE VIEW EnvironmentalImpactDistinct_vw AS
SELECT DISTINCT
	e.environmentalImpact
FROM ExtractiveIndustryFacility e
LEFT OUTER JOIN EnvironmentalImpactType i ON (i.environmentalImpact = e.environmentalImpact)
ORDER BY environmentalImpact
;


-- **** DepositTypeDistinct_vw

--***********************
CREATE OR REPLACE VIEW DepositTypeDistinct_vw AS
SELECT DISTINCT
	e.mineralDeposit
FROM ExtractiveIndustryFacility e
LEFT OUTER JOIN DepositTypeType d ON (d.depositType = e.mineralDeposit)
ORDER BY mineralDeposit
;


-- **** TreatmentRecyclingPlantDetail_vw

--***********************
CREATE OR REPLACE VIEW TreatmentRecyclingPlantDetail_vw AS
SELECT
    w.wasteFacilityDbk,
	w.name,
	w.address,
	c.name as CountryName,
	r.name as RegionName,
	p.name as ProvinceName,
	m.name as MunicipalityName,
	w.status,
	w.depth,
	w.area,
	w.volume,
	w.weight,
	w.beginOperation,
	w.endOperation,
	w.isAnalysis,
	w.sourceAnalysis,
	w.images,
	w.observations,
	w.wasteFacilityType,
	w.studies,
	w.geometry,
	w.stgeom,
	
	o.nameOperator as OperatorName,
	o.postalAddress as OperatorAddress,
	o.email as OperatorEmail,
	o.telephoneNumbers as OperatorTelephone,
	o.nameContactPerson as OperatorContact,
	o.Description as OperatorDescription,

	pp.processingActivityType,

	pt.transport,
	ps.storage,
	tp.product, --probably we will move info of product and byproduct to a separate tab (because there are amounts) in that case these columns (tp) will be removed
	tp.byproduct

FROM  WasteFacility w 
INNER JOIN TreatmentRecyclingPlant tr ON (tr.treatmentRecyclingPlantDbk = w.wasteFacilityDbk)
LEFT OUTER JOIN Operator o ON (o.operatorDbk = w.operatorDbk)
LEFT OUTER JOIN CountryType c ON (w.country=c.country)
LEFT OUTER JOIN ProvinceType p ON (w.province=p.province)
LEFT OUTER JOIN MunicipalityType m ON (w.municipality = m.municipality)
LEFT OUTER JOIN  RegionType r ON (w.region = r.region)
LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
				string_agg(transport, ', ') as transport
		FROM  PlantTransport
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as pt
ON (w.wasteFacilityDbk = pt.treatmentRecyclingPlantDbk)
LEFT OUTER JOIN (
		SELECT  wasteFacilityDbk, 
				string_agg(processingActivityType, ', ') as processingActivityType
		FROM  FacilityProcessingActivity
		GROUP BY wasteFacilityDbk
		ORDER BY wasteFacilityDbk) as pp
ON (w.wasteFacilityDbk = pp.wasteFacilityDbk)
LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
				string_agg(storage, ', ') as storage
		FROM  PlantStorage
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as ps
ON (w.wasteFacilityDbk = ps.treatmentRecyclingPlantDbk)
LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
				string_agg(product, ', ') as product,
				string_agg(byproduct, ', ') as byproduct
		FROM  PlantProduct
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as tp
ON (w.wasteFacilityDbk = tp.treatmentRecyclingPlantDbk)
ORDER BY wasteFacilityDbk
;


-- **** TreatmentPlantProductDetail_vw

--***********************
CREATE OR REPLACE VIEW TreatmentPlantProductDetail_vw1 AS
select treatmentRecyclingPlantDbk, product, byproduct, weight
from PlantProduct 
order by treatmentrecyclingplantDbk
;

-- ****   HAY QUE DECIDIR UNA (vw1) U OTRA (vw2) ¿hace falta la geometria todavía?

CREATE OR REPLACE VIEW TreatmentPlantProductDetail_vw2 AS
select treatmentRecyclingPlantDbk, product, weight, CASE WHEN product IS NOT NULL THEN 'P' ELSE '' END as KK
from PlantProduct where product is not null
UNION
select treatmentRecyclingPlantDbk, byproduct, weight, CASE WHEN product IS NULL THEN 'B' ELSE '' END as KK
from PlantProduct where product is null
order by treatmentRecyclingPlantDbk, KK
;

-- **** TreatmentPlantFeedingMaterialDetail_vw

--***********************
CREATE OR REPLACE VIEW TreatmentPlantFeedingMaterialDetail_vw AS
SELECT
    t.treatmentRecyclingPlantDbk as FacilityId,
	p.ewc,
	p.year,
	p.weight,
	et.name as description,
	w.geometry
FROM WasteFacility w 
INNER JOIN TreatmentRecyclingPlant t ON (w.wasteFacilityDbk = t.treatmentRecyclingPlantDbk)
INNER JOIN PlantFeedingMaterial p ON (p.treatmentRecyclingPlantDbk = t.treatmentRecyclingPlantDbk)
LEFT OUTER JOIN EwcType et ON (et.ewc = p.ewc)
order by FacilityId
;

-- **** TreatmentPlantWasteProducedDetail_vw

--***********************
CREATE OR REPLACE VIEW TreatmentPlantWasteProducedDetail_vw AS
SELECT
    t.treatmentRecyclingPlantDbk as FacilityId,
	p.ewc,
	p.weight,
	et.name as description,
	w.geometry
FROM WasteFacility w 
INNER JOIN TreatmentRecyclingPlant t ON (w.wasteFacilityDbk = t.treatmentRecyclingPlantDbk)
INNER JOIN PlantWasteProduced p ON (p.treatmentRecyclingPlantDbk = t.treatmentRecyclingPlantDbk)
LEFT OUTER JOIN EwcType et ON (et.ewc = p.ewc)
order by FacilityId
;


-- **** FeedingMaterialDistinct_vw
-- list of ewc used in PlantFeedingMaterials by the treatment plants
--***********************
CREATE OR REPLACE VIEW FeedingMaterialDistinct_vw AS
SELECT DISTINCT
	p.ewc,
	e.name
FROM PlantFeedingMaterial p
LEFT OUTER JOIN EwcType e ON (e.ewc = p.ewc)
ORDER BY ewc
;


-- **** WasteProducedDistinct_vw
-- list of ewc used in PlantWasteProduced by the treatment plants
--***********************
CREATE OR REPLACE VIEW WasteProducedDistinct_vw AS
SELECT DISTINCT
	p.ewc,
	e.name
FROM PlantWasteProduced p
LEFT OUTER JOIN EwcType e ON (e.ewc = p.ewc)
ORDER BY ewc
;

-- **** EwcTreatmentDistinct_vw
-- list of ewc used in PlantWasteProduced by the treatment plants
--***********************
CREATE OR REPLACE VIEW EwcTreatmentDistinct_vw AS
SELECT DISTINCT
	f.ewc,
	e.name
FROM PlantFeedingMaterial f
LEFT OUTER JOIN EwcType e ON (e.ewc = f.ewc)
UNION
SELECT DISTINCT
	p.ewc,
	e.name
FROM PlantWasteProduced p
LEFT OUTER JOIN EwcType e ON (e.ewc = p.ewc)
ORDER BY ewc
;


-- **** PlantTransportDistinct_vw
-- 
--***********************
CREATE OR REPLACE VIEW PlantTransportDistinct_vw AS
SELECT DISTINCT
	e.name,
	e.description
FROM PlantTransport p
LEFT OUTER JOIN TransportType e ON (e.transport = p.transport)
ORDER BY name
;

-- **** PlantStorageDistinct_vw
-- 
--***********************
CREATE OR REPLACE VIEW PlantStorageDistinct_vw AS
SELECT DISTINCT
	e.name,
	e.description
FROM PlantStorage p
LEFT OUTER JOIN StorageType e ON (e.storage = p.storage)
ORDER BY name
;

-- **** PlantProductDistinct_vw
-- list of ewc used in PlantWasteProduced by the treatment plants
--***********************
CREATE OR REPLACE VIEW PlantProductDistinct_vw AS
SELECT DISTINCT
	e.name as product,
	e.description
FROM PlantProduct p
LEFT OUTER JOIN ProductType e ON (e.product = p.product)
ORDER BY product
;


-- **** PlantByProductDistinct_vw
-- list of ewc used in PlantWasteProduced by the treatment plants
--***********************
CREATE OR REPLACE VIEW PlantByProductDistinct_vw AS
SELECT DISTINCT
	e.name as byproduct,
	e.description
FROM PlantProduct p
LEFT OUTER JOIN ProductType e ON (e.product = p.byproduct)
ORDER BY byproduct
;

-- **** TreatmentProductDistinct_vw
-- list of products used either as products or by-products in treatment plants
--***********************
CREATE OR REPLACE VIEW TreatmentProductDistinct_vw AS
SELECT DISTINCT
	e.name as product,
	e.description
FROM PlantProduct p
LEFT OUTER JOIN ProductType e ON (e.product = p.product)
UNION
SELECT DISTINCT
	e.name,
	e.description
FROM PlantProduct p
LEFT OUTER JOIN ProductType e ON (e.product = p.byproduct)
ORDER BY product
;

