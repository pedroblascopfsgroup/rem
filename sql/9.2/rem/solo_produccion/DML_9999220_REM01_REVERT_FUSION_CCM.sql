--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2236
--## PRODUCTO=NO
--##
--## Finalidad: FUSION CCM TO LIBERBANK Script para realizar un revert de la fusión
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
	
DBMS_OUTPUT.put_line('[FUSION CCM TO LIBERBANK] SCRIPT DE REVERT');

DBMS_OUTPUT.put_line('[1] Cambiar propietario y subcartera de los activos por su valor anterior a la fusión');

DBMS_OUTPUT.put_line('[1.1] Cambiamos la subcartera de los activos que tenemos en la tabla REVERT_UPDATE_ACT_SCR por su valor anterior a la fusión');


V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
          USING (
                  SELECT ACT_ID,DD_SCR_ID 
                  FROM '||V_ESQUEMA||'.REVERT_UPDATE_ACT_SCR
                  GROUP BY ACT_ID,DD_SCR_ID       
               ) ORIGEN
          ON (ACT.ACT_ID = ORIGEN.ACT_ID)
          WHEN MATCHED THEN
          UPDATE SET 
                  ACT.DD_SCR_ID = ORIGEN.DD_SCR_ID,
                  ACT.USUARIOMODIFICAR = ''FUSION_CMM_REVERT'',
                  ACT.FECHAMODIFICAR = SYSDATE';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ACT_ACTIVO');



 
DBMS_OUTPUT.put_line('[1.2] Cambiamos los propietarios de los activos que tenemos en la tabla ACT_PAC_PROPIETARIO_ACTIVO por su valor anterior a la fusión');


V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC
          USING (
                  SELECT PAC.ACT_ID,REVERT.PRO_ID 
                  FROM '||V_ESQUEMA||'.REVERT_UPDATE_ACT_PRO REVERT
                  JOIN '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON PAC.ACT_ID = REVERT.ACT_ID
                  GROUP BY PAC.ACT_ID,REVERT.PRO_ID       
               ) ORIGEN
          ON (PAC.ACT_ID = ORIGEN.ACT_ID)
          WHEN MATCHED THEN
          UPDATE SET 
                  PAC.PRO_ID = ORIGEN.PRO_ID,
                  PAC.USUARIOMODIFICAR = ''FUSION_CMM'',
                  PAC.FECHAMODIFICAR = SYSDATE';
EXECUTE IMMEDIATE V_SQL;


DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros en la tabla ACT_PAC_PROPIETARIO_ACTIVO');




DBMS_OUTPUT.put_line('[2] Cambiamos los propietario de los gastos que tenemos en la tabla REVERT_UPDATE_GPV_PRO por su valor anterior a la fusión');


V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
          USING (
                  SELECT GPV_ID, PRO_ID
                  FROM '||V_ESQUEMA||'.REVERT_UPDATE_GPV_PRO
                  GROUP BY GPV_ID,PRO_ID
               ) ORIGEN
          ON (GPV.GPV_ID = ORIGEN.GPV_ID)
          WHEN MATCHED THEN
          UPDATE SET 
                  GPV.PRO_ID = ORIGEN.PRO_ID,
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

