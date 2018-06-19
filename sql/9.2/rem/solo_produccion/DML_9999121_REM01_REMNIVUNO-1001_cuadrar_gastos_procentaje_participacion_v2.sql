--/*
--#########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180619
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMNIVUNO-1001
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMNIVUNO-1001';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso cuadre de porcentaje de participación del gasto.');

    EXECUTE IMMEDIATE 'MERGE INTO rem01.gpv_act ga_old
                      USING(
                             select distinct 
                                100 -  sum(ga.gpv_participacion_gasto) over (partition by ga.gpv_id ) as gpv_diff_part
                               , max(ga.gpv_act_id) over (partition by ga.gpv_id ) as gpv_act_id
                             from rem01.gpv_gastos_proveedor gpv
                             join rem01.gpv_act ga on gpv.gpv_id = ga.gpv_id
                             where gpv.gpv_num_gasto_haya in (  9463619
                                                              , 9594713
                                                              , 9601901
                                                              , 9594699
                                                              , 9594682
                                                              , 9596169
                                                              , 9596005
                                                              , 9620637
                                                              , 9595988
                                                              , 9601899
                                                              , 9594760
                                                              , 9620642
                                                              , 9596162
                                                              , 9594744
                                                              , 9594714
                                                              , 9596159
                                                              , 9451510
                                                              , 9595955
                                                              , 9595991
                                                              , 9604529
                                                              , 9620644
                                                              , 9596003
                                                              , 9594698
                                                              , 9594619
                                                              , 9596171
                                                              , 9594621
                                                              , 9596173
                                                              , 9595949
                                                              , 9620651
                                                              , 9592254
                                                              , 9595964
                                                              , 9620650
                                                              , 9595986
                                                              , 9594751
                                                              , 9620652
                                                              , 9485851
                                                              , 9615893
                                                              , 9615895
                                                              , 9466630
                                                              , 9471940
                                  )
                               ) ga_new on (ga_old.gpv_act_id = ga_new.gpv_act_id)
                        when matched then update 
                        set ga_old.gpv_participacion_gasto = ga_old.gpv_participacion_gasto + ga_new.gpv_diff_part'; 

   DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' gastos en la GPV_ACT');            
            
   DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso de cuadre de porcentaje de participación del gasto.');
   

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
