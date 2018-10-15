

--/*
--##########################################
--## AUTOR=Ivan Castelló
--## FECHA_CREACION=20180904
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1737
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
set serveroutput on;
SET DEFINE OFF;

DECLARE

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_NUM_TABLAS NUMBER(16); -- Variable auxiliar
   USUARIO_CONSULTA_REM VARCHAR2(50 CHAR):= 'REM_QUERY';
   V_USUARIO_MODIFICAR VARCHAR2(50 CHAR):='REMVIP-1737';

BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');              
                                
           V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION T1 USING
                                            (SELECT GPV_ID 
                                            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                                            WHERE GPV_NUM_GASTO_HAYA IN ( 
                                                  9492530,
                                                  9490565,
                                                  9560975,
                                                  9560976,
                                                  9560966,
                                                  9689955
                                            )
                                            )T2 ON (
                                            T1.GPV_ID = T2.GPV_ID
                                    ) WHEN MATCHED THEN
                                            UPDATE
                                            SET T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM  '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03''),
                                                    T1.GGE_FECHA_EAH = SYSDATE,
                                                    T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM  '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''01''),
                                                    T1.GGE_FECHA_EAP = NULL,
                                                    T1.GGE_MOTIVO_RECHAZO_PROP = NULL,
                                                    T1.GGE_FECHA_ENVIO_PRPTRIO = NULL,
                                                    T1.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||''',
                                                    T1.FECHAMODIFICAR = SYSDATE';
            
            EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas en tabla GGE_GASTOS_GESTION merge 1.');


            
            V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1 USING
                                            (SELECT GPV_ID 
                                              FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                                              WHERE GPV_NUM_GASTO_HAYA IN ( 
                                                  9492530,
                                                  9490565,
                                                  9560975,
                                                  9560976,
                                                  9560966,
                                                  9689955
                                            )
                                            )T2 ON (
                                            T1.GPV_ID = T2.GPV_ID
                                    ) WHEN MATCHED THEN
                                            UPDATE
                                            SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03''),
                                                    T1.PRG_ID = NULL,
                                                    T1.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||''',
                                                    T1.FECHAMODIFICAR = SYSDATE';
                                                    
            EXECUTE IMMEDIATE V_SQL;


    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas en tabla GPV_GASTOS_PROVEEDOR merge 2.');



 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION T1 USING
                                            (SELECT GPV_ID 
                                            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                                            WHERE GPV_NUM_GASTO_HAYA IN ( 
                                                 

select GPV.GPV_NUM_GASTO_HAYA
from rem01.GPV_GASTOS_PROVEEDOR GPV
JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
join REM01.PRG_PROVISION_GASTOS prg on PRG.PRG_ID = gpv.prg_id
WHERE PRG.PRG_NUM_PROVISION in (

170925634,
180925616,
180925620,
180925624,
180925630,
180925633,
180925642,
170925656,
180925657,
180925658,
180925660,
180925661,
180925662,
180925663,
180925664,
170923628,
180923637,
180923638,
180923643,
180921617,
180921618,
180921621,
180921622,
180921623,
180921629,
180921635,
180921636,
180921639,
180921645,
180924627,
180923637
)


                                                 
                                            )
                                            )T2 ON (
                                            T1.GPV_ID = T2.GPV_ID
                                    ) WHEN MATCHED THEN
                                            UPDATE
                                            SET T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM  '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03''),
                                                    T1.GGE_FECHA_EAH = SYSDATE,
                                                    T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM  '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''01''),
                                                    T1.GGE_FECHA_EAP = NULL,
                                                    T1.GGE_MOTIVO_RECHAZO_PROP = NULL,
                                                    T1.GGE_FECHA_ENVIO_PRPTRIO = NULL,
                                                    T1.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||''',
                                                    T1.FECHAMODIFICAR = SYSDATE';
            
            EXECUTE IMMEDIATE V_SQL;


            DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas en tabla GPV_GASTOS_PROVEEDOR merge 3.');

            
            V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1 USING
                                            (SELECT GPV_ID 
                                              FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                                              WHERE GPV_NUM_GASTO_HAYA IN ( 


select GPV.GPV_NUM_GASTO_HAYA
from rem01.GPV_GASTOS_PROVEEDOR GPV
JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
join REM01.PRG_PROVISION_GASTOS prg on PRG.PRG_ID = gpv.prg_id
WHERE PRG.PRG_NUM_PROVISION in (

170925634,
180925616,
180925620,
180925624,
180925630,
180925633,
180925642,
170925656,
180925657,
180925658,
180925660,
180925661,
180925662,
180925663,
180925664,
170923628,
180923637,
180923638,
180923643,
180921617,
180921618,
180921621,
180921622,
180921623,
180921629,
180921635,
180921636,
180921639,
180921645,
180924627,
180923637
)




                                                
                                            )
                                            )T2 ON (
                                            T1.GPV_ID = T2.GPV_ID
                                    ) WHEN MATCHED THEN
                                            UPDATE
                                            SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''03''),
                                                    T1.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||''',
                                                    T1.FECHAMODIFICAR = SYSDATE';
                                                    
            EXECUTE IMMEDIATE V_SQL;


            DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' filas actualizadas en tabla GPV_GASTOS_PROVEEDOR merge 4.');


                        
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: GASTOS REENVIADOS CORRECTAMENTE ');

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '||ERR_MSG);
      ROLLBACK;
      RAISE;
END;
/
EXIT


