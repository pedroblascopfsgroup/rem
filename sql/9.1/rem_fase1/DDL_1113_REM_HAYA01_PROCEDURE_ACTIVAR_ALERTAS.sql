--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20160504
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN
    
--##CREACION DE TABLA, PK y FK de tabla

  DBMS_OUTPUT.PUT('[INFO] Procedure PROCEDURE ACTIVAR_ALERTAS: CREADA...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE '||V_ESQUEMA||'.ACTIVAR_ALERTAS AS
		BEGIN
		MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar USING '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar2 ON (tar.tar_id = tar2.tar_id)
		WHEN MATCHED THEN
			UPDATE SET
			tar.tar_alerta = 1,
			tar.fechamodificar = SYSDATE,
			tar.usuariomodificar = ''REM''
			WHERE  tar.tar_fecha_venc < SYSDATE
				AND tar.borrado = 0
				AND tar.tar_alerta = 0
				AND tar.tar_tarea_finalizada = 0;
		END ACTIVAR_ALERTAS;
		';
  DBMS_OUTPUT.PUT_LINE('OK');

  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Vista creada.');
	
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
