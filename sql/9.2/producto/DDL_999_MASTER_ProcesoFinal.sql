--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=NOITEM
--## PRODUCTO=SI
--##
--## Finalidad: 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    
BEGIN
	
  FOR RS IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE UPPER(OWNER) = V_ESQUEMA_M ) LOOP  
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON ' || V_ESQUEMA_M || '.' || RS.TABLE_NAME || ' TO ' || V_ESQUEMA;  
  END LOOP;

  FOR RS IN (SELECT SEQUENCE_NAME FROM ALL_SEQUENCES WHERE UPPER(SEQUENCE_OWNER) = V_ESQUEMA_M) LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || V_ESQUEMA_M || '.' || RS.SEQUENCE_NAME || ' TO ' || V_ESQUEMA;
  END LOOP;

						
    
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;