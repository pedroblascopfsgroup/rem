--/*
--##########################################
--## AUTOR=LORENZO LERATE
--## FECHA_CREACION=20160428
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
SET DEFINE OFF;

DECLARE

    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    loop_cycle   NUMBER(25); -- Vble. para validar la existencia de una columna. 
    
    cursor c1 is
     select * from cm01.cir_cirbe 
     where CIR_FECHA_EXTRACCION = TO_DATE('29/2/16', 'dd/mm/yy');

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
            
    loop_cycle := 0;

   FOR cirbe_rec in c1
   LOOP
  
      DELETE FROM cm01.cir_cirbe WHERE CIR_ID = cirbe_rec.CIR_ID;
      loop_cycle := loop_cycle + 1;
     IF MOD(loop_cycle, 1000 ) = 0 THEN
        COMMIT;
      END IF;
   END LOOP;
  
  DBMS_OUTPUT.put_line('Eliminados '||loop_cycle||' registros de CIR_CIRBE con fecha extracción 29/02/16.');

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
