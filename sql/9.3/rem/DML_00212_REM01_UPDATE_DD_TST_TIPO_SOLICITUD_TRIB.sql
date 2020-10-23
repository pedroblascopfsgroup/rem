--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20200708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-10457
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar valores del diccionario DD_TST_TIPO_SOLICITUD_TRIB
--## INSTRUCCIONES:
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'DD_TST_TIPO_SOLICITUD_TRIB';  -- Tabla a modificar
    V_CHARS VARCHAR2(3 CHAR) := 'TST';
    V_USR VARCHAR2(30 CHAR) := 'HREOS-10457'; -- USUARIOBORRAR
    V_COUNT NUMBER(16); 
    
BEGIN	

		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
		IF V_COUNT > 0 THEN

	        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
	                    SET DD_'||V_CHARS||'_DESCRIPCION = ''Multa/Sanción'',
	                    DD_'||V_CHARS||'_DESCRIPCION_LARGA = ''Multa/Sanción'',
	                    USUARIOMODIFICAR = '''|| V_USR ||''',
	                    FECHAMODIFICAR = SYSDATE
	                    WHERE DD_'||V_CHARS||'_CODIGO IN (''03'')';
	                    
	    	EXECUTE IMMEDIATE V_MSQL;

        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[FIN] registros modificados correctamente.');
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT