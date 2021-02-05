--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210205
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8874
--## PRODUCTO=SI
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8874'; --Usuario modificar
    V_TABLA VARCHAR2(100 CHAR):='ACT_ACTIVO';
    V_TABLA_AUX VARCHAR2(100 CHAR):='AUX_REMVIP_8874';

BEGIN
	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  

	    	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                    USING ( 
                        SELECT ACT_ID,TDC.DD_TDC_ID,EQG.DD_EQG_ID FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
                        JOIN '||V_ESQUEMA||'.'||V_TABLA||' ACT ON ACT.ACT_NUM_ACTIVO=AUX.ACT_NUM_ACTIVO
                        JOIN '||V_ESQUEMA||'.DD_TDC_TERRITORIOS_DIR_COM TDC ON TDC.DD_TDC_CODIGO=AUX.TERRITORIO
                        JOIN '||V_ESQUEMA||'.DD_EQG_EQUIPO_GESTION EQG ON EQG.DD_EQG_CODIGO=AUX.GESTION
                        WHERE ACT.BORRADO=0 AND TDC.BORRADO=0 AND EQG.BORRADO=0 AND AUX.GESTION IS NOT NULL
                        ) T2
                    ON (T1.ACT_ID = T2.ACT_ID)
                    WHEN MATCHED THEN
                        UPDATE SET 
                            T1.DD_TDC_ID = T2.DD_TDC_ID,
                            T1.DD_EQG_ID = T2.DD_EQG_ID,
                            USUARIOMODIFICAR = '''||V_USUARIO||''',
                            FECHAMODIFICAR = SYSDATE
			 ';
		
	EXECUTE IMMEDIATE V_MSQL;  

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||SQL%ROWCOUNT||' registros QUE LA GESTION NO ERA NULO');

    	    	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                    USING ( 
                        SELECT ACT_ID,TDC.DD_TDC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
                        JOIN '||V_ESQUEMA||'.'||V_TABLA||' ACT ON ACT.ACT_NUM_ACTIVO=AUX.ACT_NUM_ACTIVO
                        JOIN '||V_ESQUEMA||'.DD_TDC_TERRITORIOS_DIR_COM TDC ON TDC.DD_TDC_CODIGO=AUX.TERRITORIO
                        WHERE ACT.BORRADO=0 AND TDC.BORRADO=0 AND AUX.GESTION IS NULL
                        ) T2
                    ON (T1.ACT_ID = T2.ACT_ID)
                    WHEN MATCHED THEN
                        UPDATE SET 
                            T1.DD_TDC_ID = T2.DD_TDC_ID,                            
                            USUARIOMODIFICAR = '''||V_USUARIO||''',
                            FECHAMODIFICAR = SYSDATE
			 ';
		
	EXECUTE IMMEDIATE V_MSQL;  

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||SQL%ROWCOUNT||' registros QUE LA GESTION ES NULO');
   
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
