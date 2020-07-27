--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7507
--## PRODUCTO=NO
--## 
--## Finalidad: CREAR TRAMITE GENCAT
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6781';
    V_COUNT NUMBER(16):= 0;
    
    CURSOR RECALCULAR_RATING IS 
        SELECT DISTINCT act.act_id
        FROM rem01.act_activo act
        LEFT JOIN rem01.DD_CRA_CARTERA cra ON cra.dd_cra_id = act.dd_cra_id 	
        LEFT JOIN rem01.act_ico_info_comercial ico ON ico.act_id = act.act_id and ico.borrado = 0
        LEFT JOIN rem01.vi_estado_actual_infmed vei ON vei.ico_id = ico.ico_id
        WHERE act.borrado = 0 and DD_CRA_CODIGO = '03'
        AND vei.dd_aic_codigo = '02' AND VEI.HIC_FECHA < TO_DATE('01/09/19', 'DD/MM/YY');

    FILA RECALCULAR_RATING%ROWTYPE;
   
BEGIN
    DBMS_OUTPUT.put_line('[INICIO]');
      
    OPEN RECALCULAR_RATING;
    
    V_COUNT := 0;
    
    LOOP
        FETCH RECALCULAR_RATING INTO FILA;
        EXIT WHEN RECALCULAR_RATING%NOTFOUND;
        
        REM01.CALCULO_RATING_ACTIVO_REMVIP_6781 (FILA.ACT_ID, ''||V_USUARIOMODIFICAR||'');
            
        V_COUNT := V_COUNT + 1;
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha recalculado el rating para '||V_COUNT||' de Bankia');
    CLOSE RECALCULAR_RATING;
     
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