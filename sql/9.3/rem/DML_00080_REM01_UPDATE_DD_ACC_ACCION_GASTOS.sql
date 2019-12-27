--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20191226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8872
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_ACC_ACCION_GASTOS un registro
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
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS SET DD_ACC_DESCRIPCION = ''Colaboración no Haya'', DD_ACC_DESCRIPCION_LARGA = ''Colaboración no Haya'', USUARIOMODIFICAR = ''HREOS-8872'', FECHAMODIFICAR = SYSDATE WHERE DD_ACC_CODIGO = ''05''';
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
