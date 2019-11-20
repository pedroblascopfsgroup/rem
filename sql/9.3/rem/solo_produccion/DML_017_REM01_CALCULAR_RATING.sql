--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5091
--## PRODUCTO=NO
--## 
--## Finalidad: [REMVIP-5091] Calcular el rating
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
	V_USUARIO VARCHAR2(40 CHAR) := 'REMVIP-5091'; --Vble. para el usuario REMVIP.
    V_COUNT NUMBER(16); -- Vble. para contabilizar los activos modificados.
    
    CURSOR CALCULAR_RATING_EXCEL IS 
        SELECT ACT.ACT_ID
		FROM REM01.ACT_ACTIVO ACT
		LEFT JOIN REM01.ACT_ICO_INFO_COMERCIAL ICO
		ON ACT.ACT_ID = ICO.ACT_ID
		WHERE ICO_FECHA_ACEPTACION IS NOT NULL AND DD_RTG_ID IS NULL AND ACT.DD_TPA_ID = 2 AND ACT.BORRADO = 0;

    FILA_EXCEL CALCULAR_RATING_EXCEL%ROWTYPE;
   
BEGIN

	DBMS_OUTPUT.put_line('[INICIO]');

    OPEN CALCULAR_RATING_EXCEL;
    V_COUNT := 0;
    
    LOOP
        FETCH CALCULAR_RATING_EXCEL INTO FILA_EXCEL;
        EXIT WHEN CALCULAR_RATING_EXCEL%NOTFOUND;
        
        V_SQL := 'CALL '||V_ESQUEMA||'.CALCULO_RATING_ACTIVO_AUTO ('||FILA_EXCEL.ACT_ID||','''||V_USUARIO||''')';
        EXECUTE IMMEDIATE V_SQL;
            
        V_COUNT := V_COUNT + 1;
    END LOOP;

    CLOSE CALCULAR_RATING_EXCEL;

	DBMS_OUTPUT.put_line('	[INFO] Se ha calculado el rating para ' || V_COUNT || '.');

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
