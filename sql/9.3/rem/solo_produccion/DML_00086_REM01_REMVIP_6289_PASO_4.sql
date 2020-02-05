--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200129
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6289
--## PRODUCTO=NO
--## 
--## Finalidad: REMVIP-6289, paso 4, update SPS_FECHA_VENC_TITULO a NULL
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6289_4';
    V_SQL VARCHAR2(32000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_SQL :='MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA T1 USING (
		SELECT SPS.ACT_ID, AUX.SPS_FECHA_CORRECTA
		FROM '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS 
		INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_6289_6 AUX ON SPS.ACT_ID = AUX.ACT_ID
		)T2
	ON (T1.ACT_ID=T2.ACT_ID)
	WHEN MATCHED THEN UPDATE SET 
	T1.SPS_FECHA_VENC_TITULO = NULL,
	T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''',
	T1.FECHAMODIFICAR = SYSDATE'; 	


      EXECUTE IMMEDIATE V_SQL;
    
      DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado  '||SQL%ROWCOUNT||' registros .');

     COMMIT;

     DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
