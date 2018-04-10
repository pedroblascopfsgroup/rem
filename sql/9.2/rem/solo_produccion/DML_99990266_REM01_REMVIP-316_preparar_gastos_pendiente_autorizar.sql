--/*
--##########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180315
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-316
--## PRODUCTO=NO
--##
--## Finalidad: Borrar AGR_ID mal asignado en algunas ofertas
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
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-316';
 
 BEGIN

 --Ponemos el estado del o de los gastos en Autorizado Administración

   EXECUTE IMMEDIATE   'MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1
         USING (SELECT GPV.GPV_ID
             FROM REM01.GPV_GASTOS_PROVEEDOR GPV
             JOIN REM01.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
             JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
             left JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP EAP ON EAP.DD_EAP_ID = GGE.DD_EAP_ID
             left JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON EAH.DD_EAH_ID = GGE.DD_EAH_ID
             WHERE GPV.GPV_ID IN (select gpv.gpv_id 
                                  from REM01.GPV_GASTOS_PROVEEDOR gpv 
                                  where gpv.GPV_NUM_GASTO_HAYA in (
                                        9422855
                                       ,9416204
                                       ,9423472
                                       ,9416197
                                       ,9431055
                                       ,9431069
                                       ,9430509
                                       ,9429251
                                       ,9445081
                                       ,9433169
                                       ,9433171
                                       ,9433358
                                       ,9431051
                                       ,9431048
                                       ))
             ) T2
         ON (T1.GPV_ID = T2.GPV_ID)
         WHEN MATCHED THEN UPDATE SET
             T1.USUARIOMODIFICAR = ''REMVIP-316'', T1.FECHAMODIFICAR = SYSDATE
             , T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''01'')';

 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GPV_GASTOS_PROVEEDOR');    

--Ponemos el estado de autorización por parte de Haya en Autorizado y eliminamos el estado de autorización del propietario, así como actualizar la fecha del estado de autorización de Haya y eliminamos las fechas de estado de autorización del propietario y de envío al propietario

         EXECUTE IMMEDIATE   ' MERGE INTO REM01.GGE_GASTOS_GESTION T1       
       USING (SELECT GPV.GPV_ID      
           FROM REM01.GPV_GASTOS_PROVEEDOR GPV       
           JOIN REM01.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID       
           JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID       
           left JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP EAP ON EAP.DD_EAP_ID = GGE.DD_EAP_ID       
           left JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON EAH.DD_EAH_ID = GGE.DD_EAH_ID       
           WHERE GPV.GPV_ID IN (select gpv.gpv_id 
                                  from REM01.GPV_GASTOS_PROVEEDOR gpv 
                                  where gpv.GPV_NUM_GASTO_HAYA in (
                                        9422855
                                       ,9416204
                                       ,9423472
                                       ,9416197
                                       ,9431055
                                       ,9431069
                                       ,9430509
                                       ,9429251
                                       ,9445081
                                       ,9433169
                                       ,9433171
                                       ,9433358
                                       ,9431051
                                       ,9431048
                                       ))
              ) T2       
       ON (T1.GPV_ID = T2.GPV_ID)       
       WHEN MATCHED THEN UPDATE SET       
           T1.USUARIOMODIFICAR = ''REMVIP-316'', T1.FECHAMODIFICAR = SYSDATE       
           , T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''01'')       
           , T1.GGE_FECHA_EAH = null
           , T1.DD_EAP_ID = NULL
           , T1.GGE_FECHA_EAP = NULL       
           , T1.GGE_FECHA_ENVIO_PRPTRIO = NULL
           , T1.GGE_MOTIVO_RECHAZO_PROP = NULL';

        
 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GGE_GASTOS_GESTION');
 
 COMMIT;
 
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
