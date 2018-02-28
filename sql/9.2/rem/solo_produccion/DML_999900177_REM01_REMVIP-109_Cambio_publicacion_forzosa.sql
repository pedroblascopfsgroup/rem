--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20180221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-109
--## PRODUCTO=NO
--##
--## Finalidad: Script cambio activos Bolsa de Ocupados Bankia a publicacion forzosa.
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

DBMS_OUTPUT.PUT_LINE('[INICIO] PROCESO cambio publicacion forzosa');

DBMS_OUTPUT.PUT_LINE('Actualizamos registros existentes en la HEP con fecha hasta');

MERGE INTO REM01.ACT_HEP_HIST_EST_PUBLICACION HEP_OLD
USING (
       select act.act_id
       from REM01.ACT_ACTIVO act
       where act.act_num_Activo in (
            5925298
, 5925548
, 5926896
, 5927440
, 5928288
, 5930235
, 5930339
, 5932297
, 5933219
, 5934023
, 5934710
, 5936278
, 5937534
, 5937992
, 5938102
, 5938211
, 5938278
, 5939462
, 5939748
, 5940255
, 5940852
, 5941428
, 5942266
, 5942395
, 5942462
, 5942957
, 5943102
, 5943748
, 5944277
, 5944508
, 5944883
, 5945078
, 5945273
, 5945457
, 5946218
, 5946679
, 5947650
, 5948009
, 5950055
, 5951219
, 5951331
, 5951854
, 5952663
, 5952860
, 5953439
, 5953492
, 5954347
, 5955205
, 5956128
, 5957290
, 5957690
, 5959052
, 5959407
, 5960242
, 5961294
, 5962372
, 5962776
, 5963362
, 5963698
, 5964260
, 5964381
, 5964531
, 5964943
, 5964961
, 5965098
, 5965708
, 5966491
, 5966665
, 5966726
, 5966944
, 5967587
, 5967909
, 5968770
, 5969476
, 5969790
, 5969811
, 5970460
, 5925024
, 5925025
, 5925418
, 5926078
, 5926102
, 5926996
, 5927149
, 5927201
, 5927709
, 5928039
, 5929076
, 5929480
, 5929684
, 5930016
, 5930074
, 5930196
, 5930952
, 5931264
, 5931472
, 5931599
, 5931653
, 5932004
, 5932787
, 5932809
, 5932912
, 5933587
, 5933846
, 5934927
, 5935581
, 5935768
, 5935769
, 5935812
, 5935860
, 5936382
, 5937052
, 5937193
, 5937574
, 5937691
, 5937836
, 5938111
, 5938183
, 5938585
, 5939201
, 5939417
, 5939461
, 5939649
, 5941461
, 5941723
, 5942550
, 5943024
, 5943792
, 5943994
, 5944385
, 5944609
, 5944949
, 5945875
, 5946023
, 5946103
, 5946189
, 5947024
, 5947176
, 5949394
, 5949558
, 5949625
, 5949916
, 5950273
, 5950490
, 5950988
, 5952287
, 5952605
, 5953102
, 5953197
, 5954392
, 5954498
, 5954951
, 5955345
, 5955466
, 5956338
, 5956362
, 5958065
, 5958168
, 5959499
, 5959824
, 5960294
, 5961112
, 5961125
, 5961943
, 5962285
, 5962688
, 5962912
, 5963948
, 5964138
, 5964272
, 5964376
, 5964821
, 5964975
, 5965338
, 5965348
, 5965641
, 5967393
, 5967562
, 5967839
, 5968297
, 5968375
, 5968638
, 5969086
, 5969705
, 5969726
, 5969880
, 5969988
, 5969999
           )
) HEP_NEW 
ON (HEP_OLD.ACT_ID = HEP_NEW.ACT_ID)
WHEN MATCHED THEN UPDATE 
SET HEP_OLD.hep_fecha_hasta = sysdate
--,   HEP_OLD.HEP_MOTIVO ='Bolsa de ocupados Bankia'
,   HEP_OLD.USUARIOMODIFICAR = 'REMVIP-109'
,   HEP_OLD.FECHAMODIFICAR = sysdate
 where HEP_OLD.hep_fecha_hasta is null
 ;


    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registros actualizados ACT_HEP_HIST_EST_PUBLICACION informamos FECHA_HASTA.');

DBMS_OUTPUT.PUT_LINE('Se inserta una nueva línea en la HEP con HEP_FECHA_HASTA y HEP_FECHA_DESDE a sysdate y el estado de la publicación a "No Publicado"');

INSERT INTO   REM01.ACT_HEP_HIST_EST_PUBLICACION HEP (
               HEP_ID
              ,ACT_ID
              ,HEP_FECHA_DESDE
              ,HEP_FECHA_HASTA
              ,DD_POR_ID
              ,DD_TPU_ID
              ,DD_EPU_ID
              ,HEP_MOTIVO
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT
            REM01.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL                AS HEP_ID,
            HEP_OLD.ACT_ID                                              AS ACT_ID,
            sysdate                                                     AS HEP_FECHA_DESDE,
            sysdate                                                     AS HEP_FECHA_HASTA,
            null  AS DD_POR_ID,
            null  AS DD_TPU_ID,
            (select dd_epu_id from rem01.dd_epu_estado_publicacion where dd_epu_codigo = '06')            AS DD_EPU_ID,
            'Bolsa de ocupados Bankia'                                  AS HEP_MOTIVO,
            0                                                           AS VERSION,
            'REMVIP-109'                                                AS USUARIOCREAR,
            SYSDATE                                                     AS FECHACREAR,
            0                                                           AS BORRADO
          FROM REM01.ACT_HEP_HIST_EST_PUBLICACION HEP_OLD
          WHERE HEP_OLD.USUARIOMODIFICAR = 'REMVIP-109';

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registros insertados ACT_HEP_HIST_EST_PUBLICACION ');         
          
DBMS_OUTPUT.PUT_LINE('Se inserta una nueva línea en la HEP con HEP_FECHA_DESDE a sysdate y estado a "Publicación Forzada"');
   
INSERT INTO REM01.ACT_HEP_HIST_EST_PUBLICACION HEP (
               HEP_ID
              ,ACT_ID
              ,HEP_FECHA_DESDE
              ,HEP_FECHA_HASTA
              ,DD_POR_ID
              ,DD_TPU_ID
              ,DD_EPU_ID
              ,HEP_MOTIVO
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT
            REM01.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL                AS HEP_ID,
            HEP_OLD.ACT_ID                                              AS ACT_ID,
            sysdate                                                     AS HEP_FECHA_DESDE,
            null                                                        AS HEP_FECHA_HASTA,
            (select dd_por_id from rem01.dd_por_portal where dd_por_codigo = '01')  AS DD_POR_ID,
            (select dd_tpu_id from rem01.dd_tpu_tipo_publicacion where dd_tpu_codigo = '02')  AS DD_TPU_ID,
            (select dd_epu_id from rem01.dd_epu_estado_publicacion where dd_epu_codigo = '02')            AS DD_EPU_ID,
            'Bolsa de ocupados Bankia'                                  AS HEP_MOTIVO,
            0                                                           AS VERSION,
            'REMVIP-109'                                                AS USUARIOCREAR,
            SYSDATE                                                     AS FECHACREAR,
            0                                                           AS BORRADO
          FROM REM01.ACT_HEP_HIST_EST_PUBLICACION HEP_OLD
          WHERE HEP_OLD.USUARIOMODIFICAR = 'REMVIP-109';
 
 DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registros insertados ACT_HEP_HIST_EST_PUBLICACION ');  

 DBMS_OUTPUT.PUT_LINE('Actualizamos ACT_ATIVO estado publicación "Publicacion forzosa"');
 
MERGE INTO REM01.ACT_ACTIVO ACT_OLD
USING (
 select act.act_id
       from REM01.ACT_ACTIVO act
       where act.act_num_Activo in (
            5925298
, 5925548
, 5926896
, 5927440
, 5928288
, 5930235
, 5930339
, 5932297
, 5933219
, 5934023
, 5934710
, 5936278
, 5937534
, 5937992
, 5938102
, 5938211
, 5938278
, 5939462
, 5939748
, 5940255
, 5940852
, 5941428
, 5942266
, 5942395
, 5942462
, 5942957
, 5943102
, 5943748
, 5944277
, 5944508
, 5944883
, 5945078
, 5945273
, 5945457
, 5946218
, 5946679
, 5947650
, 5948009
, 5950055
, 5951219
, 5951331
, 5951854
, 5952663
, 5952860
, 5953439
, 5953492
, 5954347
, 5955205
, 5956128
, 5957290
, 5957690
, 5959052
, 5959407
, 5960242
, 5961294
, 5962372
, 5962776
, 5963362
, 5963698
, 5964260
, 5964381
, 5964531
, 5964943
, 5964961
, 5965098
, 5965708
, 5966491
, 5966665
, 5966726
, 5966944
, 5967587
, 5967909
, 5968770
, 5969476
, 5969790
, 5969811
, 5970460
, 5925024
, 5925025
, 5925418
, 5926078
, 5926102
, 5926996
, 5927149
, 5927201
, 5927709
, 5928039
, 5929076
, 5929480
, 5929684
, 5930016
, 5930074
, 5930196
, 5930952
, 5931264
, 5931472
, 5931599
, 5931653
, 5932004
, 5932787
, 5932809
, 5932912
, 5933587
, 5933846
, 5934927
, 5935581
, 5935768
, 5935769
, 5935812
, 5935860
, 5936382
, 5937052
, 5937193
, 5937574
, 5937691
, 5937836
, 5938111
, 5938183
, 5938585
, 5939201
, 5939417
, 5939461
, 5939649
, 5941461
, 5941723
, 5942550
, 5943024
, 5943792
, 5943994
, 5944385
, 5944609
, 5944949
, 5945875
, 5946023
, 5946103
, 5946189
, 5947024
, 5947176
, 5949394
, 5949558
, 5949625
, 5949916
, 5950273
, 5950490
, 5950988
, 5952287
, 5952605
, 5953102
, 5953197
, 5954392
, 5954498
, 5954951
, 5955345
, 5955466
, 5956338
, 5956362
, 5958065
, 5958168
, 5959499
, 5959824
, 5960294
, 5961112
, 5961125
, 5961943
, 5962285
, 5962688
, 5962912
, 5963948
, 5964138
, 5964272
, 5964376
, 5964821
, 5964975
, 5965338
, 5965348
, 5965641
, 5967393
, 5967562
, 5967839
, 5968297
, 5968375
, 5968638
, 5969086
, 5969705
, 5969726
, 5969880
, 5969988
, 5969999
           )
       ) ACT_NEW
ON (ACT_OLD.ACT_ID = ACT_NEW.ACT_ID)
WHEN MATCHED THEN UPDATE 
SET ACT_OLD.DD_EPU_ID = (select dd_epu_id from rem01.dd_epu_estado_publicacion where dd_epu_codigo = '02')
,   ACT_OLD.USUARIOMODIFICAR = 'REMVIP-109'
,   ACT_OLD.FECHAMODIFICAR = sysdate;

 DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' actualizados ACT_ACTIVO');  

    
 DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO cambio publicacion forzosa');

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

EXIT;


