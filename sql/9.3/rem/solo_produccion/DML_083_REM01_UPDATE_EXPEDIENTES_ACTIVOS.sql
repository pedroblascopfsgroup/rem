--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191410
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5318
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
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5318'; -- Vble. para el usuario modificar.
    V_MSQL VARCHAR2(32000 CHAR); -- Vble. auxiliar para almacenar la sentencia a ejecutar.
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('	[INFO] Se procede a Modificación de gastos de honorarios de gestorías .'); 

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_ETG_EQV_TIPO_GASTO_RU SET cotaca_pos = 59, 
    		cosbac_pos = 1, 
     		FECHAMODIFICAR = SYSDATE 
		WHERE DD_TGA_ID = 12 AND DD_STG_ID = 54';

	EXECUTE IMMEDIATE V_MSQL;

    	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');

    DBMS_OUTPUT.PUT_LINE('[FIN]');
    COMMIT;
 
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
