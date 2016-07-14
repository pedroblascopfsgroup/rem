--/*
--#########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160630
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-616
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar Fecha Decreto, Fecha Decreto Firme, Fecha Inscripción y Fecha Posesión en BIE_ADJ_JUDICIAL. PARTE II
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
  
    --MERGE SOBRE ACT_SPS_SIT_POSESORIA PARA COPIAR EL CONTENIDO DE BIE_ADJ_F_REA_POSESION
    
    V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS USING
    (
    SELECT
    ACT.ACT_ID,
    ACT.ACT_NUM_ACTIVO_UVEM,
    SPS.SPS_ID,
    ADJ.BIE_ADJ_F_REA_POSESION
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
    INNER JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS
		ON SPS.ACT_ID = ACT.ACT_ID
	LEFT JOIN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ
		ON ADJ.BIE_ID = ACT.BIE_ID
	WHERE ADJ.USUARIOMODIFICAR = ''HREOS-616''
	AND ADJ.BIE_ADJ_F_REA_POSESION IS NOT NULL
	) TMP
	ON (SPS.SPS_ID = TMP.SPS_ID)
	WHEN MATCHED THEN UPDATE SET
	SPS.SPS_FECHA_TOMA_POSESION = TMP.BIE_ADJ_F_REA_POSESION,
	SPS.USUARIOMODIFICAR = ''HREOS-616'',
	SPS.FECHAMODIFICAR = SYSDATE
	WHERE 
	(SPS.SPS_FECHA_TOMA_POSESION != TMP.BIE_ADJ_F_REA_POSESION)
	OR 
	(SPS.SPS_FECHA_TOMA_POSESION IS NULL)
    '
    ;
    
    EXECUTE IMMEDIATE V_MSQL;
    
    V_COUNT := SQL%ROWCOUNT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_COUNT||' REGISTROS ACTUALIZADOS EN ACT_SPS_SIT_POSESORIA.SPS_FECHA_TOMA_POSESION.');
    
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
