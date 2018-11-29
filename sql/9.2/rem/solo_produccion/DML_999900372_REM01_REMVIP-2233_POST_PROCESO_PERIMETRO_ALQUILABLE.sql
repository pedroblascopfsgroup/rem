--/*
--###########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20181023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2233
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso posterior al lanzado en el perímetro alquilable para solucionar alguna incidencia.
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

	V_MSQL :=  'MERGE INTO REM01.ACT_ACTIVO                   		T1
				USING (
					SELECT DISTINCT ACT.ACT_ID AS ACT_ID
					FROM REM01.ACT_ACTIVO                   		ACT
					JOIN REM01.AUX_MMC_PER_519_ACT_NO_EXCEL 		AUX
					  ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO
					LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM
					  ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
					WHERE SCM.DD_SCM_CODIGO NOT IN (''05'')
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.DD_TCO_ID = (SELECT TCO.DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION TCO WHERE TCO.DD_TCO_CODIGO = ''01''),
					T1.USUARIOMODIFICAR = ''REMVIP-2233'',
					T1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza el destino comercial de '||SQL%ROWCOUNT||' activos (no vendidos) a Venta.');  
	
	V_MSQL :=  'MERGE INTO REM01.ACT_ACTIVO TABLA1
				USING 
				(
				SELECT ACT.ACT_ID,
					   CASE WHEN SCM.DD_SCM_CODIGO NOT IN (''01'',''05'',''06'',''09'') 
							 AND TCO.DD_TCO_ID = (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''03'')  
							 AND OFERTAS_VIVAS.ACT_ID IS NULL                                                                           
							 AND RESERVA_APROB.ACT_ID IS NULL                                                                           THEN (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''07'')  
							WHEN SCM.DD_SCM_CODIGO NOT IN (''01'',''05'',''06'',''09'') 
							 AND TCO.DD_TCO_ID = (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''02'')  
							 AND OFERTAS_VIVAS.ACT_ID IS NULL                                                                           
							 AND RESERVA_APROB.ACT_ID IS NULL                                                                           THEN (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''08'')  
							WHEN SCM.DD_SCM_CODIGO NOT IN (''01'',''05'',''06'',''09'') 
							 AND TCO.DD_TCO_ID = (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''01'')  
							 AND OFERTAS_VIVAS.ACT_ID IS NULL                                                                           
							 AND RESERVA_APROB.ACT_ID IS NULL                                                                           THEN (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02'')  
							ELSE SCM.DD_SCM_ID                                                                       
					   END AS SITUACION_A_CAMBIAR
				FROM REM01.ACT_ACTIVO                                   ACT
				JOIN REM01.DD_SCM_SITUACION_COMERCIAL                   SCM
				  ON ACT.DD_SCM_ID = SCM.DD_SCM_ID
				JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION                 TCO
				  ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
				LEFT JOIN (
								SELECT DISTINCT ACT.ACT_ID AS ACT_ID
								FROM REM01.ACT_ACTIVO                                   ACT
								JOIN REM01.DD_CRA_CARTERA                               CRA
								  ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
								LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL              SCM 
								  ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
								JOIN REM01.ACT_OFR                                      AOF
								  ON ACT.ACT_ID = AOF.ACT_ID
								JOIN REM01.OFR_OFERTAS                                  OFR
								  ON OFR.OFR_ID = AOF.OFR_ID
								JOIN REM01.DD_EOF_ESTADOS_OFERTA                        EOF
								  ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
								JOIN REM01.DD_TOF_TIPOS_OFERTA                          TOF
								  ON TOF.DD_TOF_ID = OFR.DD_TOF_ID
								LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL                ECO
								ON ECO.OFR_ID = OFR.OFR_ID 
								LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL                EEC
								ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
								WHERE EOF.DD_EOF_CODIGO IN (''01'',''04'')
								  AND ACT.BORRADO = 0
								  AND OFR.BORRADO = 0 
								  AND SCM.DD_SCM_CODIGO <> ''05''
				)                                                       OFERTAS_VIVAS    
				  ON OFERTAS_VIVAS.ACT_ID = ACT.ACT_ID
				LEFT JOIN (
								SELECT DISTINCT ACT.ACT_ID
								FROM REM01.ACT_ACTIVO ACT
								JOIN REM01.ACT_OFR    AOF
								ON AOF.ACT_ID = ACT.ACT_ID
								JOIN REM01.OFR_OFERTAS OFR
								ON OFR.OFR_ID = AOF.OFR_ID
								JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
								ON ECO.OFR_ID = OFR.OFR_ID
								JOIN REM01.RES_RESERVAS RES
								ON RES.ECO_ID = ECO.ECO_ID
								LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA ERE
								ON ERE.DD_ERE_ID = RES.DD_ERE_ID
								WHERE ERE.DD_ERE_CODIGO NOT IN (''01'',''04'')
				)                                                       RESERVA_APROB    
				ON RESERVA_APROB.ACT_ID = ACT.ACT_ID
				WHERE ACT.ACT_ID IN (
										SELECT DISTINCT ACT_ID 
										FROM (
										SELECT DISTINCT ACT.ACT_ID,
														ACT.ACT_NUM_ACTIVO,
														''DENTRO'' AS PERIMETRO
										FROM REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA
										JOIN REM01.ACT_ACTIVO                ACT
										  ON PTA.ACT_ID = ACT.ACT_ID
										WHERE PTA.USUARIOCREAR = ''REMVIP-1956''
										UNION ALL
										SELECT DISTINCT ACT.ACT_ID AS ACT_ID,
														ACT.ACT_NUM_ACTIVO AS ACT_NUM_ACTIVO,
														''FUERA'' AS PERIMETRO
										FROM REM01.ACT_ACTIVO                   ACT
										JOIN REM01.AUX_MMC_PER_519_ACT_NO_EXCEL AUX
										  ON ACT.ACT_NUM_ACTIVO = AUX.ACTIVO
										)                                                
				)
				) TABLA2
				ON (TABLA1.ACT_ID = TABLA2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					TABLA1.DD_SCM_ID = TABLA2.SITUACION_A_CAMBIAR,
					TABLA1.USUARIOMODIFICAR = ''REMVIP-2233'',
					TABLA1.FECHAMODIFICAR = SYSDATE
	';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza la situación comercial de '||SQL%ROWCOUNT||' activos.'); 
	
	
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
