


-- FUNCTIONS

--FUNCTION uniq_words

CREATE OR REPLACE FUNCTION uniq_words(text)
RETURNS text AS $$
SELECT array_to_string(ARRAY(SELECT DISTINCT trim(x) FROM
unnest(string_to_array($1,' ')) x),' ')
$$ LANGUAGE sql;

ALTER FUNCTION uniq_words(text) OWNER TO sgadmin;

--FUNCTION isnumeric (Used to convert text to numeric in the geochemistry table)

CREATE OR REPLACE FUNCTION isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

ALTER FUNCTION isnumeric(text) OWNER TO sgadmin;

--FUNCTION db_to_csv (backup utility)
-- this will create one csv file per table
-- use like this: SELECT db_to_csv('/home/user/dir');

CREATE OR REPLACE FUNCTION db_to_csv(path TEXT) RETURNS void AS $$
declare
   tables RECORD;
   statement TEXT;
begin
FOR tables IN 
   SELECT (table_schema || '.' || table_name) AS schema_table
   FROM information_schema.tables t INNER JOIN information_schema.schemata s 
   ON s.schema_name = t.table_schema 
   WHERE t.table_schema NOT IN ('pg_catalog', 'information_schema')
   AND t.table_type NOT IN ('VIEW')
   ORDER BY schema_table
LOOP
   statement := 'COPY ' || tables.schema_table || ' TO ''' || path || '/' || tables.schema_table || '.csv' ||''' DELIMITER '';'' CSV HEADER';
   EXECUTE statement;
END LOOP;
return;  
end;
$$ LANGUAGE plpgsql;




-- TechlineDetail_vw
-- I don't name it 'Custom..' because each row indicates the facility

CREATE OR REPLACE VIEW techlineDetail_vw AS
select 
	s.treatmentrecyclingplantdbk,
	--s.techlinestepdbk,
	s.customtechlinedbk,
	l.initialFacility,
	l.name as techlinename,
	CASE WHEN l.isimplemented IS TRUE THEN 'Yes' ELSE 'No' END as Isimplemented,
	l.fnpv_c::integer,
	l.fnpv_k::integer,
	l.enpv::integer,
	l.financialfeasibility,
	l.yearFinancial,
	l.env_gwp as env_gwp, -- Climate changes, incl.biogenic carbon 
	l.env_agri_land as env_agri_land, -- Agricultural land occupation [m2]
	l.env_gwp_exl  as env_gwp_exl, -- Climate change, default, excl biogenic carbon [kg CO2]
	l.env_adp_fossil  as env_adp_fossil, -- Fossil depletion [kg oil ]
	l.env_faetp  as env_faetp, -- Freshwater ecotoxicity [kg 1,4 DB]
	l.env_ep  as env_ep, -- Freshwater eutrophication [kg P]
	l.env_htp  as env_htp, -- Human toxicity [kg 1,4 DB]
	l.env_ion_rad  as env_ion_rad, -- Ionising radiation [kg U235]
	l.env_maetp  as env_maetp, -- Marine ecotoxicity [kg 1,4 DB]
	l.env_marine_eutr  as env_marine_eutr, -- Marine eutrophication [kg N]
	l.env_adp  as env_adp, -- Metal depletion [kg Fe]
	l.env_natur_land  as env_natur_land, -- Natural land transformation [m2]
	l.env_part_mat as env_part_mat, -- Particulate matter formation [kg PM10]
	l.env_pocp as env_pocp, -- Photochemical oxidant formation [kg NMVOC]
	l.env_ap as env_ap, -- Terrestrial acidification [kg SO2]
	l.env_tetp as env_tetp, -- Terrestrial ecotoxicity [kg 1,4 DB]
	l.env_urna_land  as env_urna_land, -- Urban land occupation [m2a]
	l.env_wd  as env_wd, -- Water depletion [m3]
	l.env_odp as env_odp, -- Ozone depletion [kg CFC-11]
	l.env_normalizedWeighted as env_NormalisedWeighted, -- normalised and weighted impacts
	l.yearEnvironmental, -- year of analysis
	l.method -- Method of analysis (text)	
from techlinestep s
LEFT JOIN customtechline l ON  s.customtechlinedbk = l.customtechlinedbk
LEFT JOIN operator o ON o.operatordbk = l.operatordbk
group by s.treatmentrecyclingplantdbk, s.customtechlinedbk,
	l.initialFacility, l.name, l.isimplemented, l.fnpv_c, l.fnpv_k, l.enpv, l.financialfeasibility, l.yearFinancial, l.env_gwp, l.env_agri_land,
	l.env_gwp_exl, l.env_adp_fossil, l.env_faetp, l.env_ep, l.env_htp, l.env_ion_rad, l.env_maetp, l.env_marine_eutr, l.env_adp, l.env_natur_land,
	l.env_part_mat, l.env_pocp, l.env_ap, l.env_tetp, l.env_urna_land, l.env_wd, l.env_odp, l.env_normalizedWeighted, l.yearEnvironmental, l.method
order by treatmentrecyclingplantdbk, s.customtechlinedbk
;


-- techlineinputPlantDetail_vw
-- this view is used for the public visualisation of facility info
CREATE OR REPLACE VIEW techlineinputPlantDetail_vw AS
SELECT  s.treatmentrecyclingplantdbk,
	s.customtechlinedbk,
	CASE WHEN m.custommaterial IS NULL THEN '' ELSE m.custommaterial END || CASE WHEN p.product IS NULL THEN '' ELSE p.product END as input,
	i.inputpercent as inputratio
FROM techlinestep s
LEFT JOIN customtechline t On s.customtechlinedbk = t.customtechlinedbk
LEFT JOIN techlineinput i ON i.customtechlinedbk = t.customtechlinedbk
LEFT JOIN custommaterial m ON m.customMaterialDbk = i.customMaterialDbk
LEFT JOIN productType p ON p.product = i.product
GROUP BY treatmentrecyclingplantdbk, s.customtechlinedbk, input, inputratio
order by treatmentrecyclingplantdbk, s.customtechlinedbk, inputratio
;


-- techlineoutputPlantDetail_vw
-- this view is used for the public visualisation of facility info
CREATE OR REPLACE VIEW techlineoutputPlantDetail_vw AS
SELECT  s.treatmentrecyclingplantdbk,
	s.customtechlinedbk,
	CASE WHEN m.custommaterial IS NULL THEN '' ELSE m.custommaterial END || CASE WHEN p.product IS NULL THEN '' ELSE p.product END as output,
	o.outputpercent as outputratio, -- percent of output material in overall outputs
	o.productioncost as "productioncost [eur/kg]" -- production cost (eur/kg)
FROM techlinestep s
LEFT JOIN customtechline t On s.customtechlinedbk = t.customtechlinedbk
LEFT JOIN techlineoutput o ON o.customtechlinedbk = t.customtechlinedbk
LEFT JOIN custommaterial m ON m.customMaterialDbk = o.customMaterialDbk
LEFT JOIN productType p ON p.product = o.product
GROUP BY treatmentrecyclingplantdbk, s.customtechlinedbk, output, outputratio, "productioncost [eur/kg]"
order by treatmentrecyclingplantdbk, customtechlinedbk, outputratio
;


-- ******* WasteFacilityAllTypes
CREATE OR REPLACE VIEW WasteFacilityAllTypes_vw AS
SELECT 
	CASE WHEN w.name IS NULL THEN '' ELSE lower(w.name) END ||
	CASE WHEN m.landfillCategory IS NULL THEN '' ELSE lower(m.landfillCategory) END || 
	CASE WHEN m.landfillType IS NULL THEN '' ELSE lower(m.landfillType) END || 
	CASE WHEN f.oreMinerals IS NULL THEN '' ELSE lower(f.oreMinerals) END || 
	CASE WHEN ww.wasteType IS NULL THEN '' ELSE lower(ww.wasteType) END || 
	CASE WHEN a.miningActivityType IS NULL THEN '' ELSE lower(a.miningActivityType) END || 
	CASE WHEN h.hostRock IS NULL THEN '' ELSE lower(h.hostRock) END || 
	CASE WHEN r.commodity IS NULL THEN '' ELSE lower(r.commodity) END ||
	CASE WHEN e.ewckeywords IS NULL THEN '' ELSE lower(e.ewckeywords) END ||
	CASE WHEN tt.transport IS NULL THEN '' ELSE lower(tt.transport) END ||
	CASE WHEN ts.storage IS NULL THEN '' ELSE lower(ts.storage) END ||
	CASE WHEN tp.treatmentproducts IS NULL THEN '' ELSE lower(tp.treatmentproducts) END ||
	CASE WHEN te.EwcTreatmentkeywords IS NULL THEN '' ELSE lower(te.EwcTreatmentkeywords) END as Filter, -- big concatenation to search relevant keyword
		
	w.wasteFacilityDbk, 
	w.name, 
	w.wasteFacilityType as Category, 
	w.address, 
	CASE WHEN o.nameIsPrivate = 'Y' THEN null ELSE o.nameOperator END as nameOperator, -- if the name of operator is private it is not shown
	o.operatorDbk,
	
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
	ds.NumberLandfillSamples,
-- Biogas measurements
	b.IsBiogas,
	b.NumberBiogasMeasurements,
	
-- Treatment plants
	tr.economyIncome,
	tr.employmentEducation,
	tr.landuseTerritory,
	tr.demography,
	tr.environmentHealth,
	tr.yearSLCA,
	CASE WHEN tr.economyIncome >= 0 AND tr.employmentEducation >= 0 AND tr.landuseTerritory >= 0 AND tr.demography >= 0 AND tr.environmentHealth >= 0 
	THEN true else false end as SLCAattitude, -- Selection of sites where the attitude for LFM activity is neutral or positive, when SLCA values >=0
	'; ' || te.EwcTreatment as EwcTreatment,   -- concatenation to enable search of first numbers of the codes, e.g. search "; 12" for chapter 12
	te.EwcTreatmentkeywords,
	tt.transport,
	ts.storage,
	tp.treatmentproducts,
	tc.subcapability,
	fp.fnpv_c,
	fp.fnpv_k,
	fp.enpv,
	CASE WHEN ti.techlineinput Is null then null else ',' || ti.techlineinput END as techlineinput,
	CASE WHEN tl.techlineoutput Is null then null else ',' || tl.techlineoutput END as techlineoutput,
-- subcapabilities	
	CASE WHEN (w.wasteFacilityType = 'Landfill') THEN m.landfillCategory
						ELSE w.wasteFacilityType
						END as MapLayers, 
	
    w.geometry
FROM  WasteFacility w 
LEFT OUTER JOIN ExtractiveIndustryFacility ee on (ee.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)
LEFT OUTER JOIN (  -- if we don't need to concatenate landfillcategory & landfilltype we can get rid of this select, a join of the whole table will do
		SELECT m.landfillFacilityDbk,
				m.energyRecovery,
				m.solarEnergyPlant,
				m.landfillCategory,
				m.landfillType
		FROM  LandfillFacility m) as m
ON (m.landfillFacilityDbk = w.wasteFacilityDbk)

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
		SELECT m.landfillFacilityDbk, string_agg(e.ewc, '; ') as ewc, 
		uniq_words(string_agg(t.keywords, ' ')) as ewckeywords
				
		FROM  LandfillFacility m 
		LEFT OUTER JOIN LandfillEwc e on (m.landfillFacilityDbk = e.landfillFacilityDbk)
		LEFT OUTER JOIN EwcType t ON (e.ewc = t.ewc)
		GROUP BY m.landfillFacilityDbk) as e
ON (e.landfillFacilityDbk = w.wasteFacilityDbk)

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
			CASE WHEN MAX(md.extractiveDumpDbk) IS NULL AND MAX(ls.sampleId) IS NULL THEN 'N' ELSE 'Y' END as IsSample,
			count(md.extractiveDumpSampleDbk) AS NumberMiningSamples,
			count(ls.landfillSampleDbk) AS NumberLandfillSamples
			
		FROM  WasteFacility w 
		LEFT OUTER JOIN ExtractiveDump d ON (d.extractiveIndustryFacilityDbk = w.wasteFacilityDbk)
		LEFT OUTER JOIN extractiveDumpSample md ON (md.extractiveDumpDbk = d.extractiveDumpDbk)
		LEFT OUTER JOIN LandfillSample ls ON (ls.landfillFacilityDbk = w.wasteFacilityDbk)
		GROUP BY w.wasteFacilityDbk) as ds
ON (ds.wasteFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN(
		SELECT 
			w.wasteFacilityDbk, 
			CASE WHEN MAX(c.gasCaptured) IS NULL THEN 'N' ELSE 'Y' END as IsBiogas,
			count(c.gasCaptured) AS NumberBiogasMeasurements
		FROM  WasteFacility w 
		LEFT OUTER JOIN CapturedBioGas c ON (c.landfillFacilityDbk = w.wasteFacilityDbk)
		GROUP BY w.wasteFacilityDbk) as b
ON (b.wasteFacilityDbk = w.wasteFacilityDbk)

LEFT OUTER JOIN TreatmentRecyclingPlant tr ON (tr.treatmentRecyclingPlantDbk = w.wasteFacilityDbk)

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

LEFT OUTER JOIN (
		SELECT  sc.treatmentRecyclingPlantDbk, 
				string_agg(sc.subcapability, ', ') as subcapability
		FROM (	SELECT 
					p.treatmentrecyclingplantdbk,
					CASE WHEN p.customsubcapabilitydbk IS NULL THEN s.name ELSE c.customsubcapability END as subcapability
				from plantcapability p
				LEFT OUTER JOIN SubCapabilityType s ON (s.subcapability = p.subcapability)
				LEFT OUTER JOIN CustomSubcapability c ON (p.customsubcapabilitydbk=c.customsubcapabilitydbk)
				order by p.treatmentrecyclingplantdbk) as sc
		GROUP BY treatmentrecyclingplantdbk) as tc
ON (w.wasteFacilityDbk = tc.treatmentRecyclingPlantDbk)

LEFT OUTER JOIN (
		select 
			treatmentrecyclingplantdbk,
			bool_or(fnpv_c > 0) as fnpv_c, --true if at least there is one technology line with fnpv_c positive, otherwise false
			bool_or(fnpv_k > 0) as fnpv_k, --true if at least there is one technology line with fnpv_c positive, otherwise false
			bool_or(enpv > 0) as enpv --true if at least there is one technology line with fnpv_c positive, otherwise false
		from techlinedetail_vw
		group by treatmentrecyclingplantdbk
		) as fp --finantial possibilities
ON (fp.treatmentrecyclingplantdbk = w.wasteFacilityDbk)

LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
				string_agg(input, ', ') as techlineinput
		FROM techlineinputplantdetail_vw
		GROUP BY treatmentrecyclingplantdbk
		) as ti
ON (ti.treatmentrecyclingplantdbk = w.wasteFacilityDbk)
		
LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
				string_agg(output, ', ') as techlineoutput
		FROM techlineoutputplantdetail_vw
		GROUP BY treatmentrecyclingplantdbk
		) as tl
ON (tl.treatmentrecyclingplantdbk = w.wasteFacilityDbk)
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






-- ***
-- *** LANDFILL AMOUNT CALCULATIONS
-- **
/*
SPECIFICATIONS, EXAMPLE OF CALCULATIONS FOR ONE FACILITY WITH 5 SAMPLES
Average of metals in collected samples (closed area)			8.1		calculation 1
Average of energy fraction in collected samples (closed area)	120.9	calculation 2
					
Total weight of sample collected from DH1						406.0	calculation 3
Total weight of sample collected from DH2a						192.3		
Total weight of sample collected from DH3						277.4		
Total weight of sample collected from DH2a						282.2		
Total weight of sample collected from DH3						284.4		
								
Percentual amount of metals in landfill (closed area)			2.8	%	calculation 4
Percentual amount of energy fraction in landfill (closed area)	41.9%	calculation 5
					
Total amount of waste in landfill (closed area)					960000000kg	calculation 6
					
Total amount of metals in landfill								26824	calculation 7
Total amount of energy fraction in landfill						402357		
*/


CREATE OR REPLACE VIEW LandfillSampleFractionNumeric_vw AS
--This view checks that the values of LandfillSampleFraction are numeric (not character strings)
--and changes values with prefix '<' into '0', because this happens when the value is near zero.
select 
	s.landfillfacilitydbk,
	l.landfillSampleFractiondbk,
	l.landfillSampleDbk,
	l.landfillSampleGroup,
	CASE WHEN isnumeric(samplevalue) IS true then to_number(samplevalue, '999999.99')
		WHEN samplevalue like '>%' THEN NULL -- add here the resulting value in case of '>'
		WHEN samplevalue like '<%' THEN '0' 
		ELSE NULL END as num_samplevalue
from LandfillSampleFraction l
inner join LandfillSample s ON (l.landfillsampleDbk = s.landfillsampleDbk)
order by s.landfillfacilitydbk, landfillSampleFractiondbk
;
--*******************************************************

-- calculation 1
CREATE OR REPLACE VIEW LandfillAvgMetal_vw AS
select a.landfillfacilitydbk,
	sum(a.avgMetal) as avgMetal
from (
	select 
		f.landfillfacilitydbk, 
		f.landfillsamplegroup,
		avg(f.num_samplevalue) as avgMetal
	from LandfillSampleFractionNumeric_vw f
	WHERE landfillsamplegroup in ('MetalBigFraction', 'MetalMediumFraction')
	group by f.landfillfacilitydbk, f.landfillsamplegroup
	order by f.landfillfacilitydbk, f.landfillsamplegroup) a
group by a.landfillfacilitydbk
;
--********************************************************

--OK
CREATE OR REPLACE VIEW LandfillAvgBig_vw AS
select a.landfillfacilitydbk,
	avg(a.TotalBigEnergyFraction) as avgTotalBigEnergyFraction
FROM (
	select
		landfillfacilitydbk, 
		landfillSampledbk,
		sum(num_samplevalue) as TotalBigEnergyFraction
	FROM LandfillSampleFractionNumeric_vw
	where landfillsamplegroup in ('TextileBigFraction', 'PlasticBigFraction', 'WoodBigFraction', 'PaperBigFraction')
	GROUP BY landfillfacilitydbk, landfillSampledbk
	order by landfillfacilitydbk, landfillSampledbk
) a
GROUP BY a.landfillfacilitydbk
;
--***************************************************************
-- OK
CREATE OR REPLACE VIEW LandfillAvgMedium_vw AS
select a.landfillfacilitydbk,
	avg(a.TotalMediumEnergyFraction) as avgTotalMediumEnergyFraction
FROM (
	select
		landfillfacilitydbk, 
		landfillSampledbk,
		sum(num_samplevalue) as TotalMediumEnergyFraction
	FROM LandfillSampleFractionNumeric_vw
	where landfillsamplegroup in ('TextileMediumFraction', 'PlasticMediumFraction', 'WoodMediumFraction', 'PaperMediumFraction')
	GROUP BY landfillfacilitydbk, landfillSampledbk
	order by landfillfacilitydbk, landfillSampledbk
) a
GROUP BY a.landfillfacilitydbk
;
--************************************************************

-- This is Calculation #2
CREATE OR REPLACE VIEW LandfillAvgEnergyFraction_vw As
select 
	b.landfillfacilitydbk,
	m.avgtotalMediumEnergyFraction,
	b.avgTotalBigEnergyFraction,
	m.avgtotalMediumEnergyFraction + b.avgTotalBigEnergyFraction as AvgEnergyFraction
from LandfillAvgBig_vw b, LandfillAvgMedium_vw m
WHERE b.landfillfacilitydbk = m.landfillfacilitydbk
;
--*******************************************************************

-- This is calculation #3
CREATE OR REPLACE VIEW LandfillTotalWeightofSample_vw As
select
	landfillfacilitydbk, 
	landfillSampledbk,
	sum(num_samplevalue) as TotalWeightofSample
FROM LandfillSampleFractionNumeric_vw
where landfillsamplegroup in ('SmallSorted', 'MediumSorted', 'BigSorted')
GROUP BY landfillfacilitydbk, landfillSampledbk
order by landfillfacilitydbk, landfillSampledbk
;
--*******************************************************************

CREATE OR REPLACE VIEW LandfillPercentualAmount_vw As
SELECT 
	a.landfillfacilitydbk, 
	d.volume * 1000 as FacilityVolume,    -- Calculation 6
	a.avgMetal,
	b.AvgEnergyFraction,
	AVG(c.TotalWeightofSample) as AvgTotalWeightofSample,
	a.avgMetal / AVG(c.TotalWeightofSample) * 100 as PercentualAmountMetals,  -- Calculation 4
	b.AvgEnergyFraction / AVG(c.TotalWeightofSample) * 100 as PercentualAmountEnergy,  -- Calculation 5
	round(cast(a.avgMetal / AVG(c.TotalWeightofSample) * d.volume as numeric), 2) AS TotalMetal,  -- Calculation 7 (a.avgMetal / AVG(c.TotalWeightofSample) * 100) / 100 * (d.volume * 1000) / 1000 AS TotalMetal
	round(cast(b.AvgEnergyFraction / AVG(c.TotalWeightofSample) * d.volume as numeric), 2) AS TotalEnergy  -- Calculation 7 (b.AvgEnergyFraction / AVG(c.TotalWeightofSample) * 100) / 100 * (d.volume * 1000) / 1000 AS TotalMetal
FROM LandfillAvgMetal_vw a, LandfillAvgEnergyFraction_vw b, LandfillTotalWeightofSample_vw c, WasteFacility d
WHERE a.landfillfacilitydbk = b.landfillfacilitydbk and b.landfillfacilitydbk = c.landfillfacilitydbk and a.landfillfacilitydbk = d.wastefacilityDbk
GROUP BY a.landfillfacilitydbk, a.avgMetal, b.AvgEnergyFraction, d.volume
;
--*********************************************************************




CREATE OR REPLACE VIEW LandfillSampleDetail_vw As
select 
-- *   I can use '*' and avoid the long list of columns, but the landfillsampledbk would be repeated for each samplegroup
	z.landfillfacilitydbk, 
	a.landfillsampledbk,
	ls.sampleId,
	ls.samplingdate,
	ls.samplingtechnique,
	ls.numbersamplingwell,
	ls.samplingdepth,
	ls.model3d,
	ls.thematicmap,
	ls.gisdata,
	a.SmallSorted,
	b.MediumSorted,
	c.BigSorted,
	d.MetalBigFraction,
	e.TotalBigFraction, --sum
	f.TextileBigFraction,
	g.PlasticBigFraction,
	h.WoodBigFraction,
	i.PaperBigFraction,
	j.SoilBigFraction,
	k.MetalMediumFraction,
	l.TotalMediumFraction, --sum
	m.TextileMediumFraction,
	n.PlasticMediumFraction,
	o.WoodMediumFraction,
	p.PaperMediumFraction,
	q.SoilMediumFraction,
	r.CompositionSmallFraction,
	s.RareEarthMetalSmallFraction,
	t.PlatinumGroupMetalSmallFraction,
	u.OtherMetalSmallFraction,
	v.CalorificValueBigFraction,
	w.CalorificValueMediumFraction
	from 
( select 
	landfillsampledbk,
	num_samplevalue as SmallSorted from LandfillSampleFractionNumeric_vw 
	where landfillsamplegroup = 'SmallSorted') a

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as MediumSorted from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'MediumSorted') b 
ON a.landfillsampledbk = b.landfillsampledbk 

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as BigSorted from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'BigSorted') c
ON a.landfillsampledbk = c.landfillsampledbk


LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as MetalBigFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'MetalBigFraction') d
ON a.landfillsampledbk = d.landfillsampledbk

LEFT JOIN ( select
		landfillSampledbk,
		sum(num_samplevalue) as TotalBigFraction
	FROM LandfillSampleFractionNumeric_vw
	where landfillsamplegroup in ('TextileBigFraction', 'PlasticBigFraction', 'WoodBigFraction', 'PaperBigFraction')
	GROUP BY landfillSampledbk) e
ON a.landfillsampledbk = e.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as TextileBigFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'TextileBigFraction') f
ON a.landfillsampledbk = f.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as PlasticBigFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'PlasticBigFraction') g
ON a.landfillsampledbk = g.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as WoodBigFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'WoodBigFraction') h
ON a.landfillsampledbk = h.landfillsampledbk
	
LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as PaperBigFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'PaperBigFraction') i
ON a.landfillsampledbk = i.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as SoilBigFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'SoilBigFraction') j
ON a.landfillsampledbk = j.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as MetalMediumFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'MetalMediumFraction') k
ON a.landfillsampledbk = k.landfillsampledbk

LEFT JOIN ( select
		landfillSampledbk,
		sum(num_samplevalue) as TotalMediumFraction
	FROM LandfillSampleFractionNumeric_vw
	where landfillsamplegroup in ('TextileMediumFraction', 'PlasticMediumFraction', 'WoodMediumFraction', 'PaperMediumFraction')
	GROUP BY landfillSampledbk) l
ON a.landfillsampledbk = l.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as TextileMediumFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'TextileMediumFraction') m
ON a.landfillsampledbk = m.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as PlasticMediumFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'PlasticMediumFraction') n
ON a.landfillsampledbk = n.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as WoodMediumFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'WoodMediumFraction') o
ON a.landfillsampledbk = o.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as PaperMediumFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'PaperMediumFraction') p
ON a.landfillsampledbk = p.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as SoilMediumFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'SoilMediumFraction') q
ON a.landfillsampledbk = q.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as CompositionSmallFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'CompositionSmallFraction') r
ON a.landfillsampledbk = r.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as RareEarthMetalSmallFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'RareEarthMetalSmallFraction') s
ON a.landfillsampledbk = s.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as PlatinumGroupMetalSmallFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'PlatinumGroupMetalSmallFraction') t
ON a.landfillsampledbk = t.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as OtherMetalSmallFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'OtherMetalSmallFraction') u
ON a.landfillsampledbk = u.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as CalorificValueBigFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'CalorificValueBigFraction') v
ON a.landfillsampledbk = v.landfillsampledbk

LEFT JOIN ( select 
	landfillsampledbk,
	num_samplevalue as CalorificValueMediumFraction from LandfillSampleFractionNumeric_vw where landfillsamplegroup = 'CalorificValueMediumFraction') w
ON a.landfillsampledbk = w.landfillsampledbk

LEFT JOIN ( select
	landfillsampledbk,
	landfillfacilitydbk
	from landfillsample) z
On a.landfillsampledbk = z.landfillsampledbk

LEFT JOIN LandfillSample ls ON (ls.landfillsampledbk = a.landfillsampledbk)
;



-- **** LandfillFacilityDetail_vw

--***********************
CREATE OR REPLACE VIEW LandfillFacilityDetail_vw AS
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
	--mm.energyRecovery,  
	e.name as energyRecovery,
	mm.solarEnergyPlant,
	-- Predictions
	lv.totalmetal,
	lv.totalenergy

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
LEFT OUTER JOIN landfillFacility mm ON (w.wasteFacilityDbk = mm.landfillFacilityDbk)
LEFT OUTER JOIN EnergyRecoveryType e ON (e.energyrecovery = mm.energyrecovery)
LEFT OUTER JOIN LandfillPercentualAmount_vw lv ON (lv.landfillfacilitydbk = mm.landfillFacilityDbk)
ORDER BY wasteFacilityDbk
;



-- **** LandfillEwcDetail_vw

--***********************
CREATE OR REPLACE VIEW LandfillEwcDetail_vw AS
SELECT
    m.landfillFacilityDbk as FacilityId,
	e.landfillEwcDbk,
	e.ewc,
	e.year,
	e.weight,
	et.name as description,
	w.geometry
FROM WasteFacility w 
INNER JOIN LandfillFacility m ON (w.wasteFacilityDbk = m.landfillFacilityDbk)
INNER JOIN LandfillEwc e ON (e.landfillFacilityDbk = m.landfillFacilityDbk)
LEFT OUTER JOIN EwcType et ON (et.ewc = e.ewc)
order by FacilityId
;



-- **** CapturedBioGasDetail_vw

--***********************
CREATE OR REPLACE VIEW CapturedBioGasDetail_vw AS
SELECT
	c.landfillFacilityDbk as FacilityId,
	c.year,
	c.gasCaptured,
	w.geometry
FROM WasteFacility w 
INNER JOIN LandfillFacility m ON (w.wasteFacilityDbk = m.landfillFacilityDbk)
INNER JOIN CapturedBioGas c ON (c.landfillFacilityDbk = m.landfillFacilityDbk)

ORDER BY FacilityId
;

-- **** CountryDistinct_vw

--***********************
CREATE OR REPLACE VIEW CountryDistinct_vw AS
SELECT DISTINCT
	c.name as countryname,
	c.country as countrycode,
	MAX(w.geometry)::geometry as geometry -- geometry column is needed to publish it via GeoServer. Any geometry will do, like max
FROM WasteFacility w
LEFT OUTER JOIN CountryType c ON (c.country = w.country)
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

	pp.processingActivityType, -- name of processingActivityType
		
	e.environmentalImpact,
	-- e.mineralDeposit,
	d.name as mineralDeposit, -- name of mineralDeposit
	e.mineStatus,
	e.beginLastExploitation,
	e.endLastExploitation,
	e.mineLastOperator,
	e.isRehabilitation,
	e.studyDeposit,
	
	rr.RelevantElements,
	mm.MainCommodity,
	
	f.OreMineralogy,
	
	ww.WasteType, --name of wasteType
	
	l.Lithology,
	
	ma.MiningActivity -- name of MiningActivity
	
FROM  WasteFacility w 
LEFT OUTER JOIN Operator o ON (o.operatorDbk = w.operatorDbk)
LEFT OUTER JOIN CountryType c ON (w.country=c.country)
LEFT OUTER JOIN ProvinceType p ON (w.province=p.province)
LEFT OUTER JOIN MunicipalityType m ON (w.municipality = m.municipality)
LEFT OUTER JOIN  RegionType r ON (w.region = r.region)
LEFT OUTER JOIN (
		SELECT  f.wasteFacilityDbk, 
				string_agg(pa.name, ', ') as processingActivityType				
		FROM  FacilityProcessingActivity f
		LEFT OUTER JOIN ProcessingActivityTypeType pa ON (pa.processingActivityType = f.processingActivityType)
		GROUP BY wasteFacilityDbk
		ORDER BY wasteFacilityDbk) as pp
ON (w.wasteFacilityDbk = pp.wasteFacilityDbk)
INNER JOIN ExtractiveIndustryFacility e ON (w.wasteFacilityDbk = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN DepositTypeType d ON (d.depositType = e.mineralDeposit)
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
				string_agg(wt.name, ', ') as WasteType
		FROM ExtractiveIndustryFacility e
		LEFT OUTER JOIN FacilityWasteType f on (e.extractiveIndustryFacilityDbk = f.extractiveIndustryFacilityDbk)
		LEFT OUTER JOIN WasteTypeType wt ON (wt.wasteType = f.wasteType)
		GROUP BY e.extractiveIndustryFacilityDbk) AS ww
ON (ww.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN (
		SELECT 	e.extractiveIndustryFacilityDbk,
				string_agg(l.lithology, ', ') as Lithology
		FROM ExtractiveIndustryFacility e
		LEFT OUTER JOIN FacilityLithology l on (e.extractiveIndustryFacilityDbk = l.extractiveIndustryFacilityDbk)
		GROUP BY e.extractiveIndustryFacilityDbk) AS l
ON (l.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN (
		SELECT 	e.extractiveIndustryFacilityDbk,
				string_agg(mt.name, ', ') as MiningActivity				
		FROM ExtractiveIndustryFacility e
		LEFT OUTER JOIN FacilityMiningActivity m on (e.extractiveIndustryFacilityDbk = m.extractiveIndustryFacilityDbk)
		LEFT OUTER JOIN MiningActivityTypeType mt ON (mt.miningActivityType = m.miningActivityType)
		GROUP BY e.extractiveIndustryFacilityDbk) AS ma
ON (ma.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
ORDER BY wasteFacilityDbk
;




-- **** ExtractiveDumpDetail_vw

--***********************

CREATE OR REPLACE VIEW ExtractiveDumpDetail_vw AS
SELECT
    e.extractiveIndustryFacilityDbk,
	d.extractiveDumpDbk,
	d.dumpCode,
	d.volume,
	d.bulkDensity,
	d.volume * d.bulkDensity as DUMPTONNAGE,
	f.OreMineralogy,
	wt.name as lastWasteType -- name of wasteType
FROM  ExtractiveIndustryFacility e 
INNER JOIN ExtractiveDump d ON (d.extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk)
LEFT OUTER JOIN WasteTypeType wt ON (wt.wasteType = d.lastWasteType)
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
    m.extractiveDumpSampleDbk,
	d.extractiveIndustryFacilityDbk,
	d.extractiveDumpDbk,
	m.sampleCode,
	m.mass,
	m.bulkDensity,
	m.humidity,
	t.name as samplingTechnique, -- name of samplingTechnique
	m.stgeom,
	ST_AsText(m.geometry) as samplecoordinates,
	Al.Al "Al",
	Al2O3.Al2O3 "Al2O3",
	Ca.Ca "Ca",
	CaO.CaO "CaO",
	Fetot.Fetot "Fetot",
	FeOtot.FeOtot "FeOtot",
	Fe2O3tot.Fe2O3tot "Fe2O3tot",
	FeO.FeO "FeO",
	Fe2O3.Fe2O3 "Fe2O3",
	K.K "K",
	K2O.K2O "K2O",
	Mg.Mg "Mg",
	MgO.MgO "MgO",
	Na.Na "Na",
	Na2O.Na2O "Na2O",
	Si.Si "Si",
	SiO2.SiO2 "SiO2",
	Ag.Ag "Ag",
	As1.As "As",
	Au.Au "Au",
	B.B "B",
	Ba.Ba "Ba",
	Be.Be "Be",
	Bi.Bi "Bi",
	Cd.Cd "Cd",
	Cl.Cl "Cl",
	Co.Co "Co",
	Cr.Cr "Cr",
	Cs.Cs "Cs",
	Cu.Cu "Cu",
	F.F "F",
	Ga.Ga "Ga",
	Ge.Ge "Ge",
	Hf.Hf "Hf",
	Hg.Hg "Hg",
	In1.In "In",
	Li.Li "Li",
	Mn.Mn "Mn",
	Mo.Mo "Mo",
	Nb.Nb "Nb",
	Ni.Ni "Ni",
	P.P "P",
	Pb.Pb "Pb",
	Rb.Rb "Rb",
	Re.Re "Re",
	S.S "S",
	Sb.Sb "Sb",
	Se.Se "Se",
	Sn.Sn "Sn",
	Sr.Sr "Sr",
	Ta.Ta "Ta",
	Te.Te "Te",
	Th.Th "Th",
	Tl.Tl "Tl",
	U.U "U",
	V.V "V",
	W.W "W",
	Zn.Zn "Zn",
	Zr.Zr "Zr",
	Sc.Sc "Sc",
	Y.Y "Y",
	La.La "La",
	Ce.Ce "Ce",
	Pr.Pr "Pr",
	Nd.Nd "Nd",
	Sm.Sm "Sm",
	Eu.Eu "Eu",
	Gd.Gd "Gd",
	Tb.Tb "Tb",
	Dy.Dy "Dy",
	Ho.Ho "Ho",
	Er.Er "Er",
	Tm.Tm "Tm",
	Yb.Yb "Yb",
	Lu.Lu "Lu",
	Ru.Ru "Ru",
	Rh.Rh "Rh",
	Pd.Pd "Pd",
	Os.Os "Os",
	Ir.Ir "Ir",
	Pt.Pt "Pt"
FROM ExtractiveDump d 
INNER JOIN extractiveDumpSample m ON (m.extractiveDumpDbk = d.extractiveDumpDbk)
INNER JOIN SamplingTechniqueType t ON (t.samplingTechnique = m.samplingTechnique)
INNER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Al FROM GeochemistrySample Where geochemistry = 'Al') Al ON (m.extractivedumpsampledbk = Al.extractivedumpsampledbk) LEFT OUTER JOIN ( 
SELECT extractivedumpsampledbk, samplevalue as Al2O3 FROM GeochemistrySample Where geochemistry = 'Al2O3') Al2O3 ON (m.extractivedumpsampledbk = Al2O3.extractivedumpsampledbk) LEFT OUTER JOIN ( 
SELECT extractivedumpsampledbk, samplevalue as Ca FROM GeochemistrySample Where geochemistry = 'Ca') Ca ON (m.extractivedumpsampledbk = Ca.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as CaO FROM GeochemistrySample Where geochemistry = 'CaO') CaO ON (m.extractivedumpsampledbk = CaO.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Fetot FROM GeochemistrySample Where geochemistry = 'Fetot') Fetot ON (m.extractivedumpsampledbk = Fetot.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as FeOtot FROM GeochemistrySample Where geochemistry = 'FeOtot') FeOtot ON (m.extractivedumpsampledbk = FeOtot.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Fe2O3tot FROM GeochemistrySample Where geochemistry = 'Fe2O3tot') Fe2O3tot ON (m.extractivedumpsampledbk = Fe2O3tot.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as FeO FROM GeochemistrySample Where geochemistry = 'FeO') FeO ON (m.extractivedumpsampledbk = FeO.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Fe2O3 FROM GeochemistrySample Where geochemistry = 'Fe2O3') Fe2O3 ON (m.extractivedumpsampledbk = Fe2O3.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as K FROM GeochemistrySample Where geochemistry = 'K') K ON (m.extractivedumpsampledbk = K.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as K2O FROM GeochemistrySample Where geochemistry = 'K2O') K2O ON (m.extractivedumpsampledbk = K2O.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Mg FROM GeochemistrySample Where geochemistry = 'Mg') Mg ON (m.extractivedumpsampledbk = Mg.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as MgO FROM GeochemistrySample Where geochemistry = 'MgO') MgO ON (m.extractivedumpsampledbk = MgO.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Na FROM GeochemistrySample Where geochemistry = 'Na') Na ON (m.extractivedumpsampledbk = Na.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Na2O FROM GeochemistrySample Where geochemistry = 'Na2O') Na2O ON (m.extractivedumpsampledbk = Na2O.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Si FROM GeochemistrySample Where geochemistry = 'Si') Si ON (m.extractivedumpsampledbk = Si.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as SiO2 FROM GeochemistrySample Where geochemistry = 'SiO2') SiO2 ON (m.extractivedumpsampledbk = SiO2.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ag FROM GeochemistrySample Where geochemistry = 'Ag') Ag ON (m.extractivedumpsampledbk = Ag.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as As FROM GeochemistrySample Where geochemistry = 'As') As1 ON (m.extractivedumpsampledbk = As1.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Au FROM GeochemistrySample Where geochemistry = 'Au') Au ON (m.extractivedumpsampledbk = Au.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as B FROM GeochemistrySample Where geochemistry = 'B') B ON (m.extractivedumpsampledbk = B.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ba FROM GeochemistrySample Where geochemistry = 'Ba') Ba ON (m.extractivedumpsampledbk = Ba.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Be FROM GeochemistrySample Where geochemistry = 'Be') Be ON (m.extractivedumpsampledbk = Be.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Bi FROM GeochemistrySample Where geochemistry = 'Bi') Bi ON (m.extractivedumpsampledbk = Bi.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Cd FROM GeochemistrySample Where geochemistry = 'Cd') Cd ON (m.extractivedumpsampledbk = Cd.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Cl FROM GeochemistrySample Where geochemistry = 'Cl') Cl ON (m.extractivedumpsampledbk = Cl.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Co FROM GeochemistrySample Where geochemistry = 'Co') Co ON (m.extractivedumpsampledbk = Co.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Cr FROM GeochemistrySample Where geochemistry = 'Cr') Cr ON (m.extractivedumpsampledbk = Cr.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Cs FROM GeochemistrySample Where geochemistry = 'Cs') Cs ON (m.extractivedumpsampledbk = Cs.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Cu FROM GeochemistrySample Where geochemistry = 'Cu') Cu ON (m.extractivedumpsampledbk = Cu.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as F FROM GeochemistrySample Where geochemistry = 'F') F ON (m.extractivedumpsampledbk = F.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ga FROM GeochemistrySample Where geochemistry = 'Ga') Ga ON (m.extractivedumpsampledbk = Ga.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ge FROM GeochemistrySample Where geochemistry = 'Ge') Ge ON (m.extractivedumpsampledbk = Ge.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Hf FROM GeochemistrySample Where geochemistry = 'Hf') Hf ON (m.extractivedumpsampledbk = Hf.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Hg FROM GeochemistrySample Where geochemistry = 'Hg') Hg ON (m.extractivedumpsampledbk = Hg.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as In FROM GeochemistrySample Where geochemistry = 'In') In1 ON (m.extractivedumpsampledbk = In1.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Li FROM GeochemistrySample Where geochemistry = 'Li') Li ON (m.extractivedumpsampledbk = Li.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Mn FROM GeochemistrySample Where geochemistry = 'Mn') Mn ON (m.extractivedumpsampledbk = Mn.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Mo FROM GeochemistrySample Where geochemistry = 'Mo') Mo ON (m.extractivedumpsampledbk = Mo.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Nb FROM GeochemistrySample Where geochemistry = 'Nb') Nb ON (m.extractivedumpsampledbk = Nb.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ni FROM GeochemistrySample Where geochemistry = 'Ni') Ni ON (m.extractivedumpsampledbk = Ni.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as P FROM GeochemistrySample Where geochemistry = 'P') P ON (m.extractivedumpsampledbk = P.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Pb FROM GeochemistrySample Where geochemistry = 'Pb') Pb ON (m.extractivedumpsampledbk = Pb.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Rb FROM GeochemistrySample Where geochemistry = 'Rb') Rb ON (m.extractivedumpsampledbk = Rb.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Re FROM GeochemistrySample Where geochemistry = 'Re') Re ON (m.extractivedumpsampledbk = Re.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as S FROM GeochemistrySample Where geochemistry = 'S') S ON (m.extractivedumpsampledbk = S.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Sb FROM GeochemistrySample Where geochemistry = 'Sb') Sb ON (m.extractivedumpsampledbk = Sb.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Se FROM GeochemistrySample Where geochemistry = 'Se') Se ON (m.extractivedumpsampledbk = Se.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Sn FROM GeochemistrySample Where geochemistry = 'Sn') Sn ON (m.extractivedumpsampledbk = Sn.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Sr FROM GeochemistrySample Where geochemistry = 'Sr') Sr ON (m.extractivedumpsampledbk = Sr.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ta FROM GeochemistrySample Where geochemistry = 'Ta') Ta ON (m.extractivedumpsampledbk = Ta.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Te FROM GeochemistrySample Where geochemistry = 'Te') Te ON (m.extractivedumpsampledbk = Te.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Th FROM GeochemistrySample Where geochemistry = 'Th') Th ON (m.extractivedumpsampledbk = Th.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Tl FROM GeochemistrySample Where geochemistry = 'Tl') Tl ON (m.extractivedumpsampledbk = Tl.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as U FROM GeochemistrySample Where geochemistry = 'U') U ON (m.extractivedumpsampledbk = U.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as V FROM GeochemistrySample Where geochemistry = 'V') V ON (m.extractivedumpsampledbk = V.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as W FROM GeochemistrySample Where geochemistry = 'W') W ON (m.extractivedumpsampledbk = W.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Zn FROM GeochemistrySample Where geochemistry = 'Zn') Zn ON (m.extractivedumpsampledbk = Zn.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Zr FROM GeochemistrySample Where geochemistry = 'Zr') Zr ON (m.extractivedumpsampledbk = Zr.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Sc FROM GeochemistrySample Where geochemistry = 'Sc') Sc ON (m.extractivedumpsampledbk = Sc.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Y FROM GeochemistrySample Where geochemistry = 'Y') Y ON (m.extractivedumpsampledbk = Y.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as La FROM GeochemistrySample Where geochemistry = 'La') La ON (m.extractivedumpsampledbk = La.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ce FROM GeochemistrySample Where geochemistry = 'Ce') Ce ON (m.extractivedumpsampledbk = Ce.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Pr FROM GeochemistrySample Where geochemistry = 'Pr') Pr ON (m.extractivedumpsampledbk = Pr.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Nd FROM GeochemistrySample Where geochemistry = 'Nd') Nd ON (m.extractivedumpsampledbk = Nd.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Sm FROM GeochemistrySample Where geochemistry = 'Sm') Sm ON (m.extractivedumpsampledbk = Sm.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Eu FROM GeochemistrySample Where geochemistry = 'Eu') Eu ON (m.extractivedumpsampledbk = Eu.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Gd FROM GeochemistrySample Where geochemistry = 'Gd') Gd ON (m.extractivedumpsampledbk = Gd.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Tb FROM GeochemistrySample Where geochemistry = 'Tb') Tb ON (m.extractivedumpsampledbk = Tb.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Dy FROM GeochemistrySample Where geochemistry = 'Dy') Dy ON (m.extractivedumpsampledbk = Dy.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ho FROM GeochemistrySample Where geochemistry = 'Ho') Ho ON (m.extractivedumpsampledbk = Ho.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Er FROM GeochemistrySample Where geochemistry = 'Er') Er ON (m.extractivedumpsampledbk = Er.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Tm FROM GeochemistrySample Where geochemistry = 'Tm') Tm ON (m.extractivedumpsampledbk = Tm.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Yb FROM GeochemistrySample Where geochemistry = 'Yb') Yb ON (m.extractivedumpsampledbk = Yb.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Lu FROM GeochemistrySample Where geochemistry = 'Lu') Lu ON (m.extractivedumpsampledbk = Lu.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ru FROM GeochemistrySample Where geochemistry = 'Ru') Ru ON (m.extractivedumpsampledbk = Ru.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Rh FROM GeochemistrySample Where geochemistry = 'Rh') Rh ON (m.extractivedumpsampledbk = Rh.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Pd FROM GeochemistrySample Where geochemistry = 'Pd') Pd ON (m.extractivedumpsampledbk = Pd.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Os FROM GeochemistrySample Where geochemistry = 'Os') Os ON (m.extractivedumpsampledbk = Os.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Ir FROM GeochemistrySample Where geochemistry = 'Ir') Ir ON (m.extractivedumpsampledbk = Ir.extractivedumpsampledbk) LEFT OUTER JOIN (
SELECT extractivedumpsampledbk, samplevalue as Pt FROM GeochemistrySample Where geochemistry = 'Pt') Pt ON (m.extractivedumpsampledbk = Pt.extractivedumpsampledbk)
ORDER BY m.extractiveDumpSampleDbk
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
FROM LandfillFacility m 
LEFT OUTER JOIN LandfillTypeType l ON (m.landfillType = l.landfillType)
ORDER BY landfillType
;


-- **** EnergyRecoveryTypeDistinct_vw

--***********************
CREATE OR REPLACE VIEW EnergyRecoveryTypeDistinct_vw AS
SELECT DISTINCT
	m.energyRecovery
FROM LandfillFacility m 
LEFT OUTER JOIN EnergyRecoveryType e ON (m.energyRecovery = e.energyRecovery)
ORDER BY energyRecovery
;

-- **** LandfillCategoryDistinct_vw

--***********************
CREATE OR REPLACE VIEW LandfillCategoryDistinct_vw AS
SELECT DISTINCT
	m.landfillCategory
FROM LandfillFacility m 
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

	pp.processingActivityType, -- name of processingActivityType
	
	pt.transport,
	ps.storage,
	tp.product, 
	tp.byproduct,
	cm.custommaterial as "Other materials",
-- technology steps characteristics:
	sc.capability,
	sc.customcapability as "Other capabilities",
	ce.customequipment as Equipment,
-- 	SLCA:
	tr.economyIncome,
	tr.employmentEducation,
	tr.landuseTerritory,
	tr.demography,
	tr.environmentHealth,
	tr.yearSLCA
FROM  WasteFacility w 
INNER JOIN TreatmentRecyclingPlant tr ON (tr.treatmentRecyclingPlantDbk = w.wasteFacilityDbk)
LEFT OUTER JOIN Operator o ON (o.operatorDbk = w.operatorDbk)
LEFT OUTER JOIN CountryType c ON (w.country=c.country)
LEFT OUTER JOIN ProvinceType p ON (w.province=p.province)
LEFT OUTER JOIN MunicipalityType m ON (w.municipality = m.municipality)
LEFT OUTER JOIN  RegionType r ON (w.region = r.region)
LEFT OUTER JOIN (
		SELECT  p.treatmentRecyclingPlantDbk, 
				string_agg(t.name, ', ') as transport
		FROM  PlantTransport p
		LEFT OUTER JOIN TransportType t ON (t.transport = p.transport)
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as pt
ON (w.wasteFacilityDbk = pt.treatmentRecyclingPlantDbk)
LEFT OUTER JOIN (
		SELECT  f.wasteFacilityDbk, 
				string_agg(pa.name, ', ') as processingActivityType
		FROM  FacilityProcessingActivity f
		LEFT OUTER JOIN ProcessingActivityTypeType pa ON (pa.processingActivityType = f.processingActivityType)
		GROUP BY wasteFacilityDbk
		ORDER BY wasteFacilityDbk) as pp
ON (w.wasteFacilityDbk = pp.wasteFacilityDbk)
LEFT OUTER JOIN (
		SELECT  p.treatmentRecyclingPlantDbk, 
				string_agg(s.name, ', ') as storage
		FROM  PlantStorage p
		LEFT OUTER JOIN StorageType s ON (s.storage = p.storage)
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
LEFT OUTER JOIN (

		SELECT treatmentRecyclingPlantDbk,
			string_agg(pc.subcapability, ', ') as capability,
			string_agg(pc.customsubcapability, ', ') as customcapability
		FROM ( SELECT treatmentRecyclingPlantDbk,
			subcapability,
			customsubcapability
			FROM plantcapability p 
			LEFT OUTER join customsubcapability c 
			ON p.customsubcapabilitydbk = c.customsubcapabilitydbk
		) as pc
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as sc
ON (w.wasteFacilityDbk = sc.treatmentRecyclingPlantDbk)
LEFT OUTER JOIN (
		SELECT  treatmentRecyclingPlantDbk, 
			string_agg(pe.customequipment, ', ') as customequipment
		FROM  ( SELECT treatmentRecyclingPlantDbk,
				customequipment
			FROM plantequipment p 
			LEFT OUTER join customequipment c 
			ON p.customequipmentdbk = c.customequipmentdbk) as pe
		GROUP BY treatmentRecyclingPlantDbk
		ORDER BY treatmentRecyclingPlantDbk) as ce
ON (w.wasteFacilityDbk = ce.treatmentRecyclingPlantDbk)
LEFT OUTER JOIN (

select treatmentrecyclingplantdbk,
	uniq_words(string_agg(m.custommaterial, ' ')) as custommaterial  -- commas have been avoided as separators in order to use efectively function uniq_words, otherwise it cannot distinguis "materia1" from "material1,"
FROM techlinestep t
LEFT OUTER JOIN (SELECT customtechlinedbk,
			string_agg(cm.custommaterial, ' ') as custommaterial
		FROM (select customtechlinedbk, 
				string_agg(c.custommaterial, ' ') as custommaterial
			from techlineinput ti
			left outer join custommaterial c ON ti.custommaterialdbk = c.custommaterialdbk
			group by ti.customtechlinedbk
			UNION
			select customtechlinedbk, 
				string_agg(c.custommaterial, ' ') as outputcustommaterial
			from techlineoutput u
			left outer join custommaterial c ON u.custommaterialdbk = c.custommaterialdbk
			group by customtechlinedbk) as cm
		group by customtechlinedbk) as m
ON m.customtechlinedbk = t.customtechlinedbk
GROUP BY treatmentrecyclingplantdbk) as cm
ON w.wasteFacilityDbk = cm.treatmentRecyclingPlantDbk

ORDER BY wasteFacilityDbk
;


-- **** TreatmentPlantProductDetail_vw

--***********************
CREATE OR REPLACE VIEW TreatmentPlantProductDetail_vw1 AS
select treatmentRecyclingPlantDbk, product, byproduct, weight
from PlantProduct 
order by treatmentrecyclingplantDbk
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

-- **** SubcapabilityDistinct_vw
-- 
--***********************
CREATE OR REPLACE VIEW SubcapabilityDistinct_vw AS
SELECT DISTINCT
	s.name
	--s.description
FROM PlantCapability p
LEFT OUTER JOIN SubCapabilityType s ON (s.subcapability = p.subcapability)
where s.name is not null
ORDER BY name
;



-- ***
-- *** MINING AMOUNT CALCULATIONS
-- **



CREATE OR REPLACE VIEW GeochemistrySampleNumeric_vw AS
--This view checks that the values of GeochemistrySamples are numeric (not character strings)
--and changes values with prefix '<' into '0', because this happens when the value is near zero.
select 
	g.geochemistrysampledbk,
	g.extractivedumpsampledbk,
	g.geochemistry,
	s.name,
	s.description as UoM,
	s.geochemistrygroup,
	t.factor,
	CASE WHEN isnumeric(samplevalue) IS true then to_number(samplevalue, '999999.99')
		WHEN samplevalue like '>%' THEN NULL -- add here the resulting value in case of '>'
		WHEN samplevalue ~ '<*' IS true THEN '0' 
		ELSE NULL END as num_samplevalue
from GeochemistrySample g
LEFT OUTER JOIN GeochemistryType s ON (s.geochemistry = g.geochemistry)
LEFT OUTER JOIN GeochemistryGroupType t ON (s.geochemistrygroup = t.geochemistrygroup)
order by geochemistrysampledbk
;

--
-- This view calculates the total mass for each dump

CREATE OR REPLACE VIEW ExtractiveDumpCalculation_vw AS  
SELECT
    d.extractiveIndustryFacilityDbk,
	d.extractiveDumpDbk,
	g.geochemistry,
	g.UoM,
	g.name,
	CASE WHEN bool_and(g.num_samplevalue is not null) is true then round(cast(d.volume * d.bulkdensity * avg(g.num_samplevalue) * g.factor as numeric), 2)
		ELSE NULL END as mass_samplevalue
FROM ExtractiveDump d
INNER JOIN extractiveDumpSample s ON (s.extractiveDumpDbk = d.extractiveDumpDbk)
INNER JOIN GeochemistrySampleNumeric_vw g ON (g.extractiveDumpSampleDbk = s.extractiveDumpSampleDbk)
GROUP BY d.extractiveDumpDbk, g.geochemistry, g.factor, g.name, g.UoM
ORDER BY d.extractiveDumpDbk
;



CREATE OR REPLACE VIEW ExtractiveFacilityCalculation_vw AS  
-- this view calculates the total sum of mass for each element for each facility
-- Indicates Yes or No if the geochemistry is in the group of relevant elements (commodities) of this facility
-- Daniel: in the detailed tab of web client initially show only those with value 'Y' AND totalvalue is different than 'n.a.'
SELECT 
	e.extractiveIndustryFacilityDbk,
	e.geochemistry,
	e.name,
	CASE WHEN bool_and(e.mass_samplevalue is not null) is true then cast(sum(e.mass_samplevalue)::integer as text)
		ELSE 'n.a.' END as tot_samplevalue,
	'Kg'::text as UoM,
	CASE WHEN e.name in (select commodity
		from FacilityCommodity
		where extractiveIndustryFacilityDbk = e.extractiveIndustryFacilityDbk) then true
		ELSE false END AS RelevantElement
FROM Extractivedumpcalculation_vw e
GROUP BY e.extractiveIndustryFacilityDbk, e.geochemistry, e.name, e.UoM
ORDER BY e.extractiveIndustryFacilityDbk, e.geochemistry
;



CREATE OR REPLACE VIEW GeochemistryTotalCalculation_vw AS
-- Probably this view is not needed
-- the purpose is to facilitate a quick view at the data horizontally for each facility
-- maybe it can be used to export/download data
SELECT 
	Al.extractiveIndustryFacilityDbk,
	Al.tot_Al,
	Al2O3.tot_Al2O3,
	Ca.tot_Ca,
	CaO.tot_CaO,
	Fetot.tot_Fetot,
	FeOtot.tot_FeOtot,
	Fe2O3tot.tot_Fe2O3tot,
	FeO.tot_FeO,
	Fe2O3.tot_Fe2O3,
	K.tot_K,
	K2O.tot_K2O,
	Mg.tot_Mg,
	MgO.tot_MgO,
	Na.tot_Na,
	Na2O.tot_Na2O,
	Si.tot_Si,
	SiO2.tot_SiO2,
	Ag.tot_Ag,
	As1.tot_As,
	Au.tot_Au,
	B.tot_B,
	Ba.tot_Ba,
	Be.tot_Be,
	Bi.tot_Bi,
	Cd.tot_Cd,
	Cl.tot_Cl,
	Co.tot_Co,
	Cr.tot_Cr,
	Cs.tot_Cs,
	Cu.tot_Cu,
	F.tot_F,
	Ga.tot_Ga,
	Ge.tot_Ge,
	Hf.tot_Hf,
	Hg.tot_Hg,
	In1.tot_In,
	Li.tot_Li,
	Mn.tot_Mn,
	Mo.tot_Mo,
	Nb.tot_Nb,
	Ni.tot_Ni,
	P.tot_P,
	Pb.tot_Pb,
	Rb.tot_Rb,
	Re.tot_Re,
	S.tot_S,
	Sb.tot_Sb,
	Se.tot_Se,
	Sn.tot_Sn,
	Sr.tot_Sr,
	Ta.tot_Ta,
	Te.tot_Te,
	Th.tot_Th,
	Tl.tot_Tl,
	U.tot_U,
	V.tot_V,
	W.tot_W,
	Zn.tot_Zn,
	Zr.tot_Zr,
	Sc.tot_Sc,
	Y.tot_Y,
	La.tot_La,
	Ce.tot_Ce,
	Pr.tot_Pr,
	Nd.tot_Nd,
	Sm.tot_Sm,
	Eu.tot_Eu,
	Gd.tot_Gd,
	Tb.tot_Tb,
	Dy.tot_Dy,
	Ho.tot_Ho,
	Er.tot_Er,
	Tm.tot_Tm,
	Yb.tot_Yb,
	Lu.tot_Lu,
	Ru.tot_Ru,
	Rh.tot_Rh,
	Pd.tot_Pd,
	Os.tot_Os,
	Ir.tot_Ir,
	Pt.tot_Pt
	
FROM  (
    SELECT extractiveIndustryFacilityDbk, 
	tot_samplevalue as tot_Al 
	FROM ExtractiveFacilityCalculation_vw 
	Where geochemistry = 'Al') Al
INNER JOIN (
	SELECT extractiveIndustryFacilityDbk, 
		tot_samplevalue as tot_Al2O3 
	FROM ExtractiveFacilityCalculation_vw 
	Where geochemistry = 'Al2O3') Al2O3 
ON (Al.extractiveIndustryFacilityDbk = Al2O3.extractiveIndustryFacilityDbk) 
INNER JOIN ( 
-- repetition of the previous INNER JOIN FOR EACH geochemistry
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ca FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ca') Ca ON (Al.extractiveIndustryFacilityDbk = Ca.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_CaO FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'CaO') CaO ON (Al.extractiveIndustryFacilityDbk = CaO.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Fetot FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Fetot') Fetot ON (Al.extractiveIndustryFacilityDbk = Fetot.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_FeOtot FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'FeOtot') FeOtot ON (Al.extractiveIndustryFacilityDbk = FeOtot.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Fe2O3tot FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Fe2O3tot') Fe2O3tot ON (Al.extractiveIndustryFacilityDbk = Fe2O3tot.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_FeO FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'FeO') FeO ON (Al.extractiveIndustryFacilityDbk = FeO.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Fe2O3 FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Fe2O3') Fe2O3 ON (Al.extractiveIndustryFacilityDbk = Fe2O3.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_K FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'K') K ON (Al.extractiveIndustryFacilityDbk = K.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_K2O FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'K2O') K2O ON (Al.extractiveIndustryFacilityDbk = K2O.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Mg FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Mg') Mg ON (Al.extractiveIndustryFacilityDbk = Mg.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_MgO FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'MgO') MgO ON (Al.extractiveIndustryFacilityDbk = MgO.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Na FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Na') Na ON (Al.extractiveIndustryFacilityDbk = Na.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Na2O FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Na2O') Na2O ON (Al.extractiveIndustryFacilityDbk = Na2O.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Si FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Si') Si ON (Al.extractiveIndustryFacilityDbk = Si.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_SiO2 FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'SiO2') SiO2 ON (Al.extractiveIndustryFacilityDbk = SiO2.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ag FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ag') Ag ON (Al.extractiveIndustryFacilityDbk = Ag.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_As FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'As') As1 ON (Al.extractiveIndustryFacilityDbk = As1.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Au FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Au') Au ON (Al.extractiveIndustryFacilityDbk = Au.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_B FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'B') B ON (Al.extractiveIndustryFacilityDbk = B.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ba FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ba') Ba ON (Al.extractiveIndustryFacilityDbk = Ba.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Be FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Be') Be ON (Al.extractiveIndustryFacilityDbk = Be.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Bi FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Bi') Bi ON (Al.extractiveIndustryFacilityDbk = Bi.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Cd FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Cd') Cd ON (Al.extractiveIndustryFacilityDbk = Cd.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Cl FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Cl') Cl ON (Al.extractiveIndustryFacilityDbk = Cl.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Co FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Co') Co ON (Al.extractiveIndustryFacilityDbk = Co.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Cr FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Cr') Cr ON (Al.extractiveIndustryFacilityDbk = Cr.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Cs FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Cs') Cs ON (Al.extractiveIndustryFacilityDbk = Cs.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Cu FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Cu') Cu ON (Al.extractiveIndustryFacilityDbk = Cu.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_F FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'F') F ON (Al.extractiveIndustryFacilityDbk = F.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ga FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ga') Ga ON (Al.extractiveIndustryFacilityDbk = Ga.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ge FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ge') Ge ON (Al.extractiveIndustryFacilityDbk = Ge.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Hf FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Hf') Hf ON (Al.extractiveIndustryFacilityDbk = Hf.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Hg FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Hg') Hg ON (Al.extractiveIndustryFacilityDbk = Hg.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_In FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'In') In1 ON (Al.extractiveIndustryFacilityDbk = In1.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Li FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Li') Li ON (Al.extractiveIndustryFacilityDbk = Li.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Mn FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Mn') Mn ON (Al.extractiveIndustryFacilityDbk = Mn.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Mo FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Mo') Mo ON (Al.extractiveIndustryFacilityDbk = Mo.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Nb FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Nb') Nb ON (Al.extractiveIndustryFacilityDbk = Nb.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ni FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ni') Ni ON (Al.extractiveIndustryFacilityDbk = Ni.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_P FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'P') P ON (Al.extractiveIndustryFacilityDbk = P.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Pb FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Pb') Pb ON (Al.extractiveIndustryFacilityDbk = Pb.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Rb FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Rb') Rb ON (Al.extractiveIndustryFacilityDbk = Rb.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Re FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Re') Re ON (Al.extractiveIndustryFacilityDbk = Re.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_S FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'S') S ON (Al.extractiveIndustryFacilityDbk = S.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Sb FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Sb') Sb ON (Al.extractiveIndustryFacilityDbk = Sb.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Se FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Se') Se ON (Al.extractiveIndustryFacilityDbk = Se.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Sn FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Sn') Sn ON (Al.extractiveIndustryFacilityDbk = Sn.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Sr FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Sr') Sr ON (Al.extractiveIndustryFacilityDbk = Sr.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ta FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ta') Ta ON (Al.extractiveIndustryFacilityDbk = Ta.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Te FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Te') Te ON (Al.extractiveIndustryFacilityDbk = Te.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Th FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Th') Th ON (Al.extractiveIndustryFacilityDbk = Th.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Tl FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Tl') Tl ON (Al.extractiveIndustryFacilityDbk = Tl.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_U FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'U') U ON (Al.extractiveIndustryFacilityDbk = U.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_V FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'V') V ON (Al.extractiveIndustryFacilityDbk = V.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_W FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'W') W ON (Al.extractiveIndustryFacilityDbk = W.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Zn FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Zn') Zn ON (Al.extractiveIndustryFacilityDbk = Zn.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Zr FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Zr') Zr ON (Al.extractiveIndustryFacilityDbk = Zr.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Sc FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Sc') Sc ON (Al.extractiveIndustryFacilityDbk = Sc.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Y FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Y') Y ON (Al.extractiveIndustryFacilityDbk = Y.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_La FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'La') La ON (Al.extractiveIndustryFacilityDbk = La.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ce FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ce') Ce ON (Al.extractiveIndustryFacilityDbk = Ce.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Pr FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Pr') Pr ON (Al.extractiveIndustryFacilityDbk = Pr.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Nd FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Nd') Nd ON (Al.extractiveIndustryFacilityDbk = Nd.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Sm FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Sm') Sm ON (Al.extractiveIndustryFacilityDbk = Sm.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Eu FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Eu') Eu ON (Al.extractiveIndustryFacilityDbk = Eu.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Gd FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Gd') Gd ON (Al.extractiveIndustryFacilityDbk = Gd.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Tb FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Tb') Tb ON (Al.extractiveIndustryFacilityDbk = Tb.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Dy FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Dy') Dy ON (Al.extractiveIndustryFacilityDbk = Dy.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ho FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ho') Ho ON (Al.extractiveIndustryFacilityDbk = Ho.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Er FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Er') Er ON (Al.extractiveIndustryFacilityDbk = Er.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Tm FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Tm') Tm ON (Al.extractiveIndustryFacilityDbk = Tm.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Yb FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Yb') Yb ON (Al.extractiveIndustryFacilityDbk = Yb.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Lu FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Lu') Lu ON (Al.extractiveIndustryFacilityDbk = Lu.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ru FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ru') Ru ON (Al.extractiveIndustryFacilityDbk = Ru.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Rh FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Rh') Rh ON (Al.extractiveIndustryFacilityDbk = Rh.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Pd FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Pd') Pd ON (Al.extractiveIndustryFacilityDbk = Pd.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Os FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Os') Os ON (Al.extractiveIndustryFacilityDbk = Os.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Ir FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Ir') Ir ON (Al.extractiveIndustryFacilityDbk = Ir.extractiveIndustryFacilityDbk) INNER JOIN (
SELECT extractiveIndustryFacilityDbk, tot_samplevalue as tot_Pt FROM ExtractiveFacilityCalculation_vw Where geochemistry = 'Pt') Pt ON (Al.extractiveIndustryFacilityDbk = Pt.extractiveIndustryFacilityDbk)
;




--************************
CREATE OR REPLACE FUNCTION extractivefacilitycalculation (integer, REAL[]) -- $1 is id of facility and $2 is array of dump densities
RETURNS SETOF extractivefacilitycalculation_vw AS
$BODY$
DECLARE 	
	id_facility ALIAS FOR $1;
	array_density ALIAS FOR $2;
    rec     RECORD;
	counter INT = 0 ;
	array_dump INT[];
BEGIN	
	-- First I have to obtain the ids of all dumps of the facility. Facility id is parameter $1
	array_dump := array(SELECT extractivedumpdbk FROM extractivedump where extractiveindustryfacilitydbk = id_facility order by extractivedumpdbk);
-- Next we will create temporary table having dumpid + its respective density
-- this will be used by the RETURN QUERY in inner join
	CREATE TEMP TABLE ArrayDensity (
		extractivedumpdbk integer,
		density real
		);
	FOR counter in array_lower(array_dump,1) .. array_upper(array_dump, 1) -- from 1 to n number of dumps
	LOOP
		INSERT INTO ArrayDensity  
			VALUES(array_dump[counter],array_density[counter]);	
	END LOOP;
-- The return query has 2 selects, because there are 2 steps, 
-- first step the aggregated mass at dump for each dump is calculated. This is query 'a'.
-- second select makes the sum of all dumps for the facility 	
	RETURN QUERY 
			SELECT 
				a.extractiveIndustryFacilityDbk,
				a.geochemistry,
				a.name,
				CASE WHEN bool_and(a.mass_samplevalue is not null) is true then cast(sum(a.mass_samplevalue)::integer as text)
					ELSE 'n.a.' END as tot_samplevalue,
				'Kg'::text as UoM,
				--a.UoM,
				CASE WHEN a.name in (select commodity
					from FacilityCommodity
					where extractiveIndustryFacilityDbk = a.extractiveIndustryFacilityDbk) then true
					ELSE false END AS RelevantElement
			FROM (
				SELECT
					d.extractiveIndustryFacilityDbk,
					d.extractiveDumpDbk,
					g.geochemistry,
					g.name,
					g.UoM,
					CASE 
						WHEN bool_and(g.num_samplevalue is not null) is true then round(cast(d.volume * 
							CASE
								WHEN d.bulkdensity is null THEN a.density  -- replace with NEW parameter density if null
								ELSE d.bulkdensity
							END
							* avg(g.num_samplevalue) * g.factor as numeric), 2)
						ELSE NULL 
					END as mass_samplevalue
				FROM ExtractiveDump d
				INNER JOIN extractiveDumpSample s ON (s.extractiveDumpDbk = d.extractiveDumpDbk)
				INNER JOIN GeochemistrySampleNumeric_vw g ON (g.extractiveDumpSampleDbk = s.extractiveDumpSampleDbk)
				INNER JOIN ArrayDensity a ON (a.extractivedumpdbk = d.extractivedumpdbk)
				WHERE d.extractiveDumpDbk = ANY(array_dump)  -- select only the dumps from selected facility
				GROUP BY d.extractiveDumpDbk, g.geochemistry, g.factor, g.name,g.UoM,a.density
				ORDER BY d.extractiveDumpDbk, g.name) a
			GROUP BY a.extractiveIndustryFacilityDbk, a.geochemistry, a.name, a.UoM
			ORDER BY a.extractiveIndustryFacilityDbk, a.geochemistry;
 
	DISCARD TEMP;  
END;
$BODY$
LANGUAGE plpgsql VOLATILE;



-- *******
--      TREATMENT PLANTS TECHNOLOGY STEPS
-- *****

-- techlineinputDetail_vw
-- this view is used for the facility management section, there is another view (at the beginning of the file, techlineinputPlantDetail_vw) for general visualisation of the plant info
CREATE OR REPLACE VIEW techlineinputDetail_vw AS
SELECT  i.techlineinputDbk,
	i.customtechlinedbk,
	i.custommaterialdbk,
	CASE WHEN m.custommaterial IS NULL THEN NULL ELSE m.custommaterial END as custommaterial,
	CASE WHEN p.product IS NULL THEN NULL ELSE p.product END as product,
	i.inputPercent as Percent
FROM techlineinput i 
LEFT JOIN custommaterial m ON m.customMaterialDbk = i.customMaterialDbk
LEFT JOIN productType p ON p.product = i.product
;




-- techlineOutputDetail_vw
-- this view is used for the facility management section, there is another view (at the beginning of the file, techlineoutputPlantDetail_vw) for general visualisation of the plant info
CREATE OR REPLACE VIEW techlineOutputDetail_vw AS
SELECT  o.techlineoutputDbk,
	o.customtechlinedbk,
	o.custommaterialdbk,
	CASE WHEN m.custommaterial IS NULL THEN NULL ELSE m.custommaterial END as custommaterial,
	CASE WHEN p.product IS NULL THEN NULL ELSE p.product END as product,
	o.outputPercent as Percent,
	o.productioncost
FROM techlineoutput o 
LEFT JOIN custommaterial m ON m.customMaterialDbk = o.customMaterialDbk
LEFT JOIN productType p ON p.product = o.product
;


-- techlineEquipmentDetail_vw
--
CREATE OR REPLACE VIEW techlineEquipmentDetail_vw AS
select 
	s.treatmentrecyclingplantdbk,
	s.techlinestepdbk,
	s.customequipmentdbk,
	e.customequipment as equipment,
	e.description,
	e.capacity || ' kg/hour' as capacity,
	e.operationcost || ' EUR/kg' as operationcost
from techlinestep s, customequipment e
Where s.customequipmentdbk = e.customequipmentdbk
;


-- TechLineStepEdit_vw
-- this view is for the edition of techline steps, while the view TechLineStepDetail_vw (which is very similar) is for the visualisation of details of the plant
CREATE OR REPLACE VIEW TechLineStepEdit_vw AS
select 	s.treatmentrecyclingplantdbk,
	w.name as plantname,
	s.techlinestepdbk,
	l.customtechlinedbk, 
	s.isimplemented,
	s.year,
	s.customequipmentdbk, 
	e.customequipment as customequipmentname,
	e.capacity as customequipmentCapacity,
	e.operationcost as customequipmentCost,
	CASE WHEN cc.customsubcapability IS NOT NULL then 'custom' 
		WHEN ct.subcapability IS NOT NULL then 'subCap' 
		ELSE NULL END as subcapabilitytype, 
	CASE WHEN cc.customsubcapability IS NOT NULL then cc.customsubcapability ELSE ct.name END as subcapabilityname,
	CASE WHEN cc.customsubcapabilitydbk IS NOT NULL then cc.customsubcapabilitydbk::varchar 
		WHEN ct.subcapability IS NOT NULL then ct.subcapability
		ELSE NULL END as subcapabilitydbk, 
	CASE WHEN cc.customsubcapability IS NOT NULL then cc.capability 
		WHEN ct.subcapability IS NOT NULL then ct.capability 
		ELSE NULL END as capability,
	s.planttransportdbk, 
	tt.name as transportname,
	s.isonsite
from techlinestep s
left join customtechline l ON s.customtechlinedbk = l.customtechlinedbk
left join customequipment e ON e.customequipmentdbk = s.customequipmentdbk
left join customsubcapability cc ON cc.customsubcapabilitydbk = s.customsubcapabilitydbk
left join subcapabilitytype ct ON ct.subcapability = s.subcapability
left join planttransport t ON t.planttransportdbk = s.planttransportdbk
left join transporttype tt on tt.transport = t.transport
LEFT JOIN wastefacility w ON w.wastefacilitydbk = s.treatmentRecyclingPlantDbk
order by s.treatmentrecyclingplantdbk, s.techlinestepdbk
;




-- TechLineStepDetail_vw
-- this view is for the visualisation of details of the plant, while the view TechLineStepEdit_vw (which is very similar) is for the edition of techline steps
CREATE OR REPLACE VIEW TechLineStepDetail_vw AS
select 	s.treatmentrecyclingplantdbk,
	w.name as PlantName,
	s.techlinestepdbk,
	l.customtechlinedbk,
	l.name as techlinename,
	CASE WHEN s.isimplemented IS TRUE THEN 'Yes' ELSE 'No' END as Isimplemented,
	s.year,
	e.customequipment as equipment,
	e.capacity as equipmentcapacity,
	e.operationcost as equipmentoperationcost,
	CASE WHEN cc.customsubcapability IS NOT NULL then cc.customsubcapability ELSE ct.name END as capability,
	tt.name as Transport,
	CASE WHEN s.isonsite IS TRUE THEN 'Onsite' ELSE 'External process' END as IsOnsite
from techlinestep s
left join customtechline l ON s.customtechlinedbk = l.customtechlinedbk
left join customequipment e ON e.customequipmentdbk = s.customequipmentdbk
left join customsubcapability cc ON cc.customsubcapabilitydbk = s.customsubcapabilitydbk
left join subcapabilitytype ct ON ct.subcapability = s.subcapability
left join planttransport t ON t.planttransportdbk = s.planttransportdbk
left join transporttype tt on tt.transport = t.transport
LEFT JOIN wastefacility w ON w.wastefacilitydbk = s.treatmentRecyclingPlantDbk
order by s.treatmentrecyclingplantdbk, s.techlinestepdbk
;

-- **** CustomEquipment_vw
--***********************
CREATE OR REPLACE VIEW CustomEquipment_vw AS
SELECT	p.plantequipmentdbk,
	p.treatmentrecyclingplantdbk as plantdbk,
	p.customequipmentdbk,
	c.operatordbk,
	c.customequipment,
	c.description,
	c.capacity || ' kg/hour' as capacity,
	c.operationcost || ' EUR/kg' as operationCost
from plantequipment p, customequipment c
where p.customequipmentdbk = c.customequipmentdbk
order by plantdbk
;



-- **** TechlineInputDistinct_vw
-- distinct inputs used in techlines, NOT INCLUDING custom material, only codelist producttype
-- to be used in search filter
--***********************
CREATE OR REPLACE VIEW TechlineInputDistinct_vw AS
SELECT DISTINCT
	p.product
FROM techlineinputplantdetail_vw s
LEFT OUTER JOIN producttype p ON (s.input = p.product)
where p.product is not null
ORDER BY product
;


-- **** TechlineOutputDistinct_vw
-- distinct outputs used in techlines, NOT INCLUDING custom material, only codelist producttype
-- to be used in search filter
--***********************
CREATE OR REPLACE VIEW TechlineOutputDistinct_vw AS
SELECT DISTINCT
	p.product
FROM techlineoutputplantdetail_vw s
LEFT OUTER JOIN producttype p ON (s.output = p.product)
where p.product is not null
ORDER BY product
;


-- **** AvailabilityPredictions_vw
-- this view indicates whether one mining facility can have predictions or not.
-- value 'available' means that predictions are available
-- value 'notavailable' means that we cannot estimate predictions
-- value 'bulkDensitymissing' means that we cannot make predictions, but it is possible that the user fills some density estimations and then develop the predictions.

CREATE OR REPLACE VIEW AvailabilityPredictions_vw AS  
SELECT
	e.extractiveindustryfacilitydbk,
--	a.bulkdensityavailability,
--	b.volumeavailability,
--	c.massvailability,
	CASE WHEN a.bulkdensityavailability AND b.volumeavailability AND c.massvailability IS TRUE THEN 'Available' 
		WHEN b.volumeavailability AND c.massvailability IS TRUE THEN 'BulkDensityMissing'
		ELSE 'NotAvailable' 
	END as availabilityPredictions 
FROM extractiveindustryfacility e

LEFT JOIN(
	select 
		extractiveindustryfacilitydbk,
		CASE WHEN bool_and(bulkdensity is not null) is true then true
				ELSE false END as bulkdensityavailability
	from extractivedump
	group by extractiveindustryfacilitydbk
	ORDER BY extractiveindustryfacilitydbk) as a
ON e.extractiveindustryfacilitydbk = a.extractiveindustryfacilitydbk
LEFT JOIN ( SELECT extractiveindustryfacilitydbk,
				CASE WHEN bool_and(volume is not null) is true then true
					ELSE false END as volumeavailability
			from extractivedump
			group by extractiveindustryfacilitydbk
			ORDER BY extractiveindustryfacilitydbk) as b
ON a.extractiveindustryfacilitydbk = b.extractiveindustryfacilitydbk
LEFT JOIN ( SELECT
--First we make a query#1 for each facility i get true if there are values for all the samples FOR EACH element. group by both facility and geochemistry.
-- the rule is, as long as there is one element with all the samples in one facility, i will lable the facility as true, which means that at least one prediction can be done (with regard to the sample values)
-- the second query has to group only by facility to make the last group of samplevalues
-- QUERY#2:
				f.extractiveIndustryFacilityDbk,
				CASE WHEN bool_or(f.mass_samplevalue is true) then true else false end as massvailability
			FROM (
			-- QUERY#1: 
				SELECT
					d.extractiveIndustryFacilityDbk,
					g.geochemistry,
					CASE WHEN bool_and(g.num_samplevalue is not null) is true then TRUE ELSE FALSE END as mass_samplevalue
				FROM ExtractiveDump d
				left JOIN extractiveDumpSample s ON (s.extractiveDumpDbk = d.extractiveDumpDbk)
				left JOIN GeochemistrySampleNumeric_vw g ON (g.extractiveDumpSampleDbk = s.extractiveDumpSampleDbk)
				--WHERE d.extractiveIndustryFacilityDbk = 3
				GROUP BY d.extractiveIndustryFacilityDbk, g.geochemistry
				ORDER BY d.extractiveIndustryFacilityDbk) as f
			GROUP BY f.extractiveIndustryFacilityDbk) as c
ON a.extractiveindustryfacilitydbk = c.extractiveindustryfacilitydbk
ORDER BY e.extractiveindustryfacilitydbk
;





