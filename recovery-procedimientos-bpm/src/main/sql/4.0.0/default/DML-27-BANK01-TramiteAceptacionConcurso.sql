--/*
--##########################################
--## Author: JoseVi Jimenez
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DDL Aumentar tamaño de un campo varchar2
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
    -- ******** Diccionarios previos ********

  DBMS_OUTPUT.PUT_LINE('[INFO] Cambio de valores en 2 registros de la tabla TAP_TAREA_PROCEDIMIENTO, en esquema '||V_ESQUEMA); 
  V_MSQL := 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_supervisor = 0, dd_sta_id = 39 where tap_codigo = ''P404_RegistrarAceptacionAsunto''';

  EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO cambiada tarea procedimiento P404_RegistrarAceptacionAsunto'); 


  V_MSQL := 'update '||V_ESQUEMA||'.tap_tarea_procedimiento set tap_supervisor = 1, dd_sta_id = 40 where tap_codigo = ''P404_ValidarAsignacionLetrado''';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO cambiada tarea procedimiento P404_ValidarAsignacionLetrado'); 
  
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;