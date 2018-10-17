--/*
--##########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1366
--## PRODUCTO=NO
--##
--## Finalidad: preparar gastos para envío a UVEM y revisar su retorno
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
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1366';
 
 BEGIN

 --Ponemos el estado del o de los gastos en Autorizado Administración

   EXECUTE IMMEDIATE   'MERGE INTO REM01.GGE_GASTOS_GESTION T1
                        USING (
                            SELECT GPV_ID
                            FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                            WHERE GPV_NUM_GASTO_HAYA IN (  9435157
                        ,    9652610
                        , 9652601
                        , 9652608
                        , 9652606
                        , 9652600
                        , 9635107
                        , 9676946
                        , 9704909
                        , 9603964
                        , 9652612
                        , 9594725
                        , 9592253
                        , 9592255
                        , 9592258
                        , 9592260
                        , 9556208
                        , 9652611
                        , 9493997
                        , 9494000
                        , 9493995
                        , 9493999
                        , 9450799
                        , 9431140
                        , 9431155
                        , 9648775
                        , 9492612
                        , 9432823
                        , 9432764
                        , 9432776
                        , 9432790
                        , 9432794
                        , 9432798
                        , 9432807
                        , 9431097
                        , 9492539
                        , 9492542
                        , 9594717
                        , 9424437
                        , 9472003
                        , 9472018
                        , 9471999
                        , 9472021
                        , 9450220
                        , 9430454
                        , 9483652
                        , 9496132
                        , 9719682
                        , 9435146
                        , 9431104
                        , 9432902
                        , 9431102
                        , 9431100
                        , 9431095)
                        
                            ) T2
                        ON (T1.GPV_ID = T2.GPV_ID)
                        WHEN MATCHED THEN UPDATE SET
                            T1.DD_EAH_ID = 3
                          , T1.GGE_FECHA_EAH = SYSDATE
                          , T1.DD_EAP_ID = 1
                          , T1.GGE_FECHA_EAP = NULL
                          , T1.GGE_MOTIVO_RECHAZO_PROP = NULL
                          , T1.GGE_FECHA_ENVIO_PRPTRIO = NULL
                          , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                          , T1.FECHAMODIFICAR = SYSDATE';
                       

 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GGE_GASTOS_GESTION');    

--Ponemos el estado de autorización por parte de Haya en Autorizado y eliminamos el estado de autorización del propietario, así como actualizar la fecha del estado de autorización de Haya y eliminamos las fechas de estado de autorización del propietario y de envío al propietario

         EXECUTE IMMEDIATE   ' MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1
                               USING (
                                   SELECT GPV_ID
                                   FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                                   WHERE GPV_NUM_GASTO_HAYA IN ( 9435157
                               , 9652610
                               , 9652601
                               , 9652608
                               , 9652606
                               , 9652600
                               , 9635107
                               , 9676946
                               , 9704909
                               , 9603964
                               , 9652612
                               , 9594725
                               , 9592253
                               , 9592255
                               , 9592258
                               , 9592260
                               , 9556208
                               , 9652611
                               , 9493997
                               , 9494000
                               , 9493995
                               , 9493999
                               , 9450799
                               , 9431140
                               , 9431155
                               , 9648775
                               , 9492612
                               , 9432823
                               , 9432764
                               , 9432776
                               , 9432790
                               , 9432794
                               , 9432798
                               , 9432807
                               , 9431097
                               , 9492539
                               , 9492542
                               , 9594717
                               , 9424437
                               , 9472003
                               , 9472018
                               , 9471999
                               , 9472021
                               , 9450220
                               , 9430454
                               , 9483652
                               , 9496132
                               , 9719682
                               , 9435146
                               , 9431104
                               , 9432902
                               , 9431102
                               , 9431100
                               , 9431095)
                               
                                   ) T2
                               ON (T1.GPV_ID = T2.GPV_ID)
                               WHEN MATCHED THEN UPDATE SET
                                   T1.DD_EGA_ID = 3, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
                               
        
 DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GPV_GASTOS_PROVEEDOR');
 
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
