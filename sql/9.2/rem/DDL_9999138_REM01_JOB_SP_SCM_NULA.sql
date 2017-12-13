--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171213
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.11
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    err_num NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    err_msg VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_JOB_NAME VARCHAR2(30 CHAR) := 'JOB_SCM_NULOS';

BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    -- Verificar si ya existe el JOB
  V_MSQL := 'SELECT COUNT(1) FROM ALL_SCHEDULER_JOBS WHERE JOB_NAME = '''||V_JOB_NAME||'''';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
  IF V_NUM_TABLAS = 1 THEN
    DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_JOB_NAME||'... Ya existe. Se borrará.');
    DBMS_SCHEDULER.DROP_JOB(JOB_NAME => ''||V_JOB_NAME||'');
  END IF;
  
    DBMS_SCHEDULER.CREATE_JOB (
        job_name             => ''||V_JOB_NAME||'',
        job_type             => 'PLSQL_BLOCK',
        job_action           => 'BEGIN '||V_ESQUEMA||'.SP_ASC_ACT_SIT_COM_VACIOS(0,0); END;',
        start_date           => to_date('29/12/2017 00:00:00','dd/mm/yyyy hh24:mi:ss'),
        repeat_interval      => 'FREQ=DAILY; BYHOUR=06,14,22;',
        enabled              =>  TRUE,
        comments             => 'Job que ejecuta el SP que pone situacion comercial a los activos que no la tengan.');
    DBMS_OUTPUT.PUT_LINE('  [INFO] Proceso ejecutado CORRECTAMENTE. Job '||V_ESQUEMA||'.'||V_JOB_NAME||' creado.');
    DBMS_OUTPUT.PUT_LINE('[FIN]');
  
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
