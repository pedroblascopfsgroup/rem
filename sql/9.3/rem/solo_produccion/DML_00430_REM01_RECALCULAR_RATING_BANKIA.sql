--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200814
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7960
--## PRODUCTO=NO
--## 
--## Finalidad: RECALCULAR RATING BANKIA
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-7960';
    V_COUNT NUMBER(16):= 0;
    
    CURSOR RECALCULAR_RATING IS 
        SELECT DISTINCT act.ACT_ID
        FROM rem01.act_activo act
        INNER JOIN rem01.AUX_REMVIP_7960_2 AUX ON AUX.NUM_ACTIVO = act.ACT_NUM_ACTIVO
        WHERE act.borrado = 0;

    FILA RECALCULAR_RATING%ROWTYPE;
   
BEGIN
    DBMS_OUTPUT.put_line('[INICIO]');
      
    OPEN RECALCULAR_RATING;
    
    V_COUNT := 0;
    
    LOOP
        FETCH RECALCULAR_RATING INTO FILA;
        EXIT WHEN RECALCULAR_RATING%NOTFOUND;
        
        REM01.CALCULO_RATING_ACTIVO_AUTO (FILA.ACT_ID, ''||V_USUARIOMODIFICAR||'');
            
        V_COUNT := V_COUNT + 1;
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha recalculado el rating para '||V_COUNT||' activos');
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
