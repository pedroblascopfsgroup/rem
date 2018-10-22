--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2247
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= '';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2247';
	ACT_NUM_ACTIVO NUMBER(16);
	ACT_ID VARCHAR2(55 CHAR);

BEGIN


		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion.');
		
		V_SQL := '  MERGE INTO REM01.ACT_TBJ_TRABAJO T1
					USING (
						SELECT TBJ.TBJ_ID,
							   ACT.ACT_ID, 
							   USU.USU_ID 
						FROM REM01.ACT_TBJ_TRABAJO          TBJ
						JOIN REM01.ACT_ACTIVO               ACT
						  ON ACT.ACT_ID = TBJ.ACT_ID
						JOIN REM01.GAC_GESTOR_ADD_ACTIVO    GAC
						  ON GAC.ACT_ID = ACT.ACT_ID
						JOIN REM01.GEE_GESTOR_ENTIDAD       GEE
						  ON GEE.GEE_ID = GAC.GEE_ID
						JOIN REMMASTER.DD_TGE_TIPO_GESTOR   TGE
						  ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
						JOIN REMMASTER.USU_USUARIOS         USU
						  ON USU.USU_ID = GEE.USU_ID
						WHERE TBJ.TBJ_RESPONSABLE_TRABAJO IS NULL
						  AND TGE.DD_TGE_CODIGO = ''GACT''
						  AND ACT.BORRADO = 0
						  AND USU.BORRADO = 0
						GROUP BY  TBJ.TBJ_ID,ACT.ACT_ID,USU.USU_ID 
					) T2
					ON (T1.TBJ_ID = T2.TBJ_ID)
					WHEN MATCHED THEN 
					UPDATE SET 
						T1.TBJ_RESPONSABLE_TRABAJO = T2.USU_ID,
						T1.USUARIOMODIFICAR = ''REMVIP-2247'',
						T1.FECHAMODIFICAR = SYSDATE
		';
		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla de trabajos.');
		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de actualizacion.');

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
