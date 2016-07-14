--/*
--#########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160711
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-616
--## PRODUCTO=NO
--## 
--## Finalidad: Copiar "bie_adj_f_decreto_n_firme" en "ajd_fecha_adjudicacion" 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_COUNT NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	--UPDATE ACT_SPS_SIT_POSESORIA.SPS_FECHA_TOMA_POSESION PARA EL ACTIVO 23120
	
	V_MSQL := '
	UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS
	SET SPS.SPS_FECHA_TOMA_POSESION = to_date(''30/07/2012'', ''dd/MM/yyyy''),
	SPS.USUARIOMODIFICAR = ''HREOS-616'',
	SPS.FECHAMODIFICAR = SYSDATE
	WHERE ACT_ID = 23120
	'
	;
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] SE HA MODIFICADO '||SQL%ROWCOUNT||' FECHA EN ACT_SPS_SIT_POSESORIA.SPS_FECHA_TOMA_POSESION.');
  
    --MERGE SOBRE ACT_AJD_ADJJUDICIAL PARA COPIAR EL CONTENIDO DE BIE_ADJ_F_DECRETO_N_FIRME
    
    V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD USING
    (
    SELECT
    ACT.ACT_ID,
    ACT.ACT_NUM_ACTIVO_UVEM,
    AJD.AJD_ID,
    ADJ.BIE_ADJ_F_DECRETO_N_FIRME,
    AJD.AJD_FECHA_ADJUDICACION
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
    INNER JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD
		ON AJD.ACT_ID = ACT.ACT_ID
	LEFT JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ
		ON ADJ.BIE_ID = ACT.BIE_ID
	WHERE ADJ.USUARIOMODIFICAR = ''HREOS-616''
	AND ADJ.BIE_ADJ_F_DECRETO_N_FIRME IS NOT NULL
	) TMP
	ON (AJD.AJD_ID = TMP.AJD_ID)
	WHEN MATCHED THEN UPDATE SET
	AJD.AJD_FECHA_ADJUDICACION = TMP.BIE_ADJ_F_DECRETO_N_FIRME,
	AJD.USUARIOMODIFICAR = ''HREOS-616'',
	AJD.FECHAMODIFICAR = SYSDATE
	WHERE 
	(AJD.AJD_FECHA_ADJUDICACION != TMP.BIE_ADJ_F_DECRETO_N_FIRME)
	OR 
	(AJD.AJD_FECHA_ADJUDICACION IS NULL AND TMP.BIE_ADJ_F_DECRETO_N_FIRME IS NOT NULL)
    '
    ;
    
    EXECUTE IMMEDIATE V_MSQL;
    
    V_COUNT := SQL%ROWCOUNT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_COUNT||' REGISTROS ACTUALIZADOS EN ACT_AJD_ADJJUDICIAL.AJD_FECHA_ADJUDICACION.');
    
    COMMIT;
         
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
