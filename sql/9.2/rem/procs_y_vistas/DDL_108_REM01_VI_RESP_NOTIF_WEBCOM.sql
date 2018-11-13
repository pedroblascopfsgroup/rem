--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20181113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para almacentar el historico de las respuestas de las notificaciones enviadas a webcom.
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
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_RESP_NOTIF_WEBCOM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'NWH_RESP_NOTIF_WEBCOM_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para almacentar el historico de las respuestas de las notificaciones enviadas a webcom.'; -- Vble. para los comentarios de las tablas

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
		WITH TAREA_WEBCOM AS (
			SELECT M2.REG_ID, M2.IRG_CLAVE, M2.IRG_VALOR
			FROM '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO M2 
			WHERE M2.IRG_CLAVE = ''ID_TAREA_APP_EXTERNA''
		),
		DESC_TAREA AS (
			SELECT M3.REG_ID, M3.IRG_CLAVE, M3.IRG_VALOR
			FROM '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO M3 
			WHERE M3.IRG_CLAVE = ''RESP_TAREA''
		),
		RESP_TAREA AS (
			SELECT M4.REG_ID AS REG_RESP, M4.IRG_CLAVE, M4.IRG_VALOR AS ID_TAREA_ORIG 
			FROM '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO M4 
			WHERE M4.IRG_CLAVE = ''ID_TAREA_ORIGINAL''
		),
		FECHA_RESP_TAREA AS (
			SELECT M5.REG_ID, M5.IRG_CLAVE, M5.FECHACREAR, M5.USUARIOCREAR,
		    (TO_DATE(''1970-01-01 00'',''yyyy-mm-dd hh24'') + (M5.IRG_VALOR)/1000/60/60/24) AS FECHA_RESP
			FROM '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO M5 
			WHERE M5.IRG_CLAVE = ''FECHA_RESP_TAREA''
		)
		SELECT 
		CAST(TAR.TAR_ID AS NUMBER(16,0))										AS ID_NOTIFICACION_REM,
		CAST(TWC.IRG_VALOR AS NUMBER(16,0))										AS ID_NOTIFICACION_WEBCOM,
		CAST(MEJ.TRG_EIN_ID AS NUMBER(16,0))									AS ID_ACTIVO_HAYA,
		CAST(DRT.IRG_VALOR  AS VARCHAR2(250 CHAR))								AS DESCRIPCION,
    	CAST(NVL(TO_CHAR(FRT.FECHACREAR,''YYYY-MM-DD"T"HH24:MM:SS''),
             	 TO_CHAR((SELECT SYSDATE FROM DUAL),''YYYY-MM-DD"T"HH24:MM:SS'')
             )  AS VARCHAR2(50 CHAR))                                           AS FECHA_ACCION,    
		CAST(NVL((SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
              WHERE USU.USU_USERNAME = FRT.USUARIOCREAR), 
             (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU 
              WHERE USU.USU_USERNAME = ''REM-USER'')) AS NUMBER(16,0))          AS ID_USUARIO_REM_ACCION
		FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
		INNER JOIN (SELECT INFO.REG_ID AS REG_ID,INFO.IRG_VALOR AS IDTAREA
		            FROM '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO INFO 
		            WHERE INFO.IRG_CLAVE = ''ID_TAREA'') REG ON REG.IDTAREA = TAR.TAR_ID
    	INNER JOIN '||V_ESQUEMA||'.MEJ_REG_REGISTRO MEJ ON MEJ.REG_ID = REG.REG_ID 
    	INNER JOIN TAREA_WEBCOM TWC ON TWC.REG_ID = REG.REG_ID     
    	INNER JOIN RESP_TAREA RPT ON RPT.ID_TAREA_ORIG = TAR.TAR_ID
		LEFT JOIN DESC_TAREA DRT ON DRT.REG_ID = RPT.REG_RESP
    	LEFT JOIN FECHA_RESP_TAREA FRT ON FRT.REG_ID = RPT.REG_RESP
		WHERE TWC.IRG_VALOR IS NOT NULL AND TAR.USUARIOCREAR = ''REST-USER''
		and (tar.tar_fecha_fin is null and tar.borrado = 0)';  	
		
   	 	
 		DBMS_OUTPUT.PUT_LINE('[INFO] Vista materializada : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');

		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_VISTA||'(ID_NOTIFICACION_REM) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_VISTA||'_IDX... Indice creado.');
		
		
		
		-- Creamos tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva tabla : '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||' a partir de la vista materializada ');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AS  (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_VISTA||')';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_NOTIFICACION_REM) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ID_NOTIFICACION_REM) USING INDEX)';
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
