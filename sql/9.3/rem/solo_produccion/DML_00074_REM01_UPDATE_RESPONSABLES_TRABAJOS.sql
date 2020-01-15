--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6174
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-6174';
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_ID VARCHAR2(55 CHAR);

BEGIN

--BUSCA Y ACTUALIZA  RESPONSABLE TRABAJOS 

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion DE TRABAJOS DE EXCEL (AUX_TBJ_TAR_EXCEL_REMVIP_6174).');
		
		V_SQL := '   MERGE INTO REM01.ACT_TBJ_TRABAJO T1
					USING (
						SELECT TBJ.TBJ_NUM_TRABAJO FROM REM01.ACT_TBJ_TRABAJO TBJ 
						INNER JOIN REM01.AUX_TBJ_TAR_EXCEL_REMVIP_6174 TBJ1 ON TBJ1.TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO 
                    			)T2
					ON (T1.TBJ_NUM_TRABAJO = T2.TBJ_NUM_TRABAJO)
					WHEN MATCHED THEN 
					UPDATE SET 
						T1.TBJ_RESPONSABLE_TRABAJO = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''grupgact''),
						T1.USUARIOMODIFICAR = ''REMVIP-6174.1'',
						T1.FECHAMODIFICAR = SYSDATE
		';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla de trabajos.');

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion DE TRABAJOS NO DE EXCEL (AUX_TBJ_TAR_NO_EXCEL_REMVIP_6174).');
		
		V_SQL := '   MERGE INTO REM01.ACT_TBJ_TRABAJO T1
					USING (
						SELECT TBJ.TBJ_NUM_TRABAJO FROM REM01.ACT_TBJ_TRABAJO TBJ 
						INNER JOIN REM01.AUX_TBJ_TAR_NO_EXCEL_REMVIP_6174 TBJ1 ON TBJ1.TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO 
                    			)T2
					ON (T1.TBJ_NUM_TRABAJO = T2.TBJ_NUM_TRABAJO)
					WHEN MATCHED THEN 
					UPDATE SET 
						T1.TBJ_RESPONSABLE_TRABAJO = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''grupgact''),
						T1.USUARIOMODIFICAR = ''REMVIP-6174.2'',
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
