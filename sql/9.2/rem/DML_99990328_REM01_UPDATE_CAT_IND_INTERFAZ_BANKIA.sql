--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-363
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := 'REMVIP-363'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	DBMS_OUTPUT.PUT_LINE('	[INFO]: Actualización catastro');
	
	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_CAT_CATASTRO T1
		USING (
		    WITH ACT_REF AS (
		        SELECT ACT_ID
		        FROM '||V_ESQUEMA||'.ACT_CAT_CATASTRO
		        GROUP BY ACT_ID
		        )
		    , CONSULTA AS (
		        SELECT CAT.*, ROW_NUMBER() OVER(PARTITION BY CAT.ACT_ID ORDER BY DECODE(CAT.CAT_IND_INTERFAZ_BANKIA,0,0,NULL,0,1) DESC) RN
		        FROM '||V_ESQUEMA||'.ACT_CAT_CATASTRO CAT
		        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = CAT.ACT_ID
		        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		        JOIN ACT_REF ON CAT.ACT_ID = ACT_REF.ACT_ID
		        WHERE CRA.DD_CRA_CODIGO = ''03'')
		    SELECT CAT_ID, CAT_IND_INTERFAZ_BANKIA
		    FROM CONSULTA
		    WHERE RN = 1 AND NVL(CAT_IND_INTERFAZ_BANKIA,0) = 0) T2
		ON (T1.CAT_ID = T2.CAT_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.CAT_IND_INTERFAZ_BANKIA = 1, T1.USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', T1.FECHAMODIFICAR = SYSDATE';

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('	[INFO]: Actualización de '||SQL%ROWCOUNT||' referencias catastrales');

	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT;
