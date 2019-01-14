--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2322
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2322';
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_ID VARCHAR2(55 CHAR);

BEGIN

--BUSCA Y ACTUALIZA TRABAJOS SIN RESPONSABLE QUE TENGAS AGRUPACIONES, DESDE ENERO DE 2018

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion.');
		
		V_SQL := '   MERGE INTO REM01.ACT_TBJ_TRABAJO T1
					USING (
						SELECT TBJ.TBJ_ID, 
						SUB.ACT_ID, 
						MAX(USU.USU_ID) AS USUARIO_GEST_ACTIVO 
						FROM REM01.ACT_TBJ_TRABAJO TBJ 
						JOIN  (SELECT TTB.TBJ_ID, MAX(TTB.ACT_ID) AS ACT_ID 
						       FROM REM01.ACT_TBJ TTB 
						       GROUP BY TTB.TBJ_ID) SUB 
						ON SUB.TBJ_ID = TBJ.TBJ_ID
						JOIN REM01.GAC_GESTOR_ADD_ACTIVO    GAC
						ON GAC.ACT_ID = SUB.ACT_ID
						JOIN REM01.GEE_GESTOR_ENTIDAD       GEE
						ON GEE.GEE_ID = GAC.GEE_ID
						JOIN REMMASTER.DD_TGE_TIPO_GESTOR   TGE
						ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
						JOIN REMMASTER.USU_USUARIOS         USU
						ON USU.USU_ID = GEE.USU_ID
						WHERE TBJ.ACT_ID IS NULL 
						AND TBJ.AGR_ID IS NULL 
						AND TBJ.TBJ_RESPONSABLE_TRABAJO IS NULL 
						AND TBJ.BORRADO = 0 
						AND TBJ.TBJ_FECHA_FIN IS NULL 
						AND TGE.DD_TGE_CODIGO = ''GACT'' 
						AND TBJ.FECHACREAR >= TO_DATE(''01/01/2018'',''dd/mm/YYYY'') 
						GROUP BY TBJ.TBJ_ID,SUB.ACT_ID 
                    			)T2
					ON (T1.TBJ_ID = T2.TBJ_ID)
					WHEN MATCHED THEN 
					UPDATE SET 
						T1.TBJ_RESPONSABLE_TRABAJO = T2.USUARIO_GEST_ACTIVO,
						T1.USUARIOMODIFICAR = ''REMVIP-2322'',
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
