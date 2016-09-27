--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de los proveedores enviadas a webcom.
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
		SELECT 
		CAST(PVE.PVE_ID || ''0000'' || PRD.PRD_ID AS NUMBER(16,0))                              AS ID_PROV_DELEGACION,
		CAST(PVE.PVE_ID AS NUMBER(16,0))                                          				AS ID_PROVEEDOR_REM,
		CAST(PVE.PVE_COD_UVEM AS VARCHAR2(10 CHAR))                               				AS CODIGO_PROVEEDOR,
		CAST(DDTPR.DD_TPR_CODIGO AS VARCHAR2(5 CHAR))                             				AS COD_TIPO_PROVEEDOR,
		CAST(PVE.PVE_NOMBRE AS VARCHAR2(60 CHAR))                                 				AS NOMBRE,
		CAST(NULL AS VARCHAR2(60 CHAR)) 														AS APELLIDOS,
		CAST(NULL AS VARCHAR2(5 CHAR))                                           				AS COD_TIPO_VIA,
		CAST(PVE.PVE_DIRECCION AS VARCHAR2(100 CHAR))                             				AS NOMBRE_CALLE,
		CAST(NULL AS VARCHAR2(100 CHAR))                                           				AS NUMERO_CALLE,
		CAST(NULL AS VARCHAR2(10 CHAR))                                           				AS ESCALERA,
		CAST(NULL AS VARCHAR2(11 CHAR))                                           				AS PLANTA,
		CAST(NULL AS VARCHAR2(17 CHAR))                                           				AS PUERTA,
		CAST(DDLOC.DD_LOC_CODIGO AS VARCHAR2(5 CHAR))                                			AS COD_MUNICIPIO,
		CAST(NULL AS VARCHAR2(5 CHAR))                                              			AS COD_PEDANIA,
		CAST(DDPRV.DD_PRV_CODIGO AS VARCHAR2(5 CHAR))                                  			AS COD_PROVINCIA,
		CAST(PVE.PVE_CP AS VARCHAR2(40 CHAR)) 													AS CODIGO_POSTAL,
		CAST(PVE.PVE_TELF1 AS VARCHAR2(14 CHAR)) 												AS TELEFONO1,
		CAST(PVE.PVE_TELF2 AS VARCHAR2(14 CHAR)) 												AS TELEFONO2,
		CAST(PVE.PVE_EMAIL AS VARCHAR2(40 CHAR)) 												AS EMAIL,
		CAST(NULL AS VARCHAR2(5 CHAR))                                                			AS DD,
		CAST(NULL AS VARCHAR2(5 CHAR))                                                			AS DZ,
		CAST(NULL AS VARCHAR2(5 CHAR))                                                			AS DT,
		CAST(NULL AS VARCHAR2(5 CHAR))                                                			AS MODIFICAR_INFORMES,
		CASE WHEN (PVE.BORRADO = ''1'') 
		    THEN CAST(0 AS NUMBER(1,0))
		    ELSE CAST(1 AS NUMBER(1,0))
		END 																		           	ACTIVO,
		CAST(NULL AS NUMBER(1,0))                                                  				AS ABIERTA,
	    CAST(DDTVI.DD_TVI_CODIGO AS VARCHAR2(20 CHAR))                                 			AS DELEGACIONES_COD_TIPO_VIA,
	    CAST(PRD.PRD_NOMBRE AS VARCHAR2(100 CHAR))                                      		AS DELEGACIONES_NOMBRE_CALLE,
	    CAST(PRD.PRD_NUM AS VARCHAR2(100 CHAR))                                         		AS DELEGACIONES_NUMERO_CALLE,
	    CAST(PRD.PRD_ESCALERA AS VARCHAR2(10 CHAR))                                     		AS DELEGACIONES_ESCALERA,
	    CAST(PRD.PRD_PLANTA AS VARCHAR2(11 CHAR))                                       		AS DELEGACIONES_PLANTA,
	    CAST(PRD.PRD_PTA AS VARCHAR2(17 CHAR))                                          		AS DELEGACIONES_PUERTA,
	    CAST(DDLOC2.DD_LOC_CODIGO AS VARCHAR2(5 CHAR))                                   		AS DELEGACIONES_COD_MUNICIPIO,
	    CAST(DDUPO.DD_UPO_CODIGO AS VARCHAR2(5 CHAR))                                   		AS DELEGACIONES_COD_PEDANIA,
	    CAST(DDPRV2.DD_PRV_CODIGO AS VARCHAR2(5 CHAR))                                  		AS DELEGACIONES_COD_PROVINCIA,
	    CAST(PRD.PRD_CP AS VARCHAR2(40 CHAR))                                           		AS DELEGACIONES_CODIGO_POSTAL,
	    CAST(PRD.PRD_TELEFONO AS VARCHAR2(14 CHAR))                                     		AS DELEGACIONES_TELEFONO1,
	    CAST(PRD.PRD_TELEFONO2 AS VARCHAR2(14 CHAR))                                    		AS DELEGACIONES_TELEFONO2,
	    CAST(PRD.PRD_EMAIL AS VARCHAR2(40 CHAR))                                        		AS DELEGACIONES_EMAIL,
		CAST(TO_CHAR(PVE.FECHACREAR,''YYYY-MM-DD'') || 
		    ''T'' ||TO_CHAR(PVE.FECHACREAR,''HH24:MI:SS'') AS VARCHAR2(50 CHAR))    			AS FECHA_ACCION,
		CAST((SELECT USU.USU_ID FROM REMMASTER.USU_USUARIOS USU 
		    WHERE USU.USU_USERNAME = PVE.USUARIOCREAR) AS NUMBER(16,0))         				AS ID_USUARIO_REM_ACCION
		FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
		LEFT JOIN '||V_ESQUEMA||'.ACT_PRD_PROVEEDOR_DIRECCION PRD ON PRD.PVE_ID = PVE.PVE_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR DDTPR ON DDTPR.DD_TPR_ID = PVE.DD_TPR_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA DDTVI ON DDTVI.DD_TVI_ID = PRD.DD_TVI_ID
    	LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV ON DDPRV.DD_PRV_ID = PVE.DD_PRV_ID
    	LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA DDPRV2 ON DDPRV2.DD_PRV_ID = PRD.DD_PRV_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC ON DDLOC.DD_LOC_ID = PVE.DD_LOC_ID
    	LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD DDLOC2 ON DDLOC2.DD_LOC_ID = PRD.DD_LOC_ID
		LEFT JOIN '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL DDUPO ON DDUPO.DD_UPO_ID = PRD.DD_UPO_ID
		WHERE DDTPR.DD_TPR_CODIGO = ''04'' AND PVE.PVE_COD_UVEM IS NOT NULL';
   
   	 	
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
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