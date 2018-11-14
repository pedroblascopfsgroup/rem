--/*
--#########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20181029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=HREOS-4675
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
    V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(30 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-4675';
	
BEGIN
	V_SQL := '					   
			MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' APU
				USING (SELECT APUB.APU_ID, MTO.DD_MTO_ID
    						FROM '||V_ESQUEMA||'.'||V_TABLA||' APUB
    						JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = APUB.ACT_ID AND SPS.BORRADO = 0
    						JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO ON DDTCO.DD_TCO_ID = APUB.DD_TCO_ID
                					AND DDTCO.DD_TCO_CODIGO IN (''02'',''03'',''04'')
                					AND DDTCO.BORRADO = 0
    						LEFT JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION MTO ON MTO.DD_MTO_CODIGO = ''03'' AND MTO.BORRADO = 0
    						WHERE APUB.BORRADO = 0
                					AND SPS.SPS_OCUPADO = 1
                					AND SPS.SPS_CON_TITULO = 1
                					AND ((TRUNC(SPS.SPS_FECHA_TITULO) <= TRUNC(SYSDATE) 
                					AND TRUNC(SPS.SPS_FECHA_VENC_TITULO) >= TRUNC(sysdate)) OR (TRUNC(SPS.SPS_FECHA_TITULO) <= TRUNC(SYSDATE) 
                					AND SPS.SPS_FECHA_VENC_TITULO IS NULL))
                					AND APUB.DD_EPA_ID <> (SELECT DD_EPA_ID FROM DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''04'')) AUX
				ON (APU.APU_ID = AUX.APU_ID)
			  WHEN MATCHED THEN
				UPDATE SET APU.DD_EPA_ID = (SELECT DD_EPA_ID FROM DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''04'') 
						 , APU.DD_MTO_A_ID = AUX.DD_MTO_ID	
						 , APU.USUARIOMODIFICAR = '''||V_USUARIO||'''
						 , APU.FECHAMODIFICAR = SYSDATE												   
			'; 
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han updateado en total '||SQL%ROWCOUNT||' registros en la tabla ACT_APU_ACTIVO_PUBLICACION');
    
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

