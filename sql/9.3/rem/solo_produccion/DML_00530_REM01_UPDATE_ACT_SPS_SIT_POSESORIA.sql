--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201112
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8352
--## PRODUCTO=NO
--## 
--## Finalidad: Poner riesgo ocupación NO
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8352'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_8352';	
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAR RIESGO OCUPACIÓN A NO (0)');	
	

	V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA T1 USING( 
					SELECT SPS.ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
					INNER JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID 
					INNER JOIN '|| V_ESQUEMA ||'.'||V_TABLA_AUX||' AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO 
					WHERE ACT.BORRADO = 0 AND SPS.BORRADO = 0) T2
				ON ( T1.ACT_ID = T2.ACT_ID )
				WHEN MATCHED THEN UPDATE SET
				T1.SPS_RIESGO_OCUPACION = 0,
				T1.FECHAMODIFICAR = SYSDATE,
				T1.USUARIOMODIFICAR = ''' || V_USR || '''' ;	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ACTUALIZAN '||SQL%ROWCOUNT||' registros de ACT_SPS_SIT_POSESORIA'); 	

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
