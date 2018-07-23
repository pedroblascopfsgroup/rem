--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1207
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar relacion usuario - grupo
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
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1189';
	V_USERNAME VARCHAR2(32 CHAR) := 'iba';
	V_COUNT NUMBER;
 
 BEGIN

 --Ponemos el estado del o de los gastos en Autorizado Administración

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS GRU WHERE GRU.USU_ID_USUARIO = (
		SELECT USU.USU_ID
		FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
		WHERE USU.USU_USERNAME = '''||V_USERNAME||'''
    )';
     
    EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
    
    DBMS_OUTPUT.PUT_LINE('Existen '||V_COUNT||' grupos que contienen al usuario '||V_USERNAME);
    
    IF V_COUNT > 0 THEN
		
		V_SQL := 'UPDATE '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS GRU SET GRU.BORRADO = 1, GRU.FECHABORRAR = SYSDATE, GRU.USUARIOBORRAR = '''||V_USUARIO||'''
		WHERE GRU.USU_ID_USUARIO = (
			SELECT USU.USU_ID
			FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
			WHERE USU.USU_USERNAME = '''||V_USERNAME||'''
		)';
		
		EXECUTE IMMEDIATE V_SQL;
		
        
    DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registros en la GGE_GASTOS_GESTION');
    
    END IF;
 
 
	DBMS_OUTPUT.PUT_LINE('Terminado con exito');
	
	
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
