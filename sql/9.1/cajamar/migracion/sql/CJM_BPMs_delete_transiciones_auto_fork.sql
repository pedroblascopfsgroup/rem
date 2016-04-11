--/*
--##########################################
--## Author: Gonzalo
--## ELimina las transiciones automáticas generadas a los FORKs del BPM
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('LIMPIANDO FORKs TRANSICIONES AUTOMATICAS... ');

  EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA_M||'.JBPM_TRANSITION where id_ in (select tr.id_
			from '||V_ESQUEMA_M||'.JBPM_TRANSITION tr 
			 join '||V_ESQUEMA_M||'.JBPM_NODE nd on tr.from_ = nd.id_
			where tr.from_ = tr.to_ and nd.class_ = ''F'')';

  DBMS_OUTPUT.PUT_LINE('FIN LIMPIAR FORKs TRANSICIONES AUTOMATICAS ');

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