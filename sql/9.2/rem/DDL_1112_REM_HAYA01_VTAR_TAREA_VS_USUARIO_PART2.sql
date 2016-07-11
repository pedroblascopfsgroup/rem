--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20160315
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

  DBMS_OUTPUT.PUT('[INFO] Vista VTAR_TAREA_VS_USUARIO_PART2: CREADA...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW '||V_ESQUEMA||'.VTAR_TAREA_VS_USUARIO_PART2
		  ("TAR_ID", "USU_PENDIENTES", "USU_ALERTA", "USU_SUPERVISOR", "DD_TGE_ID_ALERTA", "DD_TGE_ID_PENDIENTE") AS 
		  SELECT tar.tar_id, etn.tar_id_dest usu_pendientes, usu.usu_id, -1, -1, -1
		FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tar
		JOIN '||V_ESQUEMA||'.etn_extareas_notificaciones etn on tar.TAR_ID = etn.TAR_ID
		LEFT JOIN '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_username = tar.tar_emisor
		WHERE tar.dd_sta_id IN (700,701) AND tar.borrado = 0
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