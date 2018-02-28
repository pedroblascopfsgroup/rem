--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-117
--## PRODUCTO=NO
--##
--## Finalidad: Dar fecha de baja a una agrupación para que la puedan activar desde web
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
    V_COUNT_INSERT NUMBER(16) := 0; --Vble. para contar inserciones o updateos de los loops
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR):= 'ACT_AGR_AGRUPACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-117';
		
 BEGIN
 			  
 V_SQL :=  'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
 				    AGR_FECHA_BAJA = SYSDATE
 				   , USUARIOMODIFICAR		= '''||V_USUARIO||'''
 				   , FECHAMODIFICAR			= SYSDATE
 				   WHERE AGR_NUM_AGRUP_REM = 2305424
 				   ';
 				   
 EXECUTE IMMEDIATE V_SQL;
 
  DBMS_OUTPUT.PUT_LINE('Dada de baja la agrupación 2305424');

 
 
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

