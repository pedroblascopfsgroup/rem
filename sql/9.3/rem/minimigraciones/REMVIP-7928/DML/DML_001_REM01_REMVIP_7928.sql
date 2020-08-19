--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200806
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7928
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7928'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_7928';

    
BEGIN		
        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO BIE_DATOS_REGISTRALES ');	
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.bie_datos_registrales T1
		USING (
		    SELECT ACT.ACT_ID,bie.bie_dreg_id, aux.TX_FINCA_REGISTRAL FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
		    JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON ACT.ACT_ID = REG.ACT_ID
		    JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BIE ON REG.BIE_DREG_ID = bie.bie_dreg_id
		    JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
		) T2   
		ON (T1.BIE_DREG_ID = T2.BIE_DREG_ID)
		WHEN MATCHED THEN UPDATE SET
		T1.BIE_DREG_NUM_FINCA = T2.TX_FINCA_REGISTRAL,
		USUARIOMODIFICAR = '''||V_USR||''',
		FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de BIE_DATOS_REGISTRALES'); 	

        COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
