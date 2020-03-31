--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200326
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6748
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
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'DD_OPM_OPERACION_MASIVA';  -- Tabla a modificar
    V_TEXT_TABLA2 VARCHAR2(30 CHAR) := 'FUN_FUNCIONES';  -- Tabla a modificar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6748'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  -- Comprobamos si existe el codigo   
  V_SQL := 'SELECT COUNT(1) FROM  '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_OPM_CODIGO = ''FORM''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  -- Si existe insertamos los datos
  IF V_NUM_TABLAS = 1 THEN
  
  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR '||V_ESQUEMA||'.'||V_TEXT_TABLA);

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		SET 
        	DD_OPM_DESCRIPCION = ''Actualizar Fecha de posicionamiento prevista'', 
        	DD_OPM_DESCRIPCION_LARGA = ''Carga masiva actualizar fecha de posicionamiento prevista'', 
        	USUARIOMODIFICAR = '''||V_USR||''', 
        	FECHAMODIFICAR = SYSDATE
        WHERE DD_OPM_CODIGO = ''FORM''';
        
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS '); 
        
	END IF;
	
	 -- Comprobamos si existe el codigo
  V_SQL := 'SELECT COUNT(1) FROM  '||V_ESQUEMA_M||'.'||V_TEXT_TABLA2||' WHERE FUN_DESCRIPCION = ''CARGA_MASIVA_ACTUALIZACION_FORMALIZACION''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  -- Si existe insertamos los datos
  IF V_NUM_TABLAS = 1 THEN

  DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR '||V_ESQUEMA_M||'.'||V_TEXT_TABLA2);
  
        V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.'||V_TEXT_TABLA2||' 
		SET 
        	FUN_DESCRIPCION_LARGA = ''Actualizar Fecha de posicionamiento prevista'',
        	USUARIOMODIFICAR = '''||V_USR||''', 
        	FECHAMODIFICAR = SYSDATE
        WHERE FUN_DESCRIPCION = ''CARGA_MASIVA_ACTUALIZACION_FORMALIZACION''';
        
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS '); 
        
	END IF;

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO DE ACTUALIZACION TERMINADO CORRECTAMENTE');
  
EXCEPTION
    WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;

    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE(ERR_MSG);
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT