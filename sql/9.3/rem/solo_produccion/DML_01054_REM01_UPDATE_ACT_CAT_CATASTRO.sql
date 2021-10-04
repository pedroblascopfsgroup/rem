--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10553
--## PRODUCTO=NO
--##
--## Finalidad: Script modificar usuarios
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CAT_CATASTRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10553'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING(
					SELECT
						 ACT.ACT_ID
						,AUX.VALOR_CONSTRUCCION AS CAT_VALOR_CATASTRAL_CONST
						,AUX.VALOR_SUELO AS CAT_VALOR_CATASTRAL_SUELO
					FROM '||V_ESQUEMA||'.AUX_REMVIP_10553 AUX  
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO=AUX.ID_HAYA_STOCK
					AND ACT.BORRADO=0         
			)T2 ON (T1.ACT_ID = T2.ACT_ID)
			WHEN MATCHED THEN 
			UPDATE SET 
					T1.CAT_VALOR_CATASTRAL_CONST = T2.CAT_VALOR_CATASTRAL_CONST,
					T1.CAT_VALOR_CATASTRAL_SUELO = T2.CAT_VALOR_CATASTRAL_SUELO,
					T1.USUARIOMODIFICAR = '''||V_USU||''',
					T1.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '||SQL%ROWCOUNT||' REGISTROS');
		COMMIT;

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

EXIT