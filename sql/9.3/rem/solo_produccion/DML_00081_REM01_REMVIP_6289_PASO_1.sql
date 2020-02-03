--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200129
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6289
--## PRODUCTO=NO
--## 
--## Finalidad: REMVIP-6289, paso 1, update ACT_RECOVERY_ID a NULL
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6289_1';
    V_SQL VARCHAR2(32000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR IMPORTE TOTAL TRABAJOS');

    V_SQL :='MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1 USING (
		SELECT ACT.ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
		INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_6289_1 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		)T2
		ON (T1.ACT_NUM_ACTIVO=T2.ACT_NUM_ACTIVO)
		WHEN MATCHED THEN UPDATE SET 
		T1.ACT_RECOVERY_ID = NULL,
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
