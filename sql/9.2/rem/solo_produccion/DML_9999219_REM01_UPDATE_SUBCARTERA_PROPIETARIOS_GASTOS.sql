--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2236
--## PRODUCTO=NO
--##
--## Finalidad: FUSION CCM TO LIBERBANK
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
	
DBMS_OUTPUT.put_line('[FUSION CCM TO LIBERBANK] SCRIPT DE FUSIÓN');

DBMS_OUTPUT.put_line('[1] Cambiar propietario y subcartera de los activos de la subcartera CCM a la cartera Liberbank');

DBMS_OUTPUT.put_line('[1.1] Cambiamos la subcartera de los activos de la subcartera CCM');


V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
          USING (
                  SELECT ACT.ACT_ID
                  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                  JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                  JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
                  WHERE SCR.DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''58'')
               ) ORIGEN
          ON (ACT.ACT_ID = ORIGEN.ACT_ID)
          WHEN MATCHED THEN
          UPDATE SET 
                  ACT.DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''56''),
                  ACT.USUARIOMODIFICAR = ''FUSION_CMM'',
                  ACT.FECHAMODIFICAR = SYSDATE';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ACT_ACTIVO');




DBMS_OUTPUT.put_line('[1.2] Cambiamos los propietarios de los activos de la subcartera CCM');


V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC
          USING (
                  SELECT ACT.ACT_ID
                  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                  JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                  WHERE PAC.PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''BANCO DE CASTILLA LA MANCHA, S.A.'') 
               ) ORIGEN
          ON (PAC.ACT_ID = ORIGEN.ACT_ID)
          WHEN MATCHED THEN
          UPDATE SET 
                  PAC.PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''LIBERBANK, S.A.''),
                  PAC.USUARIOMODIFICAR = ''FUSION_CMM'',
                  PAC.FECHAMODIFICAR = SYSDATE';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ACT_PAC_PROPIETARIO_ACTIVO');




DBMS_OUTPUT.put_line('[2] Cambiar propietario de los gastos sin contabilizar. Serán los que no esten en la tabla auxiliar');


V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
          USING (
                  SELECT GPV_ID
                  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
                  WHERE GPV_NUM_GASTO_HAYA NOT IN (SELECT GPV_NUM_GASTO_HAYA FROM '||V_ESQUEMA||'.AUX_FUSION_CMM_LIBER)
                  AND PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''BANCO DE CASTILLA LA MANCHA, S.A.'')
               ) ORIGEN
          ON (GPV.GPV_ID = ORIGEN.GPV_ID)
          WHEN MATCHED THEN
          UPDATE SET 
                  GPV.PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''LIBERBANK, S.A.''),
                  GPV.USUARIOMODIFICAR = ''FUSION_CMM'',
                  GPV.FECHAMODIFICAR = SYSDATE';

EXECUTE IMMEDIATE V_SQL;

DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla GPV_GASTOS_PROVEEDOR');

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

