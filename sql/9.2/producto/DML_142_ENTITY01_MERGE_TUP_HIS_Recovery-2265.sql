--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160630
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2265
--## PRODUCTO=SI
--## Finalidad: DML
--##           
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 
    V_NUM_EXISTE NUMBER(16);  
    ERR_NUM NUMBER(25); 
    ERR_MSG VARCHAR2(1024 CHAR); 

BEGIN
        DBMS_OUTPUT.PUT_LINE('[INFO] Configuración de: plazoSiTareaVencida');
        EXECUTE IMMEDIATE '
        	MERGE INTO '||V_ESQUEMA||'.TUP_HIS_HISTORICO HIS USING (
			SELECT ASU_ID,PRC_ID FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS
			) TMP
			ON (HIS.PRC_ID = TMP.PRC_ID)
			WHEN MATCHED THEN UPDATE SET HIS.ASU_ID = TMP.ASU_ID
		';
		
		EXECUTE IMMEDIATE '
			MERGE INTO '||V_ESQUEMA||'.TUP_HIS_HISTORICO HIS USING (
			SELECT ASU_ID, USU.USU_ID
			FROM '||V_ESQUEMA||'.gaa_gestor_adicional_asunto gaa
			join '||V_ESQUEMA||'.usd_usuarios_despachos usd on gaa.usd_id = usd.usd_id
			join '||V_ESQUEMA_M||'.usu_usuarios usu on usd.usu_id = usu.usu_id
			WHERE dd_tge_id = 4
			) TMP
			ON (HIS.ASU_ID = TMP.ASU_ID)
			WHEN MATCHED THEN UPDATE SET HIS.USU_ID_REAL = TMP.USU_ID
		';
        
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
