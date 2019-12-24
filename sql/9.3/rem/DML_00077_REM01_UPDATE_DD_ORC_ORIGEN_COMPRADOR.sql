--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20191220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8873
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_ORC_ORIGEN_COMPRADOR los datos añadidos en T_ARRAY_DATA
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

BEGIN	
	
	--DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN');
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR SET DD_ORC_DESCRIPCION = ''API PROPIO'', DD_ORC_DESCRIPCION_LARGA = ''API_PROPIO'', USUARIOMODIFICAR = ''HREOS-8873'', FECHAMODIFICAR = SYSDATE WHERE DD_ORC_CODIGO = ''02''';
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_ORC_ORIGEN_COMPRADOR SET DD_ORC_DESCRIPCION = ''API AJENO'', DD_ORC_DESCRIPCION_LARGA = ''API_AJENO'', USUARIOMODIFICAR = ''HREOS-8873'', FECHAMODIFICAR = SYSDATE WHERE DD_ORC_CODIGO = ''05''';
    COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
