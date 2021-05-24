--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210518
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9751
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-9751'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_9751';

    
BEGIN		
        ---------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO BIE_DATOS_REGISTRALES ');	


        --HAY QUE HACER 2 MERGES ESTE NO ESTA BIEN
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES T1
		USING (
		   SELECT VAL.VAL_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.ACT_NUM_ACTIVO=ACT.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID=ACT.ACT_ID
			JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID=VAL.DD_TPC_ID
			WHERE ACT.BORRADO=0 AND VAL.BORRADO=0 AND TPC.DD_TPC_CODIGO=AUX.TIPO_FECHA
		) T2   
		ON (T1.VAL_ID = T2.VAL_ID)
		WHEN MATCHED THEN UPDATE SET
		T1.VAL_FECHA_APROBACION = NULL,
		USUARIOMODIFICAR = '''||V_USR||''',
		FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros en ACT_VAL_VALORACIONES'); 	


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
