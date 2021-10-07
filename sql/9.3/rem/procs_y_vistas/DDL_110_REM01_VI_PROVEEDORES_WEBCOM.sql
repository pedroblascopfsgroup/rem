--/*
--##########################################
--## AUTOR=Remus Ovidiu Viorel
--## FECHA_CREACION=20210922
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
			PRD.PRD_LOCAL_ABIERTO_PUBLICO, PRD.FECHAMODIFICAR,PRD.FECHACREAR, PRD.USUARIOMODIFICAR, 
			 ROW_NUMBER() OVER (PARTITION BY PRD.PVE_ID order by CASE WHEN prd.PRD_TELEFONO IS NULL THEN 1 ELSE 0 END, PRD.PRD_ID DESC) ORDEN
			FROM '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD 
			LEFT JOIN '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR DDTDP ON DDTDP.DD_TDP_ID = PRD.DD_TDP_ID 
			LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = PRD.DD_TVI_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = PRD.DD_PRV_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = PRD.DD_LOC_ID
			LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = PRD.DD_UPO_ID  
			WHERE PRD.BORRADO = 0) AUX2
		WHERE AUX2.ORDEN = 1
		)
		SELECT
		CAST(  NVL(LPAD(PVE.PVE_COD_REM,10,0) , ''00000'')   
			|| NVL(LPAD(DEL.PRD_ID,5,0) , ''00000'')
			|| DD_CRA_CODIGO                       AS NUMBER(38,0))                           	AS ID_PROV_DELEGACION,
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
		END 																		ACTIVO,
		CAST(DEL.PRD_LOCAL_ABIERTO_PUBLICO AS NUMBER(1,0))                                     	AS ABIERTA,
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
		CAST(TO_CHAR(COALESCE(SOC.FECHAMODIFICAR,DEL.FECHAMODIFICAR, PVE.FECHAMODIFICAR, 
					PVE.FECHACREAR), ''YYYY-MM-DD"T"HH24:MM:SS'') AS VARCHAR2 (50 CHAR)) 		AS FECHA_ACCION,
 		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
					WHERE USU.USU_USERNAME = COALESCE(SOC.USUARIOMODIFICAR,DEL.USUARIOMODIFICAR, 
					PVE.USUARIOMODIFICAR, PVE.USUARIOCREAR)),
                  (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
					WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER (16, 0)) 					AS ID_USUARIO_REM_ACCION,
		CAST(PRD.NUM_DELEGACIONES AS NUMBER (16, 0)) 			AS NUMERO_DELEGACIONES,
		CAST(CRA.DD_CRA_CODIGO AS VARCHAR2(20 CHAR))	    							        AS ARR_COD_CARTERA_AMBITO_COD_CARTERA,
		CAST(PVE2.PVE_COD_REM AS NUMBER(16,0))													AS ID_PROVEEDOR_REM_ASOCIADO
		FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
		LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR DDTPR ON DDTPR.DD_TPR_ID = PVE.DD_TPR_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE2 ON PVE.PVE_ID_MEDIADOR_REL=PVE2.PVE_ID
		LEFT JOIN DOMICILIO_SOCIAL SOC ON SOC.PVE_ID = PVE.PVE_ID AND SOC.DD_TDP_CODIGO = ''01''
    	LEFT JOIN DELEGACION DEL ON DEL.PVE_ID = PVE.PVE_ID AND DEL.DD_TDP_CODIGO = ''02''
    	LEFT JOIN '||V_ESQUEMA||'.ACT_ETP_ENTIDAD_PROVEEDOR ETP ON ETP.PVE_ID = PVE.PVE_ID
    	LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ETP.DD_CRA_ID
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
