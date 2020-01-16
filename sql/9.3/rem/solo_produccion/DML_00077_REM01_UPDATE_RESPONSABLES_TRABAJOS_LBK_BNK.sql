--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200116
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6196
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-6196';
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_ID VARCHAR2(55 CHAR);

BEGIN

--BUSCA Y ACTUALIZA  RESPONSABLE TRABAJOS 

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion DE TRABAJOS');
		
		V_SQL := '   MERGE INTO REM01.ACT_TBJ_TRABAJO T1
					USING (
						SELECT TBJ_NUM_TRABAJO 
						FROM REM01.ACT_TBJ_TRABAJO 
						WHERE TBJ_NUM_TRABAJO IN (9000266877,
									9000267163,
									9000267170,
									9000267585,
									9000267684,
									9000267924,
									9000268522,
									9000268641,
									9000268693,
									9000268697,
									9000269410,
									9000269427,
									9000269437,
									9000269573,
									9000269901,
									9000271393,
									9000271522,
									9000272458,
									9000272491,
									9000272504,
									9000272600,
									9000272636,
									9000272960,
									9000273470,
									9000273679,
									9000274675,
									9000274678,
									9000274694,
									9000275156,
									9000275165,
									9000275172,
									9000275182,
									9000275205,
									9000275339,
									9000276457,
									9000276673,
									9000276920,
									9000276991,
									9000276992,
									9000277096,
									9000277101,
									9000269332,
									9000269336,
									9000271400,
									9000271761,
									9000272561,
									9000273063,
									9000273512,
									9000273518,
									9000273531,
									9000273532,
									9000273535,
									9000273537,
									9000273547,
									9000273548,
									9000273914,
									9000274278,
									9000274293,
									9000274640,
									9000274715,
									9000274954,
									9000274972,
									9000274973,
									9000275248
									)
                    			)T2
					ON (T1.TBJ_NUM_TRABAJO = T2.TBJ_NUM_TRABAJO)
					WHEN MATCHED THEN 
					UPDATE SET 
						T1.TBJ_RESPONSABLE_TRABAJO = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''grupgact''),
						T1.USUARIOMODIFICAR = ''REMVIP-6174.3'',
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
