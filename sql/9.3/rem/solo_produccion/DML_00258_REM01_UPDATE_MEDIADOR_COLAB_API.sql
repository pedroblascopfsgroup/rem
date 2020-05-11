--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200417
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6964
--## PRODUCTO=SI
--##
--## Finalidad: Script que da de baja ciertos mediadores de tipo colaborador api.
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(4000 CHAR);
	V_SQL VARCHAR2(4000 CHAR);
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_NUM NUMBER(16); -- Vble. para validar la existencia de un registro.
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	V_USR VARCHAR2(30 CHAR) := 'REMVIP-6964'; -- USUARIOCREAR/USUARIOMODIFICAR.
	
	TYPE T_VAR IS TABLE OF VARCHAR2(100);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR; 
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(
		-- 	PVE_NOMBRE 													PVE_DOCIDENTIF 	DD_TPR_CODIGO 	BORRADO
		T_VAR('VISUALGEO SL', 											'B35564582', 	'04', 			'1'),
		T_VAR('TU MEJOR HOGAR SPAIN SL', 								'B98340839', 	'04', 			'1'),
		T_VAR('The Property Gallery, SL', 								'B38942876', 	'04', 			'1'),
		T_VAR('TALLER DE ESTUDIOS INMOBILIARIOS', 						'B03877677', 	'04', 			'1'),
		T_VAR('SUHOGAR SEVILLA S.L', 									'B91266163', 	'04', 			'1'),
		T_VAR('SERGIO GONZÁLEZ SÁNCHEZ', 								'46868366R', 	'04', 			'1'),
		T_VAR('SANTALIESTRA HOME SOLUTIONS, SL', 						'B22349674', 	'04', 			'1'),
		T_VAR('RICARD ABAD DESCALZO', 									'34733327S', 	'04', 			'1'),
		T_VAR('RENT RENTING S.L.', 										'B91817353', 	'04', 			'1'),
		T_VAR('RASEFA INVERSIONES S.L.', 								'B76552694', 	'04', 			'1'),
		T_VAR('PROMOCIONES RUVIR MUELLE DE OLABEAGA SL', 				'B95501177', 	'04', 			'1'),
		T_VAR('MUGA servicios Inmobiliarios S.L.', 						'B31869100', 	'04', 			'1'),
		T_VAR('LORENA BELMONTE MONFORT', 								'73393278W', 	'04', 			'1'),
		T_VAR('JOSE CLAUDIO HERNANDO BRIALES', 							'25673435F', 	'04', 			'1'),
		T_VAR('JOSE GARCIA BARRERA', 									'34050040N', 	'04', 			'1'),
		T_VAR('INVERSIONES HERQUIN, SL', 								'B35712207', 	'04', 			'1'),
		T_VAR('INMOBILIARIA ARENAS 1943 SL', 							'B39634514', 	'04', 			'1'),
		T_VAR('HOGARMOSA S.L.', 										'B91822338', 	'04', 			'1'),
		T_VAR('GLORIA MONTSANT TRIADO', 								'47718664N', 	'04', 			'1'),
		T_VAR('FRANCISCO BRAVO SANCHEZ', 								'15829137P', 	'04', 			'1'),
		T_VAR('FERBANXER SL NAVARRO NAVARRO', 							'B76088160', 	'04', 			'1'),
		T_VAR('EXPANSION DE SUELO, S.L.', 								'B84644921', 	'04', 			'1'),
		T_VAR('DESIREE', 												'24320614T', 	'04', 			'1'),
		T_VAR('CRESA PATRIMONIAL, S.L.', 								'B61850566', 	'04', 			'1'),
		T_VAR('COLON DE CARVAJAL, SOLANA, CARDONA ABOGADOS SLP', 		'B82615436', 	'04', 			'1'),
		T_VAR('CAPITAL FOR SALE SL', 									'B76596899', 	'04', 			'1'),
		T_VAR('CAFUR GESTIONA, S.L.U.', 								'A08397820', 	'04', 			'1'),
		T_VAR('ATICO MIRAFLORES S.L.', 									'B41823691', 	'04', 			'1'),
		T_VAR('ASSESSORAMENT I SERVEIS IMMOBILIARIS LA LLAR S.L.', 		'B62072319', 	'04', 			'1'),
		T_VAR('ASESORIA INMOBILIARIA REAL 28 S.L.', 					'B47459151', 	'04', 			'1'),
		T_VAR('DARIUS PAWEL MALKINSKI', 								'Y4456299V', 	'04', 			'1'),
		T_VAR('Aladin Diab', 											'Y2607391X', 	'04', 			'1'),
		T_VAR('ANDREW ROBERT VOSS', 									'X5852794F', 	'04', 			'1'),
		T_VAR('AGRELA SC', 												'J88177795', 	'04', 			'1'),
		T_VAR('THE LEMON KEY SL', 										'B98909617', 	'04', 			'1'),
		T_VAR('LUXURY HOMES CONSULTING SL', 							'B98610025', 	'04', 			'1'),
		T_VAR('NATUROCIO ACTIVO S.L', 									'B98426299', 	'04', 			'1'),
		T_VAR('SUÑER ASESORES FINANCIEROS S.L', 						'B97939987', 	'04', 			'1'),
		T_VAR('SERVICIOS FINANCIEROS HISPAFINANCIA SL', 				'B97628044', 	'04', 			'1'),
		T_VAR('VALSUETEC SL', 											'B97535660', 	'04', 			'1'),
		T_VAR('LOGISTICA DE INVERSIONES EUROPEAS, SL', 					'B97527618', 	'04', 			'1'),
		T_VAR('JOSYMO 2002 RENT SL', 									'B97158018', 	'04', 			'1'),
		T_VAR('HOSNIMAR, S.L.', 										'B96312897', 	'04', 			'1'),
		T_VAR('GLOBAL ATRIUM PROPERTIES SL', 							'B93467009', 	'04', 			'1'),
		T_VAR('FURUHOLMEN SL', 											'B93451193', 	'04', 			'1'),
		T_VAR('APARTAMENTOS TERRA COSTA DEL SOL SL', 					'B93410504', 	'04', 			'1'),
		T_VAR('HOGALIA SOLUCIONES INMOBILIARIAS S.L', 					'B91846287', 	'04', 			'1'),
		T_VAR('BUFETE BENITEZ GIRALDEZ SL', 							'B91553198', 	'04', 			'1'),
		T_VAR('PETORIA S.L.', 											'B90173915', 	'04', 			'1'),
		T_VAR('ANDALFIN SL', 											'B90099128', 	'04', 			'1'),
		T_VAR('HOUSE IN MADRID AND SPAIN,S.L.', 						'B87149563', 	'04', 			'1'),
		T_VAR('ALYVENT LUÃEZ S.L.', 									'B86989696', 	'04', 			'1'),
		T_VAR('IRIO CONSULTORIA Y COMUNICACION SL', 					'B83967216', 	'04', 			'1'),
		T_VAR('FRANCISCO LILLO GESTION Y PROMOCION SL', 				'B83035980', 	'04', 			'1'),
		T_VAR('FAVRO 44 S.L.U.', 										'B82765124', 	'04', 			'1'),
		T_VAR('EUROLLAVE S.L', 											'B81895690', 	'04', 			'1'),
		T_VAR('THE RETAIL NETWORK SL.', 								'B79943569', 	'04', 			'1'),
		T_VAR('MACONDE INMOBILIARIA, S.L.', 							'B79445631', 	'04', 			'1'),
		T_VAR('GESTINMOBIL PROJECTS, S.L.', 							'B78063567', 	'04', 			'1'),
		T_VAR('CRISIS BAY S.L.', 										'B76612704', 	'04', 			'1'),
		T_VAR('CARLOTA INVEST 2018 SL', 								'B76310499', 	'04', 			'1'),
		T_VAR('ACTOPROR, SL', 											'B74090978', 	'04', 			'1'),
		T_VAR('CORPOMOLINA 2015SLU', 									'B73894016', 	'04', 			'1'),
		T_VAR('NUEVA RESIDENCIA GESTION INMOBILIARIA SLU', 				'B73418345', 	'04', 			'1'),
		T_VAR('INMOPOLT GESTION INMOBILIARIA S.L', 						'B73319428', 	'04', 			'1'),
		T_VAR('INFORMES URBANOS SL', 									'B73249898', 	'04', 			'1'),
		T_VAR('INVEERTO COACHING,S.L.', 								'B66758871', 	'04', 			'1'),
		T_VAR('NIELLA SOLUTIONS,S.L.U.', 								'B66648684', 	'04', 			'1'),
		T_VAR('COMUNTERRA SLU', 										'B66204785', 	'04', 			'1'),
		T_VAR('ACTIVA GESTION SERVICIOS HIPOTECARIOS SL', 				'B65299729', 	'04', 			'1'),
		T_VAR('ZAFRA-PINTOR SL', 										'B61023255', 	'04', 			'1'),
		T_VAR('QPARC 2014 SL', 											'B55197172', 	'04', 			'1'),
		T_VAR('NOU MILENIUM ETAGE, S.L.', 								'B55054761', 	'04', 			'1'),
		T_VAR('INVESPROPERTY WORLDWIDE, S.L.', 							'B54735527', 	'04', 			'1'),
		T_VAR('GISMIPA ASOCIADOS, S.L.', 								'B47642335', 	'04', 			'1'),
		T_VAR('INICIATIVAS ACASA10 SL', 								'B45875069', 	'04', 			'1'),
		T_VAR('ESTUDIO ARTICE SL', 										'B45868692', 	'04', 			'1'),
		T_VAR('ROMEU IMMOBLES-FINANCIAL,S.L.', 							'B43844588', 	'04', 			'1'),
		T_VAR('CYM HOME S.L.', 											'B40570384', 	'04', 			'1'),
		T_VAR('KARMA GESTION S.L', 										'B40532244', 	'04', 			'1'),
		T_VAR('INMOBILIARIA CASALANZ PROM. Y GEST. S.L', 				'B35759323', 	'04', 			'1'),
		T_VAR('MASTER TORRE PACHECO S.L', 								'B30916662', 	'04', 			'1'),
		T_VAR('PROYECTOS COMERCIALES MEJIAS S.L', 						'B29526639', 	'04', 			'1'),
		T_VAR('M6 UNIDOS SL', 											'B23215775', 	'04', 			'1'),
		T_VAR('PROMOCIONES INMOBILIARIAS BAILON TRUJILLO, S.L.', 		'B18774885', 	'04', 			'1'),
		T_VAR('BENCASBROK S.L', 										'B12884706', 	'04', 			'1'),
		T_VAR('INVERSIONES JOLKER SL', 									'B12766093', 	'04', 			'1'),
		T_VAR('REFORMAS INTEGRALES VORAMAR SOCIEDAD LIM', 				'B12539706', 	'04', 			'1'),
		T_VAR('Oceanterre,S.L.', 										'B11763125', 	'04', 			'1'),
		T_VAR('CENTRE COMPTABLE LA VILA SL', 							'B07554512', 	'04', 			'1'),
		T_VAR('AMABIT SERVICIOS INMOBILIARIOS SL', 						'B04875407', 	'04', 			'1'),
		T_VAR('HORIZON SOLUCIONES Y GESTION INMOB., SL', 				'B04839775', 	'04', 			'1'),
		T_VAR('CONSULTING SANCHEZ CASTILLO Y ASOCIADOS, SL.', 			'B04635009', 	'04', 			'1'),
		T_VAR('ZENTEC RACING S.L.', 									'B04472429', 	'04', 			'1'),
		T_VAR('AGENTE FINANCIERO ALMANZORA SL', 						'B04466611', 	'04', 			'1'),
		T_VAR('RUES INMO S.A.', 										'A12354429', 	'04', 			'1'),
		T_VAR('JORGE OSVALDO PASSINI KEENA', 							'79213387F', 	'04', 			'1'),
		T_VAR('MARIANO OSVALDO AQUINO LOPEZ', 							'78833443T', 	'04', 			'1'),
		T_VAR('BTIHAJ LOUDRHIRI ZOUITA', 								'77699784B', 	'04', 			'1'),
		T_VAR('JOSEFA MARTINEZ HARO', 									'77500318R', 	'04', 			'1'),
		T_VAR('IMANOL CABELLO VERGARA', 								'77474638N', 	'04', 			'1'),
		T_VAR('ROCIO SANCHEZ NARANJO', 									'77454482G', 	'04', 			'1'),
		T_VAR('BEGOÑA SEGURA MARTINEZ', 								'75712632J', 	'04', 			'1'),
		T_VAR('JORGE RAMOS ARANDA', 									'75271065T', 	'04', 			'1'),
		T_VAR('CRISTOBAL VALERA MARTINEZ', 								'75225657V', 	'04', 			'1'),
		T_VAR('CRISTOBAL MUÑOZ RUIZ', 									'74854332G', 	'04', 			'1'),
		T_VAR('DAVID MARTIN MARTIN', 									'74843904H', 	'04', 			'1'),
		T_VAR('BORJA GALAN BORT', 										'73594299A', 	'04', 			'1'),
		T_VAR('VICENTA TORMOS MORENO', 									'73501385D', 	'04', 			'1'),
		T_VAR('MIREIA LLINARES RIBES', 									'73389524C', 	'04', 			'1'),
		T_VAR('JAVIER RUIZ LLEO', 										'73375760X', 	'04', 			'1'),
		T_VAR('PEDRO FIGUEROA DOMINGUEZ', 								'53691186D', 	'04', 			'1'),
		T_VAR('JOSE ANTONIO RAMOS LOPEZ', 								'53366408Z', 	'04', 			'1'),
		T_VAR('BEGO#A BLASCO ALEMANY', 									'53364545Z', 	'04', 			'1'),
		T_VAR('MARCOS CABELLO CAMPOS', 									'52579392N', 	'04', 			'1'),
		T_VAR('CARLOS IGNACIO GARCIA MARZAL', 							'48313425Q', 	'04', 			'1'),
		T_VAR('CAROLINA ELVIRA LÓPEZ', 									'47219663L', 	'04', 			'1'),
		T_VAR('FRANCISCO JAVIER HERNANDEZ MARQUEZ', 					'45593541C', 	'04', 			'1'),
		T_VAR('BALBIR DHANWANI KISHINCHAND', 							'45120833P', 	'04', 			'1'),
		T_VAR('JOSE SANAHUJA FUERTES', 									'44866420K', 	'04', 			'1'),
		T_VAR('RAQUEL CAÑERO RIBERA', 									'44851716Z', 	'04', 			'1'),
		T_VAR('ALICIA PASTOR GOMEZ', 									'44803816T', 	'04', 			'1'),
		T_VAR('ANDREA LACOBA EXPOSITO', 								'44797104G', 	'04', 			'1'),
		T_VAR('MARIA AURORA MURCIANO SANTOLAYA', 						'44013611Y', 	'04', 			'1'),
		T_VAR('JUAN ARIEL MEJIAS FELIPE', 								'42874405J', 	'04', 			'1'),
		T_VAR('Juana Saura Martínez', 									'34834004K', 	'04', 			'1'),
		T_VAR('JOSE ANTONIO ORTIZ CARRILLO', 							'34809979P', 	'04', 			'1'),
		T_VAR('LAURA MILLAN RUIZ', 										'28636174R', 	'04', 			'1'),
		T_VAR('SOFIA NAVARRO RAMIREZ', 									'27528591Y', 	'04', 			'1'),
		T_VAR('GUSTAVO CORREDERA MARTOS', 								'27527664E', 	'04', 			'1'),
		T_VAR('JOSE VICTOR LOZANO PATO', 								'27484215C', 	'04', 			'1'),
		T_VAR('JUAN ANTONIO AMADOR SIMON', 								'24832317E', 	'04', 			'1'),
		T_VAR('Cristina da Casa Pérez', 								'24409464R', 	'04', 			'1'),
		T_VAR('LORETO TORREGROSA ROGER', 								'24381606L', 	'04', 			'1'),
		T_VAR('VICENTE RAMON TORTAJADA CHARDI', 						'24350608W', 	'04', 			'1'),
		T_VAR('ANGELA PEREGRIN RODRIGUEZ', 								'24252315B', 	'04', 			'1'),
		T_VAR('JUAN SEBASTIAN FERNANDEZ FERNANDEZ', 					'22686499N', 	'04', 			'1'),
		T_VAR('ANTONIO JOSE LOSA PARRA', 								'22556279H', 	'04', 			'1'),
		T_VAR('RAUL SERRA GREGORI', 									'20806225B', 	'04', 			'1'),
		T_VAR('SANTIAGO JOSE DIAZ FERNANDEZ', 							'20033328Y', 	'04', 			'1'),
		T_VAR('JUAN JOSE PIQUER MESTRE', 								'19093833S', 	'04', 			'1'),
		T_VAR('EMILIO RAMIREZ FUENTES', 								'18992920A', 	'04', 			'1'),
		T_VAR('MIRIAM GONZALEZ GARCIA', 								'15441761K', 	'04', 			'1'),
		T_VAR('ROSA MARIA DEL CAMPO ORTEGA', 							'12232382Q', 	'04', 			'1'),
		T_VAR('EDUARDO GARCIA GARCIA', 									'10892024Y', 	'04', 			'1'),
		T_VAR('SILVERIO CAMPOS RODRIGUEZ', 								'07484807D', 	'04', 			'1'),
		T_VAR('SHIRA AREVALO GORDON', 									'06632229H', 	'04', 			'1'),
		T_VAR('MARIA NURIA ROJAS ROJAS', 								'05676569P', 	'04', 			'1'),
		T_VAR('AURELIA SABOU', 											'416864', 		'04', 			'1'),
		T_VAR('ARLANDIS Y ROMERO, SL', 									'B98879919', 	'04', 			'1'),
		T_VAR('FUTURCASA PAIPORTA S.L', 								'B97315295', 	'04', 			'1'),
		T_VAR('DIAZ VILLARUEL PROPIEDADES S.L', 						'B93092047', 	'04', 			'1'),
		T_VAR('GESTION DE INMUEBLES ADJUDICADOS S.L.', 					'B73552085', 	'04', 			'1'),
		T_VAR('CEN.INFORM.Y SERV.PARA MERCADO INMOB.S.A', 				'A28727204', 	'04', 			'1'),
		T_VAR('PABLO CASTRO NAVARRO', 									'52691839N', 	'04', 			'1'),
		T_VAR('PAULINO MOTILLA CANTO', 									'21667268A', 	'04', 			'1'),
		T_VAR('MARIA INMACULADA DE RODRIGO DIEGO', 						'07837257F', 	'04', 			'1'),
		T_VAR('TAMARA MILLIGAN', 										'Y2348368J', 	'04', 			'1'),
		T_VAR('RIMA TARIKET', 											'X3620468S', 	'04', 			'1'),
		T_VAR('GESTINFI SC', 											'J98614795', 	'04', 			'1'),
		T_VAR('PROAUMENTUS SL', 										'B98812548', 	'04', 			'1'),
		T_VAR('ZURKIA 6A', 												'B93353811', 	'04', 			'1'),
		T_VAR('PROMAR LCT PROYECTOS Y OBRAS S.L.', 						'B91926212', 	'04', 			'1'),
		T_VAR('PROMOCIONES Y PROYECTOS ALCA SL', 						'B86043411', 	'04', 			'1'),
		T_VAR('GRUPO EMPRESARIAL KARAL SL', 							'B65647752', 	'04', 			'1'),
		T_VAR('MALLORCA OPEN S.L.', 									'B57942807', 	'04', 			'1'),
		T_VAR('SERPACAN CONSULTORES SL', 								'B39416524', 	'04', 			'1'),
		T_VAR('PROMOVALI#AS, S.L.', 									'B36340578', 	'04', 			'1'),
		T_VAR('APROVIP. VIVIENDAS PROTEGIDAS 2006, S.A.', 				'A84649235', 	'04', 			'1'),
		T_VAR('CARLOS ESCOBAR NAVARRETE', 								'75242778A', 	'04', 			'1'),
		T_VAR('PEDRO VALLEJOS TORRES', 									'75126439K', 	'04', 			'1'),
		T_VAR('CARLOS DE MIGUEL ARIAS', 								'71161792E', 	'04', 			'1'),
		T_VAR('FELIPE CEFERINO SANCHEZ', 								'52802619R', 	'04', 			'1'),
		T_VAR('JOAQUIN MANRESA QUIRANTE', 								'48638517A', 	'04', 			'1'),
		T_VAR('RAFAEL ESTEPA GIJON', 									'37797838Y', 	'04', 			'1'),
		T_VAR('CRUZ AMPARO IGUALA CHOLBI', 								'29166480L', 	'04', 			'1'),
		T_VAR('FRANCISCO JOSE JUSTO GUEVARA', 							'27525993F', 	'04', 			'1'),
		T_VAR('JUANA PARRA SANCHEZ', 									'27496983T', 	'04', 			'1'),
		T_VAR('ARACELI TORTAJADA FELICI', 								'20809613H', 	'04', 			'1'),
		T_VAR('MIGUEL ANGEL RUBIA RODRIGUEZ', 							'05907531G', 	'04', 			'1'),
		T_VAR('SERVICIOS INMOBILIARIOS BOMBARDO MARTIN', 				'B12834552', 	'04', 			'1'),
		T_VAR('VICTORZARAGOZAGONZALVO', 								'47825150P', 	'04', 			'1'),
		T_VAR('VicenteSANCHEZPEREZ', 									'53707835Y', 	'04', 			'1'),
		T_VAR('MARIA AZUCENAMARTÍNEZPORRAS', 							'30567415R', 	'04', 			'1'),
		T_VAR('Luis MaríaCasaresInfante', 								'71941973C', 	'04', 			'1'),
		T_VAR('JOSE MARIADIAZBLAZQUEZ', 								'37791081B', 	'04', 			'1'),
		T_VAR('CARLOSALBERTRAMOS', 										'48532379X', 	'04', 			'1'),
		T_VAR('BLANCACHECAPURI', 										'25165374Q', 	'04', 			'1'),
		T_VAR('VERKASA GESTION, S.L.U.', 								'B85018760', 	'04', 			'1'),
		T_VAR('Velez Casa SL', 											'B92400498', 	'04', 			'1'),
		T_VAR('Tribeus Investments SL', 								'B54764220', 	'04', 			'1'),
		T_VAR('TOT VIVENDES 2007, S.L.', 								'B25634213', 	'04', 			'1'),
		T_VAR('SUCESORES DE PEDRO DORTA Y HNOS, S.L.', 					'B38388062', 	'04', 			'1'),
		T_VAR('SERVICIOS INMOBILIARIOS NIDA', 							'B70487228', 	'04', 			'1'),
		T_VAR('Serv.Admnivos y de Gestión Oyón Veintiuno S.L.', 		'B01493873', 	'04', 			'1'),
		T_VAR('ORTEGA DELGADO GESTION S.L.', 							'B09416355', 	'04', 			'1'),
		T_VAR('NATIC SL', 												'B43129394', 	'04', 			'1'),
		T_VAR('MULTIGESTION EXTREMEÑA S.L.', 							'B10134294', 	'04', 			'1'),
		T_VAR('MAR, SOL Y CIELO, S.L.', 								'B03913787', 	'04', 			'1'),
		T_VAR('LLIRIA HOME SLU', 										'B98696487', 	'04', 			'1'),
		T_VAR('JOSSON 2000 S.L.', 										'B26291229', 	'04', 			'1'),
		T_VAR('JAGABUSINESS SL', 										'B63119531', 	'04', 			'1'),
		T_VAR('Inversiones Pastor Requena', 							'B53199592', 	'04', 			'1'),
		T_VAR('INVER PISO STATE S.L', 									'B86897055', 	'04', 			'1'),
		T_VAR('INMUEBLES COMARCA ZARAGOZA, SUR, .L.', 					'B99028789', 	'04', 			'1'),
		T_VAR('INMOCINCA 2005, SL', 									'B22295836', 	'04', 			'1'),
		T_VAR('Inmobiliaria Ikasa, División Promoción, S.L.', 			'B28240174', 	'04', 			'1'),
		T_VAR('Grupo Hipotecario Casas, S.L', 							'B85507135', 	'04', 			'1'),
		T_VAR('GRUPO DE NEGOCIOS VIGOMAN,S.L.', 						'B45489846', 	'04', 			'1'),
		T_VAR('GPI AZPIROZ SL', 										'B31625056', 	'04', 			'1'),
		T_VAR('GOMEZ-CORRALES ASESORES SL', 							'B45630613', 	'04', 			'1'),
		T_VAR('GESTIONES GERUGA S.L.', 									'B65815367', 	'04', 			'1'),
		T_VAR('Gestion Total Diversa S.L.', 							'B57523326', 	'04', 			'1'),
		T_VAR('CRAHER PLAN SL', 										'B86518750', 	'04', 			'1'),
		T_VAR('CONSULTING INMOBILIARIO ZODIACO, S.L.', 					'B13562210', 	'04', 			'1'),
		T_VAR('BOST GAUNAS, S.L.', 										'B01276153', 	'04', 			'1'),
		T_VAR('BECEIN Y TEC, S.L.', 									'B22407084', 	'04', 			'1'),
		T_VAR('BALMAR SOLUCIONES INMOBILIARIAS,S.L.', 					'B04776340', 	'04', 			'1'),
		T_VAR('ASESORAMIENTO EMPRESARIAL ESPECIALIZADO SL', 			'B24285843', 	'04', 			'1'),
		T_VAR('AMBIT GESTIÓ PATRIMONIAL, S.L.', 						'B61855847', 	'04', 			'1'),
		T_VAR('ALBEDA S.L', 											'B19270701', 	'04', 			'1'),
		T_VAR('AGENCIA CERVERA Y CERVERA SL', 							'B17528001', 	'04', 			'1'),
		T_VAR('ACE  DERECHOS INMOBILIARIOS SL', 						'B54775499', 	'04', 			'1'),
		T_VAR('ABIB HOME', 												'B87215216', 	'04', 			'1'),
		T_VAR('MAZAL TERRENOS S.L', 									'B87825857', 	'04', 			'1'),
		T_VAR('FINCAS TEATINOS, S.L.', 									'B93082527', 	'04', 			'1'),
		T_VAR('AZAHAR TENERIFE S21, S.L.', 								'B38787388', 	'04', 			'1'),
		T_VAR('VENTIBERICA ASOCIADOS, S.A.', 							'A58008905', 	'04', 			'1'),
		T_VAR('Jones Lang LaSalle España, S.A.', 						'A78492303', 	'04', 			'1'),
		T_VAR('CBRE Valuation Advisory, S.A.', 							'A85490217', 	'04', 			'1'),
		T_VAR('COSTAMED SERVICIOS INMOBILIARIOS S.L', 					'B53830840', 	'04', 			'1'),
		T_VAR('MUTUM COMUNICACION S.L.', 								'B83634030', 	'04', 			'1'),
		T_VAR('CASA 10 MEDITERRANEA 2011 SL', 							'B12864120', 	'04', 			'1'),
		T_VAR('GESTINVERSION 20 S.L (TUDOMUS)', 						'B85389427', 	'04', 			'1'),
		T_VAR('HIGH INNOVATION REAL ESTATE SL', 						'B19287812', 	'04', 			'1'),
		T_VAR('FINQUES FARNES', 										'B43524149', 	'04', 			'1'),
		T_VAR('ABLAS REAL ESTATE ABSOLUTE, SL', 						'B98632805', 	'04', 			'1'),
		T_VAR('SEDES, S.A.', 											'A33002106', 	'04', 			'1'),
		T_VAR('VIVES E HIJOS SL', 										'B53540696', 	'04', 			'1'),
		T_VAR('PROYECTOS INMOBILIARIOS ROQUE DEL CONDE SL', 			'B76730811', 	'04', 			'1'),
		T_VAR('INMOBILIARIA GLORIA C.B.', 								'E73975385', 	'04', 			'1'),
		T_VAR('SENDEXIT S.L.', 											'B05522396', 	'04', 			'1'),
		T_VAR('REIPI VIVIENDA S.R.L.', 									'B04908950', 	'04', 			'1'),
		T_VAR('ECOGESTIO ADMINISTRACIONS, S.L.', 						'B55710792', 	'04', 			'1'),
		T_VAR('MARIA AMPARO MONTESINOS NAVARRO', 						'52670447X', 	'04', 			'1'),
		T_VAR('EUROPEA DE ADMINISTRACIONES SL', 						'B96856083', 	'04', 			'1'),
		T_VAR('JOSÉ GARCIA BARRERA', 									'34050040N', 	'04', 			'1'),
		T_VAR('MALLORCA OPEN S.L.', 									'B57942807', 	'04', 			'1'),
		T_VAR('ROMERO HOUSE 16 SL', 									'B54920889', 	'04', 			'1'),
		T_VAR('MUCHA FINCA FRANCHISING S.L', 							'B54711700', 	'04', 			'1'),
		T_VAR('BENIDORM SUN ESPORT PLANET SL', 							'B54281811', 	'04', 			'1'),
		T_VAR('LOZAINMA SL', 											'B42516641', 	'04', 			'1'),
		T_VAR('GUILLERMINA AMPARO BERENGUER BROTONS', 					'52770161L', 	'04', 			'1'),
		T_VAR('EUGENIO MARTIN DE LOS PINOS', 							'50850831Q', 	'04', 			'1'),
		T_VAR('OLIVIA RIBERA BELDA', 									'21666203L', 	'04', 			'1'),
		T_VAR('NATALIA CANO BERNABEU', 									'21664624G', 	'04', 			'1'),
		T_VAR('EMILIO GARCIA ORTS', 									'19096543B', 	'04', 			'1'),
		T_VAR('GESPROCASA DEL SURESTE SL', 								'B30815039', 	'04', 			'1'),
		T_VAR('CUSHMAN & WAKEFIELD SPAIN LIMITED SUCURSAL EN ESPAÑA', 	'W0061691B', 	'04', 			'1'),
		T_VAR('DIEGO LIONEL SAAVEDRA', 									'X5083784W', 	'04', 			'1'),
		T_VAR('MIGUEL FLICH CARDO (FLICASA)', 							'18954458C', 	'04', 			'1'),
		T_VAR('LUIS PEREZ MARTINEZ', 									'74323766W', 	'04', 			'1'),
		T_VAR('ALFREDO MOLL IVARS', 									'74081317L', 	'04', 			'1'),
		T_VAR('JUAN JOSE OLMOS SANCHO', 								'73768358K', 	'04', 			'1'),
		T_VAR('VICTOR RAUL URBINA LEON', 								'70830032Z', 	'04', 			'1'),
		T_VAR('RICARDO MARTINEZ BENITO', 								'70580352E', 	'04', 			'1'),
		T_VAR('ADRIAN BECKET CASTILLO', 								'52795785K', 	'04', 			'1'),
		T_VAR('PABLO VALERA CORTES', 									'48400931F', 	'04', 			'1'),
		T_VAR('EMILIO TRUJILLO REQUENA', 								'45474216L', 	'04', 			'1'),
		T_VAR('SANTIAGO ARAQUE MARTINEZ', 								'29176635P', 	'04', 			'1'),
		T_VAR('ANTONIO MARTIN CUESTA', 									'24100733E', 	'04', 			'1'),
		T_VAR('EVA LINARES MORALES', 									'20246661Z', 	'04', 			'1'),
		T_VAR('TANIA TORRENT GARCIA', 									'20242379X', 	'04', 			'1'),
		T_VAR('MICHAEL CERVILLA VAÑO', 									'21689312J', 	'04', 			'1'),
		T_VAR('MARIA CARMEN FALOMIR TORRES', 							'18958371T', 	'04', 			'1'),
		T_VAR('ROSALIA CATALÁN ESTEBAN "INMORUBIELOS"', 				'18432860Q', 	'04', 			'1')
	); 
	V_TMP_VAR T_VAR;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso:');
	DBMS_OUTPUT.PUT_LINE('---------------------------------------');

	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP_VAR := V_VAR(I);
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Dando de baja el mediador "'||V_TMP_VAR(1)||'" con CIF/DNI: '''||V_TMP_VAR(2)||'''...');
		
		V_MSQL := '
			SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
			JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.DD_TPR_CODIGO = '''||V_TMP_VAR(3)||'''
			WHERE PVE.PVE_DOCIDENTIF = '''||V_TMP_VAR(2)||'''
		';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
		
		IF V_NUM = 1 THEN
			
			EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
				USING(
					SELECT T1.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR T1
					JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON T1.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.DD_TPR_CODIGO = '''||V_TMP_VAR(3)||'''
					WHERE T1.PVE_DOCIDENTIF = '''||V_TMP_VAR(2)||'''
				) T2
				ON (PVE.PVE_ID = T2.PVE_ID)
				WHEN MATCHED THEN UPDATE SET
					PVE.PVE_FECHA_BAJA = SYSDATE,
					PVE.USUARIOMODIFICAR = '''||V_USR||''',
					PVE.FECHAMODIFICAR = SYSDATE
			';
			
			DBMS_OUTPUT.PUT_LINE('	[OK] Hecho. '||SQL%ROWCOUNT||' registro/s afectado/s.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[WRN] No existe el mediador.');
		END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('---------------------------------------');
	DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso.');
	
	--ROLLBACK;
	COMMIT;

EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;   
END;

/

EXIT;
