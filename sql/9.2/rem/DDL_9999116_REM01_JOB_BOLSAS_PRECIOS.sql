--/*
--##########################################
--## AUTOR=Daniel Gutiérrez
--## FECHA_CREACION=20170809
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
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
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SCHEDULER_JOBS WHERE JOB_NAME = ''JOB_ACTUALIZA_BOLSAS''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.JOB_ACTUALIZA_BOLSAS... Ya existe. Se borrará.');
		DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'JOB_AVISO_VENCIMIENTO_RESERVA');
	END IF;
	
	
  DBMS_SCHEDULER.CREATE_JOB (
   job_name             => 'JOB_ACTUALIZA_BOLSAS',
   job_type             => 'PLSQL_BLOCK',
   job_action           => 'DECLARE SALIDA VARCHAR2(4000 CHAR) BEGIN '||V_ESQUEMA||'.ACTUALIZA_ACT_IND_PRECIOS(NULL,NULL,SALIDA); END;',
   start_date           => to_date('09/08/2017 01:30:00','dd/mm/yyyy hh24:mi:ss'),
   repeat_interval      => 'FREQ=DAILY', 
   --end_date             => '15-SEP-08 1.00.00AM US/Pacific',
   enabled              =>  TRUE,
   comments             => 'Job de actualización de bolsas de precios');
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Job creado.');
	
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
