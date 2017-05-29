-- Real data
-- type: treatment plant


INSERT INTO Operator VALUES ('409', 'ARAL SPA', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('410', 'Cosmo spa', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('411', 'GAIA Spa', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('412', 'AS.RAB. Spa', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('413', 'A2A AMBIENTE SPA', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('414', 'A.C.E.M. Az.Cons.Ecol.Monregalese', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('415', 'S.T.R. Societa'' Trattamento Rifiuti Srl', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('416', 'ACSR SPA', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('417', 'ACEA PINEROLESE INDUSTRIALE', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Operator VALUES ('418', 'Cavit spa', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO WasteFacility VALUES ('206', NULL, 'FRAZIONE CASTELCERIOLO LOC TRONO', 'IT', 'ITC1', 'ITC18', 'ITC18006003', '409', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(476314 4972400)', 32632), 4326), 'POINT(476314 4972400)');
INSERT INTO WasteFacility VALUES ('207', NULL, 'STR. RONCAGLIA, 4/C - FRAZ. RONCAGLIA', 'IT', 'ITC1', 'ITC18', 'ITC18006039', '410', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(458401 4991722)', 32632), 4326), 'POINT(458401 4991722)');
INSERT INTO WasteFacility VALUES ('208', NULL, 'FRAZIONE QUARTO INFERIORE 273/D - LOCALITA'' VALTERZA', 'IT', 'ITC1', 'ITC17', 'ITC17005005', '411', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(441555 4972594)', 32632), 4326), 'POINT(441555 4972594)');
INSERT INTO WasteFacility VALUES ('209', NULL, 'VIA DELLA MANDRIA', 'IT', 'ITC1', 'ITC13', 'ITC13096016', '412', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(431549 5025651)', 32632), 4326), 'POINT(431549 5025651)');
INSERT INTO WasteFacility VALUES ('210', NULL, 'LOCALITA'' FORMIELLE CASCINA DELLE FORMICHE', 'IT', 'ITC1', 'ITC16', 'ITC16004244', '413', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(385318 4935347)', 32632), 4326), 'POINT(385318 4935347)');
INSERT INTO WasteFacility VALUES ('211', NULL, 'Loc. Beinale', 'IT', 'ITC1', 'ITC16', 'ITC16004114', '414', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(403382 4925235)', 32632), 4326), 'POINT(403382 4925235)');
INSERT INTO WasteFacility VALUES ('212', NULL, 'Frazione Agostinassi, Localita'' Grangia 19', 'IT', 'ITC1', 'ITC16', 'ITC16004114', '415', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(400592 4954119)', 32632), 4326), 'POINT(400592 4954119)');
INSERT INTO WasteFacility VALUES ('213', NULL, 'LOCALITA'' S. NICOLAO -VIA AMBOVO n. 63/A', 'IT', 'ITC1', 'ITC16', 'ITC16004025', '416', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(379505 4911736)', 32632), 4326), 'POINT(379505 4911736)');
INSERT INTO WasteFacility VALUES ('214', NULL, 'loc.Depuratore zona F9 del PRGC di Pinerolo', 'IT', 'ITC1', 'ITC11', 'ITC11001191', '417', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, 'mechanical and biological treatment of MSW', 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(370652 4971344)', 32632), 4326), 'POINT(370652 4971344)');
INSERT INTO WasteFacility VALUES ('215', NULL, 'Regione rotto 1', 'IT', 'ITC1', 'ITC11', 'ITC11001127', '418', NULL, NULL, 'm',NULL, 'm2',NULL, 'm3',NULL, 'Mt',NULL, NULL, 'N', NULL, NULL, NULL, 'Treatment', NULL, 'N', ST_Transform(ST_GeomFromText('POINT(396054 4979816)', 32632), 4326), 'POINT(396054 4979816)');


INSERT INTO TreatmentRecyclingPlant VALUES ('206');
INSERT INTO TreatmentRecyclingPlant VALUES ('207');
INSERT INTO TreatmentRecyclingPlant VALUES ('208');
INSERT INTO TreatmentRecyclingPlant VALUES ('209');
INSERT INTO TreatmentRecyclingPlant VALUES ('210');
INSERT INTO TreatmentRecyclingPlant VALUES ('211');
INSERT INTO TreatmentRecyclingPlant VALUES ('212');
INSERT INTO TreatmentRecyclingPlant VALUES ('213');
INSERT INTO TreatmentRecyclingPlant VALUES ('214');
INSERT INTO TreatmentRecyclingPlant VALUES ('215');


INSERT INTO PlantFeedingMaterial VALUES ('1', '206', '20 03 01', '2014', '82692.72', 't');
INSERT INTO PlantFeedingMaterial VALUES ('2', '206', '10 01 03', '2014', '2618.45', 't');
INSERT INTO PlantFeedingMaterial VALUES ('3', '206', '19 05 01', '2014', '3191.72', 't');
INSERT INTO PlantFeedingMaterial VALUES ('4', '206', '20 01 11', '2014', '4.56', 't');
INSERT INTO PlantFeedingMaterial VALUES ('5', '206', '20 03 03', '2014', '3809.86', 't');
INSERT INTO PlantFeedingMaterial VALUES ('6', '206', '17 02 03', '2014', '87.455', 't');
INSERT INTO PlantFeedingMaterial VALUES ('7', '206', '17 03 02', '2014', '12.94', 't');
INSERT INTO PlantFeedingMaterial VALUES ('8', '206', '02 01 04', '2014', '4.44', 't');
INSERT INTO PlantFeedingMaterial VALUES ('9', '206', '03 01 01', '2014', '6.92', 't');
INSERT INTO PlantFeedingMaterial VALUES ('10', '206', '04 01 09', '2014', '1.22', 't');
INSERT INTO PlantFeedingMaterial VALUES ('11', '206', '07 02 13', '2014', '58.91', 't');
INSERT INTO PlantFeedingMaterial VALUES ('12', '206', '04 02 21', '2014', '11.64', 't');
INSERT INTO PlantFeedingMaterial VALUES ('13', '206', '04 02 22', '2014', '12.04', 't');
INSERT INTO PlantFeedingMaterial VALUES ('14', '206', '15 02 03', '2014', '19.5', 't');
INSERT INTO PlantFeedingMaterial VALUES ('15', '206', '16 01 19', '2014', '6.82', 't');
INSERT INTO PlantFeedingMaterial VALUES ('16', '206', '16 01 20', '2014', '0.72', 't');
INSERT INTO PlantFeedingMaterial VALUES ('17', '206', '16 01 22', '2014', '1.76', 't');
INSERT INTO PlantFeedingMaterial VALUES ('18', '206', '17 01 07', '2014', '3.1', 't');
INSERT INTO PlantFeedingMaterial VALUES ('19', '206', '17 06 04', '2014', '10.26', 't');
INSERT INTO PlantFeedingMaterial VALUES ('20', '206', '17 08 02', '2014', '35.02', 't');
INSERT INTO PlantFeedingMaterial VALUES ('21', '206', '17 09 04', '2014', '6.57', 't');
INSERT INTO PlantFeedingMaterial VALUES ('22', '206', '19 12 04', '2014', '7995.09', 't');
INSERT INTO PlantFeedingMaterial VALUES ('23', '206', '19 12 12', '2014', '95817.86', 't');
INSERT INTO PlantFeedingMaterial VALUES ('24', '206', '20 01 39', '2014', '1.36', 't');
INSERT INTO PlantFeedingMaterial VALUES ('25', '206', '20 01 99', '2014', '2.4', 't');
INSERT INTO PlantFeedingMaterial VALUES ('26', '206', '20 03 06', '2014', '6.36', 't');
INSERT INTO PlantFeedingMaterial VALUES ('27', '206', '20 03 07', '2014', '2524.727', 't');
INSERT INTO PlantFeedingMaterial VALUES ('28', '207', '20 03 01', '2014', '11169.74', 't');
INSERT INTO PlantFeedingMaterial VALUES ('29', '207', '03 01 05', '2014', '2.18', 't');
INSERT INTO PlantFeedingMaterial VALUES ('30', '207', '19 05 01', '2014', '153.08', 't');
INSERT INTO PlantFeedingMaterial VALUES ('31', '207', '19 12 12', '2014', '2.2', 't');
INSERT INTO PlantFeedingMaterial VALUES ('32', '208', '20 03 01', '2014', '29736.38', 't');
INSERT INTO PlantFeedingMaterial VALUES ('33', '208', '19 12 12', '2014', '5317.38', 't');
INSERT INTO PlantFeedingMaterial VALUES ('34', '209', '20 03 01', '2014', '89744.59', 't');
INSERT INTO PlantFeedingMaterial VALUES ('35', '209', '20 02 03', '2014', '3.6', 't');
INSERT INTO PlantFeedingMaterial VALUES ('36', '209', '20 03 02', '2014', '183.43', 't');
INSERT INTO PlantFeedingMaterial VALUES ('37', '209', '20 03 03', '2014', '1715.38', 't');
INSERT INTO PlantFeedingMaterial VALUES ('38', '209', '20 03 07', '2014', '3954.66', 't');
INSERT INTO PlantFeedingMaterial VALUES ('39', '210', '20 03 01', '2014', '32603.36', 't');
INSERT INTO PlantFeedingMaterial VALUES ('40', '210', '19 08 01', '2014', '22.48', 't');
INSERT INTO PlantFeedingMaterial VALUES ('41', '210', '15 01 02', '2014', '6278.78', 't');
INSERT INTO PlantFeedingMaterial VALUES ('42', '210', '15 01 06', '2014', '396.82', 't');
INSERT INTO PlantFeedingMaterial VALUES ('43', '210', '19 12 12', '2014', '22989.82', 't');
INSERT INTO PlantFeedingMaterial VALUES ('44', '210', '20 03 07', '2014', '1265.72', 't');
INSERT INTO PlantFeedingMaterial VALUES ('45', '211', '20 03 01', '2014', '17605.06', 't');
INSERT INTO PlantFeedingMaterial VALUES ('46', '212', '20 03 01', '2014', '32701.01', 't');
INSERT INTO PlantFeedingMaterial VALUES ('47', '212', '15 01 02', '2014', '1207.06', 't');
INSERT INTO PlantFeedingMaterial VALUES ('48', '212', '19 12 04', '2014', '2342.53', 't');
INSERT INTO PlantFeedingMaterial VALUES ('49', '212', '19 12 12', '2014', '1008.81', 't');
INSERT INTO PlantFeedingMaterial VALUES ('50', '212', '20 03 07', '2014', '1150.49', 't');
INSERT INTO PlantFeedingMaterial VALUES ('51', '213', '20 03 01', '2014', '34712.01', 't');
INSERT INTO PlantFeedingMaterial VALUES ('52', '213', '15 01 06', '2014', '4.76', 't');
INSERT INTO PlantFeedingMaterial VALUES ('53', '213', '19 12 12', '2014', '727.44', 't');
INSERT INTO PlantFeedingMaterial VALUES ('54', '213', '20 03 07', '2014', '365.04', 't');
INSERT INTO PlantFeedingMaterial VALUES ('55', '214', '20 03 01', '2014', '7576.64', 't');
INSERT INTO PlantFeedingMaterial VALUES ('56', '214', '15 01 02', '2014', '10.54', 't');
INSERT INTO PlantFeedingMaterial VALUES ('57', '214', '15 01 06', '2014', '290.56', 't');
INSERT INTO PlantFeedingMaterial VALUES ('58', '214', '19 12 12', '2014', '59.05', 't');
INSERT INTO PlantFeedingMaterial VALUES ('59', '214', '20 03 07', '2014', '4434.74', 't');
INSERT INTO PlantFeedingMaterial VALUES ('60', '215', '01 04 13', '2014', '1288.55', 't');
INSERT INTO PlantFeedingMaterial VALUES ('61', '215', '12 01 02', '2014', '62.5', 't');
INSERT INTO PlantFeedingMaterial VALUES ('62', '215', '17 01 01', '2014', '2134.03', 't');
INSERT INTO PlantFeedingMaterial VALUES ('63', '215', '17 01 02', '2014', '4.56', 't');
INSERT INTO PlantFeedingMaterial VALUES ('64', '215', '17 01 03', '2014', '17.62', 't');
INSERT INTO PlantFeedingMaterial VALUES ('65', '215', '17 01 07', '2014', '46843.5', 't');
INSERT INTO PlantFeedingMaterial VALUES ('66', '215', '17 05 04', '2014', '62590.55', 't');
INSERT INTO PlantFeedingMaterial VALUES ('67', '215', '17 05 08', '2014', '528.55', 't');
INSERT INTO PlantFeedingMaterial VALUES ('68', '215', '17 08 02', '2014', '72.18', 't');
INSERT INTO PlantFeedingMaterial VALUES ('69', '215', '17 09 04', '2014', '60638.09', 't');


INSERT INTO FacilityProcessingActivity VALUES ('120', '206', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('121', '207', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('122', '208', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('123', '209', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('124', '210', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('125', '211', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('126', '212', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('127', '213', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('128', '214', 'physicalTreatment');
INSERT INTO FacilityProcessingActivity VALUES ('129', '215', 'physicalTreatment');


INSERT INTO PlantWasteProduced VALUES ('1', '215', '16 01 17', '5.05');
INSERT INTO PlantWasteProduced VALUES ('2', '215', '17 02 01', '2.95');
INSERT INTO PlantWasteProduced VALUES ('3', '215', '17 04 05', '303.18');
INSERT INTO PlantWasteProduced VALUES ('4', '215', '17 04 07', '3.4');
INSERT INTO PlantWasteProduced VALUES ('5', '215', '17 06 03*', '1.32');
INSERT INTO PlantWasteProduced VALUES ('6', '215', '19 12 01', '10.92');
INSERT INTO PlantWasteProduced VALUES ('7', '215', '19 12 04', '7.1');
INSERT INTO PlantWasteProduced VALUES ('8', '215', '19 12 07', '373.69');
INSERT INTO PlantWasteProduced VALUES ('9', '215', '19 12 12', '216.06');
INSERT INTO PlantWasteProduced VALUES ('10', '215', '15 01 01', '2.34');
INSERT INTO PlantWasteProduced VALUES ('11', '215', '15 01 03', '1.54');
INSERT INTO PlantWasteProduced VALUES ('12', '215', '15 01 06', '2.52');


