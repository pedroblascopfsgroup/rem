--/*
--##########################################
--## AUTOR=Sergio Hernández
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

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
	X NUMBER;

  BEGIN
  
   	-- Verificar si ya existe el JOB
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SCHEDULER_JOBS WHERE JOB_NAME = ''JOB_AGR_ASISTIDA_PROCESO_FIN''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.JOB_AGR_ASISTIDA_PROCESO_FIN... Ya existe. Se borrará.');
		DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'JOB_AGR_ASISTIDA_PROCESO_FIN');
	END IF;
	
--No se volverá a crear... nunca... pero lo dejo aquí como curiosidad.	
--  DBMS_SCHEDULER.CREATE_JOB (
--   job_name             => 'JOB_AGR_ASISTIDA_PROCESO_FIN',
--   job_type             => 'PLSQL_BLOCK',
--   job_action           => V_ESQUEMA || '.AGR_ASISTIDA_PROCESO_FIN;',
--   start_date           => to_date('26/04/2016 00:35:00','dd/mm/yyyy hh24:mi:ss'),
--   repeat_interval      => 'FREQ=DAILY', 
--   enabled              =>  TRUE,
 --  comments             => 'Job de procesado de datos para agrupaciones asistidas vencidas');
  
--DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Job creado.');
	
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
