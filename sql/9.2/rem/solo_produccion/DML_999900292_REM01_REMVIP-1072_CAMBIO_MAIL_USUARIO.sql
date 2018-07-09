--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1072
--## PRODUCTO=NO
--##
--## Finalidad: Cambio mail para la usuaria CLOTILDE CARBONELL HERNANDEZ
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1072';
	V_COUNT NUMBER;
 
 BEGIN

 --Ponemos el estado del o de los gastos en Autorizado Administración

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''tch''
    '
    ;
    EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
    
    IF V_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('EL USUARIO tch existe');
    
    V_SQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_MAIL = ''tch@haya.es'', FECHAMODIFICAR = SYSDATE, USUARIOMODIFICAR = '''||V_USUARIO||'''
    WHERE USU_USERNAME = ''tch''';
    EXECUTE IMMEDIATE V_SQL;
    
        
    DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registros en la GGE_GASTOS_GESTION');
	
	END IF;
	
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
