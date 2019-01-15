--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180923
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4513
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4513'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION DD_TAL_TIPO_ALQUILER');
	
	V_SQL := 'SELECT COUNT(1) FROM DD_TAL_TIPO_ALQUILER WHERE DD_TAL_DESCRIPCION = ''Fondo Social Vivienda o FSV''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TAL_TIPO_ALQUILER
			   SET DD_TAL_DESCRIPCION = ''Fondo Social Vivienda o FSV'',
				   DD_TAL_DESCRIPCION_LARGA = ''Fondo Social Vivienda o FSV'',
				   FECHAMODIFICAR = SYSDATE, 
				   USUARIOMODIFICAR = '''||V_USR||''' 
			   WHERE DD_TAL_CODIGO = ''03''';
    EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA DD_TAL_TIPO_ALQUILER');
	
	ELSE 
	
	DBMS_OUTPUT.PUT_LINE('[FIN] EL REGISTRO YA EXISTE');
	
	END IF;
	
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
