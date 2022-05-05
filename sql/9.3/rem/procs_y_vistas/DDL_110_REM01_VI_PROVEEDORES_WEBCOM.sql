--/*
--##########################################
--## AUTOR=Remus Ovidiu Viorel
--## FECHA_CREACION=20220401
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-8153
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de los proveedores enviadas a webcom.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 SHG- Incluyo oficinas Liberbank (38)
--##        0.3 AMG- Añadir array de código de carteras
--##        0.4 JBH - Optimización Vistas WEBCOM
--##        0.5 AMG- Aumentar capacidad del campo codPedania
--##		0.6 JAC- Añadir campo nuevo ID_PROVEEDOR_REM_ASOCIADO
--##		0.7 IRC [REMVIP-9539] - Modificar orden de domicilio social para coger primero los que tienen telefono 
--##		0.8 VRO [REMVIP-10495] - Modificar para que no duplique delegaciones
--##		0.8 IRC [HREOS-17602] - Nuevos campos gestion APIs
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_PROVEEDOR_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'PWH_PROVEEDOR_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de los proveedores enviadas a webcom.'; -- Vble. para los comentarios de las tablas

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
		WITH DOMICILIO_SOCIAL AS (
            SELECT AUX.* FROM (
                SELECT PRD.PVE_ID, DDTDP.DD_TDP_CODIGO, DDTVI.DD_TVI_CODIGO, PRD.PRD_NOMBRE, PRD.PRD_NUM, PRD.PRD_ESCALERA, PRD.PRD_PLANTA, PRD.PRD_PTA, 
                DDLOC.DD_LOC_CODIGO,DDUPO.DD_UPO_CODIGO, DDPRV.DD_PRV_CODIGO, PRD.PRD_CP, PRD.PRD_TELEFONO, PRD.PRD_TELEFONO2, PRD.PRD_EMAIL, PRD.FECHAMODIFICAR, 
                PRD.FECHACREAR, PRD.USUARIOMODIFICAR, CNT.CLAVE_CENTRO AS DD, CSP.CLAVE_CENTRO AS DZ, CSP.CLAVE_CENTRO_SUPERIOR AS DT,
                    ROW_NUMBER() OVER (PARTITION BY PRD.PVE_ID ORDER BY CASE WHEN prd.PRD_TELEFONO IS NULL THEN 1 ELSE 0 END, PRD.PRD_ID DESC) ORDEN
                FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD
                LEFT JOIN '||V_ESQUEMA||'.ACT_CNT_CENTROS CNT ON CNT.CLAVE_CENTRO = PRD.PRD_REFERENCIA
                LEFT JOIN '||V_ESQUEMA||'.ACT_CNS_CENTROS_SUPERIOR CSP ON CSP.CLAVE_CENTRO = CNT.CLAVE_CODIGO_DIRECCION_ZONA
                LEFT JOIN '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR DDTDP ON DDTDP.DD_TDP_ID = PRD.DD_TDP_ID
                LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = PRD.DD_TVI_ID
                LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = PRD.DD_PRV_ID
                LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = PRD.DD_LOC_ID
                LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = PRD.DD_UPO_ID
                WHERE PRD.BORRADO = 0) AUX
            WHERE AUX.ORDEN = 1
		),
	    DELEGACION AS ( 
	        SELECT AUX2.* FROM (
                SELECT PRD.PRD_ID, PRD.PVE_ID, DDTDP.DD_TDP_CODIGO, DDTVI.DD_TVI_CODIGO, PRD.PRD_NOMBRE, PRD.PRD_NUM, PRD.PRD_ESCALERA, PRD.PRD_PLANTA, PRD.PRD_PTA, 
                DDLOC.DD_LOC_CODIGO,DDUPO.DD_UPO_CODIGO, DDPRV.DD_PRV_CODIGO, PRD.PRD_CP, PRD.PRD_TELEFONO, PRD.PRD_TELEFONO2, PRD.PRD_EMAIL,
                PRD.PRD_LOCAL_ABIERTO_PUBLICO, PRD.FECHAMODIFICAR,PRD.FECHACREAR, PRD.USUARIOMODIFICAR, PRD.PRD_PISO, PRD.PRD_OTROS, TCO.DD_TCO_CODIGO,
                PRD.PRD_NUMERO_COMERCIALES,SINO.DD_SIN_CODIGO
                FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD 
                LEFT JOIN '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR DDTDP ON DDTDP.DD_TDP_ID = PRD.DD_TDP_ID 
                LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = PRD.DD_TVI_ID
                LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = PRD.DD_PRV_ID
                LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = PRD.DD_LOC_ID
                LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = PRD.DD_UPO_ID  
                LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = PRD.PRD_LINEA_NEGOCIO AND TCO.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO SINO ON SINO.DD_SIN_ID = PRD.PRD_GEST_CLIENT_NO_RESIDENTES AND SINO.BORRADO = 0
                WHERE PRD.BORRADO = 0) AUX2
		),
	    ESPECIALIDAD_DELEG AS ( 
	        SELECT ESPE.* FROM (
                SELECT PRD.PRD_ID, PRD.PVE_ID, LISTAGG(ESP.DD_ESP_CODIGO, '','') WITHIN GROUP (ORDER BY ESP.DD_ESP_CODIGO) AS DD_ESP_CODIGO
                FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD 
                LEFT JOIN '||V_ESQUEMA||'.PVE_PROVEEDOR_ESPECIALIDAD PVEESP ON PVEESP.PRD_ID = PRD.PRD_ID AND PVEESP.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_ESP_ESPECIALIDAD ESP ON ESP.DD_ESP_ID = PVEESP.DD_ESP_ID AND ESP.BORRADO = 0
                WHERE PRD.BORRADO = 0 GROUP BY PRD.PRD_ID, PRD.PVE_ID) ESPE
		),
	    IDIOMA_DELEG AS ( 
	        SELECT IDI.* FROM (
                SELECT PRD.PRD_ID, PRD.PVE_ID, LISTAGG(IDM.DD_IDM_CODIGO, '','') WITHIN GROUP (ORDER BY IDM.DD_IDM_CODIGO) AS DD_IDM_CODIGO
                FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD 
                LEFT JOIN '||V_ESQUEMA||'.PVI_PROVEEDOR_IDIOMA PVEIDM ON PVEIDM.PRD_ID = PRD.PRD_ID AND PVEIDM.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_IDM_IDIOMA IDM ON IDM.DD_IDM_ID = PVEIDM.DD_IDM_ID AND IDM.BORRADO = 0
                WHERE PRD.BORRADO = 0 GROUP BY PRD.PRD_ID, PRD.PVE_ID) IDI
		),
	    PROVINCIA_ACTUA_DELEG AS ( 
	        SELECT PROV.* FROM (
                SELECT PRD.PRD_ID, PRD.PVE_ID, LISTAGG(PRV.DD_PRV_CODIGO, '','') WITHIN GROUP (ORDER BY PRV.DD_PRV_CODIGO) AS DD_PRV_CODIGO
                FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD 
                LEFT JOIN '||V_ESQUEMA||'.DPR_DELEGACIONES_PROVINCIA DPR ON DPR.PRD_ID = PRD.PRD_ID AND DPR.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = DPR.DD_PRV_ID AND PRV.BORRADO = 0
                WHERE PRD.BORRADO = 0 GROUP BY PRD.PRD_ID, PRD.PVE_IDACTUA_) PROV
		),
	    LOCALIDAD_ACTUA_DELEG AS ( 
	        SELECT LOCD.* FROM (
                SELECT PRD.PRD_ID, PRD.PVE_ID, LISTAGG(LOC.DD_LOC_CODIGO, '','') WITHIN GROUP (ORDER BY LOC.DD_LOC_CODIGO) AS DD_LOC_CODIGO
                FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD 
                LEFT JOIN '||V_ESQUEMA||'.DLO_DELEGACIONES_LOCALIDAD DLO ON DLO.PRD_ID = PRD.PRD_ID AND DLO.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = DLO.DD_LOC_ID AND LOC.BORRADO = 0
                WHERE PRD.BORRADO = 0 GROUP BY PRD.PRD_ID, PRD.PVE_ID) LOCD
		),
	    CP_ACTUA_DELEG AS ( 
	        SELECT CODP.* FROM (
                SELECT PRD.PRD_ID, PRD.PVE_ID, LISTAGG(CDP.DD_CDP_CODIGO, '','') WITHIN GROUP (ORDER BY CDP.DD_CDP_CODIGO) AS DD_CDP_CODIGO
                FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD 
                LEFT JOIN '||V_ESQUEMA||'.DCP_DELEGACIONES_CODIGO_POSTAL DCP ON DCP.PRD_ID = PRD.PRD_ID AND DCP.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_CDP_CODIGO_POSTAL CDP ON CDP.DD_CDP_ID = DCP.DD_CDP_ID AND CDP.BORRADO = 0
                WHERE PRD.BORRADO = 0 GROUP BY PRD.PRD_ID, PRD.PVE_ID) CODP
		),
	    ESPECIALIDAD_PVE AS ( 
	        SELECT ESPE2.* FROM (
                SELECT PVE.PVE_ID, LISTAGG(ESP.DD_ESP_CODIGO, '','') WITHIN GROUP (ORDER BY ESP.DD_ESP_CODIGO) AS DD_ESP_CODIGO
                FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
                LEFT JOIN '||V_ESQUEMA||'.PVE_PROVEEDOR_ESPECIALIDAD PVEESP ON PVEESP.PVE_ID = PVE.PVE_ID AND PVEESP.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_ESP_ESPECIALIDAD ESP ON ESP.DD_ESP_ID = PVEESP.DD_ESP_ID AND ESP.BORRADO = 0
                WHERE PVE.BORRADO = 0 AND PVEESP.PRD_ID IS NULL GROUP BY PVE.PVE_ID) ESPE2
		),
	    IDIOMA_PVE AS ( 
	        SELECT IDI2.* FROM (
                SELECT PVE.PVE_ID, LISTAGG(IDM.DD_IDM_CODIGO, '','') WITHIN GROUP (ORDER BY IDM.DD_IDM_CODIGO)  AS DD_IDM_CODIGO
                FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
                LEFT JOIN '||V_ESQUEMA||'.PVI_PROVEEDOR_IDIOMA PVEIDM ON PVEIDM.PVE_ID = PVE.PVE_ID AND PVEIDM.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_IDM_IDIOMA IDM ON IDM.DD_IDM_ID = PVEIDM.DD_IDM_ID AND IDM.BORRADO = 0
                WHERE PVE.BORRADO = 0 AND PVEIDM.PRD_ID IS NULL GROUP BY PVE.PVE_ID) IDI2
		),
	    CONDUCTAS_INAPROPIADAS AS ( 
	        SELECT COI.* FROM (
                SELECT COI.COI_ID, COI.COI_PVE, COALESCE(COI.FECHAMODIFICAR,COI.FECHACREAR) AS FECHA,COALESCE(COI.USUARIOMODIFICAR,COI.USUARIOCREAR) AS USUARIO,
                DD_TCI_CODIGO,DD_CCI_CODIGO,DD_NCI_CODIGO,COI_COMENTARIOS,COI_DELEGACION
                FROM '||V_ESQUEMA||'.PVE_COI_CONDUCTAS_INAPROPIADAS COI 
                JOIN '||V_ESQUEMA||'.DD_CCI_CAT_CONDUC_INAPROP CCI ON COI.DD_CCI_ID = CCI.DD_CCI_ID AND CCI.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TCI_TIPO_CONDUC_INAPROP TCI ON TCI.DD_TCI_ID = CCI.DD_TCI_ID AND TCI.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_NCI_NIVEL_CONDUC_INAPROP NCI ON NCI.DD_NCI_ID = CCI.DD_NCI_ID AND NCI.BORRADO = 0
                WHERE COI.BORRADO = 0) COI
		)
		SELECT
		CAST(  NVL(PVE.PVE_COD_REM , ''00000'')   
			|| NVL(DEL.PRD_ID , ''00000'')
			|| DD_CRA_CODIGO || ROWNUM AS NUMBER(38,0))                           	            AS ID_PROV_DELEGACION,
		CAST(PVE.PVE_COD_REM AS NUMBER(16,0))                                          			AS ID_PROVEEDOR_REM,
		CAST(PVE.PVE_COD_API_PROVEEDOR AS VARCHAR2(10 CHAR))                               		AS CODIGO_PROVEEDOR,
		CAST(DDTPR.DD_TPR_CODIGO AS VARCHAR2(5 CHAR))                             				AS COD_TIPO_PROVEEDOR,
		CAST(PVE.PVE_NOMBRE AS VARCHAR2(60 CHAR))                                 				AS NOMBRE,
		CAST(PVE.PVE_NOMBRE_COMERCIAL AS VARCHAR2(60 CHAR))                                 	AS NOMBRE_COMERCIAL,
		CAST(PVE.PVE_TELF_CONTACTO_VIS AS VARCHAR2(50 CHAR))                           			AS TELFONO_CONTACTO_VISITAS,
		CAST(NULL AS VARCHAR2(60 CHAR)) 														AS APELLIDOS,
		CAST(SOC.DD_TVI_CODIGO AS VARCHAR2(5 CHAR))                                           	AS COD_TIPO_VIA,
		CAST(SOC.PRD_NOMBRE AS VARCHAR2(100 CHAR))                             					AS NOMBRE_CALLE,
		CAST(SOC.PRD_NUM AS VARCHAR2(100 CHAR))                                           		AS NUMERO_CALLE,
		CAST(SOC.PRD_ESCALERA AS VARCHAR2(10 CHAR))                                           	AS ESCALERA,
		CAST(SOC.PRD_PLANTA AS VARCHAR2(11 CHAR))                                           	AS PLANTA,
		CAST(SOC.PRD_PTA AS VARCHAR2(17 CHAR))                                           		AS PUERTA,
		CAST(SOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR))                                				AS COD_MUNICIPIO,
		CAST(SOC.DD_UPO_CODIGO AS VARCHAR2(25 CHAR))                                           	AS COD_PEDANIA,
		CAST(SOC.DD_PRV_CODIGO AS VARCHAR2(5 CHAR))                                  			AS COD_PROVINCIA,
		CAST(SOC.PRD_CP AS VARCHAR2(40 CHAR)) 													AS CODIGO_POSTAL,
		CAST(SOC.PRD_TELEFONO AS VARCHAR2(14 CHAR)) 											AS TELEFONO1,
		CAST(SOC.PRD_TELEFONO2 AS VARCHAR2(14 CHAR)) 											AS TELEFONO2,
		CAST(PVE.PVE_EMAIL AS VARCHAR2(100 CHAR)) 												AS EMAIL,
		CAST(SOC.DD AS VARCHAR2(5 CHAR))                                                		AS DD,
		CAST(SOC.DZ AS VARCHAR2(5 CHAR))                                                		AS DZ,
		CAST(SOC.DT AS VARCHAR2(5 CHAR))                                                		AS DT,
		CAST(PVE.PVE_AUTORIZACION_WEB AS VARCHAR2(5 CHAR))                                      AS MODIFICAR_INFORMES,
		CASE WHEN (PVE.PVE_FECHA_BAJA IS NULL OR PVE.PVE_FECHA_BAJA > TO_DATE(SYSDATE, ''DD/MM/YY''))  
					THEN CAST(1 AS NUMBER(1,0))
					ELSE CAST(0 AS NUMBER(1,0))
		END 																		            ACTIVO,
		CAST(DEL.PRD_LOCAL_ABIERTO_PUBLICO AS NUMBER(1,0))                                     	AS ABIERTA,
	    CAST(DEL.PRD_ID AS NUMBER(16,0))                                 			            AS DELEGACIONES_ID_DELEGACION,
	    CAST(DEL.DD_TVI_CODIGO AS VARCHAR2(20 CHAR))                                 			AS DELEGACIONES_COD_TIPO_VIA,
	    CAST(DEL.PRD_NOMBRE AS VARCHAR2(100 CHAR))                                      		AS DELEGACIONES_NOMBRE_CALLE,
	    CAST(DEL.PRD_NUM AS VARCHAR2(100 CHAR))                                         		AS DELEGACIONES_NUMERO_CALLE,
	    CAST(DEL.PRD_ESCALERA AS VARCHAR2(10 CHAR))                                     		AS DELEGACIONES_ESCALERA,
	    CAST(DEL.PRD_PLANTA AS VARCHAR2(11 CHAR))                                       		AS DELEGACIONES_PLANTA,
	    CAST(DEL.PRD_PTA AS VARCHAR2(17 CHAR))                                          		AS DELEGACIONES_PUERTA,
	    CAST(DEL.DD_LOC_CODIGO AS VARCHAR2(5 CHAR))                                   			AS DELEGACIONES_COD_MUNICIPIO,
	    CAST(DEL.DD_UPO_CODIGO AS VARCHAR2(25 CHAR))                                   			AS DELEGACIONES_COD_PEDANIA,
	    CAST(DEL.DD_PRV_CODIGO AS VARCHAR2(5 CHAR))                                  			AS DELEGACIONES_COD_PROVINCIA,
	    CAST(DEL.PRD_CP AS VARCHAR2(40 CHAR))                                           		AS DELEGACIONES_CODIGO_POSTAL,
	    CAST(DEL.PRD_TELEFONO AS VARCHAR2(14 CHAR))                                     		AS DELEGACIONES_TELEFONO1,
	    CAST(DEL.PRD_TELEFONO2 AS VARCHAR2(14 CHAR))                                    		AS DELEGACIONES_TELEFONO2,
	    CAST(DEL.PRD_EMAIL AS VARCHAR2(100 CHAR))                                        		AS DELEGACIONES_EMAIL,
	    CAST(DEL.PRD_PISO AS VARCHAR2(100 CHAR))                                        		AS DELEGACIONES_PISO,
	    CAST(DEL.PRD_OTROS AS VARCHAR2(100 CHAR))                                        		AS DELEGACIONES_OTROS,
	    CAST(DEL.DD_TCO_CODIGO AS VARCHAR2(20 CHAR))                                        	AS DELEGACIONES_COD_LINEA_NEGOCIO,
	    CAST(ESPED.DD_ESP_CODIGO AS VARCHAR2(100 CHAR))                                        	AS DELEGACIONES_ARR_COD_ESPECIALIDAD,
	    CAST(IDID.DD_IDM_CODIGO AS VARCHAR2(100 CHAR))                                        	AS DELEGACIONES_ARR_COD_IDIOMA,
	    CAST(DEL.PRD_NUMERO_COMERCIALES AS NUMBER(16,0))	                                    AS DELEGACIONES_NUM_COMERCIALES,
	    CAST(DEL.DD_SIN_CODIGO AS VARCHAR2(20 CHAR))                                        	AS DELEGACIONES_COD_GESTION_CNR,
	    CAST(PRVDEL.DD_PRV_CODIGO AS VARCHAR2(250 CHAR))                                        AS DELEGACIONES_ARR_COD_PROVINCIA,
	    CAST(LOCDEL.DD_LOC_CODIGO AS VARCHAR2(250 CHAR))                                        AS DELEGACIONES_ARR_COD_LOCALIDAD,
	    CAST(CPDEL.DD_CDP_CODIGO AS VARCHAR2(250 CHAR))                                        	AS DELEGACIONES_ARR_CODIGO_POSTAL,
		CAST(TO_CHAR(COALESCE(SOC.FECHAMODIFICAR,DEL.FECHAMODIFICAR, PVE.FECHAMODIFICAR, 
					PVE.FECHACREAR), ''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 		AS FECHA_ACCION,
 		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
					WHERE USU.USU_USERNAME = COALESCE(SOC.USUARIOMODIFICAR,DEL.USUARIOMODIFICAR, 
					PVE.USUARIOMODIFICAR, PVE.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 					AS ID_USUARIO_REM_ACCION,
		CAST(NVL(PRD.NUM_DELEGACIONES,0) AS NUMBER (16, 0)) 			                        AS NUMERO_DELEGACIONES,
		CAST(CRA.DD_CRA_CODIGO AS VARCHAR2(20 CHAR))	    							        AS ARR_COD_CARTERA_AMBITO_COD_CARTERA,
		CAST(PVE2.PVE_COD_REM AS NUMBER(16,0))													AS ID_PROVEEDOR_REM_ASOCIADO,
		CAST(OPH.DD_OPH_CODIGO AS VARCHAR2(20 CHAR)) 			                                AS COD_ORIGEN_PETICION,
		CAST(PVE.PVE_PETICIONARIO AS VARCHAR2(100 CHAR)) 			                            AS NOMBRE_PETICIONARIO,
		CAST(TCO.DD_TCO_CODIGO AS VARCHAR2(20 CHAR)) 			                                AS COD_LINEA_NEGOCIO,
		CAST(ESPEP.DD_ESP_CODIGO AS VARCHAR2(20 CHAR))	    							        AS ARR_COD_ESPECIALIDAD,
		CAST(IDIP.DD_IDM_CODIGO AS VARCHAR2(20 CHAR))	    							        AS ARR_COD_IDIOMA,
		CAST(SINO.DD_SIN_CODIGO AS VARCHAR2(20 CHAR)) 			                                AS COD_GESTION_CNR,
		CAST(PVE.PVE_NUMERO_COMERCIALES AS NUMBER(16,0))			                            AS NUM_COMERCIALES,
		CAST(TO_CHAR(PVE.PVE_FECHA_ULT_CNT_VIGNETE, 
                    ''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 		                AS FECHA_ULT_CONTRATO,
		CAST(PVE.PVE_MOTIVO_BAJA AS VARCHAR2(100 CHAR)) 			                            AS MOTIVO_BAJA,
        
	    CAST(COI.COI_PVE AS NUMBER(16,0))                                 			            AS CONDUCTAS_INAPROPIADAS_ID_CONDUCTA_INAPROPIADA,
        CAST(TO_CHAR(COI.FECHA, ''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 		    AS CONDUCTAS_INAPROPIADAS_FECHA_ALTA,
 		CAST(NVL(COI.USUARIO,NULL) AS VARCHAR2(100 CHAR)) 			    						AS CONDUCTAS_INAPROPIADAS_USUARIO_ALTA,
	    CAST(COI.DD_TCI_CODIGO AS VARCHAR2(20 CHAR))                                         	AS CONDUCTAS_INAPROPIADAS_COD_TIPOLOGIA,
	    CAST(COI.DD_CCI_CODIGO AS VARCHAR2(20 CHAR))                                     		AS CONDUCTAS_INAPROPIADAS_COD_CATEGORIA,
	    CAST(COI.DD_NCI_CODIGO AS VARCHAR2(20 CHAR))                                       		AS CONDUCTAS_INAPROPIADAS_COD_NIVEL,
	    CAST(COI.COI_COMENTARIOS AS VARCHAR2(250 CHAR))                                         AS CONDUCTAS_INAPROPIADAS_COMENTARIOS,
	    CAST(COI.COI_DELEGACION AS NUMBER(16,0))                                   			    AS CONDUCTAS_INAPROPIADAS_ID_DELEGACION
        
        
		FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
		LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR DDTPR ON DDTPR.DD_TPR_ID = PVE.DD_TPR_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE2 ON PVE.PVE_ID_MEDIADOR_REL=PVE2.PVE_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_OPH_ORIGEN_PETI_HOMOLOG OPH ON OPH.DD_OPH_ID = PVE.DD_OPH_ID AND OPH.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = PVE.PVE_LINEA_NEGOCIO AND TCO.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO SINO ON SINO.DD_SIN_ID = PVE.PVE_GEST_CLIENT_NO_RESIDENTES AND SINO.BORRADO = 0
		LEFT JOIN DOMICILIO_SOCIAL SOC ON SOC.PVE_ID = PVE.PVE_ID AND SOC.DD_TDP_CODIGO = ''01''
    	LEFT JOIN DELEGACION DEL ON DEL.PVE_ID = PVE.PVE_ID AND DEL.DD_TDP_CODIGO = ''02''
    	LEFT JOIN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR ETP ON ETP.PVE_ID = PVE.PVE_ID
    	LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ETP.DD_CRA_ID
    	LEFT JOIN CONDUCTAS_INAPROPIADAS COI ON COI.COI_PVE = PVE.PVE_ID
        LEFT JOIN ESPECIALIDAD_DELEG ESPED ON ESPED.PVE_ID = PVE.PVE_ID AND ESPED.PRD_ID = DEL.PRD_ID
        LEFT JOIN IDIOMA_DELEG IDID ON IDID.PVE_ID = PVE.PVE_ID  AND IDID.PRD_ID = DEL.PRD_ID
        LEFT JOIN PROVINCIA_ACTUA_DELEG PRVDEL ON PRVDEL.PVE_ID = PVE.PVE_ID  AND PRVDEL.PRD_ID = DEL.PRD_ID
        LEFT JOIN LOCALIDAD_ACTUA_DELEG LOCDEL ON LOCDEL.PVE_ID = PVE.PVE_ID  AND LOCDEL.PRD_ID = DEL.PRD_ID
        LEFT JOIN CP_ACTUA_DELEG CPDEL ON CPDEL.PVE_ID = PVE.PVE_ID  AND CPDEL.PRD_ID = DEL.PRD_ID
        LEFT JOIN ESPECIALIDAD_PVE ESPEP ON ESPEP.PVE_ID = PVE.PVE_ID 
        LEFT JOIN IDIOMA_PVE IDIP ON IDIP.PVE_ID = PVE.PVE_ID 
		LEFT JOIN (SELECT COUNT(*) AS NUM_DELEGACIONES, PVE_ID FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION
								WHERE DD_TDP_ID = (SELECT DD_TDP_ID FROM '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR
                                											WHERE DD_TDP_CODIGO = ''02'') 
            					GROUP BY PVE_ID)	PRD ON PRD.PVE_ID = DEL.PVE_ID   
		WHERE DDTPR.DD_TPR_CODIGO IN (''04'', ''18'', ''23'', ''28'', ''29'', ''30'', ''31'', ''32'', ''33'', ''34'', ''35'', ''38'',''05'')';
   	 	
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_PROV_DELEGACION) TABLESPACE '||V_TABLESPACE_IDX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT
		                                                                            * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_PROV_DELEGACION) TABLESPACE '||V_TABLESPACE_IDX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_PROV_DELEGACION) USING INDEX)';
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
