--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20151109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN


--##CREACION DE TABLA, PK y FK de tabla
	DBMS_OUTPUT.PUT_LINE('******** ETN_EXTAREAS_NOTIFICACIONES ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ETN_EXTAREAS_NOTIFICACIONES... Comprobaciones previas');
	
	-- Comprobamos si se creó la tabla antigua
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME= ''ETN_EXT_TAREAS_NOTIFICACIONES''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		EXECUTE IMMEDIATE 'DROP TABLE ' ||V_ESQUEMA||'.ETN_EXT_TAREAS_NOTIFICACIONES';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ETN_EXT_TAREAS_NOTIFICACIONES... Borrado');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ETN_EXT_TAREAS_NOTIFICACIONES... No existia');
	END IF;
	
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME= ''ETN_EXTAREAS_NOTIFICACIONES''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 0 THEN
	  	DBMS_OUTPUT.PUT('[INFO] Tabla ETN_EXTAREAS_NOTIFICACIONES: CREADA...');
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.ETN_EXTAREAS_NOTIFICACIONES
			  AS SELECT "TAR_ID", "TAR_FECHA_VENC_REAL", "NFA_TAR_REVISADA", "NFA_TAR_FECHA_REVIS_ALER", "NFA_TAR_COMENTARIOS_ALERTA", "DD_TRA_ID", "TAR_TIPO_DESTINATARIO", "TAR_ID_DEST", "CNT_ID", "PER_ID" 
			  FROM TAR_TAREAS_NOTIFICACIONES ';
	  	DBMS_OUTPUT.PUT_LINE('OK');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ETN_EXTAREAS_NOTIFICACIONES: La tabla ya existe, no se creará');
	END IF;

  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Tabla creada.');
	
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

EXIT