--/*
--#########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180412
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-487
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-487';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de marcado de gastos para enviar a UVEM.');

    EXECUTE IMMEDIATE 'UPDATE REM01.GGE_GASTOS_GESTION GGE_OLD
    set  GGE_OLD.USUARIOMODIFICAR = ''REMVIP-487''
       , GGE_OLD.FECHAMODIFICAR   = sysdate
       , GGE_OLD.GGE_FECHA_ENVIO_PRPTRIO   = null
       , GGE_OLD.DD_EAP_ID = 1
       , GGE_OLD.GGE_FECHA_EAP = NULL        
       where GGE_OLD.gpv_id in (
        select gpv.gpv_id
          from rem01.gpv_gastos_proveedor gpv
          join REM01.GGE_GASTOS_GESTION gge on gpv.gpv_id = gge.GPV_ID
        where gpv.dd_Ega_id = 10
          and gge.GGE_FECHA_ENVIO_PRPTRIO is not null
          and gpv.prg_id is null
          and gpv.usuariocrear = ''gestoria_gastos_gr''
          and gpv.gpv_num_gasto_haya <> 4342912          
  union all
        select gpv1.gpv_id
          from rem01.gpv_gastos_proveedor gpv1
        where  gpv1.gpv_num_gasto_haya 
          in  ( 9195382
            , 9220662
            , 9221723
            , 9225836
            , 9184953
            , 9185707
            , 9199341
            , 9167449
            , 9206303
            , 9229102
            , 9186008
            , 9175609
            , 9185319
            , 9209246
            , 9195433
            , 9169303
            , 9219386
            , 9184867
            , 9199342
            , 9230788
            , 9185299
            , 9206709
            , 9220851
            , 9416204
            , 9418943
            , 9424624
            , 9427823
            , 9427877
            , 9431077
            , 9433177
            , 9434965
            , 9435135
            , 9435159
            , 9435275
            , 9435279
            , 9435280
            , 9435281
            , 9435282
            , 9435283
            , 9435298
            , 9443954
            , 9443955
            , 9445072
            , 9445082
            , 9445094
            , 9445099
            , 9463679
            , 9463705
            , 9445010
            , 9445012
            , 9445014
            , 9445024
            , 9445029
            , 9445036
            , 9445040
            , 9430423
            , 9157992
            , 9157993
            , 9192960
            , 9194968
            , 9202602
            , 9213453
            , 9208707
            , 9209805
            , 9185120
            , 9190686
            , 9223380
            , 9223093
            , 9164666
            , 9212696
            , 9231713
            , 9202488
            , 9169220
            , 9204466
            , 9222049
            , 9198427
            , 9161205
            , 9157989
            , 9157994
            , 9161609
            , 9203248
            , 9203761
            , 9227907
            , 9361722
            , 9211040
            , 9200347
            , 9217617
            , 9219713
            , 9183261
            , 9183925
            , 9222572
            , 9223653
            , 9207859
            , 9221929
            , 9211278
            , 9162805
            , 9185132
            , 9196860
            , 9183769
            , 9183924
            , 9315588
            , 9206171
            , 9218556
            , 9199501
            , 9222981
            , 9213978
            , 9162946
            , 9166543
            , 9184894
            , 9194967
            , 9202234
            , 9170935
            , 9195270
            , 9168652
            , 9185109
            , 9231981
            , 9473330
            , 9473335
            , 9473336
            , 9489765
            , 9485830
            , 9485842
            , 9485843
            , 9485844
            , 9485845
            , 9490564
            , 9490565
            , 9492525
            , 9492530
            , 9492551
            , 9483586
            , 9497395
            , 9496127
            , 9496557
            , 9496610
            , 9502411
            , 9552331
            , 9552332
            , 9552333
            , 9552337
            , 9552339
            , 9552344
            , 9552360
            , 9553030
            , 9552468
            , 9552477
            , 9552493
            , 9555291
            , 9555213
            , 9555214
            , 9555225
            , 9559241
            , 9559246
            , 9559250
            , 9556186
            , 9556208
            , 9556212
            , 9556215
            , 9556216
            , 9556225
            , 9556242
            , 9556257
            , 9560960
            , 9560963
            , 9560966
            , 9560967
            , 9560968
            , 9560973
            , 9560975
            , 9560976
            , 9560977
            , 9560980
            , 9560982
            , 9560983
            , 9560984
            , 9560985
            , 9560988
            , 9560993
            , 9562451
            , 9562452
            , 9562453
            , 9562454
            , 9562473
            , 9562475))'; 

   DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GGE_GASTOS_GESTION');            
            
   DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso de marcado de gastos para enviar a UVEM.');
   

EXCEPTION
    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;

END;
/
EXIT;
