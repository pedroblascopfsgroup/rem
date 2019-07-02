--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190626
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3842
--## PRODUCTO=NO
--## 
--## Finalidad: [REMVIP-3842] Calcular el rating
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
	V_USUARIO VARCHAR2(40 CHAR) := 'REMVIP-3842'; --Vble. para el usuario REMVIP.
    V_COUNT NUMBER(16); -- Vble. para contabilizar los activos modificados.
    
    CURSOR CALCULAR_RATING IS 
        SELECT ACT_ID FROM REM01.ACT_ACTIVO ACT
        WHERE ACT.DD_RTG_ID IS NULL AND DD_TPA_ID = 2 AND BORRADO = 0
        AND EXISTS (
            SELECT * FROM REM01.ACT_HIC_EST_INF_COMER_HIST EST
            JOIN REM01.DD_AIC_ACCION_INF_COMERCIAL AIC ON AIC.DD_AIC_ID = EST.DD_AIC_ID
            WHERE AIC.DD_AIC_CODIGO = '02' AND EST.ACT_ID = ACT.ACT_ID
        );

    FILA CALCULAR_RATING%ROWTYPE;
   
BEGIN

	DBMS_OUTPUT.put_line('[INICIO]');
    OPEN CALCULAR_RATING;
    V_COUNT := 0;
    
    LOOP
        FETCH CALCULAR_RATING INTO FILA;
        EXIT WHEN CALCULAR_RATING%NOTFOUND;
        
        V_SQL := 'CALL '||V_ESQUEMA||'.CALCULO_RATING_ACTIVO_AUTO ('||FILA.ACT_ID||','''||V_USUARIO||''')';
        EXECUTE IMMEDIATE V_SQL;
            
        V_COUNT := V_COUNT + 1;
    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha recalculado el rating para '||V_COUNT||' activos');
    CLOSE CALCULAR_RATING;

 	COMMIT;
	DBMS_OUTPUT.put_line('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
