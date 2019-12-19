--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191216
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6016
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR TIPO Y SUBTIPO ACTIVO
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6016';
    V_SQL VARCHAR2(32000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');



    V_SQL :='MERGE INTO REM01.ACT_ACTIVO T1 USING 
			(SELECT ACT_NUM_ACTIVO, SAC_ID, TPA_ID
			FROM REM01.AUX_REMVIP_6016) T2
		ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
	   WHEN MATCHED THEN UPDATE SET 
	   T1.DD_TPA_ID = T2.TPA_ID,
	   T1.DD_SAC_ID = T2.SAC_ID,
	   USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''',
	   FECHAMODIFICAR = SYSDATE'; 	


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
