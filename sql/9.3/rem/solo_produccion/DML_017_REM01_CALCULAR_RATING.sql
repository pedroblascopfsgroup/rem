--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
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
		WHERE ACT_NUM_ACTIVO IN (
			6996343,
			6996342,
			6996341,
			6996340,
			6996339,
			6996337,
			6996336,
			6996311,
			6996310,
			6996126,
			6996125,
			6996124,
			6996123,
			6996122,
			6996121,
			6996120,
			6995839,
			6995838,
			6995837,
			6995836,
			6995835,
			6995834,
			6995833,
			6995832,
			6994815,
			6994814,
			6994813,
			6994812,
			6994811,
			6994810,
			6994809,
			6994808,
			6994783,
			6994782,
			6994339,
			6994338,
			6994337,
			6994336,
			6988332,
			6813844,
			6809751,
			5951766,
			5945610,
			5940481,
			5939435,
			5925634
		);

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
