--/*
--#########################################
--## AUTOR=JUANJO ARBONA
--## FECHA_CREACION=20180628
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1163
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
    V_SQL_UPDATE_ACTIVO VARCHAR2(32000 CHAR); -- Sentencia a ejecutar (update del activo)
	V_SQL_UPDATE_PUBLICACION VARCHAR2(32000 CHAR); -- Sentencia a ejecutar (update de la publicación)
	V_SQL_INSERT VARCHAR2(32000 CHAR); -- Sentencia a ejecutar insert         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA_ACTIVO VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
	V_TABLA_HIST_PUBL VARCHAR2(30 CHAR):= 'ACT_HEP_HIST_EST_PUBLICACION';
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1163';
	ACT_NUM_ACTIVO NUMBER(16) := 192894;
	ACT_ID NUMBER(16);
BEGIN

		EXECUTE IMMEDIATE 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO INTO ACT_ID;
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' WHERE ACT_ID = '||ACT_ID INTO V_COUNT;

		IF V_COUNT > 0 THEN
			V_SQL_UPDATE_ACTIVO := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' SET
						 DD_EPU_ID = 1
					   , USUARIOMODIFICAR = '''||V_USUARIO||'''
					   , FECHAMODIFICAR = SYSDATE
					   WHERE ACT_ID = '||ACT_ID;
			EXECUTE IMMEDIATE V_SQL_UPDATE_ACTIVO;

			V_SQL_UPDATE_PUBLICACION := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_HIST_PUBL||' SET
						 HEP_FECHA_HASTA = SYSDATE
					   , USUARIOMODIFICAR = '''||V_USUARIO||'''
					   , FECHAMODIFICAR = SYSDATE
					   WHERE ACT_ID = '||ACT_ID||'
						AND HEP_FECHA_HASTA IS NULL';
			EXECUTE IMMEDIATE V_SQL_UPDATE_PUBLICACION;

			DBMS_OUTPUT.PUT_LINE('ACTUALIZADO EL '||ACT_NUM_ACTIVO);

			V_SQL_INSERT := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HIST_PUBL||' (
						HEP_ID						
						, ACT_ID
						, HEP_FECHA_DESDE
						, DD_POR_ID
						, DD_TPU_ID
						, DD_EPU_ID
						, VERSION
						, USUARIOCREAR
						, FECHACREAR
						, BORRADO
						) VALUES (
						  '||V_ESQUEMA||'.S_'||V_TABLA_HIST_PUBL||'.NEXTVAL
						, '||ACT_ID||'
						, SYSDATE
						, 1
						, 1
						, 1
						, 0
						, '''||V_USUARIO||'''
						, SYSDATE
						, 0
						)
						';
			EXECUTE IMMEDIATE V_SQL_INSERT;
						DBMS_OUTPUT.PUT_LINE('UPDATEADO EL '||ACT_NUM_ACTIVO);
END IF;			    
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] SE HA UPDATEADO LA PUBLICACION DEL ACTIVO '||ACT_NUM_ACTIVO);

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
