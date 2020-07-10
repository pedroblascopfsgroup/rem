--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200707
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7703
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
	V_ID NUMBER;
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-7703';

   
BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT T1
				USING (
				    SELECT CMG.CMG_ID 
					FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG
				    LEFT JOIN '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG ON OFG.CMG_ID = CMG.CMG_ID
				    WHERE CMG.USUARIOCREAR = ''MIG_DIVARIAN''
				    AND OFG.OFG_ID IS NULL
				) T2
				ON (T1.CMG_ID = T2.CMG_ID)
				WHEN NOT MATCHED THEN INSERT (OFG_ID, CMG_ID, USUARIOCREAR, FECHACREAR, BORRADO)
				VALUES (REM01.S_ACT_OFG_OFERTA_GENCAT.NEXTVAL, T2.CMG_ID, '''||V_ITEM||''', SYSDATE, 0)';      
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' registros insertados en ACT_OFG_OFERTA_GENCAT');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ADG_ADECUACION_GENCAT T1
				USING (
				    SELECT CMG.CMG_ID 
					FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG
				    LEFT JOIN '||V_ESQUEMA||'.ACT_ADG_ADECUACION_GENCAT ADG ON CMG.CMG_ID = ADG.CMG_ID
				    WHERE CMG.USUARIOCREAR = ''MIG_DIVARIAN''
				    AND ADG.ADG_ID IS NULL
				) T2
				ON (T1.CMG_ID = T2.CMG_ID)
				WHEN NOT MATCHED THEN INSERT (ADG_ID, CMG_ID, USUARIOCREAR, FECHACREAR, BORRADO)
				VALUES (REM01.S_ACT_ADG_ADECUACION_GENCAT.NEXTVAL, T2.CMG_ID, '''||V_ITEM||''', SYSDATE, 0)';      
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' registros insertados en ACT_ADG_ADECUACION_GENCAT');
    
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
