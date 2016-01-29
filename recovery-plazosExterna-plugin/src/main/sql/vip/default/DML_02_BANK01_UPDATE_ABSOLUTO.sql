--/*
--##########################################
--## Author: Carlos Perez
--## Finalidad: DML para setear el campo absoluto si la longitud es menor a 25
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	  
    -- ******** ASU_ASUNTOS - Añadir campos *******
    DBMS_OUTPUT.PUT_LINE('[INICIO] DD_PTP_PLAZOS_TAREAS_PLAZAS - UPDATE DD_PTP_ABSOLUTO');
    
    
    V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_ABSOLUTO=1 WHERE length(DD_PTP_PLAZO_SCRIPT)<25';
    EXECUTE IMMEDIATE V_SQL;    
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[END] Tabla DD_PTP_PLAZOS_TAREAS_PLAZAS actualizada correctamente');  
      
  
    
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