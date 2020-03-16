--/*
--##########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9578
--## PRODUCTO=NO
--##
--## Finalidad: Modificar la descripción y la descripción larga de la tabla DD_EEC_EST_EXP_COMERCIAL
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
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'DD_EEC_EST_EXP_COMERCIAL';  -- Tabla a modificar
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-9578'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

  -- Comprobamos si existe la tabla   
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  -- Si existe la tabla modificamos los datos
  IF V_NUM_TABLAS = 1 THEN

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET 
        DD_EEC_DESCRIPCION = ''Pendiente Sanción Comité''
        , DD_EEC_DESCRIPCION_LARGA = ''Pendiente Sanción Comité''
        , USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        WHERE DD_EEC_CODIGO =''31''';        
        
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET 
        DD_EEC_DESCRIPCION = ''Pdte respuesta ofertante Comité''
        , DD_EEC_DESCRIPCION_LARGA = ''Pdte respuesta ofertante Comité''
        , USUARIOMODIFICAR = '''||V_USUARIO||'''
        , FECHAMODIFICAR = SYSDATE
        WHERE DD_EEC_CODIGO =''43''';
        
        EXECUTE IMMEDIATE V_MSQL;

  END IF;
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT