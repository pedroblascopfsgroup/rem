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

		WITH SUBDIVISIONES AS (
			SELECT VSUB.ACT_ID, VSUB.ID, AGR.AGR_NUM_AGRUP_REM 
			FROM '||V_ESQUEMA||'.V_ACTIVOS_SUBDIVISION VSUB 
			INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON VSUB.AGR_ID = AGR.AGR_ID AND AGR.DD_TAG_ID= 1
		),
		VALORES_PRECIOS AS (			
			SELECT * FROM (
			SELECT VAL.ACT_ID, VAL.DD_TPC_ID, DD.DD_TPC_CODIGO, VAL.VAL_IMPORTE, VAL.VAL_FECHA_INICIO, VAL.VAL_FECHA_FIN,
			ROW_NUMBER() OVER (PARTITION BY VAL.ACT_ID, VAL.DD_TPC_ID ORDER BY VAL.VAL_FECHA_INICIO DESC) ORDEN
			FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
			LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO DD ON DD.DD_TPC_ID = VAL.DD_TPC_ID )
			WHERE ORDEN = 1
		),
		REFERENCIA_CATASTRAL AS (
			SELECT * FROM (
			SELECT CAT.ACT_ID, CAT.CAT_REF_CATASTRAL,
			ROW_NUMBER() OVER (PARTITION BY CAT.ACT_ID ORDER BY CAT.CAT_ID DESC) REF
			FROM '||V_ESQUEMA||'.ACT_CAT_CATASTRO CAT)
			WHERE REF = 1
		),
		VALORES_PRECIOS_ANT AS (
			SELECT * FROM (
			SELECT HVAL.ACT_ID, HVAL.HVA_IMPORTE, HVAL.HVA_FECHA_INICIO, HVAL.HVA_FECHA_FIN, DD.DD_TPC_CODIGO,
			ROW_NUMBER() OVER (PARTITION BY HVAL.ACT_ID, HVAL.DD_TPC_ID ORDER BY HVAL.HVA_FECHA_FIN DESC) ORDEN
			FROM '||V_ESQUEMA||'.ACT_HVA_HIST_VALORACIONES HVAL
			LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO DD ON DD.DD_TPC_ID = HVAL.DD_TPC_ID AND DD.DD_TPC_CODIGO = ''02'')
			WHERE ORDEN = 1
		),
		GESTOR_COMERCIAL AS (
			SELECT GEE.USU_ID, GAC.ACT_ID 
			FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC 
			JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID 
			JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON (GEE.DD_TGE_ID = TGE.DD_TGE_ID AND DD_TGE_CODIGO = ''GCOM'')
		),
	    PUBLICADO_DESDE AS (
	        SELECT * FROM (
	        SELECT HEP.HEP_FECHA_DESDE, HEP.ACT_ID,
	        ROW_NUMBER() OVER (PARTITION BY HEP.ACT_ID, HEP.HEP_FECHA_HASTA ORDER BY HEP.HEP_FECHA_DESDE DESC) ORDEN
	        FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP 
	        WHERE HEP.HEP_FECHA_HASTA IS NULL)
	        WHERE ORDEN = 1
		)
		SELECT 
		CAST(ACT.ACT_NUM_ACTIVO AS NUMBER(16,0)) 											AS ID_ACTIVO_HAYA,
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
		CAST(VAL1.VAL_IMPORTE AS NUMBER(16,2)) 												AS ACTUAL_IMPORTE,
		CAST(VANT.HVA_IMPORTE AS NUMBER(16,2)) 												AS ANTERIOR_IMPORTE,
		CASE WHEN (VAL1.VAL_FECHA_INICIO IS NOT NULL) 
			THEN CAST(TO_CHAR(VAL1.VAL_FECHA_INICIO ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
			ELSE NULL
		END 																				AS DESDE_IMPORTE,		 
		CASE WHEN (VAL1.VAL_FECHA_FIN IS NOT NULL) 
			THEN CAST(TO_CHAR(VAL1.VAL_FECHA_FIN ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS HASTA_IMPORTE,
		CAST(DDTPA.DD_TPA_CODIGO AS VARCHAR2(5 CHAR))										AS COD_TIPO_INMUEBLE,
		CAST(DDSAC.DD_SAC_CODIGO AS VARCHAR2(5 CHAR))										AS COD_SUBTIPO_INMUEBLE,
		CAST(BREG.BIE_DREG_NUM_FINCA AS VARCHAR2(14 CHAR))									AS FINCA_REGISTRAL,
		CAST(DDBRLOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR)) 									AS COD_MUNICIPIO_REGISTRO,
		CAST(BREG.BIE_DREG_NUM_REGISTRO AS VARCHAR2(14 CHAR))								AS REGISTRO,
		CAST(CAT.CAT_REF_CATASTRAL AS VARCHAR2(20 CHAR)) 									AS REFERENCIA_CATASTRAL,
		CAST(REG.REG_SUPERFICIE_UTIL AS NUMBER(9,2))   										AS SUPERFICIE,
		CAST(BREG.BIE_DREG_SUPERFICIE_CONSTRUIDA AS NUMBER(9,2))  							AS SUPERFICIE_CONSTRUIDA,
		CAST(BREG.BIE_DREG_SUPERFICIE AS NUMBER(9,2))  										AS SUPERFICIE_REGISTRAL,
		CAST(EDI.EDI_ASCENSOR AS NUMBER(1,0))   											AS ASCENSOR,
		CAST(VPD.DORMITORIOS AS NUMBER(5,0))  												AS DORMITORIOS,
		CAST(VPD.BANYOS AS NUMBER(5,0)) 													AS BANYOS,
		CAST(VPD.ASEOS AS NUMBER(5,0)) 														AS ASEOS,
		CAST(VPD.GARAJES AS NUMBER(5,0))													AS GARAJES,
		CASE DDEAC.DD_EAC_CODIGO
			WHEN ''03'' THEN CAST(''1'' AS NUMBER(1,0))
			WHEN ''04'' THEN CAST(''1'' AS NUMBER(1,0))
			ELSE CAST(''0'' AS NUMBER(1,0)) 
		END 																				AS NUEVO,
		CAST(DDSCM.DD_SCM_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_ESTADO_COMERCIAL,
		CAST(DDTCO.DD_TCO_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_TIPO_VENTA,
		CAST(LOC.LOC_LATITUD AS NUMBER(21,15)) 												AS LAT,
		CAST(LOC.LOC_LONGITUD AS NUMBER(21,15)) 											AS LNG,
		CAST(DDECT.DD_ECT_CODIGO AS VARCHAR2(5 CHAR))										AS COD_ESTADO_CONSTRUCCION,
		CAST(NVL(VPD.TERRAZAS_CUBIERTAS, 0) + NVL(VPD.TERRAZAS_DESCUBIERTAS, 0) AS NUMBER(5,0)) 	AS TERRAZAS,
		CAST(DDEPU.DD_EPU_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_ESTADO_PUBLICACION,	
    	CASE WHEN (PUB.HEP_FECHA_DESDE IS NOT NULL) 
			THEN CAST(TO_CHAR(PUB.HEP_FECHA_DESDE ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS PUBLICADO_DESDE,
		CASE WHEN (VIV.VIV_REFORMA_CARP_INT =1 OR VIV.VIV_REFORMA_CARP_EXT = 1 
				OR VIV.VIV_REFORMA_COCINA =1 OR VIV.VIV_REFORMA_BANYO =1 
				OR VIV.VIV_REFORMA_SUELO=1 OR VIV.VIV_REFORMA_PINTURA=1 
				OR VIV.VIV_REFORMA_INTEGRAL=1 OR VIV.VIV_REFORMA_OTRO=1) 
			THEN CAST( 1 AS NUMBER(1,0))
		    ELSE CAST(0 AS NUMBER(1,0)) 
		END 																				AS REFORMAS,
		CAST(VPO.DD_TVP_CODIGO AS VARCHAR2(5 CHAR)) 										AS COD_REGIMEN_PROTECCION,
		CAST(ICO.ICO_INFO_DESCRIPCION AS VARCHAR2(500 CHAR))								AS DESCRIPCION,
		CAST(ICO.ICO_INFO_DISTRIBUCION_INTERIOR AS VARCHAR2(500 CHAR))						AS DISTRIBUCION,
		CAST(ICO.ICO_CONDICIONES_LEGALES AS VARCHAR2(500 CHAR))								AS CONDICIONES_ESPECIFICAS,
		CAST(NULL AS VARCHAR2(5 CHAR))														AS COD_DETALLE_PUBLICACION, 
		CAST(VSUB.AGR_NUM_AGRUP_REM AS NUMBER(16,0))	                                 	AS CODIGO_AGRUPACION_OBRA_NUEVA,
        CAST(VSUB.ID AS NUMBER(16,0))                                 						AS CODIGO_CABECERA_OBRA_NUEVA,
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
  		CAST(TO_CHAR(NVL(ACT.FECHAMODIFICAR, ACT.FECHACREAR), 
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 					AS FECHA_ACCION,
 		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = NVL(ACT.USUARIOMODIFICAR, ACT.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 				AS ID_USUARIO_REM_ACCION
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		LEFT JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BLOC ON BLOC.BIE_LOC_ID = LOC.BIE_LOC_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BREG ON BREG.BIE_DREG_ID = REG.BIE_DREG_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID	
		LEFT JOIN '||V_ESQUEMA||'.VI_PIVOT_DISTRIBUCION VPD ON VPD.ICO_ID = ICO.ICO_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_EDI_EDIFICIO EDI ON EDI.ICO_ID = ICO.ICO_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV ON VIV.ICO_ID = ICO.ICO_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ADM_INF_ADMINISTRATIVA ADM ON ADM.ACT_ID = ACT.ACT_ID	
		LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = BLOC.DD_TVI_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = BLOC.DD_UPO_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = BLOC.DD_PRV_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = BLOC.DD_LOC_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDBRLOC ON DDBRLOC.DD_LOC_ID = BREG.DD_LOC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO DDEAC ON DDEAC.DD_EAC_ID = ACT.DD_EAC_ID
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
		LEFT JOIN GESTOR_COMERCIAL GESTOR_COM ON GESTOR_COM.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = GESTOR_COM.USU_ID
		LEFT JOIN VALORES_PRECIOS VAL1 ON VAL1.ACT_ID = ACT.ACT_ID AND VAL1.DD_TPC_CODIGO = ''02''
		LEFT JOIN VALORES_PRECIOS_ANT VANT ON VANT.ACT_ID = ACT.ACT_ID AND VANT.DD_TPC_CODIGO = ''02''
		LEFT JOIN REFERENCIA_CATASTRAL CAT ON CAT.ACT_ID = ACT.ACT_ID
		LEFT JOIN PUBLICADO_DESDE PUB ON PUB.ACT_ID = ACT.ACT_ID
		LEFT JOIN SUBDIVISIONES VSUB ON VSUB.ACT_ID = ACT.ACT_ID';

		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');
		
		
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_ACTIVO_HAYA) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		
		
		
		
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