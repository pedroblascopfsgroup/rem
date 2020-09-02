--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200831
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7312
--## PRODUCTO=NO
--## 
--## Finalidad:
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
	V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
 	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USU VARCHAR2(30 CHAR):= 'REMVIP-7312';
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES T1
                USING (
                    SELECT VAL.VAL_ID, VAL.ACT_ID, ACT.ACT_NUM_ACTIVO, TPC.DD_TPC_DESCRIPCION, VAL.VAL_IMPORTE, VAL.VAL_FECHA_INICIO
                        ,VAL.VAL_FECHA_FIN, VAL.USUARIOCREAR, VAL.FECHACREAR,VAL.USUARIOMODIFICAR,VAL.FECHAMODIFICAR,VAL.BORRADO
                        ,ROW_NUMBER() OVER (PARTITION BY ACT.ACT_ID ORDER BY VAL_FECHA_INICIO desc) RN
                    FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = VAL.ACT_ID
                    JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO IN (''02'',''03'') 
                    WHERE VAL.ACT_ID IN (
                        SELECT  VAL.ACT_ID
                        FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
                        JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID  AND TPC.DD_TPC_CODIGO IN (''02'',''03'') 
                        WHERE VAL.BORRADO = 0
                        GROUP BY  VAL.ACT_ID,TPC.DD_TPC_CODIGO,TPC.DD_TPC_DESCRIPCION
                        HAVING COUNT(TPC.DD_TPC_CODIGO)>1
                    )
                ) T2
                ON (T1.VAL_ID = T2.VAL_ID AND T2.RN > 1)
                WHEN MATCHED THEN UPDATE SET
                    USUARIOBORRAR = '''||V_USU||''',
                    FECHABORRAR = SYSDATE,
                    BORRADO = 1';
	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS '|| SQL%ROWCOUNT ||' PRECIOS DUPLICADOS');

    COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
	EXCEPTION
	
	    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		ROLLBACK;
		RAISE;
END;
/
EXIT;