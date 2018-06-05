--/*
--#########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180605
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-899
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'DD_OPM_OPERACION_MASIVA';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-899';

	ACT_NUM_ACTIVO NUMBER(16);
	PVE_COD_REM VARCHAR2(55 CHAR);
	ICM_ID NUMBER(16);

BEGIN

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
				  DD_OPM_ID
				, DD_OPM_CODIGO
				, DD_OPM_DESCRIPCION
				, DD_OPM_DESCRIPCION_LARGA
				, FUN_ID
				, USUARIOCREAR
				, FECHACREAR
				, DD_OPM_VALIDACION_FORMATO
				) VALUES (
				  '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
				, ''FSD''
				, ''Carga masiva de fecha de solicitud de desahucio''
				, ''Carga masiva de fecha de solicitud de desahucio''
				, (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE USUARIOCREAR = '''||V_USUARIO||''')
				, '''||V_USUARIO||'''
				, SYSDATE
				, ''nD*,f''
				)
				';
 	
 	EXECUTE IMMEDIATE V_SQL;
 	
 	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' valores en la tabla '||V_TABLA);
 	
	COMMIT;


EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
