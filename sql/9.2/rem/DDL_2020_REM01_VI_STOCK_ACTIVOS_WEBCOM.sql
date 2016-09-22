--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico del stock de activos enviados a webcom
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_STOCK_ACTIVOS_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'SWH_STOCK_ACT_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico del stock de activos enviados a webcom.'; -- Vble. para los comentarios de las tablas

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
		SELECT 
		CAST(ACT.ACT_NUM_ACTIVO AS NUMBER(16,0)) 											AS ID_ACTIVO_HAYA,
		CAST(DDTVI.DD_TVI_CODIGO AS VARCHAR2(20 CHAR)) 										AS COD_TIPO_VIA,
		CAST(BLOC.BIE_LOC_NOMBRE_VIA AS VARCHAR2(100 CHAR)) 								AS NOMBRE_CALLE,
		CAST(BLOC.BIE_LOC_NUMERO_DOMICILIO AS VARCHAR2(100 CHAR)) 							AS NUMERO_CALLE,
		CAST(BLOC.BIE_LOC_ESCALERA AS VARCHAR2(10 CHAR)) 									AS ESCALERA,
		CAST(BLOC.BIE_LOC_PISO AS VARCHAR2(11 CHAR))										AS PLANTA,
		CAST(BLOC.BIE_LOC_PUERTA AS VARCHAR2(17 CHAR))										AS PUERTA,
		CAST(DDBRLOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR))										AS COD_MUNICIPIO, 
		CAST(DDUPO.DD_UPO_CODIGO AS VARCHAR2(5 CHAR))										AS COD_PEDANIA,
		CAST(DDPRV.DD_PRV_CODIGO AS VARCHAR2(5 CHAR))										AS COD_PROVINCIA,
		CAST(BLOC.BIE_LOC_COD_POST AS VARCHAR2(40 CHAR)) 									AS CODIGO_POSTAL,
		CAST((SELECT MAX(VAL.VAL_IMPORTE) FROM 
		'||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL, 
		'||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC 
		WHERE VAL.ACT_ID = ACT.ACT_ID AND TPC.DD_TPC_ID = VAL.DD_TPC_ID 
		AND TPC.DD_TPC_CODIGO = ''02'' AND VAL.VAL_FECHA_FIN IS NULL) AS NUMBER(9,2)) 		AS ACTUAL_IMPORTE,
		CAST((SELECT MAX(VAL.VAL_IMPORTE) FROM 
		'||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL, 
		'||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC 
		WHERE VAL.ACT_ID = ACT.ACT_ID AND TPC.DD_TPC_ID = VAL.DD_TPC_ID 
		AND TPC.DD_TPC_CODIGO = ''02'' AND VAL.VAL_FECHA_FIN IS NOT NULL 
		AND VAL.VAL_FECHA_FIN = (SELECT MAX(VAL2.VAL_FECHA_FIN) FROM 
		'||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL2)) AS NUMBER(9,2))  						AS ANTERIOR_IMPORTE,
		CAST((SELECT CASE 
			WHEN (VAL_FECHA_INICIO IS NOT NULL) 
			THEN TO_CHAR(VAL_FECHA_INICIO,''YYYY-MM-DD'') || 
			''T'' ||TO_CHAR(VAL_FECHA_INICIO,''HH24:MI:SS'')
			ELSE NULL 
			END DESDE_IMPORTE
		FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL, 
		'||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC 
		WHERE VAL.ACT_ID = ACT.ACT_ID AND TPC.DD_TPC_ID = VAL.DD_TPC_ID 
		AND TPC.DD_TPC_CODIGO = ''02'' AND VAL.VAL_FECHA_FIN IS NULL) AS VARCHAR2(50 CHAR))	AS DESDE_IMPORTE,
		CAST((SELECT CASE 
			WHEN (VAL_FECHA_FIN IS NOT NULL) 
			THEN TO_CHAR(VAL_FECHA_FIN,''YYYY-MM-DD'') || 
			''T'' ||TO_CHAR(VAL_FECHA_FIN,''HH24:MI:SS'')
			ELSE NULL 
			END HASTA_IMPORTE
		FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL, 
		'||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC 
		WHERE VAL.ACT_ID = ACT.ACT_ID AND TPC.DD_TPC_ID = VAL.DD_TPC_ID 
		AND TPC.DD_TPC_CODIGO = ''02'' AND VAL.VAL_FECHA_FIN IS NULL) AS VARCHAR2(50 CHAR))	AS HASTA_IMPORTE,
		CAST(DDTPA.DD_TPA_CODIGO AS VARCHAR2(5 CHAR))										AS COD_TIPO_INMUEBLE,
		CAST(DDSAC.DD_SAC_CODIGO AS VARCHAR2(5 CHAR))										AS COD_SUBTIPO_INMUEBLE,
		CAST(BREG.BIE_DREG_NUM_FINCA AS VARCHAR2(14 CHAR))									AS FINCA_REGISTRAL,
		CAST(DDBRLOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR)) 									AS COD_MUNICIPIO_REGISTRO,
		CAST(BREG.BIE_DREG_NUM_REGISTRO AS VARCHAR2(14 CHAR))								AS REGISTRO,
		CAST((SELECT MAX(CAT.CAT_REF_CATASTRAL) FROM 
		'||V_ESQUEMA||'.ACT_CAT_CATASTRO CAT 
		WHERE CAT.ACT_ID = ACT.ACT_ID) AS VARCHAR2(20 CHAR)) 								AS REFERENCIA_CATASTRAL,
		CAST(REG.REG_SUPERFICIE_UTIL AS NUMBER(9,2))   										AS SUPERFICIE,
		CAST(BREG.BIE_DREG_SUPERFICIE AS NUMBER(9,2))  										AS SUPERFICIE_REGISTRAL,
		CAST(EDI.EDI_ASCENSOR AS NUMBER(1,0))   											AS ASCENSOR,
		CAST((SELECT SUM(DIS.DIS_CANTIDAD) FROM 
		'||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS, 
		'||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH 
		WHERE  DIS.DD_TPH_ID = TPH.DD_TPH_ID 
		AND ICO.ICO_ID = DIS.ICO_ID AND TPH.DD_TPH_CODIGO = ''01'') AS NUMBER(5,0))  		AS DORMITORIOS,
		CAST((SELECT SUM(DIS.DIS_CANTIDAD) FROM 
		'||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS, 
		'||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH
		WHERE  DIS.DD_TPH_ID = TPH.DD_TPH_ID 
		AND ICO.ICO_ID = DIS.ICO_ID AND TPH.DD_TPH_CODIGO = ''02'') AS NUMBER(5,0)) 		AS BANYOS,
		CAST((SELECT SUM(DIS.DIS_CANTIDAD) FROM 
		'||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS, 
		'||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH
		WHERE  DIS.DD_TPH_ID = TPH.DD_TPH_ID 
		AND ICO.ICO_ID = DIS.ICO_ID AND TPH.DD_TPH_CODIGO = ''04'') AS NUMBER(5,0)) 		AS ASEOS,
		CAST((SELECT SUM(DIS.DIS_CANTIDAD) FROM 
		'||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS, 
		'||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH
		WHERE  DIS.DD_TPH_ID = TPH.DD_TPH_ID 
		AND ICO.ICO_ID = DIS.ICO_ID AND TPH.DD_TPH_CODIGO = ''12'') AS NUMBER(5,0))			AS GARAJES,
		CAST((SELECT CASE DDEAC.DD_EAC_CODIGO 
			WHEN ''03'' THEN ''1'' 
			WHEN ''04'' THEN ''1'' 
			ELSE ''0'' END NUEVO 
		FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO DDEAC 
		WHERE DDEAC.DD_EAC_ID = ACT.DD_EAC_ID) AS NUMBER(1,0))								AS NUEVO,
		CAST(DDSCM.DD_SCM_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_ESTADO_COMERCIAL,
		CAST(DDTCO.DD_TCO_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_TIPO_VENTA,
		CAST(LOC.LOC_LATITUD AS NUMBER(10,8)) 												AS LAT,
		CAST(LOC.LOC_LONGITUD AS NUMBER(11,8)) 												AS LNG,
		CAST(DDECT.DD_ECT_CODIGO AS VARCHAR2(5 CHAR))										AS COD_ESTADO_CONSTRUCCION,
		CAST((SELECT SUM(DIS.DIS_CANTIDAD) FROM 
		'||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DIS, 
		'||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO TPH
		WHERE  DIS.DD_TPH_ID = TPH.DD_TPH_ID AND ICO.ICO_ID = DIS.ICO_ID 
		AND (TPH.DD_TPH_CODIGO = ''15'' OR TPH.DD_TPH_CODIGO = ''16'')) AS NUMBER(5,0)) 	AS TERRAZAS,
		CAST(DDEPU.DD_EPU_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_ESTADO_PUBLICACION,
		CAST((SELECT CASE
			WHEN (HEP.HEP_FECHA_DESDE IS NOT NULL)
			THEN TO_CHAR(HEP.HEP_FECHA_DESDE,''YYYY-MM-DD'') || 
			''T'' ||TO_CHAR(HEP.HEP_FECHA_DESDE,''HH24:MI:SS'')
			ELSE NULL 
			END PUBLICADO_DESDE
		FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP 
		WHERE HEP.ACT_ID = ACT.ACT_ID AND HEP.HEP_FECHA_HASTA IS NULL) AS VARCHAR2(50 CHAR))AS PUBLICADO_DESDE,
		CAST((SELECT CASE 
			WHEN (VIV.VIV_REFORMA_CARP_INT =1 OR VIV.VIV_REFORMA_CARP_EXT = 1 
				OR VIV.VIV_REFORMA_COCINA =1 OR VIV.VIV_REFORMA_BANYO =1 
				OR VIV.VIV_REFORMA_SUELO=1 OR VIV.VIV_REFORMA_PINTURA=1 
				OR VIV.VIV_REFORMA_INTEGRAL=1 OR VIV.VIV_REFORMA_OTRO=1) 
			THEN 1
		    ELSE 0 END REFORMAS
		FROM '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV 
		WHERE VIV.ICO_ID = ICO.ICO_ID) AS NUMBER(1,0))										AS REFORMAS,
		CAST(VPO.DD_TVP_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_REGIMEN_PROTECCION,
		CAST(ICO.ICO_INFO_DESCRIPCION AS VARCHAR2(500 CHAR))								AS DESCRIPCION,
		CAST(ICO.ICO_INFO_DISTRIBUCION_INTERIOR AS VARCHAR2(500 CHAR))						AS DISTRIBUCION,
		CAST(ICO.ICO_CONDICIONES_LEGALES AS VARCHAR2(500 CHAR))								AS CONDICIONES_ESPECIFICAS,
		CAST(NULL AS VARCHAR2(5 CHAR))														AS COD_DETALLE_PUBLICACION, 
		CAST((SELECT MIN(AGR_NUM_AGRUP_REM) FROM 
		'||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR , 
		'||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA , 
		'||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION DDTAG
		WHERE AGR.AGR_ID = AGA.AGR_ID AND AGR.DD_TAG_ID = DDTAG.DD_TAG_ID 
		AND AGA.ACT_ID = ACT.ACT_ID 
		AND DDTAG.DD_TAG_CODIGO = ''01'') AS VARCHAR2(9 CHAR)) 								AS CODIGO_AGRUPACION_OBRA_NUEVA,
		CAST((SELECT MAX(SDV.SDV_ID) FROM 
		'||V_ESQUEMA||'.ACT_SDV_SUBDIVISION_ACTIVO SDV, 
		'||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR , 
		'||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION DDTAG
		WHERE SDV.SDV_ID = ACT.SDV_ID AND AGR.AGR_ID = SDV.AGR_ID 
		AND AGR.DD_TAG_ID = DDTAG.DD_TAG_ID 
		AND DDTAG.DD_TAG_CODIGO = ''01'') AS VARCHAR2(5 CHAR)) 								AS CODIGO_CABECERA_OBRA_NUEVA,
		CAST((SELECT MAX(ICO_MEDIADOR_ID) FROM 
		'||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI ICM
		WHERE ICM.ACT_ID = ACT.ACT_ID AND ICM.ICM_FECHA_HASTA IS NOT NULL 
		AND ICM.ICM_FECHA_HASTA = (SELECT MAX(ICM2.ICM_FECHA_HASTA) FROM 
		'||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI ICM2)) AS NUMBER(16,0))					AS ID_PROVEEDOR_REM_ANTERIOR,
		CAST(ICO.ICO_MEDIADOR_ID AS NUMBER(16,0))											AS ID_PROVEEDOR_REM,
		CAST(USU.USU_NOMBRE || '' '' || 
		USU.USU_APELLIDO1 || '' '' || 
		USU.USU_APELLIDO2 AS VARCHAR2(60 CHAR))												AS NOMBRE_GESTOR_COMERCIAL, 
		CAST(USU.USU_TELEFONO AS VARCHAR2(14 CHAR))											AS TELEFONO_GESTOR_COMERCIAL, 
		CAST(USU.USU_MAIL AS VARCHAR2(60 CHAR))												AS EMAIL_GESTOR_COMERCIAL,
		CAST((SELECT DDTCE.DD_TCE_CODIGO FROM 
		'||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO, 
		'||V_ESQUEMA||'.DD_TCE_TIPO_CALIF_ENERGETICA DDTCE 
		WHERE ADO.ACT_ID = ACT.ACT_ID AND DDTCE.DD_TCE_ID = ADO.DD_TCE_ID 
		AND ADO.DD_TCE_ID IS NOT NULL
		AND ADO.ADO_FECHA_EMISION = (SELECT MAX(ADO2.ADO_FECHA_EMISION) FROM 
		'||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO2))  AS VARCHAR2(5 CHAR)) 		  	AS COD_CEE,
		CAST(ICO.ICO_ANO_CONSTRUCCION AS VARCHAR2(50 CHAR))									AS ANTIGUEDAD,
		CAST(DDCRA.DD_CRA_CODIGO AS VARCHAR2(14 CHAR)) 										AS COD_CARTERA,
		CAST(DDRTG.DD_RTG_CODIGO AS VARCHAR2(14 CHAR)) 										AS COD_RATIO,
		CASE WHEN (ACT.FECHAMODIFICAR IS NOT NULL) 
			THEN CAST(TO_CHAR(ACT.FECHAMODIFICAR,''YYYY-MM-DD'') || 
				''T'' ||TO_CHAR(ACT.FECHACREAR,''HH24:MI:SS'') AS VARCHAR2(50 CHAR))
			ELSE CAST(TO_CHAR(ACT.FECHACREAR,''YYYY-MM-DD'') || 
				''T'' ||TO_CHAR(ACT.FECHACREAR,''HH24:MI:SS'') AS VARCHAR2(50 CHAR))
		END 																				FECHA_ACCION,
		CASE WHEN (ACT.USUARIOMODIFICAR IS NOT NULL) 
			THEN CAST((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
				WHERE USU.USU_USERNAME = ACT.USUARIOMODIFICAR) AS NUMBER(16,0))
			ELSE CAST((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
				WHERE USU.USU_USERNAME = ACT.USUARIOCREAR) AS NUMBER(16,0))
		END 																			   ID_USUARIO_REM_ACCION
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		LEFT JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BLOC ON BLOC.BIE_LOC_ID = LOC.BIE_LOC_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BREG ON BREG.BIE_DREG_ID = REG.BIE_DREG_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID		
		LEFT JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ADM ON ADM.ACT_ID = ACT.ACT_ID	
		LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = BLOC.DD_TVI_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = BLOC.DD_UPO_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = BLOC.DD_PRV_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDBRLOC ON DDBRLOC.DD_LOC_ID = BREG.DD_LOC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO DDTPA ON DDTPA.DD_TPA_ID = ACT.DD_TPA_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO DDSAC ON DDSAC.DD_SAC_ID = ACT.DD_SAC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL DDSCM ON DDSCM.DD_SCM_ID = ACT.DD_SCM_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = ACT.DD_TCO_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_ECT_ESTADO_CONSTRUCCION DDECT ON DDECT.DD_ECT_ID = ICO.DD_ECT_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION DDEPU ON DDEPU.DD_EPU_ID = ACT.DD_EPU_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TVP_TIPO_VPO VPO ON VPO.DD_TVP_ID = ADM.DD_TVP_ID	
		LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA DDCRA ON DDCRA.DD_CRA_ID = ACT.DD_CRA_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_RTG_RATING_ACTIVO DDRTG ON DDRTG.DD_RTG_ID = ACT.DD_RTG_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_DIS_DISTRITO DDDIS ON DDDIS.DD_DIS_ID = ICO.DD_DIS_ID
		LEFT JOIN (SELECT GEE.USU_ID, GAC.ACT_ID FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
		JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID 
		JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON (GEE.DD_TGE_ID = TGE.DD_TGE_ID AND DD_TGE_CODIGO = ''GCOM'')) GESTOR_COM ON GESTOR_COM.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = GESTOR_COM.USU_ID
		WHERE ACT.USUARIOMODIFICAR IS NOT NULL AND ACT.USUARIOMODIFICAR != ''REST-USER''';

		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

		
		
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