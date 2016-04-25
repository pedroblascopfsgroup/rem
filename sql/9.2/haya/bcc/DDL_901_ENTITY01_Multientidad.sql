--/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=NOITEM
--## PRODUCTO=NO
--##
--## Finalidad: Conceder permisos de acceso a las tablas PEF_PERFILES, ZON_PEF_USU, FUN_PEF al usuario de la otra entidad
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
    V_ESQUEMA_2 VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema 01

    V_MSQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar 

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    
BEGIN
	
IF V_ESQUEMA = '' OR V_ESQUEMA_2 = '' THEN
   DBMS_OUTPUT.put_line('No parece haber sido configurada la multientidad: ' || V_ESQUEMA || ', ' || V_ESQUEMA_2);
ELSE 
   V_MSQL := 'GRANT SELECT ON ' || V_ESQUEMA || '.PEF_PERFILES TO ' || V_ESQUEMA_2;
   EXECUTE IMMEDIATE V_MSQL;

   V_MSQL := 'GRANT SELECT ON ' || V_ESQUEMA || '.ZON_PEF_USU TO ' || V_ESQUEMA_2;
   EXECUTE IMMEDIATE V_MSQL;

   V_MSQL := 'GRANT SELECT ON ' || V_ESQUEMA || '.FUN_PEF TO ' || V_ESQUEMA_2;
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.put_line('Permisos de acceso concedidos a las tablas.');
END IF;
    
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
