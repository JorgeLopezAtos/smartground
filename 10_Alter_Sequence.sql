-- List all sequences: SELECT c.relname FROM pg_class c WHERE c.relkind = 'S';
-- documentation: https://www.postgresql.org/docs/current/static/sql-altersequence.html
--                http://stackoverflow.com/questions/8745051/postgres-manually-alter-sequence
-- query: SELECT sequence_name, last_value FROM public.operator_operatordbk_seq;


-- 01DATA_REAL_MINE_GIULIO_4_PIEMONTEandVDA_OK

ALTER SEQUENCE public.operator_operatordbk_seq RESTART WITH 295;
ALTER SEQUENCE public.wastefacility_wastefacilitydbk_seq RESTART WITH 92;	
ALTER SEQUENCE public.ExtractiveIndustryFacility_ExtractiveIndustryFacilitydbk_seq RESTART WITH 92;
ALTER SEQUENCE public.facilitywastetype_facilitywastetypedbk_seq RESTART WITH 98;
ALTER SEQUENCE public.FacilityCommodity_FacilityCommoditydbk_seq RESTART WITH 217;
ALTER SEQUENCE public. FacilityOreMineralogy_FacilityOreMineralogydbk_seq RESTART WITH 233;
ALTER SEQUENCE public.FacilityLithology_FacilityLithologydbk_seq RESTART WITH 92;
ALTER SEQUENCE public.FacilityMiningActivity_FacilityMiningActivitydbk_seq RESTART WITH 94;
ALTER SEQUENCE public.FacilityProcessingActivity_FacilityProcessingActivitydbk_seq RESTART WITH 120;
ALTER SEQUENCE public.ExtractiveDump_ExtractiveDumpdbk_seq RESTART WITH 17;
ALTER SEQUENCE public.DumpOreMineralogy_DumpOreMineralogydbk_seq RESTART WITH 110;
ALTER SEQUENCE public.ExtractiveDumpSample_ExtractiveDumpSampledbk_seq RESTART WITH 110;
ALTER SEQUENCE public.Geochemistry_Geochemistrydbk_seq RESTART WITH 115;


-- 03DATA_REAL_PLANT_Francesca_1_OK

ALTER SEQUENCE public.Operator_Operatordbk_seq RESTART WITH 419;
ALTER SEQUENCE public.WasteFacility_WasteFacilitydbk_seq RESTART WITH 216;	
ALTER SEQUENCE public.TreatmentRecyclingPlant_TreatmentRecyclingPlantdbk_seq RESTART WITH 216;
ALTER SEQUENCE public.PlantFeedingMaterial_PlantFeedingMaterialdbk_seq RESTART WITH 70;
ALTER SEQUENCE public.FacilityProcessingActivity_FacilityProcessingActivitydbk_seq RESTART WITH 130;
ALTER SEQUENCE public.PlantWasteProduced_PlantWasteProduceddbk_seq RESTART WITH 13;

-- 04DATA_TEST_PLANT_jorge_1_OK

ALTER SEQUENCE public.Operator_Operatordbk_seq RESTART WITH 420;
ALTER SEQUENCE public.WasteFacility_WasteFacilitydbk_seq RESTART WITH 218;	
ALTER SEQUENCE public.TreatmentRecyclingPlant_TreatmentRecyclingPlantdbk_seq RESTART WITH 218;
ALTER SEQUENCE public.PlantFeedingMaterial_PlantFeedingMaterialdbk_seq RESTART WITH 97;
ALTER SEQUENCE public.PlantTransport_PlantTransportdbk_seq RESTART WITH 9;
ALTER SEQUENCE public.FacilityProcessingActivity_FacilityProcessingActivitydbk_seq RESTART WITH 132;
ALTER SEQUENCE public.PlantStorage_PlantStoragedbk_seq RESTART WITH 4;
ALTER SEQUENCE public.PlantProduct_PlantProductdbk_seq RESTART WITH 9;
ALTER SEQUENCE public.PlantWasteProduced_PlantWasteProduceddbk_seq RESTART WITH 25;


-- 05DATA_REAL_MSW_HeikkiUK_1_OK

ALTER SEQUENCE public.operator_operatordbk_seq RESTART WITH 424;
ALTER SEQUENCE public.wastefacility_wastefacilitydbk_seq RESTART WITH 230;	
ALTER SEQUENCE public.municipalconstructionfacility_municipalconstructionfacility_seq RESTART WITH 230;
ALTER SEQUENCE public.LandfillEwc_LandfillEwcdbk_seq RESTART WITH 329;
ALTER SEQUENCE public.MunicipalDumpSample_MunicipalDumpSampledbk_seq RESTART WITH 15;
ALTER SEQUENCE public.CapturedBiogas_CapturedBiogasdbk_seq RESTART WITH 354;





