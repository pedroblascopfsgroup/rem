--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2236
--## PRODUCTO=NO
--##
--## Finalidad: FUSION CCM TO LIBERBANK Guardamos información anterior a la fusión
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
DBMS_OUTPUT.put_line('[FUSION CCM TO LIBERBANK] SCRIPT INSERCIÓN EN TABLAS PARA REVERT');

DBMS_OUTPUT.put_line('[1] Guardar propietario y subcartera de los activos de la subcartera CCM');

DBMS_OUTPUT.put_line('[1.1] Guardamos la subcartera de los activos de la subcartera CCM');


V_SQL := 'INSERT INTO '||V_ESQUEMA||'.REVERT_UPDATE_ACT_SCR(ACT_ID,DD_SCR_ID)
            SELECT ACT.ACT_ID, ACT.DD_SCR_ID
            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''58'')';
EXECUTE IMMEDIATE V_SQL;



DBMS_OUTPUT.put_line('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla REVERT_UPDATE_ACT_SCR');




DBMS_OUTPUT.put_line('[1.2] Guardamos los propietarios de los activos de la subcartera CCM');


V_SQL := 'INSERT INTO '||V_ESQUEMA||'.REVERT_UPDATE_ACT_PRO(ACT_ID,PRO_ID)
            SELECT ACT.ACT_ID, PAC.PRO_ID
            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
            JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
            WHERE PAC.PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''BANCO DE CASTILLA LA MANCHA, S.A.'')
            ';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla REVERT_UPDATE_ACT_PRO');




DBMS_OUTPUT.put_line('[2] Guardar propietario de los gastos sin contabilizar. Serán los que no esten en la tabla auxiliar');


V_SQL := 'INSERT INTO '||V_ESQUEMA||'.REVERT_UPDATE_GPV_PRO(GPV_ID,PRO_ID)
          SELECT GPV_ID, PRO_ID
          FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
          WHERE GPV_NUM_GASTO_HAYA NOT IN (SELECT GPV_NUM_GASTO_HAYA FROM '||V_ESQUEMA||'.AUX_FUSION_CMM_LIBER) AND
          PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''BANCO DE CASTILLA LA MANCHA, S.A.'')';


EXECUTE IMMEDIATE V_SQL;

DBMS_OUTPUT.put_line('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla REVERT_UPDATE_GPV_PRO');

COMMIT;
	   

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

