--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de las comisiones enviadas a webcom
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_COMISIONES_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CWH_COMISIONES_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de las comisiones enviadas a webcom.'; -- Vble. para los comentarios de las tablas

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
		WITH ACCION AS (
			SELECT * FROM (
				SELECT GEX.GEX_ID,
		        CASE WHEN (GEX.FECHACREAR IS NOT NULL) 
		            THEN CAST(TO_CHAR(GEX.FECHACREAR,''YYYY-MM-DD'') || 
		            ''T'' ||TO_CHAR(GEX.FECHACREAR,''HH24:MM:SS'') AS VARCHAR2(50 CHAR))
		            ELSE NULL
		        END FECHA_ACCION,
		        CASE WHEN (GEX.USUARIOMODIFICAR IS NOT NULL) 
		            THEN (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		            WHERE USU.USU_USERNAME = GEX.USUARIOMODIFICAR)
		            ELSE (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		            WHERE USU.USU_USERNAME = GEX.USUARIOCREAR) 
		        END ID_USUARIO_REM_ACCION
				FROM '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE GEX
			)
		)
		SELECT 
	    CAST(GEX.GEX_ID AS NUMBER(16,0)) 												        AS ID_HONORARIO_REM,
			CAST(OFR.OFR_WEBCOM_ID AS NUMBER(16,0)) 											AS ID_OFERTA_WEBCOM,
			CAST(OFR.OFR_NUM_OFERTA AS NUMBER(16,0)) 											AS ID_OFERTA_REM,  
	    CAST(NVL(GEX.GEX_PROVEEDOR, ''0'') AS NUMBER(16,0))  									AS ID_PROVEEDOR_REM,
	    CAST(NVL((SELECT CASE 
		    WHEN (DDACC.DD_ACC_CODIGO = ''04'') 
				THEN 1 
				ELSE 0 
			END ES_PRESCRIPCION 
    		FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS DDACC
    		WHERE DDACC.DD_ACC_ID = GEX.DD_ACC_ID ), ''0'') AS NUMBER(1,0))               		AS ES_PRESCRIPCION,
	    CAST(NVL((SELECT CASE 
	     	WHEN (DDACC.DD_ACC_CODIGO = ''05'') 
				THEN 1 
				ELSE 0 
			END ES_COLABORACION 
		    FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS DDACC
		    WHERE DDACC.DD_ACC_ID = GEX.DD_ACC_ID ), ''0'') AS NUMBER(1,0))                		AS ES_COLABORACION, 
	    CAST(NVL((SELECT CASE 
	      	WHEN (DDACC.DD_ACC_CODIGO = ''06'') 
				THEN 1 
				ELSE 0 
			END ES_RESPONSABLE 
		    FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS DDACC
		    WHERE DDACC.DD_ACC_ID = GEX.DD_ACC_ID ), ''0'') AS NUMBER(1,0))                		AS ES_RESPONSABLE,
	    CAST(NVL((SELECT CASE 
			WHEN (DDACC.DD_ACC_CODIGO = ''05'' AND 
	            (SELECT PVE.PVE_ID 
					FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE, 
					'||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR DDTPR
		            WHERE PVE.PVE_ID = GEX.GEX_PROVEEDOR 
		            AND PVE.DD_TPR_ID = DDTPR.DD_TPR_ID 
		            AND DDTPR.DD_TPR_CODIGO = ''18'') IS NOT NULL) 
				THEN 1 
				ELSE 0 
			END ES_FDV 
		    FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS DDACC
		    WHERE DDACC.DD_ACC_ID = GEX.DD_ACC_ID ), ''0'') AS NUMBER(1,0))               		AS ES_FDV,
	    CAST(NVL((SELECT CASE 
	      	WHEN (DDACC.DD_ACC_CODIGO = ''06'') 
				THEN 1 
				ELSE 0 
			END ES_RESPONSABLE 
		    FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS DDACC
		    WHERE DDACC.DD_ACC_ID = GEX.DD_ACC_ID) , ''0'') AS NUMBER(1,0))                		AS ES_DOBLE_PRESCRIPCION,
	    CAST(GEX.GEX_OBSERVACIONES AS VARCHAR2(250 CHAR))               						AS OBSERVACIONES,
	    CAST(NVL(GEX.GEX_IMPORTE_FINAL , ''0'') AS NUMBER(9,2))                      			AS IMPORTE,
	    CAST(NVL(GEX.GEX_IMPORTE_CALCULO , ''0'') AS NUMBER(3,2))                    			AS PORCENTAJE,	    
		CAST(NVL(ACC.FECHA_ACCION, 
			TO_CHAR((SELECT SYSDATE FROM DUAL),''YYYY-MM-DD'') || 
			''T'' ||
			TO_CHAR((SELECT SYSDATE FROM DUAL),''HH24:MM:SS'')) AS VARCHAR2(50 CHAR))   		AS FECHA_ACCION,      
		CAST(NVL(ACC.ID_USUARIO_REM_ACCION, 
		    (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
		    WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER(16,0))                       		AS ID_USUARIO_REM_ACCION   
		FROM '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE GEX
		LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = GEX.ECO_ID
	    LEFT JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
	    LEFT JOIN '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS DDACC ON DDACC.DD_ACC_ID = GEX.DD_ACC_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DDEEC ON DDEEC.DD_EEC_ID = ECO.DD_EEC_ID
		LEFT JOIN ACCION ACC ON ACC.GEX_ID = GEX.GEX_ID
	   	WHERE OFR.OFR_WEBCOM_ID IS NOT NULL AND DDEEC.DD_EEC_CODIGO = ''08'' AND GEX.GEX_IMPORTE_FINAL IS NOT NULL';  	
		
   	 	
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_HONORARIO_REM) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_HONORARIO_REM) USING INDEX)';
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