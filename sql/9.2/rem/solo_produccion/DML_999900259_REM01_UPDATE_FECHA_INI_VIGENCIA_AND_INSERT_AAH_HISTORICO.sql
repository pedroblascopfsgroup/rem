--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-196
--## PRODUCTO=NO
--##
--## Finalidad: Modificar la fecha de inicio de vigencia y el histórico y cambiarlo por la fecha real.
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_AGR_AGRUPACION';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-196';
    
    AGR_NUM_AGRUP_REM NUMBER(16):= 1000001553;
    
 BEGIN
 
 		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
 					  AGR_INI_VIGENCIA = TO_DATE(''19022018'', ''DDMMYYYY'')
 					, USUARIOMODIFICAR = '''||V_USUARIO||'''
 					, FECHAMODIFICAR   = SYSDATE
 					WHERE AGR_NUM_AGRUP_REM = '||AGR_NUM_AGRUP_REM||'
 					';
 					
 		EXECUTE IMMEDIATE V_SQL;
    	
              DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en el en ACT_AGR_AGRUPACION de la agrupación '||AGR_NUM_AGRUP_REM);

		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_VAS_VIGENCIA_ASISTIDAS (
					  ACT_VAS_AGR_ID
					, ACT_VAS_FECHA_FIN_VIGENCIA
					, ACT_VAS_FECHA_INICIO_VIGENCIA
					, ACT_VAS_ID
					, FECHACREAR
					, USUARIOCREAR
					) VALUES (
					  (SELECT AGR_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE AGR_NUM_AGRUP_REM = '||AGR_NUM_AGRUP_REM||')
					, (SELECT AGR_FIN_VIGENCIA FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE AGR_NUM_AGRUP_REM = '||AGR_NUM_AGRUP_REM||')
					, (SELECT AGR_INI_VIGENCIA FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE AGR_NUM_AGRUP_REM = '||AGR_NUM_AGRUP_REM||')
					, S_ACT_VAS_VIGENCIA_ASISTIDAS.NEXTVAL
					, SYSDATE
					, '''||V_USUARIO||'''
					)
    				';
    				
     	EXECUTE IMMEDIATE V_SQL;
		
        DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado '||SQL%ROWCOUNT||' registro en el histórico ACT_VAS_VIGENCIA_ASISTIDAS de la agrupación '||AGR_NUM_AGRUP_REM);
      
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
