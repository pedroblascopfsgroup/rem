--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210601
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9856
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

    -- Esquemas
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9856';
    -- Tablas
    V_TABLA_ACTIVO VARCHAR2(100 CHAR):= 'ACT_ACTIVO';
    V_TABLA_ESPARTA  VARCHAR2(100 CHAR):= 'ESPARTA_ACT_ACTIVO';
    V_TABLA_AUX  VARCHAR2(100 CHAR):= 'AUX_REMVIP_9856';
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');	


       DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR IDS '||V_TABLA_ACTIVO||' ');
  	
  	 V_MSQL :='MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_ACTIVO ||' T1 
                USING (
                    SELECT DISTINCT ACT.ACT_ID,ACT.ACT_NUM_ACTIVO,ESP_ACT.DD_TPA_ID,ESP_ACT.DD_SAC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO ||' ACT
                        JOIN '||V_ESQUEMA||'.'||V_TABLA_ESPARTA||' ESP_ACT ON ESP_ACT.ACT_ID=ACT.ACT_ID AND ESP_ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.ACT_NUM_ACTIVO=ACT.ACT_NUM_ACTIVO
                        WHERE ACT.BORRADO=0
                    ) T2
                ON (T1.ACT_ID = T2.ACT_ID)
                WHEN MATCHED THEN UPDATE SET                 
                T1.DD_TPA_ID = T2.DD_TPA_ID,
                T1.DD_SAC_ID = T2.DD_SAC_ID,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                T1.FECHAMODIFICAR = SYSDATE';

  	EXECUTE IMMEDIATE V_MSQL;

  	DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACTUALIZADAS '||SQL%ROWCOUNT||' FILAS.');

        
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: IDS MODIFICADOS con éxito');

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