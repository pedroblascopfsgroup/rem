--/*
--##########################################
--## AUTOR=Adrián Molina Garrido
--## FECHA_CREACION=20190411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.1.0
--## INCIDENCIA_LINK=HREOS-6082
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico del stock de activos enviados a webcom.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Versiń Adrián
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_STOCK_ACTIVOS_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'SWH_STOCK_ACT_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico del stock de activos enviados a webcom.'; -- Vble. para los comentarios de las tablas

    CUENTA NUMBER;
    
BEGIN/*Versión 0.2*/


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_VISTA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Comprobaciones previas');
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');	
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'MATERIALIZED VIEW';
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista materializada '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'VIEW';  
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
	END IF;
  
  
  	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
  
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||'..');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';		
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe secuencia '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'..');
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	END IF; 
  
  
	-- Creamos vista materializada
	DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'..');
	EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
		SELECT DISTINCT
		CAST(ACT.ACT_NUM_ACTIVO AS NUMBER(16,0)) 											AS ID_ACTIVO_HAYA,
		CAST(ACT.ACT_NUM_ACTIVO_UVEM AS NUMBER(16,0)) 										AS ID_ACTIVO_UVEM,
		CAST(ACT.ACT_NUM_ACTIVO_SAREB AS VARCHAR2(55 CHAR)) 								AS ID_ACTIVO_SAREB,
        CAST(ACT.ACT_NUM_ACTIVO_PRINEX AS NUMBER(16,0)) 									AS ID_ACTIVO_PRINEX,
        CAST(ACT.ACT_NUM_ACTIVO_REM AS NUMBER(16,0)) 										AS ID_ACTIVO_REM,
		CAST(DDTVI.DD_TVI_CODIGO AS VARCHAR2(20 CHAR)) 										AS COD_TIPO_VIA,
		CAST(BLOC.BIE_LOC_NOMBRE_VIA AS VARCHAR2(100 CHAR)) 								AS NOMBRE_CALLE,
		CAST(BLOC.BIE_LOC_NUMERO_DOMICILIO AS VARCHAR2(100 CHAR)) 							AS NUMERO_CALLE,
		CAST(BLOC.BIE_LOC_ESCALERA AS VARCHAR2(10 CHAR)) 									AS ESCALERA,
		CAST(BLOC.BIE_LOC_PISO AS VARCHAR2(11 CHAR))										AS PLANTA,
		CAST(BLOC.BIE_LOC_PUERTA AS VARCHAR2(17 CHAR))										AS PUERTA,
		CAST(DDLOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR))										AS COD_MUNICIPIO, 
		CAST(DDUPO.DD_UPO_CODIGO AS VARCHAR2(5 CHAR))										AS COD_PEDANIA,
		CAST(DDPRV.DD_PRV_CODIGO AS VARCHAR2(5 CHAR))										AS COD_PROVINCIA,
		CAST(BLOC.BIE_LOC_COD_POST AS VARCHAR2(40 CHAR)) 									AS CODIGO_POSTAL,
		CAST(DDTPA.DD_TPA_CODIGO AS VARCHAR2(5 CHAR))										AS COD_TIPO_INMUEBLE,
		CAST(DDSAC.DD_SAC_CODIGO AS VARCHAR2(5 CHAR))										AS COD_SUBTIPO_INMUEBLE,
		CAST(BREG.BIE_DREG_NUM_FINCA AS VARCHAR2(14 CHAR))									AS FINCA_REGISTRAL,
		CAST(DDBRLOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR)) 									AS COD_MUNICIPIO_REGISTRO,
		CAST(BREG.BIE_DREG_NUM_REGISTRO AS VARCHAR2(14 CHAR))								AS REGISTRO,
		CAST(CAT.CAT_REF_CATASTRAL AS VARCHAR2(50 CHAR)) 									AS REFERENCIA_CATASTRAL,
		CAST(REG.REG_SUPERFICIE_UTIL AS NUMBER(16,2))   									AS UTIL_SUPERFICIE,
		CAST(BREG.BIE_DREG_SUPERFICIE_CONSTRUIDA AS NUMBER(16,2))  							AS CONSTRUIDA_SUPERFICIE,
		CAST(BREG.BIE_DREG_SUPERFICIE AS NUMBER(16,2))  									AS REGISTRAL_SUPERFICIE,
		CAST(REG.REG_SUPERFICIE_PARCELA AS NUMBER(16,2)) 									AS PARCELA_SUPERFICIE,
		CAST(EDI.EDI_ASCENSOR AS NUMBER(1,0))   											AS ASCENSOR,
		CAST(VPD.DORMITORIOS AS NUMBER(5,0))  												AS DORMITORIOS,
		CAST(VPD.BANYOS AS NUMBER(5,0)) 													AS BANYOS,
		CAST(VPD.ASEOS AS NUMBER(5,0)) 														AS ASEOS,
		CAST(VPD.GARAJES AS NUMBER(5,0))													AS GARAJES,
		CASE DDEAC.DD_EAC_CODIGO
			WHEN ''03'' THEN CAST(''1'' AS NUMBER(1,0))
			ELSE CAST(''0'' AS NUMBER(1,0))
		END 																				AS ES_NUEVO,
		CAST(DDSCM.DD_SCM_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_ESTADO_COMERCIAL,
		CAST(DDTCO.DD_TCO_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_TIPO_VENTA,
		CAST(LOC.LOC_LATITUD AS NUMBER(21,15)) 												AS LAT,
		CAST(LOC.LOC_LONGITUD AS NUMBER(21,15)) 											AS LNG,
		CAST(DDECT.DD_ECT_CODIGO AS VARCHAR2(5 CHAR))										AS COD_ESTADO_CONSTRUCCION,
		CAST(NVL(VPD.TERRAZAS_CUBIERTAS, 0) + NVL(VPD.TERRAZAS_DESCUBIERTAS, 0) AS NUMBER(5,0)) 	AS TERRAZAS,
		CASE WHEN (VIV.VIV_REFORMA_CARP_INT =1 OR VIV.VIV_REFORMA_CARP_EXT = 1 
				OR VIV.VIV_REFORMA_COCINA =1 OR VIV.VIV_REFORMA_BANYO =1 
				OR VIV.VIV_REFORMA_SUELO=1 OR VIV.VIV_REFORMA_PINTURA=1 
				OR VIV.VIV_REFORMA_INTEGRAL=1 OR VIV.VIV_REFORMA_OTRO=1) 
			THEN CAST( 1 AS NUMBER(1,0))
		    ELSE CAST(0 AS NUMBER(1,0)) 
		END 																				AS REFORMAS,
		CASE WHEN (PUB.HEP_FECHA_DESDE IS NOT NULL) 
			THEN CAST(TO_CHAR(PUB.HEP_FECHA_DESDE ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS PUBLICADO_DESDE,
		CAST(VPO.DD_TVP_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_REGIMEN_PROTECCION,
		CAST(EDI.EDI_DESCRIPCION AS VARCHAR2(3000 CHAR))									AS DESCRIPCION,
		CAST(NVL(VIV.VIV_DISTRIBUCION_TXT, ICO.ICO_INFO_DISTRIBUCION_INTERIOR) AS VARCHAR2(3000 CHAR))						AS DISTRIBUCION,
		CAST(COE.COE_TEXTO AS VARCHAR2(3000 CHAR))                            				AS CONDICIONES_ESPECIFICAS,
		CAST(VCOND.ESTADO AS VARCHAR2(5 CHAR))                       						AS COD_DETALLE_PUBLICACION, 
		CAST(PIVOT_AGR.OBRA_NUEVA_NUM_REM AS NUMBER(16,0))	                                AS CODIGO_AGRUPACION_OBRA_NUEVA,
        CAST(NVL2(PIVOT_AGR.OBRA_NUEVA_NUM_REM, SUBD_ACT.ID, NULL) AS NUMBER(16,0))         AS CODIGO_CABECERA_OBRA_NUEVA,
		CAST(PVE_ANT.PVE_COD_REM AS NUMBER(16,0))											AS ID_PROVEEDOR_REM_ANTERIOR,		
		CAST(PVE.PVE_COD_REM AS NUMBER(16,0))												AS ID_PROVEEDOR_REM,
		CAST(GCO.NOMBRE AS VARCHAR2(60 CHAR)) 												AS NOMBRE_GESTOR_COMERCIAL,
		CAST(GCO.USU_TELEFONO AS VARCHAR2(14 CHAR)) 										AS TELEFONO_GESTOR_COMERCIAL,
		CAST(GCO.USU_MAIL AS VARCHAR2(60 CHAR)) 											AS EMAIL_GESTOR_COMERCIAL,		
		CAST(DDTCE.DD_TCE_CODIGO AS VARCHAR2(5 CHAR)) 		  								AS COD_CEE,
		CAST(ICO.ICO_ANO_CONSTRUCCION AS VARCHAR2(50 CHAR))									AS ANTIGUEDAD,
		CAST(DDCRA.DD_CRA_CODIGO AS VARCHAR2(14 CHAR)) 										AS COD_CARTERA,
		CAST(DDRTG.DD_RTG_CODIGO AS VARCHAR2(14 CHAR)) 										AS COD_RATIO,
		CAST(SPS.SPS_RIESGO_OCUPACION AS NUMBER(1,0)) 										AS RIESGO_OCUPACION,    
		CASE WHEN (SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL) 
			THEN CAST(TO_CHAR(SPS.SPS_FECHA_TOMA_POSESION,
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
		END 																				FECHA_POSESION,
		CASE WHEN (SPS.SPS_FECHA_TITULO IS NOT NULL) 
			THEN CAST(TO_CHAR(SPS.SPS_FECHA_TITULO ,
			''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
		END 																				FECHA_CONTRATO_DATOS_OCU,
		CASE WHEN (SPS.SPS_FECHA_VENC_TITULO IS NOT NULL) 
			THEN CAST(TO_CHAR(SPS.SPS_FECHA_VENC_TITULO ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
		END  																				PLAZO_CONTRATO_DATOS_OCU,
		CAST(SPS.SPS_RENTA_MENSUAL AS NUMBER(16,2)) 										AS RENTA_MENSUAL_DATOS_OCU,
		CAST(ICO.ICO_RECIBIO_IMPORTE_ADM AS NUMBER(16,2))									AS RECIBIDO_IMPORTE_DATOS_ADM,
		CAST(ICO.ICO_IBI_IMPORTE_ADM AS NUMBER(16,2)) 										AS IBI_IMPORTE_DATOS_ADM,
		CAST(ICO.ICO_DERRAMA_IMPORTE_ADM AS NUMBER(16,2)) 									AS DERRAMA_IMPORTE_DATOS_ADM,
		CAST(ICO.ICO_DET_DERRAMA_IMPORTE_ADM AS VARCHAR2(500 CHAR)) 						AS DETALLE_DERRAMA_DATOS_ADM,	
		CAST(NVL2 (VPD.TRASTEROS, VPD.TRASTEROS || 
			'' trastero(s)'', '''') AS VARCHAR2(150 CHAR))									AS ANEJO_TRASTERO,
		CAST(ZCO.ZCO_PISCINA AS NUMBER(1,0)) 												AS EXISTE_PISCINA,
		CAST(PIVOT_AGR.LOTE_NUM_REM AS NUMBER(16,0)) 										AS ID_LOTE_REM,
		CAST(PIVOT_AGR.LOTE_PRINCIPAL AS NUMBER(1,0)) 										AS ES_ACTIVO_PRINCIPAL,
		CAST(VAL1.DESCUENTO_PUBLICADO AS NUMBER(16,2)) 										AS ACTUAL_IMPORTE_DESCUENTO_WEB,
		CASE WHEN (VAL1.DESCUENTO_PUBLICADO_F_INI IS NOT NULL) 
			THEN CAST(TO_CHAR(VAL1.DESCUENTO_PUBLICADO_F_INI ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
		END 																				AS DESDE_IMPORTE_DESCUENTO_WEB,
		CASE WHEN (VAL1.DESCUENTO_PUBLICADO_F_FIN IS NOT NULL) 
			THEN CAST(TO_CHAR(VAL1.DESCUENTO_PUBLICADO_F_FIN ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
		END 																				AS HASTA_IMPORTE_DESCUENTO_WEB,
		CAST(VAL1.APROBADO_RENTA_WEB AS NUMBER(16,2)) 										AS VALOR_APROBADO_RENTA,
		CASE WHEN (VAL1.APROBADO_RENTA_WEB_F_INI IS NOT NULL) 
			THEN CAST(TO_CHAR(VAL1.APROBADO_RENTA_WEB_F_INI ,
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS FECHA_VALOR_APROBADO_RENTA,
		CAST(VANT.APROBADO_RENTA_WEB AS NUMBER(16,2))										AS ANTERIOR_VALOR_APROBADO_RENTA,
		CAST(VAL1.APROBADO_VENTA_WEB AS NUMBER(16,2)) 										AS VALOR_APROBADO_VENTA,
		CASE WHEN (VAL1.APROBADO_VENTA_WEB_F_INI IS NOT NULL) 
			THEN CAST(TO_CHAR(VAL1.APROBADO_VENTA_WEB_F_INI ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
		END 																				AS FECHA_VALOR_APROBADO_VENTA,	
		CAST(VANT.APROBADO_VENTA_WEB AS NUMBER(16,2))										AS ANTERIOR_VALOR_APROBADO_VENTA,
		CAST(PIVOT_AGR.ASISTIDA_NUM_REM AS NUMBER(16,0))	                                AS ID_ASISTIDA,
 		CAST(NVL2(PIVOT_AGR.ASISTIDA_NUM_REM, SUBD_ACT.ID, NULL) AS NUMBER(16,0))			AS CODIGO_CABECERA_ASISTIDA,
  		CAST(TO_CHAR(NVL(ACT.FECHAMODIFICAR, ACT.FECHACREAR), 
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 					AS FECHA_ACCION,
 		
		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = NVL(ACT.USUARIOMODIFICAR, ACT.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 				AS ID_USUARIO_REM_ACCION,
		CAST(DDSTA.DD_STA_CODIGO AS VARCHAR2(5 CHAR))										AS COD_SUBTIPO_TITULO,
		CAST(DDSCR.DD_SCR_CODIGO AS VARCHAR2(5 CHAR))										AS COD_SUB_CARTERA,
		CASE WHEN (AGA.AGR_FECHA_BAJA IS NULL AND
					(AGA.AGR_FIN_VIGENCIA IS NULL OR AGA.AGR_FIN_VIGENCIA > SYSDATE))
			THEN CAST(AGA.AGR_NUM_AGRUP_REM AS NUMBER(16,0))
			ELSE NULL
		END																					AS COD_AGRUPACION_COMERCIAL_REM,
       CAST(epv.dd_epv_codigo AS VARCHAR2(5 CHAR)) 											AS cod_estado_publicacion,
       CAST(epa.dd_epa_codigo AS VARCHAR2(5 CHAR)) 											AS cod_estado_pub_alquiler,
       CAST(tpu.dd_tpu_codigo AS VARCHAR2(5 CHAR)) 											AS cod_subestado_pub_venta,
       CAST(tpu.dd_tpu_codigo AS VARCHAR2(5 CHAR)) 											AS cod_subestado_pub_alquiler,
       actpub.apu_check_ocultar_precio_v 													AS ind_ocultar_precio_venta,
       actpub.apu_check_ocultar_precio_a 													AS ind_ocultar_precio_alquiler,
       v.condicionantes 																	AS arr_cod_detalle_publicacion,
       v.descripcion_otros																	AS descripcion_otros,
		PVEPRV.PVE_COD_REM 																	AS ACTIVO_PROVEEDOR_TECNICO,
		CASE WHEN (ACT_PTA.CHECK_HPM = 1)
			THEN DD_TAL.DD_TAL_CODIGO
			ELSE NULL
		END 																				AS COD_TIPO_ALQUILER,
		CAST(DDEAC.DD_EAC_CODIGO AS VARCHAR2(5 CHAR))										AS cod_estado_fisico,
		CAST(TUD.DD_TUD_CODIGO AS VARCHAR2(5 CHAR))											AS cod_tipo_uso_destino,
		CASE WHEN (AGA.DD_TAG_ID = (SELECT AGA.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 1)
			THEN 1
			ELSE 0
		END 																				AS INDICADOR_AM,
        CASE WHEN (AGA.DD_TAG_ID = (SELECT AGA.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 0)
			THEN CAST(ACT.ACT_NUM_ACTIVO AS NUMBER(16,0))
			ELSE NULL
		END 																				AS ID_HAYA_AM,
        CASE WHEN (AGA.DD_TAG_ID = (SELECT AGA.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''16''))
			THEN CAST(AGA.AGR_NUM_AGRUP_REM AS NUMBER(16,0))
			ELSE NULL
		END 																				AS ID_PA,
        CAST(NVL2(PIVOT_AGR.PROMOCION_ALQUILER_NUM_REM, SUBD_ACT.ID, NULL) AS NUMBER(16,0)) AS ID_SUBDIVISION_PA
    	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		INNER JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BLOC ON BLOC.BIE_LOC_ID = LOC.BIE_LOC_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = BLOC.DD_TVI_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = BLOC.DD_UPO_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = BLOC.DD_PRV_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = BLOC.DD_LOC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO DDTPA ON DDTPA.DD_TPA_ID = ACT.DD_TPA_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO DDSAC ON DDSAC.DD_SAC_ID = ACT.DD_SAC_ID

		INNER JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BREG ON BREG.BIE_DREG_ID = REG.BIE_DREG_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDBRLOC ON DDBRLOC.DD_LOC_ID = BREG.DD_LOC_ID

		LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID	
		LEFT JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID
		LEFT JOIN '||V_ESQUEMA||'.VI_PIVOT_DISTRIBUCION VPD ON VPD.ICO_ID = ICO.ICO_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO DDEAC ON DDEAC.DD_EAC_ID = ACT.DD_EAC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TUD_TIPO_USO_DESTINO TUD ON TUD.DD_TUD_ID = ACT.DD_TUD_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL DDSCM ON DDSCM.DD_SCM_ID = ACT.DD_SCM_ID

		LEFT JOIN '||V_ESQUEMA||'.DD_ECT_ESTADO_CONSTRUCCION DDECT ON DDECT.DD_ECT_ID = ICO.DD_ECT_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO DDSTA ON DDSTA.DD_STA_ID = ACT.DD_STA_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA DDSCR ON DDSCR.DD_SCR_ID = ACT.DD_SCR_ID

		LEFT JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV ON VIV.ICO_ID = ICO.ICO_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ADM ON ADM.ACT_ID = ACT.ACT_ID	
		LEFT JOIN '||V_ESQUEMA||'.DD_TVP_TIPO_VPO VPO ON VPO.DD_TVP_ID = ADM.DD_TVP_ID	
		LEFT JOIN '||V_ESQUEMA||'.DD_RTG_RATING_ACTIVO DDRTG ON DDRTG.DD_RTG_ID = ACT.DD_RTG_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA DDCRA ON DDCRA.DD_CRA_ID = ACT.DD_CRA_ID

		LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ZCO_ZONA_COMUN ZCO ON ZCO.ICO_ID = ICO.ICO_ID
		LEFT JOIN '||V_ESQUEMA||'.VI_STOCK_ACTIVO_GCOM GCO ON GCO.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = ICO.ICO_MEDIADOR_ID
		
		LEFT JOIN '||V_ESQUEMA||'.VI_STOCK_PIVOT_AGRUP_ACTIVO PIVOT_AGR ON PIVOT_AGR.ACT_ID = ACT.ACT_ID -- V_PIVOT_AGRUPACIONES_ACTIVO
		LEFT JOIN '||V_ESQUEMA||'.VI_STOCK_ACTIVOS_SUBDIVISON SUBD_ACT ON SUBD_ACT.ACT_ID = ACT.ACT_ID --v_activos_lite
		LEFT JOIN '||V_ESQUEMA||'.VI_STOCK_PIVOT_PRECIOS VAL1 ON VAL1.ACT_ID = ACT.ACT_ID --v_stock_pivot_precios
		LEFT JOIN '||V_ESQUEMA||'.VI_STOCK_PIVOT_PRECIOS_ANT VANT ON VANT.ACT_ID = ACT.ACT_ID --v_new_pivot_precios_ant

		INNER JOIN '||V_ESQUEMA||'.VI_STOCK_ACTIVO_CONDICIONANTE VCOND ON VCOND.ACT_ID = ACT.ACT_ID --v_stock_activo_condicionantes
		LEFT JOIN '||V_ESQUEMA||'.VI_STOCK_ACTIVO_REFCATASTRAL CAT ON CAT.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.VI_STOCK_ACTIVO_PROV_ANT PVE_ANT ON PVE_ANT.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.VI_STOCK_ACTIVO_FECHAPUBLICA PUB ON PUB.ACT_ID = ACT.ACT_ID
		left join ( SELECT COE.ACT_ID, COE.COE_TEXTO
					FROM '||V_ESQUEMA||'.ACT_COE_CONDICION_ESPECIFICA COE
					WHERE COE.COE_FECHA_HASTA IS NULL AND COE.BORRADO = 0 AND COE.COE_FECHA_DESDE <= SYSDATE ) COE on COE.ACT_ID = ACT.ACT_ID

		LEFT JOIN '||V_ESQUEMA||'.act_apu_activo_publicacion actpub ON actpub.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = actpub.DD_TCO_ID
        LEFT JOIN '||V_ESQUEMA||'.dd_epv_estado_pub_venta epv ON epv.dd_epv_id = actpub.dd_epv_id
        LEFT JOIN '||V_ESQUEMA||'.dd_epa_estado_pub_alquiler epa ON epa.dd_epa_id = actpub.dd_epa_id
        LEFT JOIN '||V_ESQUEMA||'.dd_tpu_tipo_publicacion tpu ON tpu.dd_tpu_id = actpub.DD_TPU_V_ID
        LEFT JOIN '||V_ESQUEMA||'.dd_tpu_tipo_publicacion tpu ON tpu.dd_tpu_id = actpub.DD_TPU_A_ID
        LEFT JOIN
           (SELECT vi.act_id,
					CASE 
					  WHEN
						pac.pac_check_comercializar IS NULL THEN 1
						ELSE
						pac.pac_check_comercializar
					  END 
                   || vi.sin_toma_posesion_inicial --Sin Posesión
                   || vi.ocupado_contitulo --Alquilado
                   || vi.ocupado_sintitulo --Ocupado
                   || vi.pendiente_inscripcion --Pendiente inscripción
                   || vi.proindiviso --Proindiviso
                   || vi.tapiado --Tapiado
                   || vi.obranueva_sindeclarar --Sin declarar obra nueva
                   || vi.obranueva_enconstruccion --En construcción obra nueva
                   || vi.divhorizontal_noinscrita --División horizontal no inscrita
                   || vi.ruina --Ruina
				   || NVL2 (vi.otro, 1, 0) --Inmueble en Situación Especial
                   || vi.sin_informe_aprobado --Inmueble en Precomercialización
                   || vi.revision --Inmueble en Revisión
                   || vi.procedimiento_judicial --Procedimiento Judicial
                   || vi.con_cargas --Inmueble con Cargas
                   || 0 --Inmueble sin Título
                   || 0 --Pendiente de adjudicación
                   || vi.vandalizado --Vandalizado
                   || vi.sin_acceso --Sin Acceso
                   condicionantes,
                   vi.otro descripcion_otros
              FROM rem01.v_cond_disponibilidad vi
              LEFT JOIN rem01.ACT_PAC_PERIMETRO_ACTIVO pac on pac.act_id = vi.act_id) v ON v.act_id = actpub.act_id

    	LEFT JOIN(  SELECT DISTINCT pve.PVE_COD_REM, gac.ACT_ID, row_number() over(partition by gac.act_id order by pve.fechacrear desc) rn
    	    FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO gac
                inner join '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD gee ON gee.GEE_ID = gac.GEE_ID
                inner join '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO pvc ON pvc.USU_ID = gee.USU_ID
                inner join '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR pve ON pve.PVE_ID = pvc.PVE_ID
                inner join '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR epr ON epr.DD_EPR_ID = pve.DD_EPR_ID AND epr.DD_EPR_CODIGO = ''04''
                inner join '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR tpr ON tpr.DD_TPR_ID = pve.DD_TPR_ID AND tpr.DD_TPR_CODIGO =''05''
                INNER join '||V_ESQUEMA||'.act_activo act on act.act_id = gac.ACT_ID
		        INNER join '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge on tge.DD_TGE_ID = gee.DD_TGE_ID
		        INNER join '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR etp on etp.DD_CRA_ID = act.DD_CRA_ID and etp.PVE_ID = pve.PVE_ID
		    WHERE tge.DD_TGE_CODIGO = ''PTEC'') PVEPRV ON PVEPRV.ACT_ID = act.ACT_ID and PVEPRV.RN = 1

		LEFT JOIN (
            SELECT DDTCE.DD_TCE_CODIGO, CFD.DD_TPA_ID, ADO.ACT_ID, ROW_NUMBER() OVER(PARTITION BY ADO.ACT_ID ORDER BY CFD.FECHACREAR DESC) RN
            FROM '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO
            JOIN '||V_ESQUEMA||'.DD_TCE_TIPO_CALIF_ENERGETICA DDTCE ON ADO.DD_TCE_ID = DDTCE.DD_TCE_ID
            JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID
            WHERE ADO.DD_TCE_ID IS NOT NULL AND ADO.BORRADO = 0 AND DDTCE.BORRADO = 0 AND CFD.BORRADO = 0
        ) DDTCE ON DDTCE.ACT_ID = ACT.ACT_ID AND DDTPA.DD_TPA_ID = DDTCE.DD_TPA_ID AND DDTCE.RN = 1
		LEFT JOIN (
			SELECT AGA.ACT_ID, AGR.AGR_FECHA_BAJA, AGR.AGR_FIN_VIGENCIA, AGR.AGR_NUM_AGRUP_REM, AGR.AGR_ACT_PRINCIPAL, AGR.DD_TAG_ID, DDTAG.DD_TAG_CODIGO, AGA.AGA_PRINCIPAL
				, ROW_NUMBER() OVER(PARTITION BY AGA.ACT_ID ORDER BY AGR.FECHACREAR ASC) RN
			FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
			INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID
			INNER JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION DDTAG ON AGR.DD_TAG_ID = DDTAG.DD_TAG_ID 
				AND DDTAG.DD_TAG_CODIGO in (''14'',''15'', ''16'')
			WHERE AGA.BORRADO = 0 AND AGR.BORRADO = 0 AND DDTAG.BORRADO = 0
		) AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.RN = 1
		LEFT JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO ACT_PTA ON ACT_PTA.ACT_ID = ACT.ACT_ID AND ACT_PTA.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.DD_TAL_TIPO_ALQUILER DD_TAL ON DD_TAL.DD_TAL_ID = ACT.DD_TAL_ID
		where act.borrado = 0 and sps.borrado = 0';

		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');
		
		
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_ACTIVO_HAYA) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		
		-- Creamos primary key
		V_MSQL := 'ALTER MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' ADD (CONSTRAINT '||V_TEXT_VISTA||'_PK PRIMARY KEY (ID_ACTIVO_HAYA) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_PK... PK creada.');
	
		
		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_ACTIVO_HAYA) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_ACTIVO_HAYA) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');	
	
		-- Creamos comentario	
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');	
	
	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');


	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;
