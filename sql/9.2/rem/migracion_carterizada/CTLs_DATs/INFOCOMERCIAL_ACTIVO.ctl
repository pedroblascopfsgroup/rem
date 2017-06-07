OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/INFOCOMERCIAL_ACTIVO.dat'
BADFILE './CTLs_DATs/bad/INFOCOMERCIAL_ACTIVO.bad'
DISCARDFILE './CTLs_DATs/rejects/INFOCOMERCIAL_ACTIVO.bad'
INTO TABLE REM01.MIG_AIA_INFCOMERCIAL_ACT
TRUNCATE 
TRAILING NULLCOLS
(
   
  	-- 17,37,57,77,589,609,618,627,629,879,887,  
	-- 895,903,911,961,3961,3981,4001,4010,4019,4021,4029,4031, 
	--4033,4035,4037,4039,4041,4043,4293,4543,7543,8567,9591,  
	--9611,9631,9651,9653,9662,9664,9666,9668,9670, 
	--9672,9674,9676,9678,9928,9945,11445,11462,11479  
	--,11496,11513,11530,11532,11782,12032,12544,12546,12548,12550,  
	--12570,12590,12607,12624,12626
    ACT_NUMERO_ACTIVO	   				POSITION(1:17)      	INTEGER EXTERNAL												"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))"
   ,UBICACION_ACTIVO			        POSITION(18:37)     	CHAR nullif(UBICACION_ACTIVO=BLANKS) 							"replace (replace(replace(TRIM(:UBICACION_ACTIVO),';',' '), '\"',''),'''','')"
   ,ESTADO_CONSTRUCCION					POSITION(38:57)     	CHAR nullif(ESTADO_CONSTRUCCION=BLANKS) 						"replace (replace(replace(TRIM(:ESTADO_CONSTRUCCION),';',' '), '\"',''),'''','')"
   ,ESTADO_CONSERVACION 				POSITION(58:77)     	CHAR nullif(ESTADO_CONSERVACION=BLANKS) 						"replace (replace(replace(TRIM(:ESTADO_CONSERVACION),';',' '), '\"',''),'''','')"
   ,ICO_DESCRIPCION						POSITION(78:589)    	CHAR nullif(ICO_DESCRIPCION=BLANKS) 							"replace (replace(replace(TRIM(:ICO_DESCRIPCION),';',' '), '\"',''),'''','')"
   ,TIPO_INFO_COMERCIAL					POSITION(590:609)   	CHAR nullif(TIPO_INFO_COMERCIAL=BLANKS) 						"replace (replace(replace(TRIM(:TIPO_INFO_COMERCIAL),';',' '), '\"',''),'''','')"
   ,ICO_ANO_CONSTRUCCION				POSITION(610:618)   	INTEGER EXTERNAL  nullif (ICO_ANO_CONSTRUCCION=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ICO_ANO_CONSTRUCCION),';',' '), '\"',''),'''',''),2,8))"
   ,ICO_ANO_REHABILITACION				POSITION(619:627)   	INTEGER EXTERNAL  nullif (ICO_ANO_REHABILITACION=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ICO_ANO_REHABILITACION),';',' '), '\"',''),'''',''),2,8))"
   ,ICO_APTO_PUBLICIDAD         		POSITION(628:629)   	INTEGER EXTERNAL  nullif (ICO_APTO_PUBLICIDAD=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ICO_APTO_PUBLICIDAD),';',' '), '\"',''),'''',''),2,1))"
   ,ICO_ACTIVOS_VINC					POSITION(630:879)   	CHAR nullif(ICO_ACTIVOS_VINC=BLANKS) 							"replace (replace(replace(TRIM(:ICO_ACTIVOS_VINC),';',' '), '\"',''),'''','')"
   ,ICO_FECHA_EMISION_INFORME	        POSITION(880:887)		DATE 'YYYYMMDD' NULLIF(ICO_FECHA_EMISION_INFORME=BLANKS) 		"REPLACE(:ICO_FECHA_EMISION_INFORME, '00000000', '')"
   ,ICO_FECHA_ULTIMA_VISITA				POSITION(888:895)		DATE 'YYYYMMDD' NULLIF(ICO_FECHA_ULTIMA_VISITA=BLANKS) 			"REPLACE(:ICO_FECHA_ULTIMA_VISITA, '00000000', '')"
   ,ICO_FECHA_ACEPTACION				POSITION(896:903)		DATE 'YYYYMMDD' NULLIF(ICO_FECHA_ACEPTACION=BLANKS) 			"REPLACE(:ICO_FECHA_ACEPTACION, '00000000', '')"
   ,ICO_FECHA_RECHAZO					POSITION(904:911)		DATE 'YYYYMMDD' NULLIF(ICO_FECHA_RECHAZO=BLANKS) 				"REPLACE(:ICO_FECHA_RECHAZO, '00000000', '')"
   ,PVE_CODIGO							POSITION(912:961)   	CHAR nullif(PVE_CODIGO=BLANKS) 									"replace (replace(replace(TRIM(:PVE_CODIGO),';',' '), '\"',''),'''','')"
   ,ICO_CONDICIONES_LEGALES				POSITION(962:3961)  	CHAR nullif(ICO_CONDICIONES_LEGALES=BLANKS) 					"replace (replace(replace(TRIM(:ICO_CONDICIONES_LEGALES),';',' '), '\"',''),'''','')"
   ,ESTADO_CONSERVACION_EDIFICIO		POSITION(3962:3981)     CHAR nullif(ESTADO_CONSERVACION_EDIFICIO=BLANKS) 				"replace (replace(replace(TRIM(:ESTADO_CONSERVACION_EDIFICIO),';',' '), '\"',''),'''','')"
   ,TIPO_FACHADA_EDIFICIO				POSITION(3982:4001)     CHAR nullif(TIPO_FACHADA_EDIFICIO=BLANKS) 						"replace (replace(replace(TRIM(:TIPO_FACHADA_EDIFICIO),';',' '), '\"',''),'''','')"
   ,EDI_ANO_REHABILITACION		        POSITION(4002:4010)   	INTEGER EXTERNAL  nullif (EDI_ANO_REHABILITACION=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_ANO_REHABILITACION),';',' '), '\"',''),'''',''),2,8))"
   ,EDI_NUM_PLANTAS						POSITION(4011:4019)   	INTEGER EXTERNAL  nullif (EDI_NUM_PLANTAS=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_NUM_PLANTAS),';',' '), '\"',''),'''',''),2,8))"
   ,EDI_ASCENSOR						POSITION(4020:4021)   	INTEGER EXTERNAL  nullif (EDI_ASCENSOR=BLANKS)					"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_ASCENSOR),';',' '), '\"',''),'''',''),2,1))"
   ,EDI_NUM_ASCENSORES					POSITION(4022:4029)   	INTEGER EXTERNAL  nullif (EDI_NUM_ASCENSORES=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_NUM_ASCENSORES),';',' '), '\"',''),'''',''),2,8))"
   ,EDI_REFORMA_FACHADA					POSITION(4030:4031)   	INTEGER EXTERNAL  nullif (EDI_REFORMA_FACHADA=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_REFORMA_FACHADA),';',' '), '\"',''),'''',''),2,1))"
   ,EDI_REFORMA_ESCALERA				POSITION(4032:4033)   	INTEGER EXTERNAL  nullif (EDI_REFORMA_ESCALERA=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_REFORMA_ESCALERA),';',' '), '\"',''),'''',''),2,1))"
   ,EDI_REFORMA_PORTAL					POSITION(4034:4035)   	INTEGER EXTERNAL  nullif (EDI_REFORMA_PORTAL=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_REFORMA_PORTAL),';',' '), '\"',''),'''',''),2,1))"
   ,EDI_REFORMA_ASCENSOR				POSITION(4036:4037)   	INTEGER EXTERNAL  nullif (EDI_REFORMA_ASCENSOR=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_REFORMA_ASCENSOR),';',' '), '\"',''),'''',''),2,1))"
   ,EDI_REFORMA_CUBIERTA				POSITION(4038:4039)   	INTEGER EXTERNAL  nullif (EDI_REFORMA_CUBIERTA=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_REFORMA_CUBIERTA),';',' '), '\"',''),'''',''),2,1))"
   ,EDI_REFORMA_OTRA_ZONA				POSITION(4040:4041)   	INTEGER EXTERNAL  nullif (EDI_REFORMA_OTRA_ZONA=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_REFORMA_OTRA_ZONA),';',' '), '\"',''),'''',''),2,1))"
   ,EDI_REFORMA_OTRO					POSITION(4042:4043)   	INTEGER EXTERNAL  nullif (EDI_REFORMA_OTRO=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:EDI_REFORMA_OTRO),';',' '), '\"',''),'''',''),2,1))"
   ,EDI_REFORMA_OTRO_ZONA_COM_DES		POSITION(4044:4293)		CHAR nullif(EDI_REFORMA_OTRO_ZONA_COM_DES=BLANKS)				"replace (replace(replace(TRIM(:EDI_REFORMA_OTRO_ZONA_COM_DES),';',' '), '\"',''),'''','')"
   ,EDI_REFORMA_OTRO_DESC				POSITION(4294:4543)     CHAR nullif(EDI_REFORMA_OTRO_DESC=BLANKS) 						"replace (replace(replace(TRIM(:EDI_REFORMA_OTRO_DESC),';',' '), '\"',''),'''','')"
   ,EDI_DESCRIPCION						POSITION(4544:7543)     CHAR nullif(EDI_DESCRIPCION=BLANKS) 							"replace (replace(replace(TRIM(:EDI_DESCRIPCION),';',' '), '\"',''),'''','')"
   ,EDI_ENTORNO_INFRAESTRUCTURA			POSITION(7544:8567)     CHAR nullif(EDI_ENTORNO_INFRAESTRUCTURA=BLANKS) 				"replace (replace(replace(TRIM(:EDI_ENTORNO_INFRAESTRUCTURA),';',' '), '\"',''),'''','')"
   ,EDI_ENTORNO_COMUNICACION			POSITION(8568:9591)     CHAR nullif(EDI_ENTORNO_COMUNICACION=BLANKS) 					"replace (replace(replace(TRIM(:EDI_ENTORNO_COMUNICACION),';',' '), '\"',''),'''','')"
   ,TIPO_VIVIENDA						POSITION(9592:9611)     CHAR nullif(TIPO_VIVIENDA=BLANKS) 								"replace (replace(replace(TRIM(:TIPO_VIVIENDA),';',' '), '\"',''),'''','')"
   ,TIPO_ORIENTACION					POSITION(9612:9631)     CHAR nullif(TIPO_ORIENTACION=BLANKS) 							"replace (replace(replace(TRIM(:TIPO_ORIENTACION),';',' '), '\"',''),'''','')"
   ,TIPO_RENTA							POSITION(9632:9651)     CHAR nullif(TIPO_RENTA=BLANKS) 									"replace (replace(replace(TRIM(:TIPO_RENTA),';',' '), '\"',''),'''','')"
   ,VIV_ULTIMA_PLANTA					POSITION(9652:9653)   	INTEGER EXTERNAL  nullif (VIV_ULTIMA_PLANTA=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_ULTIMA_PLANTA),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_NUM_PLANTAS_INTERIOR			POSITION(9654:9662)   	INTEGER EXTERNAL  nullif (VIV_NUM_PLANTAS_INTERIOR=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_NUM_PLANTAS_INTERIOR),';',' '), '\"',''),'''',''),2,8))"
   ,VIV_REFORMA_CARP_INT				POSITION(9663:9664)   	INTEGER EXTERNAL  nullif (VIV_REFORMA_CARP_INT=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_REFORMA_CARP_INT),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_REFORMA_CARP_EXT				POSITION(9665:9666)   	INTEGER EXTERNAL  nullif (VIV_REFORMA_CARP_EXT=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_REFORMA_CARP_EXT),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_REFORMA_COCINA					POSITION(9667:9668)   	INTEGER EXTERNAL  nullif (VIV_REFORMA_COCINA=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_REFORMA_COCINA),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_REFORMA_BANYO					POSITION(9669:9670)   	INTEGER EXTERNAL  nullif (VIV_REFORMA_BANYO=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_REFORMA_BANYO),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_REFORMA_SUELO					POSITION(9671:9672)   	INTEGER EXTERNAL  nullif (VIV_REFORMA_SUELO=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_REFORMA_SUELO),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_REFORMA_PINTURA					POSITION(9673:9674)   	INTEGER EXTERNAL  nullif (VIV_REFORMA_PINTURA=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_REFORMA_PINTURA),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_REFORMA_INTEGRAL				POSITION(9675:9676)   	INTEGER EXTERNAL  nullif (VIV_REFORMA_INTEGRAL=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_REFORMA_INTEGRAL),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_REFORMA_OTRO					POSITION(9677:9678)   	INTEGER EXTERNAL  nullif (VIV_REFORMA_OTRO=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIV_REFORMA_OTRO),';',' '), '\"',''),'''',''),2,1))"
   ,VIV_REFORMA_OTRO_DESC				POSITION(9679:9928)     CHAR nullif(VIV_REFORMA_OTRO_DESC=BLANKS) 						"replace (replace(replace(TRIM(:VIV_REFORMA_OTRO_DESC),';',' '), '\"',''),'''','')"
   ,VIV_REFORMA_PRESUPUESTO		        POSITION(9929:9945)   	INTEGER EXTERNAL NULLIF(VIV_REFORMA_PRESUPUESTO=BLANKS)  		"CASE WHEN (:VIV_REFORMA_PRESUPUESTO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:VIV_REFORMA_PRESUPUESTO,1,15)||','||SUBSTR(:VIV_REFORMA_PRESUPUESTO,16,2)),';',' '), '\"',''),'''','')) END" 
   ,VIV_DISTRIBUCION_TXT				POSITION(9946:11445)     CHAR nullif(VIV_DISTRIBUCION_TXT=BLANKS) 						"replace (replace(replace(TRIM(:VIV_DISTRIBUCION_TXT),';',' '), '\"',''),'''','')"
   ,LCO_MTS_FACHADA_PPAL				POSITION(11446:11462)   	INTEGER EXTERNAL NULLIF(LCO_MTS_FACHADA_PPAL=BLANKS)  			"CASE WHEN (:LCO_MTS_FACHADA_PPAL) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:LCO_MTS_FACHADA_PPAL,1,15)||','||SUBSTR(:LCO_MTS_FACHADA_PPAL,16,2)),';',' '), '\"',''),'''','')) END" 
   ,LCO_MTS_FACHADA_LAT					POSITION(11463:11479)   	INTEGER EXTERNAL NULLIF(LCO_MTS_FACHADA_LAT=BLANKS)  			"CASE WHEN (:LCO_MTS_FACHADA_LAT) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:LCO_MTS_FACHADA_LAT,1,15)||','||SUBSTR(:LCO_MTS_FACHADA_LAT,16,2)),';',' '), '\"',''),'''','')) END" 
   ,LCO_MTS_LUZ_LIBRE					POSITION(11480:11496)   	INTEGER EXTERNAL NULLIF(LCO_MTS_LUZ_LIBRE=BLANKS)  				"CASE WHEN (:LCO_MTS_LUZ_LIBRE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:LCO_MTS_LUZ_LIBRE,1,15)||','||SUBSTR(:LCO_MTS_LUZ_LIBRE,16,2)),';',' '), '\"',''),'''','')) END" 
   ,LCO_MTS_ALTURA_LIBRE				POSITION(11497:11513)   	INTEGER EXTERNAL NULLIF(LCO_MTS_ALTURA_LIBRE=BLANKS)  			"CASE WHEN (:LCO_MTS_ALTURA_LIBRE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:LCO_MTS_ALTURA_LIBRE,1,15)||','||SUBSTR(:LCO_MTS_ALTURA_LIBRE,16,2)),';',' '), '\"',''),'''','')) END" 
   ,LCO_MTS_LINEALES_PROF				POSITION(11514:11530)   	INTEGER EXTERNAL NULLIF(LCO_MTS_LINEALES_PROF=BLANKS)  			"CASE WHEN (:LCO_MTS_LINEALES_PROF) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:LCO_MTS_LINEALES_PROF,1,15)||','||SUBSTR(:LCO_MTS_LINEALES_PROF,16,2)),';',' '), '\"',''),'''','')) END" 
   ,LCO_DIAFANO							POSITION(11531:11532)   	INTEGER EXTERNAL  nullif (LCO_DIAFANO=BLANKS)					"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:LCO_DIAFANO),';',' '), '\"',''),'''',''),2,1))"
   ,LCO_USO_IDONEO						POSITION(11533:11782)     CHAR nullif(LCO_USO_IDONEO=BLANKS) 								"replace (replace(replace(TRIM(:LCO_USO_IDONEO),';',' '), '\"',''),'''','')"
   ,LCO_USO_ANTERIOR					POSITION(11783:12032)     CHAR nullif(LCO_USO_ANTERIOR=BLANKS) 							"replace (replace(replace(TRIM(:LCO_USO_ANTERIOR),';',' '), '\"',''),'''','')"
   ,LCO_OBSERVACIONES					POSITION(12033:12544)    CHAR nullif(LCO_OBSERVACIONES=BLANKS) 							"replace (replace(replace(TRIM(:LCO_OBSERVACIONES),';',' '), '\"',''),'''','')"
   ,APR_DESTINO_COCHE					POSITION(12545:12546)   INTEGER EXTERNAL  nullif (APR_DESTINO_COCHE=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:APR_DESTINO_COCHE),';',' '), '\"',''),'''',''),2,1))"
   ,APR_DESTINO_MOTO					POSITION(12547:12548)   INTEGER EXTERNAL  nullif (APR_DESTINO_MOTO=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:APR_DESTINO_MOTO),';',' '), '\"',''),'''',''),2,1))"
   ,APR_DESTINO_DOBLE					POSITION(12549:12550)   INTEGER EXTERNAL  nullif (APR_DESTINO_DOBLE=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:APR_DESTINO_DOBLE),';',' '), '\"',''),'''',''),2,1))"
   ,TIPO_UBICACION_APARCA				POSITION(12551:12570)   CHAR nullif(TIPO_UBICACION_APARCA=BLANKS) 						"replace (replace(replace(TRIM(:TIPO_UBICACION_APARCA),';',' '), '\"',''),'''','')"
   ,TIPO_CALIDAD						POSITION(12571:12590)   CHAR nullif(TIPO_CALIDAD=BLANKS) 								"replace (replace(replace(TRIM(:TIPO_CALIDAD),';',' '), '\"',''),'''','')"
   ,APR_ANCHURA							POSITION(12591:12607)   INTEGER EXTERNAL NULLIF(APR_ANCHURA=BLANKS)  					"CASE WHEN (:APR_ANCHURA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:APR_ANCHURA,1,15)||','||SUBSTR(:APR_ANCHURA,16,2)),';',' '), '\"',''),'''','')) END" 
   ,APR_PROFUNDIDAD						POSITION(12608:12624) 	INTEGER EXTERNAL NULLIF(APR_PROFUNDIDAD=BLANKS)  				"CASE WHEN (:APR_PROFUNDIDAD) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:APR_PROFUNDIDAD,1,15)||','||SUBSTR(:APR_PROFUNDIDAD,16,2)),';',' '), '\"',''),'''','')) END" 
   ,APR_FORMA_IRREGULAR					POSITION(12625:12626)   INTEGER EXTERNAL  nullif (APR_FORMA_IRREGULAR=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:APR_FORMA_IRREGULAR),';',' '), '\"',''),'''',''),2,1))"
   ,ICO_FECHA_RECEPCION_LLAVES			POSITION(12627:12634)	DATE 'YYYYMMDD' NULLIF(ICO_FECHA_RECEPCION_LLAVES=BLANKS)		"REPLACE(:ICO_FECHA_RECEPCION_LLAVES, '00000000', '')"
   ,ICO_JUSTIFICANTE_IMP_VENTA			POSITION(12635:15634)	CHAR nullif(ICO_JUSTIFICANTE_IMP_VENTA=BLANKS) 					"replace (replace(replace(TRIM(:ICO_JUSTIFICANTE_IMP_VENTA),';',' '), '\"',''),'''','')"
   ,ICO_JUSTIFICANTE_IMP_ALQUILER		POSITION(15635:18634)	CHAR nullif(ICO_JUSTIFICANTE_IMP_ALQUILER=BLANKS) 				"replace (replace(replace(TRIM(:ICO_JUSTIFICANTE_IMP_ALQUILER),';',' '), '\"',''),'''','')"
   ,ICO_ANYO_REHABILITA_EDIFICIO		POSITION(18635:18643)	INTEGER EXTERNAL  nullif (ICO_ANYO_REHABILITA_EDIFICIO=BLANKS)	"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ICO_ANYO_REHABILITA_EDIFICIO),';',' '), '\"',''),'''',''),2,8))"
   ,ICO_DISTRITO						POSITION(18644:18652)	INTEGER EXTERNAL  nullif (ICO_DISTRITO=BLANKS)					"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ICO_DISTRITO),';',' '), '\"',''),'''',''),2,8))",	
   VALIDACION CONSTANT "0"	
   
  )