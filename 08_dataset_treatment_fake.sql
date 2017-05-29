-- fake data
-- type: treatment


INSERT INTO Operator VALUES ('419', 'AMBIENTE SA', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO WasteFacility VALUES ('216', 'JorgeTestName', 'Regione rotto 1', 'IT', 'ITC1', 'ITC11', 'ITC11001127', '418', NULL, '101', 'm','202', 'm2','303', 'm3','404', 'Mt','2000', '2003', 'N', NULL, NULL, 'This is test record', 'Treatment', NULL, NULL, ST_Transform(ST_GeomFromText('POINT(396054 4979820)', 32632), 4326), 'POINT(396054 4979820)');
INSERT INTO WasteFacility VALUES ('217', 'JorgeTestName2', 'Regione rotto 1', 'IT', 'ITC1', 'ITC11', 'ITC11001127', '418', NULL, '101', 'm','202', 'm2','303', 'm3','404', 'Mt','2000', '2003', 'N', NULL, NULL, 'This is test record', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(396055 4979823)', 32632), 4326), 'POINT(396055 4979823)');


INSERT INTO TreatmentRecyclingPlant VALUES ('216');
INSERT INTO TreatmentRecyclingPlant VALUES ('217');


INSERT INTO PlantFeedingMaterial VALUES ('70', '216', '20 03 01', '2014', '82692.72', 't');
INSERT INTO PlantFeedingMaterial VALUES ('71', '216', '10 01 03', '2014', '2618.45', 't');
INSERT INTO PlantFeedingMaterial VALUES ('72', '216', '19 05 01', '2014', '3191.72', 't');
INSERT INTO PlantFeedingMaterial VALUES ('73', '216', '20 01 11', '2014', '4.56', 't');
INSERT INTO PlantFeedingMaterial VALUES ('74', '216', '20 03 03', '2014', '3809.86', 't');
INSERT INTO PlantFeedingMaterial VALUES ('75', '216', '17 02 03', '2014', '87.455', 't');
INSERT INTO PlantFeedingMaterial VALUES ('76', '216', '17 03 02', '2014', '12.94', 't');
INSERT INTO PlantFeedingMaterial VALUES ('77', '216', '02 01 04', '2014', '4.44', 't');
INSERT INTO PlantFeedingMaterial VALUES ('78', '216', '03 01 01', '2014', '6.92', 't');
INSERT INTO PlantFeedingMaterial VALUES ('79', '216', '04 01 09', '2014', '1.22', 't');
INSERT INTO PlantFeedingMaterial VALUES ('80', '216', '07 02 13', '2014', '58.91', 't');
INSERT INTO PlantFeedingMaterial VALUES ('81', '216', '04 02 21', '2014', '11.64', 't');
INSERT INTO PlantFeedingMaterial VALUES ('82', '216', '04 02 22', '2014', '12.04', 't');
INSERT INTO PlantFeedingMaterial VALUES ('83', '216', '15 02 03', '2014', '19.5', 't');
INSERT INTO PlantFeedingMaterial VALUES ('84', '216', '16 01 19', '2014', '6.82', 't');
INSERT INTO PlantFeedingMaterial VALUES ('85', '216', '16 01 20', '2014', '0.72', 't');
INSERT INTO PlantFeedingMaterial VALUES ('86', '216', '16 01 22', '2014', '1.76', 't');
INSERT INTO PlantFeedingMaterial VALUES ('87', '216', '17 01 07', '2014', '3.1', 't');
INSERT INTO PlantFeedingMaterial VALUES ('88', '216', '17 06 04', '2014', '10.26', 't');
INSERT INTO PlantFeedingMaterial VALUES ('89', '216', '17 08 02', '2014', '35.02', 't');
INSERT INTO PlantFeedingMaterial VALUES ('90', '216', '17 09 04', '2014', '6.57', 't');
INSERT INTO PlantFeedingMaterial VALUES ('91', '216', '19 12 04', '2014', '7995.09', 't');
INSERT INTO PlantFeedingMaterial VALUES ('92', '217', '19 12 12', '2014', '95817.86', 't');
INSERT INTO PlantFeedingMaterial VALUES ('93', '217', '20 01 39', '2014', '1.36', 't');
INSERT INTO PlantFeedingMaterial VALUES ('94', '217', '20 01 99', '2014', '2.4', 't');
INSERT INTO PlantFeedingMaterial VALUES ('95', '217', '20 03 06', '2014', '6.36', 't');
INSERT INTO PlantFeedingMaterial VALUES ('96', '217', '20 03 07', '2014', '2524.727', 't');


INSERT INTO PlantTransport VALUES ('1', '216', 'conveyorbelt');
INSERT INTO PlantTransport VALUES ('2', '216', 'scoopwheel');
INSERT INTO PlantTransport VALUES ('3', '216', 'pipes');
INSERT INTO PlantTransport VALUES ('4', '216', 'excavator');
INSERT INTO PlantTransport VALUES ('5', '216', 'truck');
INSERT INTO PlantTransport VALUES ('6', '217', 'conveyorbelt');
INSERT INTO PlantTransport VALUES ('7', '217', 'screwconveyor');
INSERT INTO PlantTransport VALUES ('8', '217', 'scoopwheel');


INSERT INTO FacilityProcessingActivity VALUES ('130', '216', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('131', '217', 'physicalTreatment');


INSERT INTO PlantStorage VALUES ('1', '216', 'Silos');
INSERT INTO PlantStorage VALUES ('2', '217', 'stockpile');
INSERT INTO PlantStorage VALUES ('3', '217', 'warehouse');


INSERT INTO PlantProduct VALUES ('1', '216', 'chrome', NULL, '11', 't');
INSERT INTO PlantProduct VALUES ('2', '216', 'copper', NULL, '22', 't');
INSERT INTO PlantProduct VALUES ('3', '217', 'fluorite', NULL, '33', 't');
INSERT INTO PlantProduct VALUES ('4', '217', 'iron', NULL, '44', 't');
INSERT INTO PlantProduct VALUES ('5', '216', NULL, 'manganese', '55', 't');
INSERT INTO PlantProduct VALUES ('6', '216', NULL, 'nickel', '66', 't');
INSERT INTO PlantProduct VALUES ('7', '217', NULL, 'platinum', '77', 't');
INSERT INTO PlantProduct VALUES ('8', '217', NULL, 'quartz', '88', 't');


