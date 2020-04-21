--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200413
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-9419
--## PRODUCTO=NO
--## 
--## Finalidad: Revertir estado de Pagado a Pendiente de pago de trabajos NO divarian.
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Merge ACT_TBJ_TRABAJO...Cambiamos de Pagado a Pendiente de pago...');

    
    execute immediate '
    MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1
                USING (
                    SELECT DISTINCT TBJ.TBJ_ID
                    FROM REM01.ACT_TBJ_TRABAJO TBJ
                    INNER JOIN '||V_ESQUEMA||'.AUX_TBJ_A_PDTE_PAGO_REMVIP_6961 AUX ON TBJ.TBJ_NUM_TRABAJO = AUX.TBJ_NUM_TRABAJO
                ) T2
                ON (T1.TBJ_ID = T2.TBJ_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.DD_EST_ID = (SELECT DD_EST_ID FROM REM01.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO = ''05''),--PENDIENTE DE PAGO
                    T1.USUARIOMODIFICAR = ''REMVIP-6961'',
                    T1.FECHAMODIFICAR = SYSDATE
                    where T1.DD_EST_ID = (SELECT DD_EST_ID FROM REM01.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO = ''06'')--pagado
    ';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_TBJ_TRABAJO mergeada. '||SQL%ROWCOUNT||' Filas.');

    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
