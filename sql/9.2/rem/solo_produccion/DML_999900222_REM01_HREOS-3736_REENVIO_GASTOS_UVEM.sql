--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20180125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3736
--## PRODUCTO=NO
--##
--## Finalidad: Script que prepara gastos para volver a enviarlos a UVEM
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

 
BEGIN   

DBMS_OUTPUT.PUT_LINE('[INICIO] PROCESO PREPARA GASTOS PARA ENVIO');

     -- REACTIVAMOS PROVISIONES
     
     
     -- PROVISIONES GENERADAS 24/01/2018 (Sergio H.)
     -- Solo cambiamos la fecha_envio_propietario ya que nunca recibimos respuesta
     --1.493 gastos
     MERGE INTO REM01.GGE_GASTOS_GESTION T1
     USING (SELECT GPV.GPV_ID
         FROM REM01.GPV_GASTOS_PROVEEDOR GPV
         JOIN REM01.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
         JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
         WHERE GPV.GPV_ID IN (select  gpv.gpv_id
                                from REM01.PRG_PROVISION_GASTOS prg 
                                inner join REM01.GPV_GASTOS_PROVEEDOR gpv on prg.prg_id = gpv.PRG_ID 
                                where trunc(prg.fechacrear) = trunc(sysdate-1)
                                  and prg.usuariocrear = 'apr_main_ru_gastos_uvem'
                                  and gpv.borrado = 0
                                           )
           ) T2
     ON (T1.GPV_ID = T2.GPV_ID)
     WHEN MATCHED THEN UPDATE SET
           T1.USUARIOMODIFICAR = 'REENVIO_EJECUCION_250118', T1.FECHAMODIFICAR = SYSDATE
         , T1.GGE_FECHA_ENVIO_PRPTRIO = NULL
     ;
     
     DBMS_OUTPUT.PUT_LINE('[INFO] Preparados '||SQL%ROWCOUNT||' gastos de provisiones que no se enviaron el 24/01 [Actualizada GGE]');     
     
     -- PROVISION PRUEBA FERNANDO 24/01/2018
     --7 gastos
     
     --Actualizamos estado GASTO a '03' autorizado
     
     MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1
     USING (SELECT GPV.GPV_ID
         FROM REM01.GPV_GASTOS_PROVEEDOR GPV
         JOIN REM01.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
         JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
         JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP EAP ON EAP.DD_EAP_ID = GGE.DD_EAP_ID
         JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON EAH.DD_EAH_ID = GGE.DD_EAH_ID
         WHERE GPV.GPV_ID IN (select  gpv.gpv_id                                
                                from REM01.PRG_PROVISION_GASTOS prg 
                                inner join REM01.GPV_GASTOS_PROVEEDOR gpv on prg.prg_id = gpv.PRG_ID 
                                where prg.prg_num_provision =  120022003
                                  and gpv.borrado = 0)
         ) T2
     ON (T1.GPV_ID = T2.GPV_ID)
     WHEN MATCHED THEN UPDATE SET
         T1.USUARIOMODIFICAR = 'REENVIO_EJECUCION_250118', T1.FECHAMODIFICAR = SYSDATE
         , T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = '03')
     ;
     
     
     DBMS_OUTPUT.PUT_LINE('[INFO] Preparados '||SQL%ROWCOUNT||' gastos de provision prueba 120022003 [Actualizada GPV]');     
     
     --Actualizamos GGE fecha_envio y estado aut propietario
     
     MERGE INTO REM01.GGE_GASTOS_GESTION T1
     USING (SELECT GPV.GPV_ID
         FROM REM01.GPV_GASTOS_PROVEEDOR GPV
         JOIN REM01.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
         JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
         WHERE GPV.GPV_ID IN (select  gpv.gpv_id
                                          from REM01.PRG_PROVISION_GASTOS prg 
                                          inner join REM01.GPV_GASTOS_PROVEEDOR gpv on prg.prg_id = gpv.PRG_ID 
                                          where prg.prg_num_provision =  120022003
                                            and gpv.borrado = 0
                                           )
         ) T2
     ON (T1.GPV_ID = T2.GPV_ID)
     WHEN MATCHED THEN UPDATE SET
           T1.USUARIOMODIFICAR = 'REENVIO_EJECUCION_250118'
         , T1.FECHAMODIFICAR = SYSDATE
         , T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = '03')
         , T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM REM01.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = '01')
         , T1.GGE_FECHA_EAP = NULL
         , T1.GGE_FECHA_ENVIO_PRPTRIO = NULL        
     ;
     
     
     DBMS_OUTPUT.PUT_LINE('[INFO] Preparados '||SQL%ROWCOUNT||' gastos de provision prueba 120022003 [Actualizada GGE]');          
     
     --REACTIVAMOS GASTOS CON IVA
     --861 gastos con IVA
     --Actualizamos estado GASTO a '03' autorizado
     
     MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1
     USING (SELECT GPV.GPV_ID
         FROM REM01.GPV_GASTOS_PROVEEDOR GPV
         JOIN REM01.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
         JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
         JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP EAP ON EAP.DD_EAP_ID = GGE.DD_EAP_ID
         JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON EAH.DD_EAH_ID = GGE.DD_EAH_ID
         WHERE GPV.GPV_ID IN (SELECT  GPV.GPV_ID
                                          FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                                          INNER JOIN REM01.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID AND GDE.BORRADO = 0 
                                          INNER JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID AND GGE.BORRADO = 0 --AND GGE.GGE_FECHA_ENVIO_PRPTRIO IS NULL
                                          INNER JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA DD_EAH ON DD_EAH.DD_EAH_ID = GGE.DD_EAH_ID 
                                          INNER JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP DD_EAP ON DD_EAP.DD_EAP_ID = GGE.DD_EAP_ID 
                                          LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                                          LEFT JOIN REM01.DD_CRA_CARTERA CRA2     ON CRA2.DD_CRA_ID = PRO.DD_CRA_ID  
                                          LEFT JOIN REM01.PRG_PROVISION_GASTOS PRG   ON GPV.PRG_ID = PRG.PRG_ID
                                          INNER JOIN REM01.DD_EGA_ESTADOS_GASTO  EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
                                          WHERE GPV.BORRADO = 0
                                            AND PRG.PRG_ID is null
                                            AND DD_EAH.DD_EAH_CODIGO  = '03'
                                            AND CRA2.DD_CRA_CODIGO    = '03' 
                                            AND (DD_EAP.DD_EAP_CODIGO = '01' OR DD_EAP.DD_EAP_CODIGO IS NULL)
                                            AND EGA.DD_EGA_CODIGO IN ('03', '08')    
                                            AND gpv.borrado = 0
                                          UNION ALL
                                          SELECT 
                                                GPV.GPV_ID
                                          FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                                          INNER JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
                                          INNER JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA DD_EAH ON DD_EAH.DD_EAH_ID = GGE.DD_EAH_ID 
                                          INNER JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP DD_EAP ON DD_EAP.DD_EAP_ID = GGE.DD_EAP_ID 
                                          LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                                          LEFT JOIN REM01.DD_CRA_CARTERA CRA2     ON CRA2.DD_CRA_ID = PRO.DD_CRA_ID  
                                          INNER JOIN REM01.DD_EGA_ESTADOS_GASTO  EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
                                          LEFT JOIN REM01.PRG_PROVISION_GASTOS PRG   ON GPV.PRG_ID = PRG.PRG_ID
                                          WHERE GPV.BORRADO = 0
                                            AND PRG.PRG_ID is null
                                            AND DD_EAH.DD_EAH_CODIGO = '03'
                                            AND CRA2.DD_CRA_CODIGO   = '03' 
                                            AND DD_EAP.DD_EAP_CODIGO = '02'
                                            AND (
                                                  DD_EGA_CODIGO IN ('08')   
                                                )
                                            AND gpv.borrado = 0)
                                              ) T2
     ON (T1.GPV_ID = T2.GPV_ID)
     WHEN MATCHED THEN UPDATE SET
     T1.USUARIOMODIFICAR = 'REENVIO_EJECUCION_250118', T1.FECHAMODIFICAR = SYSDATE
     , T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = '03')
     ;
     
     DBMS_OUTPUT.PUT_LINE('[INFO] Preparados '||SQL%ROWCOUNT||' gastos con IVA  [Actualizada GPV]');           
     
     --Actualizamos GGE fecha_envio y estado aut propietario
     
     MERGE INTO REM01.GGE_GASTOS_GESTION T1
     USING (SELECT GPV.GPV_ID
         FROM REM01.GPV_GASTOS_PROVEEDOR GPV
         JOIN REM01.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
         JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
         WHERE GPV.GPV_ID IN (SELECT GPV.GPV_ID
                                          FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                                          INNER JOIN REM01.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID AND GDE.BORRADO = 0 
                                          INNER JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID AND GGE.BORRADO = 0 --AND GGE.GGE_FECHA_ENVIO_PRPTRIO IS NULL
                                          INNER JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA DD_EAH ON DD_EAH.DD_EAH_ID = GGE.DD_EAH_ID 
                                          INNER JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP DD_EAP ON DD_EAP.DD_EAP_ID = GGE.DD_EAP_ID 
                                          LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                                          LEFT JOIN REM01.DD_CRA_CARTERA CRA2     ON CRA2.DD_CRA_ID = PRO.DD_CRA_ID  
                                          LEFT JOIN REM01.PRG_PROVISION_GASTOS PRG   ON GPV.PRG_ID = PRG.PRG_ID
                                          INNER JOIN REM01.DD_EGA_ESTADOS_GASTO  EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
                                          WHERE GPV.BORRADO = 0
                                            AND PRG.PRG_ID is null
                                            AND DD_EAH.DD_EAH_CODIGO  = '03'
                                            AND CRA2.DD_CRA_CODIGO    = '03' 
                                            AND (DD_EAP.DD_EAP_CODIGO = '01' OR DD_EAP.DD_EAP_CODIGO IS NULL)
                                            AND EGA.DD_EGA_CODIGO IN ('03', '08')    
                                            AND gpv.borrado = 0
                                          UNION ALL
                                          SELECT GPV.GPV_ID
                                          FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                                          INNER JOIN REM01.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
                                          INNER JOIN REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA DD_EAH ON DD_EAH.DD_EAH_ID = GGE.DD_EAH_ID 
                                          INNER JOIN REM01.DD_EAP_ESTADOS_AUTORIZ_PROP DD_EAP ON DD_EAP.DD_EAP_ID = GGE.DD_EAP_ID 
                                          LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                                          LEFT JOIN REM01.DD_CRA_CARTERA CRA2     ON CRA2.DD_CRA_ID = PRO.DD_CRA_ID  
                                          INNER JOIN REM01.DD_EGA_ESTADOS_GASTO  EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID
                                          LEFT JOIN REM01.PRG_PROVISION_GASTOS PRG   ON GPV.PRG_ID = PRG.PRG_ID
                                          WHERE GPV.BORRADO = 0
                                            AND PRG.PRG_ID is null
                                            AND DD_EAH.DD_EAH_CODIGO = '03'
                                            AND CRA2.DD_CRA_CODIGO   = '03' 
                                            AND DD_EAP.DD_EAP_CODIGO = '02'
                                            AND (
                                                  DD_EGA_CODIGO IN ('08')   
                                                )
                                            AND gpv.borrado = 0
                                           )
         ) T2
     ON (T1.GPV_ID = T2.GPV_ID)
     WHEN MATCHED THEN UPDATE SET
           T1.USUARIOMODIFICAR = 'REENVIO_EJECUCION_250118', T1.FECHAMODIFICAR = SYSDATE
         , T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = '03')
         , T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM REM01.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = '01')         
         , T1.GGE_FECHA_EAP = NULL
         , T1.GGE_FECHA_ENVIO_PRPTRIO = NULL        
     ;

     DBMS_OUTPUT.PUT_LINE('[INFO] Preparados '||SQL%ROWCOUNT||' gastos con IVA  [Actualizada GGE]');        

COMMIT;        

DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO PREPARA GASTOS PARA ENVIO');



   
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


