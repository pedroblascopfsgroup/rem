--/*
--##########################################
--## AUTOR=RLB
--## FECHA_CREACION=20181220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de los informes enviadas a webcom.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2: 20180525 Gustavo Mora. Se filtra borrado = 0 en dis_distribucion de las subconsultas
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_INFORME_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'IWH_INFORME_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de los informes enviadas a webcom.'; -- Vble. para los comentarios de las tablas

    CUENTA NUMBER;
    
BEGIN
	

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
		WITH REFERENCIA_CATASTRAL AS (
			SELECT AUX.* FROM (
				SELECT CAT.ACT_ID, CAT.CAT_REF_CATASTRAL,
				ROW_NUMBER() OVER (PARTITION BY CAT.ACT_ID ORDER BY CAT.CAT_ID DESC) REF
				FROM '||V_ESQUEMA||'.ACT_CAT_CATASTRO CAT) AUX
			WHERE AUX.REF = 1
		),
		ACCION AS (
			SELECT * FROM (
				SELECT ICO.ICO_ID,
		        CASE WHEN (ICO.FECHACREAR IS NOT NULL) 
		            THEN CAST(TO_CHAR(ICO.FECHACREAR,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		            ELSE NULL
		        END FECHA_ACCION,
		        CASE WHEN (ICO.USUARIOMODIFICAR IS NOT NULL) 
		            THEN (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		            WHERE USU.USU_USERNAME = ICO.USUARIOMODIFICAR)
		            ELSE (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		            WHERE USU.USU_USERNAME = ICO.USUARIOCREAR) 
		        END ID_USUARIO_REM_ACCION
				FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			)
		)	
		SELECT 
			CAST(  NVL(LPAD(ACT.ACT_ID,10,0) , ''00000'')   
				|| NVL(LPAD(ICO.ICO_ID,8,0) , ''00000000'')  
				|| NVL(LPAD(DIS.DIS_ID,10,0) , ''00000000'') 
				|| NVL(LPAD(AVI.AVI_ID,5,0) , ''00000'') AS NUMBER(32,0)) AS ID_INFORME_COMERCIAL,
			CAST(ACT.ACT_NUM_ACTIVO AS NUMBER(16,0)) AS ID_ACTIVO_HAYA,
			CAST(ICO.ICO_WEBCOM_ID AS NUMBER(16,0)) AS ID_INFORME_MEDIADOR_WEBCOM,
			CAST((SELECT MAX(PVE.PVE_COD_REM) FROM 
				'||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI ICM, '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
				WHERE ICM.ACT_ID = ACT.ACT_ID AND PVE.PVE_ID = ICM.ICO_MEDIADOR_ID
				AND ICM.ICM_FECHA_HASTA = (SELECT MAX(ICM2.ICM_FECHA_HASTA) FROM 
				'||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI ICM2)) AS NUMBER(16,0))  AS ID_PROVEEDOR_REM_ANTERIOR,
			CAST(PVE.PVE_COD_REM AS NUMBER(16,0)) AS ID_PROVEEDOR_REM,
			CAST(ICO.ICO_POSIBLE_HACER_INF AS NUMBER(1,0)) AS POSIBLE_INFORME,
			CAST(ICO.ICO_MOTIVO_NO_HACER_INF AS VARCHAR2(500 CHAR)) AS MOTIVO_NO_POSIBLE_INFORME,
			CAST(CASE WHEN (ESI.DD_AIC_CODIGO = ''02'') 
				THEN CAST(''1'' AS NUMBER(1,0))
				ELSE CAST(''0'' AS NUMBER(1,0))
			END  AS NUMBER(1,0)) AS ACEPTADO,
			CAST(ESI.HIC_MOTIVO AS VARCHAR2(500 CHAR)) AS MOTIVO_RECHAZO,
			CASE WHEN (ICO.ICO_FECHA_RECEP_LLAVES_HAYA IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.ICO_FECHA_RECEP_LLAVES_HAYA ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END AS RECEPCION_LLAVES_HAYA,
			CASE WHEN (ICO.ICO_FECHA_ENVIO_LLAVES_API IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.ICO_FECHA_ENVIO_LLAVES_API ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END AS ENVIO_LLAVES_A_API,
			CAST(BREG.BIE_DREG_NUM_FINCA AS VARCHAR2(14 CHAR)) AS FINCA_REGISTRAL,
			CAST(BREG.BIE_DREG_NUM_REGISTRO AS NUMBER(16,0)) AS NUMERO_REGISTRO,			
			CAST(CAT.CAT_REF_CATASTRAL AS VARCHAR2(20 CHAR)) AS REFERENCIA_CATASTRAL,
			CAST(VAL.APROBADO_VENTA_WEB AS NUMBER(16,2)) AS VALOR_APROBADO_VENTA,
			CASE WHEN (VAL.APROBADO_VENTA_WEB_F_INI IS NOT NULL) 
				THEN CAST(TO_CHAR(VAL.APROBADO_VENTA_WEB_F_INI ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END AS FECHA_VALOR_APROBADO_VENTA,		
			CAST(VAL.APROBADO_RENTA_WEB AS NUMBER(16,2)) AS VALOR_APROBADO_RENTA,
			CASE WHEN (VAL.APROBADO_RENTA_WEB_F_INI IS NOT NULL) 
				THEN CAST(TO_CHAR(VAL.APROBADO_RENTA_WEB_F_INI ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
			END AS FECHA_VALOR_APROBADO_RENTA,

			CAST(SPS.SPS_RIESGO_OCUPACION AS NUMBER(1,0)) AS RIESGO_OCUPACION,    
			CASE WHEN (SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL) 
				THEN CAST(TO_CHAR(SPS.SPS_FECHA_TOMA_POSESION,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END FECHA_POSESION,
			CASE WHEN (ICO.FECHAMODIFICAR IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.FECHAMODIFICAR ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END ULTIMA_MODIFICACION,  
				CASE WHEN (SPS.SPS_FECHA_TITULO IS NOT NULL) 
				THEN CAST(TO_CHAR(SPS.SPS_FECHA_TITULO ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END FECHA_CONTRATO_DATOS_OCU,
			CASE WHEN (SPS.SPS_FECHA_VENC_TITULO IS NOT NULL) 
				THEN CAST(TO_CHAR(SPS.SPS_FECHA_VENC_TITULO ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END  PLAZO_CONTRATO_DATOS_OCU,
			CAST(SPS.SPS_RENTA_MENSUAL AS NUMBER(16,2)) AS RENTA_MENSUAL_DATOS_OCU,
			CAST(ICO.ICO_RECIBIO_IMPORTE_ADM AS NUMBER(16,2)) AS RECIBIDO_IMPORTE_DATOS_ADM,
			CAST(ICO.ICO_IBI_IMPORTE_ADM AS NUMBER(16,2)) AS IBI_IMPORTE_DATOS_ADM,
			CAST(ICO.ICO_DERRAMA_IMPORTE_ADM AS NUMBER(16,2)) AS DERRAMA_IMPORTE_DATOS_ADM,
			CAST(ICO.ICO_DET_DERRAMA_IMPORTE_ADM AS VARCHAR2(500 CHAR)) AS DETALLE_DERRAMA_DATOS_ADM,
			CAST(DDTPA.DD_TPA_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_ACTIVO,
			CAST(DDSAC.DD_SAC_CODIGO AS VARCHAR2(5 CHAR)) AS COD_SUBTIPO_INMUEBLE,
			CAST(DDTPV.DD_TPV_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_VIVIENDA,
			CASE WHEN (ICO.ICO_FECHA_ULTIMA_VISITA IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.ICO_FECHA_ULTIMA_VISITA ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END  FECHA_ULTIMA_VISITA,
			CAST(DDTVI.DD_TVI_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_VIA,
			CAST(ICO.ICO_NOMBRE_VIA AS VARCHAR2(100 CHAR)) AS NOMBRE_CALLE,
			CAST(ICO.ICO_NUM_VIA AS VARCHAR2(100 CHAR)) AS NUMERO_CALLE,
			CAST(ICO.ICO_ESCALERA AS VARCHAR2(10 CHAR)) AS ESCALERA,
			CAST(ICO.ICO_PLANTA AS VARCHAR2(11 CHAR)) AS PLANTA,
			CAST(ICO.ICO_PUERTA AS VARCHAR2(17 CHAR)) AS PUERTA,
			CAST(DDLOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR)) AS COD_MUNICIPIO,
			CAST(DDUPO.DD_UPO_CODIGO AS VARCHAR2(5 CHAR)) AS COD_PEDANIA,
			CAST(DDPRV.DD_PRV_CODIGO AS VARCHAR2(5 CHAR)) AS COD_PROVINCIA,
			CAST(ICO.ICO_CODIGO_POSTAL AS VARCHAR2(250 CHAR)) AS CODIGO_POSTAL,
			CAST(ICO.ICO_ZONA AS VARCHAR2(100 CHAR)) AS ZONA,
			CAST(DDUAC.DD_UAC_CODIGO AS VARCHAR2(5 CHAR)) AS COD_UBICACION,
			CAST(DDDIS.DD_DIS_CODIGO AS VARCHAR2(5 CHAR)) AS COD_DISTRITO,
			CAST(ICO.ICO_LATITUD  AS NUMBER(10,8)) AS LAT,
			CAST(ICO.ICO_LONGITUD AS NUMBER(11,8)) AS LNG,
			CASE WHEN (ICO.ICO_FECHA_RECEP_LLAVES IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.ICO_FECHA_RECEP_LLAVES ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END  FECHA_RECEPCION_LLAVES_API,
			CAST(DDLOC2.DD_LOC_CODIGO AS VARCHAR2(5 CHAR)) AS COD_MUNICIPIO_REGISTRO,
			CAST(DDTVP.DD_TVP_CODIGO  AS VARCHAR2(5 CHAR)) AS COD_REGIMEN_PROTECCION,
			CAST(ADM.ADM_MAX_PRECIO_VENTA  AS NUMBER(16,2)) AS VALOR_MAXIMO_VPO,
			CAST(DDTGP.DD_TGP_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_PROPIEDAD,
			CAST(PAC.PAC_PORC_PROPIEDAD AS NUMBER(16,2)) AS PORCENTAJE_PROPIEDAD,
			CAST(ICO.ICO_VALOR_ESTIMADO_VENTA AS NUMBER(16,2)) AS VALOR_ESTIMADO_VENTA,
			
			CASE WHEN (ICO.ICO_FECHA_ESTIMACION_VENTA IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.ICO_FECHA_ESTIMACION_VENTA ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END AS FECHA_VALOR_ESTIMADO_VENTA,
			CAST(ICO.ICO_JUSTIFICACION_VENTA AS VARCHAR2(1000 CHAR)) AS JUSTIFICACION_VALOR_EST_VENTA,
			CAST(ICO.ICO_VALOR_ESTIMADO_RENTA AS NUMBER(16,2)) AS VALOR_ESTIMADO_RENTA,
			CASE WHEN (ICO.ICO_FECHA_ESTIMACION_RENTA IS NOT NULL) 
				THEN CAST(TO_CHAR(ICO.ICO_FECHA_ESTIMACION_RENTA ,''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
				ELSE NULL
			END  FECHA_VALOR_ESTIMADO_RENTA,
			CAST(ICO.ICO_JUSTIFICACION_RENTA AS VARCHAR2(1000 CHAR)) AS JUSTIFICACION_VALOR_EST_RENTA,
			CAST(REG.REG_SUPERFICIE_UTIL AS NUMBER(16,2)) AS UTIL_SUPERFICIE,
			CAST(BREG.BIE_DREG_SUPERFICIE_CONSTRUIDA AS NUMBER(16,2)) AS CONSTRUIDA_SUPERFICIE,
			CAST(BREG.BIE_DREG_SUPERFICIE AS NUMBER(16,2)) AS REGISTRAL_SUPERFICIE,
			CAST(REG.REG_SUPERFICIE_PARCELA AS NUMBER(16,2)) AS PARCELA_SUPERFICIE,
			CAST(CIF.COD_ESTADO_CONSERVACION AS VARCHAR2(5 CHAR)) AS COD_ESTADO_CONSERVACION,
			CAST(ICO.ICO_ANO_CONSTRUCCION  AS NUMBER(16,0)) AS ANYO_CONSTRUCCION,
			CAST(ICO.ICO_ANO_REHABILITACION AS NUMBER(16,0)) AS ANYO_REHABILITACION,
			CAST(DDTPO.DD_TPO_CODIGO AS VARCHAR2(5 CHAR)) AS COD_ORIENTACION,
			CAST(VIV.VIV_ULTIMA_PLANTA AS NUMBER(1,0)) AS ULTIMA_PLANTA,
			CAST(SPS.SPS_OCUPADO AS NUMBER(1,0)) AS OCUPADO,
			CAST(VIV.VIV_NUM_PLANTAS_INTERIOR AS NUMBER(16,0)) AS NUMERO_PLANTAS,
			CAST(DDTPR.DD_TPR_CODIGO AS VARCHAR2(5 CHAR)) AS COD_NIVEL_RENTA,		
			CAST(DIS.DIS_NUM_PLANTA AS NUMBER(16,0)) AS PLANTAS_NUMERO,
			CAST(TPH.DD_TPH_CODIGO AS VARCHAR2(5 CHAR))	AS PLANTAS_COD_TIPO_ESTANCIA,	
			CAST(DIS.DIS_CANTIDAD AS NUMBER(16,0)) AS PLANTAS_NUMERO_ESTANCIAS,
			CAST(DIS.DIS_SUPERFICIE AS NUMBER(16,2)) AS PLANTAS_ESTANCIAS,
			CAST(DIS.DIS_DESCRIPCION AS VARCHAR2(150 CHAR)) AS PLANTAS_DESCRIPCION_ESTANCIAS,
			CAST(ICO.ICO_NUM_TERRAZA_DESCUBIERTA AS NUMBER(16,0)) AS NUMERO_TERRAZAS_DESCUBIERTAS,
			CAST(ICO.ICO_DESC_TERRAZA_DESCUBIERTA AS VARCHAR2(150 CHAR)) AS DESC_TERRAZAS_DESCUBIERTAS,
			CAST(ICO.ICO_NUM_TERRAZA_CUBIERTA AS NUMBER(16,0)) AS NUMERO_TERRAZAS_CUBIERTAS,
			CAST(ICO.ICO_DESC_TERRAZA_CUBIERTA AS VARCHAR2(150 CHAR)) AS DESC_TERRAZAS_CUBIERTAS,
			CAST(ICO.ICO_DESPENSA_OTRAS_DEP AS NUMBER(1,0))	AS DESPENSA_OTRAS_DEPENDENCIAS,
			CAST(ICO.ICO_LAVADERO_OTRAS_DEP AS NUMBER(1,0))	AS LAVADERO_OTRAS_DEPENDENCIAS,                                                     
			CAST(ICO.ICO_AZOTEA_OTRAS_DEP AS NUMBER(1,0)) AS AZOTEA_OTRAS_DEPENDENCIAS, 
			CAST(ICO.ICO_OTROS_OTRAS_DEP AS VARCHAR2(150 CHAR))	AS OTROS_OTRAS_DEPENDENCIAS,
			CAST(VIV.VIV_REFORMA_CARP_EXT AS NUMBER(1,0)) AS EXTERIOR_CARP_REFORMAS_NEC,
			CAST(VIV.VIV_REFORMA_CARP_INT AS NUMBER(1,0)) AS INTERIOR_CARP_REFORMAS_NEC,
			CAST(VIV.VIV_REFORMA_COCINA AS NUMBER(1,0))	AS COCINA_REFORMAS_NEC,
			CAST(VIV.VIV_REFORMA_SUELO AS NUMBER(1,0)) AS SUELOS_REFORMAS_NEC,
			CAST(VIV.VIV_REFORMA_PINTURA AS NUMBER(1,0)) AS PINTURA_REFORMAS_NEC,
			CAST(VIV.VIV_REFORMA_INTEGRAL AS NUMBER(1,0)) AS INTEGRAL_REFORMAS_NEC,
			CAST(VIV.VIV_REFORMA_BANYO AS NUMBER(1,0)) AS BANYOS_REFORMAS_NEC,
			CAST(VIV.VIV_REFORMA_OTRO_DESC AS VARCHAR2(250 CHAR)) AS OTRAS_REFORMAS_NEC,
			CAST(VIV.VIV_REFORMA_PRESUPUESTO AS NUMBER(16,2)) 	AS OTRAS_REFORMAS_NEC_IMPORTE,
			CAST(ACT2.ACT_NUM_ACTIVO AS NUMBER(16,0)) AS ACTIVOS_VINCULADOS_ID_ACTIVO,
			CAST(ICO.ICO_INFO_DISTRIBUCION_INTERIOR AS VARCHAR2(500 CHAR)) AS DISTRIBUCION_INTERIOR,
			CAST(CIF.DIVISIBLE AS NUMBER(1,0)) AS DIVISIBLE,
			CAST(CIF.ASCENSOR AS NUMBER(1,0)) AS ASCENSOR,
			CAST(CIF.NUMERO_ASCENSORES AS NUMBER(16,0)) AS NUMERO_ASCENSORES,
			CAST(CIF.DESCRIPCION_PLANTAS AS VARCHAR2(150 CHAR)) AS DESCRIPCION_PLANTAS,
			CAST(CIF.OTRAS_CARACTERISTICAS AS VARCHAR2(3000 CHAR)) AS OTRAS_CARACTERISTICAS,
			CAST(CIF.FACHADA_REFORMAS_NECESARIAS AS NUMBER(1,0)) AS FACHADA_REFORMAS_NECESARIAS,
			CAST(CIF.ESCALERA_REFORMAS_NECESARIAS AS NUMBER(1,0)) AS ESCALERA_REFORMAS_NECESARIAS,
			CAST(CIF.PORTAL_REFORMAS_NECESARIAS AS NUMBER(1,0)) AS PORTAL_REFORMAS_NECESARIAS,
			CAST(CIF.ASCENSOR_REFORMAS_NECESARIAS AS NUMBER(1,0)) AS ASCENSOR_REFORMAS_NECESARIAS,
			CAST(CIF.CUBIERTA AS NUMBER(1,0)) AS CUBIERTA,
			CAST(CIF.OTRAS_ZNC_REFORMAS_NECESARIAS AS NUMBER(1,0)) AS OTRAS_ZNC_REFORMAS_NECESARIAS,
			CAST(CIF.OTRAS_REFORMAS_NECESARIAS AS VARCHAR2(150 CHAR)) AS OTRAS_REFORMAS_NECESARIAS,
			CAST(CIF.DESCRIPCION_EDIFICIO AS VARCHAR2(3000 CHAR)) AS DESCRIPCION_EDIFICIO,
			CAST(CIF.INFRAESTRUCTURAS_ENTORNO AS VARCHAR2(1024 CHAR)) AS INFRAESTRUCTURAS_ENTORNO,
			CAST(CIF.COMUNICACIONES_ENTORNO AS VARCHAR2(1024 CHAR)) AS COMUNICACIONES_ENTORNO,	
			CAST(LCO.LCO_USO_IDONEO AS VARCHAR2(150 CHAR)) AS IDONEO_USO,
			CASE WHEN (LCO.LCO_USO_ANTERIOR IS NOT NULL) 
				THEN CAST(''1'' AS NUMBER(1,0))
				ELSE CAST(''0'' AS NUMBER(1,0))
			END EXISTE_ANTERIOR_USO,	  
			CAST(LCO.LCO_USO_ANTERIOR AS VARCHAR2(250 CHAR)) AS ANTERIOR_USO,
			CAST(LCO.LCO_NUMERO_ESTANCIAS AS NUMBER(16,0)) AS NUMERO_ESTANCIAS,
			CAST(LCO.LCO_NUMERO_BANYOS AS NUMBER(16,0)) AS NUMERO_BANYOS,
			CAST(LCO.LCO_NUMERO_ASEOS AS NUMBER(16,0)) AS NUMERO_ASEOS,
			CAST(LCO.LCO_MTS_FACHADA_PPAL AS NUMBER(16,2)) AS MTS_LINEALES_FACHADA_PPAL,
			CASE WHEN (DDTPA.DD_TPA_CODIGO = ''07'')
				THEN CAST(APR.APR_ALTURA AS NUMBER(16,2))
				ELSE CAST(LCO.LCO_MTS_ALTURA_LIBRE AS NUMBER(16,2))	
			END ALTURA,
			CASE WHEN (PIV.TRASTEROS IS NOT NULL) 
				THEN CAST(''1'' AS NUMBER(1,0))
				ELSE CAST(''0'' AS NUMBER(1,0)) 
			END EXISTE_ANEJO_TRASTERO,				
			CAST((SELECT DIS.DIS_DESCRIPCION
				FROM '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS
				INNER JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID = DIS.DD_TPH_ID
				WHERE DIS.ICO_ID = ICO.ICO_ID AND DIS.DIS_NUM_PLANTA = 0 AND TPH.DD_TPH_CODIGO = ''11''  AND DIS.BORRADO = 0) AS VARCHAR2(150 CHAR)) AS ANEJO_TRASTERO,
			CAST((SELECT DIS.DIS_DESCRIPCION
				FROM '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS
				INNER JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID = DIS.DD_TPH_ID
				WHERE DIS.ICO_ID = ICO.ICO_ID AND DIS.DIS_NUM_PLANTA = 0 AND TPH.DD_TPH_CODIGO = ''12'' AND DIS.BORRADO = 0) AS VARCHAR2(150 CHAR)) AS ANEJO_GARAGE,
			CAST(PIV.GARAJES AS NUMBER(16,0)) AS NUMERO_PLAZAS_GARAJE,
			CAST((SELECT SUP.MTS_GARAJES
				FROM '||V_ESQUEMA||'.VI_PIVOT_SUP_DISTRIBUCION SUP
				WHERE SUP.ICO_ID = ICO.ICO_ID) AS NUMBER(16,2)) AS SUPERFICIE_PLAZAS_GARAJE,
			CAST(NULL AS VARCHAR2(5 CHAR)) AS COD_SUBTIPO_PLAZAS_GARAJE,
			CAST(LCO.LCO_SALIDA_HUMOS AS NUMBER(1,0)) AS SALIDA_HUMOS_OTRAS_CARAC,
			CAST(LCO.LCO_SALIDA_EMERGENCIA AS NUMBER(1,0)) AS SALIDA_EMERGENCIA_OTRAS_CARAC,
			CAST(LCO.LCO_ACCESO_MINUSVALIDOS AS NUMBER(1,0)) AS ACCESO_MINUSVAL_OTRAS_CARAC,
			CAST(LCO.LCO_OTROS_OTRAS_CARACT AS VARCHAR2(150 CHAR)) AS OTROS_OTRAS_CARAC,
			CAST(DDTPVA.DD_TPV_CODIGO AS VARCHAR2(5 CHAR)) AS COD_TIPO_VARIO,
			CAST(APR.APR_ANCHURA AS NUMBER(16,2)) AS ANCHO,
			CAST(APR.APR_ALTURA AS NUMBER(16,2)) AS ALTO,
			CAST(APR.APR_PROFUNDIDAD AS NUMBER(16,2)) AS LARGO,
			CAST(DDSPG.DD_SPG_CODIGO AS VARCHAR2(5 CHAR)) AS COD_USO,
			CAST(DDTCA.DD_TCA_CODIGO AS VARCHAR2(5 CHAR)) AS COD_MANIOBRABILIDAD,
			CAST(APR.APR_LICENCIA AS NUMBER(1,0)) AS LICENCIA_OTRAS_CARAC,
			CAST(APR.APR_SERVIDUMBRE AS NUMBER(1,0)) AS SERVIDUMBRE_OTRAS_CARAC,
			CAST(APR.APR_ASCENSOR_MONTACARGA AS NUMBER(1,0)) AS ASCENSOR_MONT_OTRAS_CARAC,
			CAST(APR.APR_COLUMNAS AS NUMBER(1,0)) AS COLUMNAS_OTRAS_CARAC,
			CAST(APR.APR_SEGURIDAD AS NUMBER(1,0)) AS SREGURIDAD_OTRAS_CARAC,	
			CAST(CIF.BUEN_EST_INST_ELECT_INST AS NUMBER(1,0))	AS BUEN_EST_INST_ELECT_INST,
			CAST(CIF.BUEN_EST_CONT_ELECT_INST AS NUMBER(1,0)) AS BUEN_EST_CONT_ELECT_INST,
			CAST(CIF.BUEN_EST_INST_AGUA_INST AS NUMBER(1,0)) AS BUEN_EST_INST_AGUA_INST,
			CAST(CIF.BUEN_EST_CONT_AGUA_INST AS NUMBER(1,0)) AS BUEN_EST_CONT_AGUA_INST,
			CAST(CIF.BUEN_EST_INST_GAS_INST AS NUMBER(1,0)) AS BUEN_EST_INST_GAS_INST,
			CAST(CIF.BUEN_EST_CONT_GAS_INST AS NUMBER(1,0)) AS BUEN_EST_CONT_GAS_INST,
			CAST(CIF.ESTADO_CONSERVACION_EDI AS VARCHAR2(5 CHAR)) AS ESTADO_CONSERVACION_EDI,	
			CAST(ICO.ICO_ANO_REHABILITACION AS NUMBER(16,0)) AS ANYO_REHABILITACION_EDIFICIO,	
			CAST(CIF.NUMERO_PLANTAS_EDIFICIO AS NUMBER(16,0)) AS NUMERO_PLANTAS_EDIFICIO,
			CAST(CIF.ASCENSOR_EDIFICIO AS NUMBER(1,0)) AS ASCENSOR_EDIFICIO,
			CAST(CIF.NUMERO_ASCENSORES_EDIFICIO AS NUMBER(16,0)) AS NUMERO_ASCENSORES_EDIFICIO,
			CAST(ICO.ICO_EXIS_COM_PROP AS NUMBER(1,0)) AS EXISTE_COMUNIDAD_EDIFICIO,
			CAST(ICO.ICO_CUOTACP_ORIENTATIVA AS NUMBER(16,2)) AS CUOTA_COMUNIDAD_EDIFICIO,
			CAST(ICO.ICO_PRESIDENTE_NOMBRE AS VARCHAR2(100 CHAR)) AS NOM_PRESIDENTE_COM_EDIFICIO,
			CAST(ICO.ICO_PRESIDENTE_TELF AS VARCHAR2(20 CHAR)) AS TELF_PRESIDENTE_COM_EDIFICIO,
			CAST(ICO.ICO_ADMINISTRADOR_NOMBRE AS VARCHAR2(100 CHAR)) AS NOM_ADMIN_COM_EDIFICIO,
			CAST(ICO.ICO_ADMINISTRADOR_TELF AS VARCHAR2(20 CHAR)) AS TELF_ADMIN_COM_EDIFICIO,
			CAST(ICO.ICO_DERRAMACP_ORIENTATIVA AS VARCHAR2(150 CHAR)) AS DESC_DERRAMA_COM_EDIFICIO,
			CAST(CIF.FACHADA_REFORMAS_NEC_EDI AS NUMBER(1,0)) AS FACHADA_REFORMAS_NEC_EDI,
			CAST(CIF.ESCALERA_REFORMAS_NEC_EDI AS NUMBER(1,0)) AS ESCALERA_REFORMAS_NEC_EDI,
			CAST(CIF.PORTAL_REFORMAS_NEC_EDI AS NUMBER(1,0)) AS PORTAL_REFORMAS_NEC_EDI,
			CAST(CIF.ASCENSOR_REFORMAS_NEC_EDI AS NUMBER(1,0)) AS ASCENSOR_REFORMAS_NEC_EDI,
			CAST(CIF.CUBIERTA_REFORMAS_NEC_EDI AS NUMBER(1,0)) AS CUBIERTA_REFORMAS_NEC_EDI,
			CAST(CIF.OTRAS_ZCO_REFORMAS_NEC_EDI AS NUMBER(1,0)) AS OTRAS_ZCO_REFORMAS_NEC_EDI,
			CAST(CIF.OTRAS_REFORMAS_NEC_EDI AS VARCHAR2(250 CHAR)) AS OTRAS_REFORMAS_NEC_EDI,
			CAST(CIF.INFRAESTRUCTURAS_ENTORNO_EDI AS VARCHAR2(1024 CHAR)) AS INFRAESTRUCTURAS_ENTORNO_EDI,
			CAST(CIF.COMUNICACIONES_ENTORNO_EDI AS VARCHAR2(1024 CHAR))  AS COMUNICACIONES_ENTORNO_EDI,
			CAST(CIF.EXISTE_OCIO AS NUMBER(1,0)) AS EXISTE_OCIO,
			CAST(CIF.EXISTEN_HOTELES AS NUMBER(1,0)) AS EXISTEN_HOTELES,
			CAST(CIF.HOTELES AS VARCHAR2(250 CHAR)) AS HOTELES,
			CAST(CIF.EXISTEN_TEATROS AS NUMBER(1,0)) AS EXISTEN_TEATROS,
			CAST(CIF.TEATROS AS VARCHAR2(250 CHAR)) AS TEATROS,
			CAST(CIF.EXISTEN_SALAS_DE_CINE AS NUMBER(1,0)) AS EXISTEN_SALAS_DE_CINE,
			CAST(CIF.SALAS_DE_CINE AS VARCHAR2(250 CHAR)) AS SALAS_DE_CINE,
			CAST(CIF.EXISTEN_INST_DEPORTIVAS AS NUMBER(1,0)) AS EXISTEN_INST_DEPORTIVAS,
			CAST(CIF.INST_DEPORTIVAS AS VARCHAR2(250 CHAR)) AS INST_DEPORTIVAS,
			CAST(CIF.EXISTEN_CENTROS_COMERCIALES AS NUMBER(1,0)) AS EXISTEN_CENTROS_COMERCIALES,
			CAST(CIF.CENTROS_COMERCIALES AS VARCHAR2(250 CHAR)) AS CENTROS_COMERCIALES,
			CAST(CIF.OTROS_OCIO AS VARCHAR2(250 CHAR)) AS OTROS_OCIO,
			CAST(CIF.EXISTEN_CENTROS_EDUCATIVOS AS NUMBER(1,0)) AS EXISTEN_CENTROS_EDUCATIVOS,
			CAST(CIF.EXISTEN_ESCUELAS_INFANTILES AS NUMBER(1,0)) AS EXISTEN_ESCUELAS_INFANTILES,
			CAST(CIF.ESCUELAS_INFANTILES AS VARCHAR2(250 CHAR)) AS ESCUELAS_INFANTILES,
			CAST(CIF.EXISTEN_COLEGIOS AS NUMBER(1,0)) AS EXISTEN_COLEGIOS,
			CAST(CIF.COLEGIOS AS VARCHAR2(250 CHAR)) AS COLEGIOS,
			CAST(CIF.EXISTEN_INSTITUTOS AS NUMBER(1,0))  AS EXISTEN_INSTITUTOS,
			CAST(CIF.INSTITUTOS AS VARCHAR2(250 CHAR)) AS INSTITUTOS,
			CAST(CIF.EXISTEN_UNIVERSIDADES AS NUMBER(1,0))  AS EXISTEN_UNIVERSIDADES,
			CAST(CIF.UNIVERSIDADES AS VARCHAR2(250 CHAR)) AS UNIVERSIDADES,
			CAST(CIF.OTROS_CENTROS_EDUCATIVOS AS VARCHAR2(250 CHAR))  AS OTROS_CENTROS_EDUCATIVOS,
			CAST(CIF.EXISTEN_CENTROS_SANITARIOS AS NUMBER(1,0)) AS EXISTEN_CENTROS_SANITARIOS,
			CAST(CIF.EXISTEN_CENTROS_DE_SALUD AS NUMBER(1,0))  AS EXISTEN_CENTROS_DE_SALUD,
			CAST(CIF.CENTROS_DE_SALUD AS VARCHAR2(250 CHAR))  AS CENTROS_DE_SALUD,
			CAST(CIF.EXISTEN_CLINICAS AS NUMBER(1,0)) AS EXISTEN_CLINICAS,
			CAST(CIF.CLINICAS AS VARCHAR2(250 CHAR)) AS CLINICAS,
			CAST(CIF.EXISTEN_HOSPITALES AS NUMBER(1,0)) AS EXISTEN_HOSPITALES,
			CAST(CIF.HOSPITALES AS VARCHAR2(250 CHAR)) AS HOSPITALES,
			CAST(CIF.EXISTEN_OTROS_CENTROS_SANIT AS NUMBER(1,0)) AS EXISTEN_OTROS_CENTROS_SANIT,
			CAST(CIF.OTROS_CENTROS_SANITARIOS AS VARCHAR2(250 CHAR)) AS OTROS_CENTROS_SANITARIOS,
			CAST(CIF.SUFI_APARCAMIENTO_SUPERFICIE AS NUMBER(1,0)) AS SUFI_APARCAMIENTO_SUPERFICIE,
			CAST(CIF.EXISTEN_COMUNICACIONES AS NUMBER(1,0)) AS EXISTEN_COMUNICACIONES,
			CAST(CIF.EXISTE_FACIL_ACCESO_CARRETERA AS NUMBER(1,0)) AS EXISTE_FACIL_ACCESO_CARRETERA,
			CAST(CIF.FACIL_ACCESO_POR_CARRETERA AS VARCHAR2(250 CHAR)) AS FACIL_ACCESO_POR_CARRETERA,
			CAST(CIF.EXISTE_LINEAS_DE_AUTOBUS AS NUMBER(1,0))  AS EXISTE_LINEAS_DE_AUTOBUS,
			CAST(CIF.LINEAS_DE_AUTOBUS AS VARCHAR2(250 CHAR)) AS LINEAS_DE_AUTOBUS,
			CAST(CIF.EXISTE_METRO AS NUMBER(1,0)) AS EXISTE_METRO,
			CAST(CIF.METRO AS VARCHAR2(250 CHAR)) AS METRO,
			CAST(CIF.EXISTE_ESTACIONES_DE_TREN AS NUMBER(1,0)) AS EXISTE_ESTACIONES_DE_TREN,
			CAST(CIF.ESTACIONES_DE_TREN AS VARCHAR2(250 CHAR)) AS ESTACIONES_DE_TREN,
			CAST(CIF.OTROS_COMUNICACIONES AS VARCHAR2(150 CHAR)) AS OTROS_COMUNICACIONES,		
			CAST(CIF.BUEN_ESTADO_PTA_ENT_NORMAL AS NUMBER(1,0)) AS BUEN_ESTADO_PTA_ENT_NORMAL,
			CAST(CIF.BUEN_ESTADO_PTA_ENT_BLINDADA AS NUMBER(1,0)) AS BUEN_ESTADO_PTA_ENT_BLINDADA,
			CAST(CIF.BUEN_ESTADO_PTA_ENT_ACORAZADA AS NUMBER(1,0)) AS BUEN_ESTADO_PTA_ENT_ACORAZADA,
			CAST(CIF.BUEN_ESTADO_PTA_PASO_MACIZA AS NUMBER(1,0)) AS BUEN_ESTADO_PTA_PASO_MACIZA,
			CAST(CIF.BUEN_ESTADO_PTA_PASO_HUECA AS NUMBER(1,0)) AS BUEN_ESTADO_PTA_PASO_HUECA,
			CAST(CIF.BUEN_ESTADO_PTA_PASO_LACADA AS NUMBER(1,0)) AS BUEN_ESTADO_PTA_PASO_LACADA,
			CAST(CIF.EXISTEN_ARMARIOS_EMPOTRADOS AS NUMBER(1,0)) AS EXISTEN_ARMARIOS_EMPOTRADOS,
			CAST(CIF.COD_ACABADO_CARPINTERIA AS VARCHAR2(5 CHAR)) AS COD_ACABADO_CARPINTERIA,
			CAST(CIF.OTROS_CARPINTERIA_INTERIOR AS VARCHAR2(250 CHAR))  AS OTROS_CARPINTERIA_INTERIOR,	
			CAST(CIF.BUEN_ESTADO_VENTANA_HIERRO AS NUMBER(1,0)) AS BUEN_ESTADO_VENTANA_HIERRO,
			CAST(CIF.BUEN_ESTADO_VENTANA_ANODIZADO AS NUMBER(1,0)) AS BUEN_ESTADO_VENTANA_ANODIZADO,
			CAST(CIF.BUEN_ESTADO_VENTANA_LACADO AS NUMBER(1,0)) AS BUEN_ESTADO_VENTANA_LACADO,
			CAST(CIF.BUEN_ESTADO_VENTANA_PVC AS NUMBER(1,0)) AS BUEN_ESTADO_VENTANA_PVC,
			CAST(CIF.BUEN_ESTADO_VENTANA_MADERA AS NUMBER(1,0)) AS BUEN_ESTADO_VENTANA_MADERA,
			CAST(CIF.BUEN_ESTADO_PERSIANA_PLASTICO AS NUMBER(1,0))  AS BUEN_ESTADO_PERSIANA_PLASTICO,
			CAST(CIF.BUEN_ESTADO_PERSIANA_ALUMINIO AS NUMBER(1,0)) AS BUEN_ESTADO_PERSIANA_ALUMINIO,
			CAST(CIF.BUEN_ESTADO_VTNAS_CORREDERAS AS NUMBER(1,0)) AS BUEN_ESTADO_VTNAS_CORREDERAS,
			CAST(CIF.BUEN_ESTADO_VTNAS_ABATIBLES AS NUMBER(1,0)) AS BUEN_ESTADO_VTNAS_ABATIBLES,
			CAST(CIF.BUEN_ESTADO_VTNAS_OSCILOBAT AS NUMBER(1,0)) AS BUEN_ESTADO_VTNAS_OSCILOBAT,
			CAST(CIF.BUEN_ESTADO_DOBLE_CRISTAL AS NUMBER(1,0)) AS BUEN_ESTADO_DOBLE_CRISTAL,
			CAST(CIF.OTROS_CARPINTERIA_EXTERIOR AS VARCHAR2(250 CHAR)) AS OTROS_CARPINTERIA_EXTERIOR,		
			CAST(CIF.HUMEDADES_PARED AS NUMBER(1,0)) AS HUMEDADES_PARED,
			CAST(CIF.HUMEDADES_TECHO AS NUMBER(1,0)) AS HUMEDADES_TECHO,
			CAST(CIF.GRIETAS_PARED AS NUMBER(1,0)) AS GRIETAS_PARED,
			CAST(CIF.GRIETAS_TECHO AS NUMBER(1,0)) AS GRIETAS_TECHO,
			CAST(CIF.ESTADO_PINTURA_PAREDES_GOTELE AS NUMBER(1,0)) AS ESTADO_PINTURA_PAREDES_GOTELE,
			CAST(CIF.ESTADO_PINTURA_PAREDES_LISA AS NUMBER(1,0)) AS ESTADO_PINTURA_PAREDES_LISA,
			CAST(CIF.ESTADO_PINTURA_PAREDES_PINTADO AS NUMBER(1,0)) AS ESTADO_PINTURA_PAREDES_PINTADO,
			CAST(CIF.ESTADO_PINTURA_TECHO_GOTELE AS NUMBER(1,0)) AS ESTADO_PINTURA_TECHO_GOTELE,
			CAST(CIF.ESTADO_PINTURA_TECHO_LISA AS NUMBER(1,0)) AS ESTADO_PINTURA_TECHO_LISA,
			CAST(CIF.ESTADO_PINTURA_TECHO_PINTADO AS NUMBER(1,0)) AS ESTADO_PINTURA_TECHO_PINTADO,
			CAST(CIF.ESTADO_MOLDURA_ESCAYOLA AS NUMBER(1,0)) AS ESTADO_MOLDURA_ESCAYOLA,
			CAST(CIF.OTROS_PARAMENTOS_VERTICALES AS VARCHAR2(250 CHAR)) AS OTROS_PARAMENTOS_VERTICALES,
			CAST(CIF.ESTADO_TARIMA_FLOTANTE_SOLADOS AS NUMBER(1,0)) AS ESTADO_TARIMA_FLOTANTE_SOLADOS,
			CAST(CIF.ESTADO_PARQUE_SOLADOS AS NUMBER(1,0)) AS ESTADO_PARQUE_SOLADOS,
			CAST(CIF.ESTADO_MARMOL_SOLADOS AS NUMBER(1,0)) AS ESTADO_MARMOL_SOLADOS,
			CAST(CIF.ESTADO_PLAQUETA_SOLADOS AS NUMBER(1,0)) AS ESTADO_PLAQUETA_SOLADOS,
			CAST(CIF.OTROS_SOLADOS AS VARCHAR2(250 CHAR)) AS OTROS_SOLADOS,	
			CAST(CIF.ESTADO_COCINA_AMUEBLADA_COCINA AS NUMBER(1,0)) AS ESTADO_COCINA_AMUEBLADA_COCINA,
			CAST(CIF.ESTADO_ENCIMERA_GRANITO_COCINA AS NUMBER(1,0)) AS ESTADO_ENCIMERA_GRANITO_COCINA,
			CAST(CIF.ESTADO_ENCIMERA_MARMOL_COCINA AS NUMBER(1,0)) AS ESTADO_ENCIMERA_MARMOL_COCINA,
			CAST(CIF.ESTADO_ENCIMERA_MATERIAL_COC AS NUMBER(1,0)) AS ESTADO_ENCIMERA_MATERIAL_COC,
			CAST(CIF.ESTADO_VITROCERAMICA_COCINA AS NUMBER(1,0)) AS ESTADO_VITROCERAMICA_COCINA,
			CAST(CIF.ESTADO_LABADORA_COCINA AS NUMBER(1,0)) AS ESTADO_LABADORA_COCINA,
			CAST(CIF.ESTADO_FRIGORIFICO_COCINA AS NUMBER(1,0)) AS ESTADO_FRIGORIFICO_COCINA,
			CAST(CIF.ESTADO_LAVAVAJILLAS_COCINA AS NUMBER(1,0)) AS ESTADO_LAVAVAJILLAS_COCINA,
			CAST(CIF.ESTADO_MICROONDAS_COCINA AS NUMBER(1,0)) AS ESTADO_MICROONDAS_COCINA,
			CAST(CIF.ESTADO_HORNO_COCINA AS NUMBER(1,0)) AS ESTADO_HORNO_COCINA,
			CAST(CIF.ESTADO_SUELO_COCINA AS NUMBER(1,0)) AS ESTADO_SUELO_COCINA,
			CAST(CIF.ESTADO_AZULEJOS_COCINA AS NUMBER(1,0)) AS ESTADO_AZULEJOS_COCINA,
			CAST(CIF.ESTADO_GRIFERIA_MONOMANDO_COC AS NUMBER(1,0)) AS ESTADO_GRIFERIA_MONOMANDO_COC,
			CAST(CIF.OTROS_COCINA AS VARCHAR2(250 CHAR)) AS OTROS_COCINA,    		
			CAST(CIF.ESTADO_DUCHA_BNY AS NUMBER(1,0)) AS ESTADO_DUCHA_BNY,
			CAST(CIF.ESTADO_BANYERA_NORMAL_BNY AS NUMBER(1,0)) AS ESTADO_BANYERA_NORMAL_BNY,
			CAST(CIF.ESTADO_BANYERA_HIDROMASAJE_BNY AS NUMBER(1,0)) AS ESTADO_BANYERA_HIDROMASAJE_BNY,
			CAST(CIF.ESTADO_COLUMNA_HIDROMASAJE_BNY AS NUMBER(1,0)) AS ESTADO_COLUMNA_HIDROMASAJE_BNY,
			CAST(CIF.ESTADO_ALICATADO_MARMOL_BNY AS NUMBER(1,0)) AS ESTADO_ALICATADO_MARMOL_BNY,
			CAST(CIF.ESTADO_ALICATADO_GRANITO_BNY AS NUMBER(1,0)) AS ESTADO_ALICATADO_GRANITO_BNY,
			CAST(CIF.ESTADO_ALICATADO_AZULEJO_BNY AS NUMBER(1,0)) AS ESTADO_ALICATADO_AZULEJO_BNY,
			CAST(CIF.ESTADO_ENCIMERA_MARMOL_BNY AS NUMBER(1,0)) AS ESTADO_ENCIMERA_MARMOL_BNY,
			CAST(CIF.ESTADO_ENCIMERA_GRANITO_BNY AS NUMBER(1,0)) AS ESTADO_ENCIMERA_GRANITO_BNY,
			CAST(CIF.ESTADO_ENCIMERA_MATERIAL_BNY AS NUMBER(1,0)) AS ESTADO_ENCIMERA_MATERIAL_BNY,
			CAST(CIF.ESTADO_SANITARIOS_BNY AS NUMBER(1,0)) AS ESTADO_SANITARIOS_BNY,
			CAST(CIF.ESTADO_SUELO_BNY AS NUMBER(1,0)) AS ESTADO_SUELO_BNY,
			CAST(CIF.ESTADO_GRIFERIA_MONOMANDO_BNY AS NUMBER(1,0)) AS ESTADO_GRIFERIA_MONOMANDO_BNY,
			CAST(CIF.OTROS_BANYO AS VARCHAR2(250 CHAR)) AS OTROS_BANYO,
			CAST(CIF.ESTADO_INS_ELECTR AS NUMBER(1,0)) AS ESTADO_INS_ELECTR,
			CAST(CIF.INS_ELECTR_ANTIGUA_DEFECTUOSA AS NUMBER(1,0))	AS INS_ELECTR_ANTIGUA_DEFECTUOSA,
			CAST(CIF.EXISTE_CALEFACCION_GAS_NATURAL AS NUMBER(1,0)) AS EXISTE_CALEFACCION_GAS_NATURAL,
			CAST(CIF.EXISTEN_RADIADORES_DE_ALUMINIO AS NUMBER(1,0)) AS EXISTEN_RADIADORES_DE_ALUMINIO,
			CAST(CIF.EXISTE_AGUA_CALIENTE_CENTRAL AS NUMBER(1,0)) AS EXISTE_AGUA_CALIENTE_CENTRAL,
			CAST(CIF.EXISTE_AGUA_CALIENTE_GAS_NAT AS NUMBER(1,0)) AS EXISTE_AGUA_CALIENTE_GAS_NAT,
			CAST(CIF.EXISTE_AIRE_PREINSTALACION AS NUMBER(1,0)) AS EXISTE_AIRE_PREINSTALACION,
			CAST(CIF.EXISTE_AIRE_INSTALACION AS NUMBER(1,0)) AS EXISTE_AIRE_INSTALACION,
			CAST(CIF.EXISTE_AIRE_CALOR AS NUMBER(1,0)) AS EXISTE_AIRE_CALOR,
			CAST(CIF.OTROS_INSTALACIONES AS VARCHAR2(250 CHAR)) AS OTROS_INSTALACIONES,
			CAST(CIF.EXISTEN_JARDINES_ZONAS_VERDES AS NUMBER(1,0)) AS EXISTEN_JARDINES_ZONAS_VERDES,
			CAST(CIF.EXISTE_PISCINA AS NUMBER(1,0)) AS EXISTE_PISCINA,
			CAST(CIF.EXISTE_PISTA_PADEL AS NUMBER(1,0)) AS EXISTE_PISTA_PADEL,
			CAST(CIF.EXISTE_PISTA_TENIS AS NUMBER(1,0)) AS EXISTE_PISTA_TENIS,
			CAST(CIF.EXISTE_PISTA_POLIDEPORTIVA AS NUMBER(1,0)) AS EXISTE_PISTA_POLIDEPORTIVA,
			CAST(CIF.EXISTE_GIMNASIO AS NUMBER(1,0)) AS EXISTE_GIMNASIO,
			CAST(CIF.OTROS_INSTALACIONES_DEPORTIVAS AS VARCHAR2(250 CHAR)) AS OTROS_INSTALACIONES_DEPORTIVAS,
			CAST(CIF.EXISTE_ZONA_INFANTIL AS NUMBER(1,0)) AS EXISTE_ZONA_INFANTIL,
			CAST(CIF.EXISTE_CONSERJE_VIGILANCIA AS NUMBER(1,0)) AS EXISTE_CONSERJE_VIGILANCIA,
			CAST(CIF.OTROS_ZONAS_COMUNES AS VARCHAR2(250 CHAR)) AS OTROS_ZONAS_COMUNES,			
			CAST(NVL(ACC.FECHA_ACCION, 
				TO_CHAR((SELECT SYSDATE FROM DUAL),''YYYY-MM-DD"T"HH24:MM:SS'')) AS VARCHAR2(50 CHAR)) AS FECHA_ACCION,      
			CAST(NVL(ACC.ID_USUARIO_REM_ACCION, 
		    	(SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		    	WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER(16,0)) AS ID_USUARIO_REM_ACCION
			FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
			LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID and act.borrado = 0
			LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BREG ON BREG.BIE_DREG_ID = REG.BIE_DREG_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ADM ON ADM.ACT_ID = ACT.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV ON VIV.ICO_ID = ICO.ICO_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS ON DIS.ICO_ID = ICO.ICO_ID 		 
			LEFT JOIN '||V_ESQUEMA||'.VI_PIVOT_DISTRIBUCION PIV ON PIV.ICO_ID = ICO.ICO_ID 
			LEFT JOIN '||V_ESQUEMA||'.ACT_LCO_LOCAL_COMERCIAL LCO ON LCO.ICO_ID = ICO.ICO_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_APR_PLAZA_APARCAMIENTO APR ON APR.ICO_ID = ICO.ICO_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_AVI_ACTIVOS_VINCULADOS AVI ON AVI.ACT_ID_ORIGEN = ACT.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT2 ON ACT2.ACT_ID = AVI.ACT_ID_VINCULADO
			LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = ICO.ICO_MEDIADOR_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID = DIS.DD_TPH_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_ORIENTACION DDTPO ON DDTPO.DD_TPO_ID = VIV.DD_TPO_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD DDTGP ON DDTGP.DD_TGP_ID = PAC.DD_TGP_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_RENTA DDTPR ON DDTPR.DD_TPR_ID = VIV.DD_TPR_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TVP_TIPO_VPO DDTVP ON DDTVP.DD_TVP_ID = ICO.DD_TVP_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = ICO.DD_TVI_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = ICO.DD_UPO_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = ICO.DD_PRV_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = ICO.DD_LOC_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC2 ON DDLOC2.DD_LOC_ID = BREG.DD_LOC_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO DDTPA ON DDTPA.DD_TPA_ID = ICO.DD_TPA_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO DDSAC ON DDSAC.DD_SAC_ID = ICO.DD_SAC_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TPV_TIPO_VIVIENDA DDTPV ON DDTPV.DD_TPV_ID = VIV.DD_TPV_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_UAC_UBICACION_ACTIVO DDUAC ON DDUAC.DD_UAC_ID = ICO.DD_UAC_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_DIS_DISTRITO DDDIS ON DDDIS.DD_DIS_ID = ICO.DD_DIS_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TPV_TIPO_VARIO DDTPVA ON DDTPVA.DD_TPV_ID = APR.DD_TPV_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_SPG_SUBTIPO_PLAZA_GARAJE DDSPG ON DDSPG.DD_SPG_ID = APR.DD_SPG_ID
			LEFT JOIN '||V_ESQUEMA||'.DD_TCA_TIPO_CALIDAD DDTCA ON DDTCA.DD_TCA_ID = APR.DD_TCA_ID
			LEFT JOIN '||V_ESQUEMA||'.VI_CALIDADES_INFORME CIF ON CIF.ICO_ID = ICO.ICO_ID
			LEFT JOIN '||V_ESQUEMA||'.V_PIVOT_PRECIOS_ACTIVOS VAL ON VAL.ACT_ID = ACT.ACT_ID
			LEFT JOIN '||V_ESQUEMA||'.VI_ESTADO_ACTUAL_INFMED ESI ON ESI.ICO_ID = ICO.ICO_ID		
			LEFT JOIN REFERENCIA_CATASTRAL CAT ON CAT.ACT_ID = ACT.ACT_ID
			LEFT JOIN ACCION ACC ON ACC.ICO_ID = ICO.ICO_ID
			WHERE ICO.ICO_WEBCOM_ID IS NOT NULL';

			


   
   	 	
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

 		
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_INFORME_COMERCIAL) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_INFORME_COMERCIAL) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_INFORME_COMERCIAL) USING INDEX)';
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
