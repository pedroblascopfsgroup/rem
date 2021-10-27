--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20211027
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16054
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de las ofertas enviadas a webcom
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Modificación IMPORTE_CONTRAOFERTA
--##		0.3 Añadir campos FECHA_VENTA, FECHA_RESERVA y FECHA_ALQUILER
--##		0.4 Añadir campo IMPORTE - Carlos Santos Vílchez - REMVIP-10152
--##		0.5 Añadir campos HAYA HOME - Alejandro Valverde - HREOS-14860
--##		0.6 Añadir campos HAYA HOME - Juan Jose Sanjuan - HREOS-15266
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_OFERTAS_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'OWH_OFERTAS_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de las ofertas enviadas a webcom.'; -- Vble. para los comentarios de las tablas

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
		CAST(  NVL(LPAD(OFR.OFR_ID,16,0) , ''0'')   
				|| NVL(LPAD(ACT.ACT_ID,16,0) , ''0'') 											AS NUMBER(32,0)) AS ID_OFERTA_PK,
		CAST(OFR.OFR_WEBCOM_ID AS NUMBER(16,0)) 												AS ID_OFERTA_WEBCOM,
		CAST(OFR.OFR_HAYA_HOME_ID AS NUMBER(16,0)) 												AS ID_OFERTA_HAYA_HOME,
		CAST(OFR.OFR_SALESFORCE_COD AS VARCHAR2(250 CHAR)) 										AS COD_OFERTA_SALESFORCE,
		CAST(DDSOR.DD_SOR_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ENTIDAD_ORIGEN,
		CAST(OFR.OFR_NUM_OFERTA AS NUMBER(16,0)) 												AS ID_OFERTA_REM,
 		CAST(ACT.ACT_NUM_ACTIVO AS NUMBER(16,0)) 												AS ID_ACTIVO_HAYA,  
		CAST(DDEOF.DD_EOF_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ESTADO_OFERTA,
		CAST(DDEEC.DD_EEC_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ESTADO_EXPEDIENTE,
		CAST(DDSEC.DD_SEC_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_SUBESTADO_EXPEDIENTE,
		CASE WHEN (DDEEC.DD_EEC_CODIGO = ''08'')
		      THEN CAST(''1'' AS NUMBER(1,0))
		      ELSE CAST(''0'' AS NUMBER(1,0))
	    END VENDIDO, 
		CAST(TO_CHAR(NVL(OFR.FECHAMODIFICAR, OFR.FECHACREAR), 
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 						AS FECHA_ACCION,
 		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = NVL(OFR.USUARIOMODIFICAR, OFR.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 					AS ID_USUARIO_REM_ACCION,
		CAST(AGR.AGR_NUM_AGRUP_REM AS NUMBER(16,0)) 											AS ID_AGRUPACION_REM,
        MRO.DD_MRO_DESCRIPCION AS MOTIVO_RECHAZO,
		OFR.OFR_IMPORTE_CONTRAOFERTA															AS IMPORTE_CONTRAOFERTA,
	    CASE WHEN (DD_TOF.DD_TOF_CODIGO = ''02'')
		      THEN CAST(ECO.ECO_NUM_EXPEDIENTE AS NUMBER(16,0))
		      ELSE NULL
	    END 																					AS ID_EXPEDIENTE_REM,
		CASE WHEN (ECO.ECO_FECHA_VENTA IS NOT NULL AND DDEEC.DD_EEC_CODIGO = ''08'') 
			THEN CAST(TO_CHAR(ECO.ECO_FECHA_VENTA ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS FECHA_VENTA,
  		CASE WHEN (RES.RES_FECHA_FIRMA IS NOT NULL) 
			THEN CAST(TO_CHAR(RES.RES_FECHA_FIRMA ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS FECHA_RESERVA,        
        CASE WHEN (ECO.ECO_FECHA_INICIO_ALQUILER IS NOT NULL AND DDEEC.DD_EEC_CODIGO = ''03'') 
			THEN CAST(TO_CHAR(ECO.ECO_FECHA_INICIO_ALQUILER ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS FECHA_ALQUILER,
		CAST(OFR.OFR_IMPORTE AS NUMBER(16,2))													AS IMPORTE, 
		CAST(OFR.OFR_ORIGEN AS VARCHAR2(5 CHAR))											AS COD_ORIGEN_OFERTA,
		CAST(OFR.OFR_MESES_CARENCIA AS NUMBER(16,2))											AS MESES_CARENCIA,
		CAST(OFR.OFR_CONTRATO_RESERVA AS NUMBER(1,0))											AS TIENE_CONTRATO_RESERVA,
		CAST(OFR.OFR_MOTIVO_CONGELACION AS VARCHAR2(250 CHAR))									AS MOTIVO_CONGELACION,
		CAST(OFR.OFR_IBI AS NUMBER(1,0))														AS TIENE_IBI,
		CAST(OFR.OFR_IMPORTE_IBI AS NUMBER(16,2))												AS IMPORTE_IBI,
		CAST(OFR.OFR_OTRAS_TASAS AS NUMBER(1,0))												AS TIENE_OTRAS_TASAS,
		CAST(OFR.OFR_IMPORTE_OTRAS_TASAS AS NUMBER(16,2))										AS IMPORTE_OTRAS_TASAS,
		CAST(OFR.OFR_CCPP AS NUMBER(1,0))														AS TIENE_CCPP,
		CAST(OFR.OFR_IMPORTE_CCPP AS NUMBER(16,2))												AS IMPORTE_CCPP,
		CAST(OFR.OFR_PORCENTAJE_1_ANYO AS NUMBER(16,2))											AS BONIFICACION_ANYO_1,
		CAST(OFR.OFR_PORCENTAJE_2_ANYO AS NUMBER(16,2))											AS BONIFICACION_ANYO_2,
		CAST(OFR.OFR_PORCENTAJE_3_ANYO AS NUMBER(16,2))											AS BONIFICACION_ANYO_3,
		CAST(OFR.OFR_PORCENTAJE_4_ANYO AS NUMBER(16,2))											AS BONIFICACION_ANYO_4,
		CAST(OFR.OFR_MESES_CARENCIA_CTRAOFR AS NUMBER(16,2))									AS MESES_CARENCIA_CTRAOFR,
		CAST(OFR.OFR_PORCENTAJE_1_ANYO_CTRAOFR AS NUMBER(16,2))									AS BONIFICACION_ANYO_1_CONTRAOFERTA,
		CAST(OFR.OFR_PORCENTAJE_2_ANYO_CTRAOFR AS NUMBER(16,2))									AS BONIFICACION_ANYO_2_CONTRAOFERTA,
		CAST(OFR.OFR_PORCENTAJE_3_ANYO_CTRAOFR AS NUMBER(16,2))									AS BONIFICACION_ANYO_3_CONTRAOFERTA,
		CAST(OFR.OFR_PORCENTAJE_4_ANYO_CTRAOFR AS NUMBER(16,2))									AS BONIFICACION_ANYO_4_CONTRAOFERTA

		FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
		LEFT JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = OFR.AGR_ID
		INNER JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DDEEC ON DDEEC.DD_EEC_ID = ECO.DD_EEC_ID 
		LEFT JOIN '||V_ESQUEMA||'.DD_SEC_SUBEST_EXP_COMERCIAL DDSEC ON DDSEC.DD_SEC_ID = ECO.DD_SEC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA DDEOF ON DDEOF.DD_EOF_ID = OFR.DD_EOF_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_MRO_MOTIVO_RECHAZO_OFERTA MRO ON MRO.DD_MRO_ID = OFR.DD_MRO_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA DD_TOF ON DD_TOF.DD_TOF_ID = OFR.DD_TOF_ID
		LEFT JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID AND RES.BORRADO = 0 AND DDEEC.DD_EEC_CODIGO = ''06''
		LEFT JOIN '||V_ESQUEMA||'.DD_SOR_SISTEMA_ORIGEN DDSOR ON OFR.OFR_ORIGEN = DDSOR.DD_SOR_ID

		WHERE OFR.AGR_ID IS NULL AND (OFR.OFR_WEBCOM_ID IS NOT NULL OR OFR.OFR_HAYA_HOME_ID IS NOT NULL OR OFR.OFR_ORIGEN = (SELECT DD_SOR_ID FROM '||V_ESQUEMA||'.DD_SOR_SISTEMA_ORIGEN WHERE DD_SOR_CODIGO = ''03'')) and act.borrado = 0

		UNION ALL

		SELECT 
		CAST(  NVL(LPAD(OFR.OFR_ID,16,0) , ''0'')   
				|| NVL(LPAD(ACT2.ACT_ID,16,0) , ''0'') 											AS NUMBER(32,0)) AS ID_OFERTA_PK,
		CAST(OFR.OFR_WEBCOM_ID AS NUMBER(16,0)) 												AS ID_OFERTA_WEBCOM,
		CAST(OFR.OFR_HAYA_HOME_ID AS NUMBER(16,0)) 												AS ID_OFERTA_HAYA_HOME,
		CAST(OFR.OFR_SALESFORCE_COD AS VARCHAR2(250 CHAR)) 										AS COD_OFERTA_SALESFORCE,
		CAST(DDSOR.DD_SOR_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ENTIDAD_ORIGEN,
		CAST(OFR.OFR_NUM_OFERTA AS NUMBER(16,0)) 												AS ID_OFERTA_REM,
	    CASE WHEN (ACT_PRINCIPAL.ACT_NUM_ACTIVO IS NULL)
		      THEN CAST(ACT2.ACT_NUM_ACTIVO AS NUMBER(16,0))
		      ELSE CAST(ACT_PRINCIPAL.ACT_NUM_ACTIVO AS NUMBER(16,0))
  		END ID_ACTIVO_HAYA,  
		CAST(DDEOF.DD_EOF_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ESTADO_OFERTA,
		CAST(DDEEC.DD_EEC_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_ESTADO_EXPEDIENTE,
		CAST(DDSEC.DD_SEC_CODIGO AS VARCHAR2(5 CHAR)) 											AS COD_SUBESTADO_EXPEDIENTE,
		CASE WHEN (DDEEC.DD_EEC_CODIGO = ''08'')
		      THEN CAST(''1'' AS NUMBER(1,0))
		      ELSE CAST(''0'' AS NUMBER(1,0))
	    END VENDIDO, 
		CAST(TO_CHAR(NVL(OFR.FECHAMODIFICAR, OFR.FECHACREAR), 
					''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 						AS FECHA_ACCION,
 		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = NVL(OFR.USUARIOMODIFICAR, OFR.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 					AS ID_USUARIO_REM_ACCION,
		CAST(AGR.AGR_NUM_AGRUP_REM AS NUMBER(16,0)) 												AS ID_AGRUPACION_REM,
		MRO.DD_MRO_DESCRIPCION AS MOTIVO_RECHAZO,
		OFR.OFR_IMPORTE_CONTRAOFERTA 															AS IMPORTE_CONTRAOFERTA, 
	    CASE WHEN (DD_TOF.DD_TOF_CODIGO = ''02'')
		      THEN CAST(ECO.ECO_NUM_EXPEDIENTE AS NUMBER(16,0))
		      ELSE NULL
	    END 																					AS ID_EXPEDIENTE_REM,
		CASE WHEN (ECO.ECO_FECHA_VENTA IS NOT NULL AND DDEEC.DD_EEC_CODIGO = ''08'') 
			THEN CAST(TO_CHAR(ECO.ECO_FECHA_VENTA ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS FECHA_VENTA,
  		CASE WHEN (RES.RES_FECHA_FIRMA IS NOT NULL) 
			THEN CAST(TO_CHAR(RES.RES_FECHA_FIRMA ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																				AS FECHA_RESERVA,        
        CASE WHEN (ECO.ECO_FECHA_INICIO_ALQUILER IS NOT NULL AND DDEEC.DD_EEC_CODIGO = ''03'') 
			THEN CAST(TO_CHAR(ECO.ECO_FECHA_INICIO_ALQUILER ,
				''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		ELSE NULL
		END 																					AS FECHA_ALQUILER,
		CAST(OFR.OFR_IMPORTE AS NUMBER(16,2))													AS IMPORTE,
		CAST(OFR.OFR_ORIGEN AS VARCHAR2(5 CHAR))											    AS COD_ORIGEN_OFERTA,
		CAST(OFR.OFR_MESES_CARENCIA AS NUMBER(16,2))											AS MESES_CARENCIA,
		CAST(OFR.OFR_CONTRATO_RESERVA AS NUMBER(1,0))											AS TIENE_CONTRATO_RESERVA,
		CAST(OFR.OFR_MOTIVO_CONGELACION AS VARCHAR2(250 CHAR))									AS MOTIVO_CONGELACION,
		CAST(OFR.OFR_IBI AS NUMBER(1,0))														AS TIENE_IBI,
		CAST(OFR.OFR_IMPORTE_IBI AS NUMBER(16,2))												AS IMPORTE_IBI,
		CAST(OFR.OFR_OTRAS_TASAS AS NUMBER(1,0))												AS TIENE_OTRAS_TASAS,
		CAST(OFR.OFR_IMPORTE_OTRAS_TASAS AS NUMBER(16,2))										AS IMPORTE_OTRAS_TASAS,
		CAST(OFR.OFR_CCPP AS NUMBER(1,0))														AS TIENE_CCPP,
		CAST(OFR.OFR_IMPORTE_CCPP AS NUMBER(16,2))												AS IMPORTE_CCPP,
		CAST(OFR.OFR_PORCENTAJE_1_ANYO AS NUMBER(16,2))											AS BONIFICACION_ANYO_1,
		CAST(OFR.OFR_PORCENTAJE_2_ANYO AS NUMBER(16,2))											AS BONIFICACION_ANYO_2,
		CAST(OFR.OFR_PORCENTAJE_3_ANYO AS NUMBER(16,2))											AS BONIFICACION_ANYO_3,
		CAST(OFR.OFR_PORCENTAJE_4_ANYO AS NUMBER(16,2))											AS BONIFICACION_ANYO_4,
		CAST(OFR.OFR_MESES_CARENCIA_CTRAOFR AS NUMBER(16,2))									AS MESES_CARENCIA_CTRAOFR,
		CAST(OFR.OFR_PORCENTAJE_1_ANYO_CTRAOFR AS NUMBER(16,2))									AS BONIFICACION_ANYO_1_CONTRAOFERTA,
		CAST(OFR.OFR_PORCENTAJE_2_ANYO_CTRAOFR AS NUMBER(16,2))									AS BONIFICACION_ANYO_2_CONTRAOFERTA,
		CAST(OFR.OFR_PORCENTAJE_3_ANYO_CTRAOFR AS NUMBER(16,2))									AS BONIFICACION_ANYO_3_CONTRAOFERTA,
		CAST(OFR.OFR_PORCENTAJE_4_ANYO_CTRAOFR AS NUMBER(16,2))									AS BONIFICACION_ANYO_4_CONTRAOFERTA

		FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
		INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = OFR.AGR_ID
		INNER JOIN ( SELECT  OFR_ID,ACT_ID FROM (SELECT OFR_ID,ACT_ID, ROW_NUMBER() OVER (PARTITION BY OFR_ID ORDER BY ACT_ID) AS NUMFILA FROM '||V_ESQUEMA||'.ACT_OFR) WHERE NUMFILA = 1 ) AO ON AO.OFR_ID = OFR.OFR_ID
        LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT_PRINCIPAL ON ACT_PRINCIPAL.ACT_ID = AGR.AGR_ACT_PRINCIPAL
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT2 ON ACT2.ACT_ID = AO.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
		LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DDEEC ON DDEEC.DD_EEC_ID = ECO.DD_EEC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SEC_SUBEST_EXP_COMERCIAL DDSEC ON DDSEC.DD_SEC_ID = ECO.DD_SEC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA DDEOF ON DDEOF.DD_EOF_ID = OFR.DD_EOF_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_MRO_MOTIVO_RECHAZO_OFERTA MRO ON MRO.DD_MRO_ID = OFR.DD_MRO_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA DD_TOF ON DD_TOF.DD_TOF_ID = OFR.DD_TOF_ID
		LEFT JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID AND RES.BORRADO = 0 AND DDEEC.DD_EEC_CODIGO = ''06''
		LEFT JOIN '||V_ESQUEMA||'.DD_SOR_SISTEMA_ORIGEN DDSOR ON OFR.OFR_ORIGEN = DDSOR.DD_SOR_ID

		WHERE OFR.AGR_ID IS NOT NULL AND (OFR.OFR_WEBCOM_ID IS NOT NULL OR OFR.OFR_HAYA_HOME_ID IS NOT NULL OR OFR.OFR_ORIGEN = (SELECT DD_SOR_ID FROM '||V_ESQUEMA||'.DD_SOR_SISTEMA_ORIGEN WHERE DD_SOR_CODIGO = ''03'')) and act2.borrado = 0 AND (TAG.DD_TAG_CODIGO = ''02'' OR TAG.DD_TAG_CODIGO = ''14'')';

		
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

 		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_OFERTA_PK) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT VISTA.* FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||' VISTA)';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_OFERTA_PK) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_OFERTA_PK) USING INDEX)';
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
