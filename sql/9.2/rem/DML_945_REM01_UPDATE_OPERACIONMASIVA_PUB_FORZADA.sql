--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20161015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-999
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade modifica la descripcion del masivo de publicacion forzada
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
    V_TEXT_DESCRIPCION VARCHAR2(1024 CHAR); -- Vble. auxiliar para indicar la descripcion a cambiar
    V_CODIGO_OPM VARCHAR2(1024 CHAR); -- Vble. auxiliar para indicar el codigo del masivo sobre el que realizar cambios

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_OPM_OPERACION_MASIVA'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN
  		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE LOS REGISTROS');

      V_TEXT_DESCRIPCION := 'Publicación forzada del activo';
      V_CODIGO_OPM := 'APUB';
  		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA opm ' ||
          ' SET opm.DD_OPM_DESCRIPCION = '''||V_TEXT_DESCRIPCION||''' ' ||
          ' , opm.DD_OPM_DESCRIPCION_LARGA = '''||V_TEXT_DESCRIPCION||''' ' ||
          ' , opm.USUARIOMODIFICAR = ''HREOS-999'' ' ||
          ' , opm.FECHAMODIFICAR = sysdate '||
  				' WHERE opm.DD_OPM_CODIGO = '''||V_CODIGO_OPM||''' ';
--      DBMS_OUTPUT.PUT_LINE('[MSQL] '||V_MSQL);
  		EXECUTE IMMEDIATE V_MSQL;
    	
    END IF;
    
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE LA DESCRIPCION DEL MASIVO '||V_TEXT_DESCRIPCION );
    
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