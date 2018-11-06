--/*
--###########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181030
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2328
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizaciones de activos en agrupacion asistida.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
  
  
BEGIN		
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...');

	V_MSQL :=  'MERGE INTO REM01.BIE_ADJ_ADJUDICACION T1
				USING (
					SELECT BIE_ADJ_ID, FECHA_POSESION_PRINEX FROM (
						SELECT DISTINCT ACT.ACT_NUM_ACTIVO                                                                                                                      AS ACTIVO,
							   ADJ.BIE_ADJ_ID,
							   CRA.DD_CRA_DESCRIPCION                                                                                                                           AS CARTERA,
							   AUX.FECHA_POSESION_PRINEX                                                                                                                        AS FECHA_POSESION_PRINEX,  
							   ADJ.BIE_ADJ_F_REA_POSESION                                                                                                                       AS FECHA_POSESION_REM_BIEN, 
							   SPS.SPS_FECHA_TOMA_POSESION                                                                                                                      AS FECHA_POSESION_REM_ACTIVO,
							   CASE WHEN NVL(AUX.FECHA_POSESION_PRINEX,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) <> NVL(ADJ.BIE_ADJ_F_REA_POSESION,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) THEN ''DISTINTAS'' ELSE ''IGUALES'' END    AS PRINEX_vs_BIEN,
							   CASE WHEN NVL(AUX.FECHA_POSESION_PRINEX,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) <> NVL(SPS.SPS_FECHA_TOMA_POSESION,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) THEN ''DISTINTAS'' ELSE ''IGUALES'' END   AS PRINEX_vs_ACTIVO,
							   CASE WHEN NVL(ADJ.BIE_ADJ_F_REA_POSESION,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) <> NVL(SPS.SPS_FECHA_TOMA_POSESION,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) THEN ''DISTINTAS'' ELSE ''IGUALES'' END  AS BIEN_vs_ACTIVO,
							   case when  AUX.FECHA_POSESION_PRINEX  is null THEN ''prinex_nulo'' when (AUX.FECHA_POSESION_PRINEX  is not null and AUX.FECHA_POSESION_PRINEX < SPS.SPS_FECHA_TOMA_POSESION) then ''prinex_menor_que_sps'' else ''prinex_mayor_igual_que_sps'' end as mayor_menor,
							   SPS.USUARIOMODIFICAR,
							   SPS.FECHAMODIFICAR,
							   case when ADJ.BIE_ADJ_F_REA_POSESION is not null and (ADJ.BIE_ADJ_F_REA_POSESION > SPS.SPS_FECHA_TOMA_POSESION) then ''adj_mayor_que_sps'' else ''OK'' end as cosa
						FROM REM_EXT.TMP_FECHA_POSESION_AUX AUX
						JOIN REM01.ACT_ACTIVO               ACT
						ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
						JOIN REM01.DD_CRA_CARTERA           CRA
						ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
						JOIN REM01.BIE_BIEN                 BIE
						ON BIE.BIE_ID = ACT.BIE_ID
						JOIN REM01.BIE_ADJ_ADJUDICACION     ADJ
						ON ADJ.BIE_ID = BIE.BIE_ID
						JOIN REM01.ACT_SPS_SIT_POSESORIA    SPS
						ON SPS.ACT_ID = ACT.ACT_ID
						JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM
						ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
						WHERE ACT.DD_SCM_ID NOT IN (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05'')
						ORDER BY 1 ASC
					)
					WHERE PRINEX_vs_ACTIVO = ''DISTINTAS''
				) T2
				ON (T1.BIE_ADJ_ID = T2.BIE_ADJ_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.BIE_ADJ_F_REA_POSESION = T2.FECHA_POSESION_PRINEX,
					T1.USUARIOMODIFICAR = ''REMVIP-2328'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza la fecha de posesion de '||SQL%ROWCOUNT||' activos en la BIE_ADJ_ADJUDICACION.');  
	
	V_MSQL :=  'MERGE INTO REM01.ACT_SPS_SIT_POSESORIA T1
				USING (
					SELECT SPS_ID, FECHA_POSESION_PRINEX FROM (
						SELECT DISTINCT ACT.ACT_NUM_ACTIVO                                                                                                                      AS ACTIVO,
							   SPS.SPS_ID,
							   CRA.DD_CRA_DESCRIPCION                                                                                                                           AS CARTERA,
							   AUX.FECHA_POSESION_PRINEX                                                                                                                        AS FECHA_POSESION_PRINEX,  
							   ADJ.BIE_ADJ_F_REA_POSESION                                                                                                                       AS FECHA_POSESION_REM_BIEN, 
							   SPS.SPS_FECHA_TOMA_POSESION                                                                                                                      AS FECHA_POSESION_REM_ACTIVO,
							   CASE WHEN NVL(AUX.FECHA_POSESION_PRINEX,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) <> NVL(ADJ.BIE_ADJ_F_REA_POSESION,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) THEN ''DISTINTAS'' ELSE ''IGUALES'' END    AS PRINEX_vs_BIEN,
							   CASE WHEN NVL(AUX.FECHA_POSESION_PRINEX,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) <> NVL(SPS.SPS_FECHA_TOMA_POSESION,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) THEN ''DISTINTAS'' ELSE ''IGUALES'' END   AS PRINEX_vs_ACTIVO,
							   CASE WHEN NVL(ADJ.BIE_ADJ_F_REA_POSESION,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) <> NVL(SPS.SPS_FECHA_TOMA_POSESION,TRUNC(to_date(''26/10/2019'',''dd/mm/yyyy''))) THEN ''DISTINTAS'' ELSE ''IGUALES'' END  AS BIEN_vs_ACTIVO,
							   case when  AUX.FECHA_POSESION_PRINEX  is null THEN ''prinex_nulo'' when (AUX.FECHA_POSESION_PRINEX  is not null and AUX.FECHA_POSESION_PRINEX < SPS.SPS_FECHA_TOMA_POSESION) then ''prinex_menor_que_sps'' else ''prinex_mayor_igual_que_sps'' end as mayor_menor,
							   SPS.USUARIOMODIFICAR,
							   SPS.FECHAMODIFICAR,
							   case when ADJ.BIE_ADJ_F_REA_POSESION is not null and (ADJ.BIE_ADJ_F_REA_POSESION > SPS.SPS_FECHA_TOMA_POSESION) then ''adj_mayor_que_sps'' else ''OK'' end as cosa
						FROM REM_EXT.TMP_FECHA_POSESION_AUX AUX
						JOIN REM01.ACT_ACTIVO               ACT
						ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
						JOIN REM01.DD_CRA_CARTERA           CRA
						ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
						JOIN REM01.BIE_BIEN                 BIE
						ON BIE.BIE_ID = ACT.BIE_ID
						JOIN REM01.BIE_ADJ_ADJUDICACION     ADJ
						ON ADJ.BIE_ID = BIE.BIE_ID
						JOIN REM01.ACT_SPS_SIT_POSESORIA    SPS
						ON SPS.ACT_ID = ACT.ACT_ID
						JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM
						ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
						WHERE ACT.DD_SCM_ID NOT IN (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05'')
						ORDER BY 1 ASC
					)
					WHERE PRINEX_vs_ACTIVO = ''DISTINTAS''
				) T2
				ON (T1.SPS_ID = T2.SPS_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.SPS_FECHA_TOMA_POSESION = T2.FECHA_POSESION_PRINEX,
					T1.USUARIOMODIFICAR = ''REMVIP-2328'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza la fecha de posesion de '||SQL%ROWCOUNT||' activos en la ACT_SPS_SIT_POSESORIA.');  
	
	COMMIT;  
	DBMS_OUTPUT.PUT_LINE('[FIN]: Fin del proceso.');
 

EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;
/
EXIT
