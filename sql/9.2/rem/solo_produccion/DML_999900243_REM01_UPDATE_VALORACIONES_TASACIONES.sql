--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180208
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=HREOS-3800
--## PRODUCTO=NO
--## Finalidad: Script de actualización de importes dados de alta incorrectamente.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_M#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar  
    
BEGIN
	 DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion de importes...');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion de registros de BIE_VALORACIONES...');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_VALORACIONES... Procedemos a actualizar');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_VALORACIONES BIE_VAL
				USING (
				  SELECT aux.IMP_VALOR_TASACION, tas.BIE_VAL_ID, act.BIE_ID
				  from  '||V_ESQUEMA||'.APR_AUX_TAS_TASACIONES aux 
				  INNER JOIN '||V_ESQUEMA||'.DD_EQV_BANKIA_REM EQV ON EQV.DD_CODIGO_BANKIA = NVL(aux.TIPO_TASACION, ''00'')
				  INNER JOIN '||V_ESQUEMA||'.dd_tts_tipo_tasacion tts ON tts.dd_tts_codigo = EQV.DD_CODIGO_REM
				  inner join '||V_ESQUEMA||'.ACT_ACTIVO act on aux.IDENTIFICADOR_ACTIVO_ESPECIAL=act.ACT_NUM_ACTIVO_UVEM
				  INNER join '||V_ESQUEMA||'.ACT_TAS_TASACION tas ON tas.tas_id_externo = aux.num_identif_tasacion and act.act_id = tas.act_id
				  INNER JOIN '||V_ESQUEMA||'.BIE_VALORACIONES VAL ON VAL.BIE_VAL_ID = TAS.BIE_VAL_ID
				  WHERE EQV.DD_NOMBRE_BANKIA = ''DD_TASACION_BANKIA''
				  AND EQV.DD_NOMBRE_REM = ''DD_TTS_TIPO_TASACION''
				  AND TAS.USUARIOCREAR = ''apr_main_tasaciones_from_file''
				  AND VAL.USUARIOCREAR = ''apr_main_tasaciones_from_file''
				) AUX1
				ON (BIE_VAL.BIE_ID = AUX1.BIE_ID AND BIE_VAL.BIE_VAL_ID = AUX1.BIE_VAL_ID)
				WHEN MATCHED THEN UPDATE SET
				BIE_VAL.BIE_IMPORTE_VALOR_TASACION = AUX1.IMP_VALOR_TASACION,
				BIE_VAL.USUARIOMODIFICAR = ''HREOS-3800'',
				BIE_VAL.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_VALORACIONES... Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');     
    
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion de registros de ACT_TAS_TASACION...');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_TAS_TASACION... Procedemos a actualizar');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TAS_TASACION ACT_TAS
				USING (
				  SELECT aux.IMP_VALOR_TASACION, tas.TAS_ID_EXTERNO, ACT.ACT_ID
				  from  '||V_ESQUEMA||'.APR_AUX_TAS_TASACIONES aux 
				  INNER JOIN '||V_ESQUEMA||'.DD_EQV_BANKIA_REM EQV ON EQV.DD_CODIGO_BANKIA = NVL(aux.TIPO_TASACION, ''00'')
				  INNER JOIN '||V_ESQUEMA||'.dd_tts_tipo_tasacion tts ON tts.dd_tts_codigo = EQV.DD_CODIGO_REM
				  inner join '||V_ESQUEMA||'.ACT_ACTIVO act on aux.IDENTIFICADOR_ACTIVO_ESPECIAL=act.ACT_NUM_ACTIVO_UVEM
				  INNER join '||V_ESQUEMA||'.ACT_TAS_TASACION tas ON tas.tas_id_externo = aux.num_identif_tasacion and act.act_id = tas.act_id
				  INNER JOIN '||V_ESQUEMA||'.BIE_VALORACIONES VAL ON VAL.BIE_VAL_ID = TAS.BIE_VAL_ID
				  WHERE EQV.DD_NOMBRE_BANKIA = ''DD_TASACION_BANKIA''
				  AND EQV.DD_NOMBRE_REM = ''DD_TTS_TIPO_TASACION''
				  AND TAS.USUARIOCREAR = ''apr_main_tasaciones_from_file''
				  AND VAL.USUARIOCREAR = ''apr_main_tasaciones_from_file''
				) AUX1
				ON (ACT_TAS.ACT_ID = AUX1.ACT_ID AND ACT_TAS.TAS_ID_EXTERNO = AUX1.TAS_ID_EXTERNO)
				WHEN MATCHED THEN UPDATE SET
				ACT_TAS.TAS_IMPORTE_TAS_FIN = AUX1.IMP_VALOR_TASACION,
				ACT_TAS.USUARIOMODIFICAR = ''HREOS-3800'',
				ACT_TAS.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_TAS_TASACION... Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
    
	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización de importes a finalizado correctamente');
	
	COMMIT;    
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
