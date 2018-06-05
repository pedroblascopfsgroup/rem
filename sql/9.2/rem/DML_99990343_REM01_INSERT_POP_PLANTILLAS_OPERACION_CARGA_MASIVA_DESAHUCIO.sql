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
    V_TABLA VARCHAR2(25 CHAR):= 'POP_PLANTILLAS_OPERACION';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-899';

BEGIN


	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
				  POP_ID
				, POP_NOMBRE
				, POP_DIRECTORIO
				, DD_OPM_ID
				, USUARIOCREAR
				, FECHACREAR
				) VALUES (
				  '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
				, ''FECHA_SOLICITUD_DESAHUCIO''
				, ''plantillas/plugin/masivo/CARGA_FECHA_SOLICITUD_DESAHUCIO.xls''
				, (SELECT DD_OPM_ID FROM '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = ''FSD'')
				, '''||V_USUARIO||'''
				, SYSDATE
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
