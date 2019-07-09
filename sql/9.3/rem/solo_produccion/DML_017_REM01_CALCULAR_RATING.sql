--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4668
--## PRODUCTO=NO
--## 
--## Finalidad: [REMVIP-4668] Calcular el rating
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
	V_USUARIO VARCHAR2(40 CHAR) := 'REMVIP-4668'; --Vble. para el usuario REMVIP.
    V_COUNT NUMBER(16); -- Vble. para contabilizar los activos modificados.
    
    CURSOR CALCULAR_RATING_EXCEL IS 
        SELECT ACT.ACT_ID
		FROM REM01.ACT_ACTIVO ACT
		WHERE ACT_NUM_ACTIVO IN (
			5924914,
			5924929,
			5924933,
			5925021,
			5954934,
			5955845,
			5962787,
			5925039,
			5925046,
			5925063,
			5925064,
			5925071,
			6938934,
			6949797,
			6966391,
			5925097,
			5935532,
			6044700,
			6050178,
			6051243,
			6054562,
			6057592,
			6058343,
			5931843,
			6355382,
			7001601,
			7001600,
			7002702,
			7001562,
			7002672,
			7001546,
			7001538,
			7002258,
			7001460,
			7001362,
			7001271,
			7001194,
			7001979,
			7001956,
			7001193,
			7001934,
			7001186,
			7000953,
			7001799,
			7000817,
			7000760,
			7000759,
			7001678,
			7001605,
			7001604
		);

    FILA_EXCEL CALCULAR_RATING_EXCEL%ROWTYPE;

	CURSOR CALCULAR_RATING_CONSULTA IS 
        SELECT ACT.ACT_ID
		FROM REM01.ACT_ACTIVO ACT
		LEFT JOIN REM01.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID
		LEFT JOIN REM01.ACT_VIV_VIVIENDA VIV ON ICO.ICO_ID = VIV.ICO_ID
		LEFT JOIN REM01.ACT_INF_INFRAESTRUCTURA INF ON ICO.ICO_ID = INF.ICO_ID
		WHERE INF_PARKING_SUP_SUF = 2 AND DD_RTG_ID IS NOT NULL;

    FILA_CONSULTA CALCULAR_RATING_CONSULTA%ROWTYPE;
   
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

	DBMS_OUTPUT.put_line('	[INFO] Se ha calculado el rating para ' || V_COUNT || ' del excel');

	OPEN CALCULAR_RATING_CONSULTA;
    V_COUNT := 0;

    LOOP
        FETCH CALCULAR_RATING_CONSULTA INTO FILA_CONSULTA;
        EXIT WHEN CALCULAR_RATING_CONSULTA%NOTFOUND;
        
        V_SQL := 'CALL '||V_ESQUEMA||'.CALCULO_RATING_ACTIVO_AUTO ('||FILA_CONSULTA.ACT_ID||','''||V_USUARIO||''')';
        EXECUTE IMMEDIATE V_SQL;
            
        V_COUNT := V_COUNT + 1;
    END LOOP;

    CLOSE CALCULAR_RATING_CONSULTA;

	DBMS_OUTPUT.put_line('	[INFO] Se ha calculado el rating para ' || V_COUNT ||' de la consulta');

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
