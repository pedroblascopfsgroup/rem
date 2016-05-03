--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160502
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=NO
--## PRODUCTO=NO
--## Finalidad: DML
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    NUM_CIRBE   NUMBER(25):=1; -- Vble. para validar la existencia de una columna. 
    
BEGIN

  FOR c IN
    (SELECT c.owner, c.table_name, c.constraint_name
    FROM user_constraints c
    WHERE c.table_name = 'CIR_CIRBE'
    AND c.status = 'ENABLED'
    AND NOT c.constraint_type = 'P'
    ORDER BY c.constraint_type DESC)
  LOOP
    dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" disable constraint ' || c.constraint_name);
  END LOOP;
    
      SELECT COUNT(1) INTO NUM_CIRBE FROM CIR_CIRBE WHERE CIR_FECHA_EXTRACCION = TO_DATE('29/02/16', 'dd/mm/yy');
 WHILE NUM_CIRBE>0           
LOOP 
      DELETE FROM cm01.cir_cirbe WHERE CIR_FECHA_EXTRACCION = TO_DATE('29/02/16', 'dd/mm/yy') AND ROWNUM < 10000;
      COMMIT;
       SELECT COUNT (1)INTO NUM_CIRBE FROM CIR_CIRBE WHERE CIR_FECHA_EXTRACCION = TO_DATE('29/02/16', 'dd/mm/yy');
END LOOP;
  

 FOR c IN
    (SELECT c.owner, c.table_name, c.constraint_name
    FROM user_constraints c
    WHERE c.table_name = 'CIR_CIRBE'
    AND c.status = 'DISABLED'
    AND NOT c.constraint_type = 'P'
    ORDER BY c.constraint_type DESC)
  LOOP
    dbms_utility.exec_ddl_statement('alter table "' || c.owner || '"."' || c.table_name || '" enable constraint ' || c.constraint_name);
  END LOOP;
    
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
