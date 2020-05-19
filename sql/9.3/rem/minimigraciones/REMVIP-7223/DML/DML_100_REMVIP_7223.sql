--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200506
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7223
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_REMVIP_7223'
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-7223';

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO]');
        
        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1
                    USING (
                        SELECT TBJ_NUM_TRABAJO, TBJ_IMPORTE_PENAL_DIARIO, TBJ_IMPORTE_TOTAL
                        FROM '||V_ESQUEMA||'.AUX_REMVIP_7223
                    ) T2
                    ON (T1.TBJ_NUM_TRABAJO = T2.TBJ_NUM_TRABAJO)
                    WHEN MATCHED THEN UPDATE SET
                        T1.TBJ_IMPORTE_PENAL_DIARIO = T2.TBJ_IMPORTE_PENAL_DIARIO
                        ,T1.TBJ_IMPORTE_TOTAL = T2.TBJ_IMPORTE_TOTAL
                        ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                        ,FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_ESQUEMA||'.ACT_TBJ_TRABAJO.');

		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
