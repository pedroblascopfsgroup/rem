--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150518
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1-rc03-hy
--## INCIDENCIA_LINK=HR-893
--## PRODUCTO=NO
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS' ||
	          ' SET USU_PASSWORD = ''HREMAD1234'' ' ||
	          ' WHERE USU_USERNAME IN (''G_ULI_H'',''S_ULI_H'',''D_ULI_H'',''ADMIN_H'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando password de usuarios.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Passwords actualizados.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS' ||
	          ' SET USU_PASSWORD = ''HREVLC1234'' ' ||
	          ' WHERE USU_USERNAME IN (''G_ULI_V'',''S_ULI_V'',''D_ULI_V'',''ADMIN_V'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando password de usuarios.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Passwords actualizados.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS' ||
	          ' SET USU_PASSWORD = ''Pintor32'' ' ||
	          ' WHERE USU_USERNAME IN (''GEST_ULI'',''SUPER_ULI'',''DTOR_ULI'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando password de usuarios.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Passwords actualizados.');
    
    COMMIT;

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
  	