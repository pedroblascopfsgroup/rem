--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200129
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6289
--## PRODUCTO=NO
--## 
--## Finalidad: REMVIP-6289, paso 2, update BIE_ADJ_F_REA_POSESION a correcta
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6289_2_3';
    V_SQL VARCHAR2(32000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_SQL :='MERGE INTO '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION T1 USING (
		SELECT AUX.ACT_ID, AUX.BIE_ADJ_F_REA_CORRECTA, ADJ.BIE_ADJ_ID, TO_DATE(BIE_ADJ_F_REA_CORRECTA, ''yyyy-mm-dd'') 
		FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ 
		INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_6289_4 AUX ON AUX.BIE_ADJ_ID = ADJ.BIE_ADJ_ID
		)T2
		ON (T1.BIE_ADJ_ID=T2.BIE_ADJ_ID)
		WHEN MATCHED THEN UPDATE SET 
		T1.BIE_ADJ_F_REA_POSESION = TO_DATE(T2.BIE_ADJ_F_REA_CORRECTA, ''yyyy-mm-dd''),
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
