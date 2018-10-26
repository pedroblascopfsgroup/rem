--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2290
--## PRODUCTO=NO
--##
--## Finalidad: Modificar descripcion tabla DD_TPD_TIPO_DOCUMENTO 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar      
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(30 CHAR):= 'DD_TPD_TIPO_DOCUMENTO';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_MAX_TPD_ID NUMBER(16,0);
    V_MAX_TPD_CODIGO VARCHAR2(20 CHAR);
    --V_TABLA_INSERT VARCHAR2(50 CHAR) := 'DD_TPD_TIPO_DOCUMENTO';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2290';
    
 BEGIN

 
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
				  DD_TPD_DESCRIPCION = ''Requerimientos administraciones o terceros de actuaciones''
    				, USUARIOMODIFICAR = '''||V_USUARIO||''' 
    				, FECHAMODIFICAR = SYSDATE 
    				  WHERE DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''70'') 
    				';
    				
         EXECUTE IMMEDIATE V_SQL;
      
	 DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la descripcion');

      
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
EXIT;
