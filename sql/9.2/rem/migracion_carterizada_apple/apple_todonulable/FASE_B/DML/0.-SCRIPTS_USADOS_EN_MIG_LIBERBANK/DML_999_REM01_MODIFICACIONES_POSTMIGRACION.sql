--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=201701004
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2333
--## PRODUCTO=NO
--## 
--## Finalidad: Modificaciones varias tras migracion
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

    TABLE_COUNT NUMBER(10,0) := 0;
    TABLE_COUNT_2 NUMBER(10,0) := 0;
    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
    V_EXISTE NUMBER (15);
    MAX_NUM NUMBER (16);
    V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_MSQL VARCHAR2(4000 CHAR);
    V_REG_TOTAL NUMBER(20,0) := 0;
    V_REG_ACTUALIZADOS NUMBER(20,0) := 0;

BEGIN

    --###############################################
    --##### SITUACION POSESORIA 
    --###############################################

    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION SOBRE LA TABLA '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA');
    
    V_MSQL := '
            merge into '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA act
            using (with tmp as 
            (select row_number()  over (partition by act_id order by HAL_FECHA_INICIO_CONTRATO desc) NUM,  act_id,HAL_NUMERO_CONTRATO_ALQUILER, HAL_FECHA_INICIO_CONTRATO 
             from '||V_ESQUEMA||'.ACT_HAL_HIST_ALQUILERES
            )
            select * from tmp where num = 1) alq
            on (act.act_id = alq.act_id )
            when matched then update
            set act.SPS_NUMERO_CONTRATO_ALQUILER = alq.HAL_NUMERO_CONTRATO_ALQUILER
    '
    ;
    EXECUTE IMMEDIATE V_MSQL;
    
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
     
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. 01 - PENDIENTE AUTOMATIZAR');
    
    --
    --
    
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION SOBRE LA TABLA '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA');
    
    V_MSQL := '
        update '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA act
        set SPS_FECHA_TITULO = (
        with alq as 
        (select row_number()  over (partition by act_id order by HAL_FECHA_INICIO_CONTRATO desc) NUM,  act_id,HAL_FECHA_INICIO_CONTRATO 
         from '||V_ESQUEMA||'.ACT_HAL_HIST_ALQUILERES
        ) 
        select HAL_FECHA_INICIO_CONTRATO from alq where alq.act_id = act.act_id and alq.num = 1 ),
         SPS_FECHA_VENC_TITULO = (
        with alq as 
        (select row_number()  over (partition by act_id order by HAL_FECHA_INICIO_CONTRATO desc) NUM,  act_id,HAL_FECHA_FIN_CONTRATO 
         from '||V_ESQUEMA||'.ACT_HAL_HIST_ALQUILERES
        ) 
        select HAL_FECHA_FIN_CONTRATO from alq where alq.act_id = act.act_id and alq.num = 1 )
        where SPS_FECHA_TITULO is null
    '
    ;
    EXECUTE IMMEDIATE V_MSQL;
    
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
     
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. 02 - RECHAZO ADMINISTRACION');
    
    --
    --

    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION SOBRE LA TABLA '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA');
    
    V_MSQL := '
        update '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA act
        set SPS_FECHA_RESOLUCION_CONTRATO = (
        with alq as 
        (select row_number()  over (partition by act_id order by HAL_FECHA_INICIO_CONTRATO desc) NUM,  act_id,HAL_FECHA_RESOLUCION_CONTRATO  
         from '||V_ESQUEMA||'.ACT_HAL_HIST_ALQUILERES
        ) 
        select HAL_FECHA_RESOLUCION_CONTRATO  from alq where alq.act_id = act.act_id and alq.num = 1 )
        where SPS_FECHA_RESOLUCION_CONTRATO is null
    '
    ;
    EXECUTE IMMEDIATE V_MSQL;
    
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
     
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. 03 - AUTORIZADO ADMINISTRACION');


    --###############################################
    --##### CLIENTES_COMERCIALES 
    --###############################################
     

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICACION CLC_CLIENTE_COMERCIAL');

    V_MSQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''CLC_CLIENTE_COMERCIAL'' and owner = '''||V_ESQUEMA||''' and (column_name = ''CLC_WEBCOM_ID_OLD'')';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;
    -- Si NO existen los campos los creamos
 
    IF V_EXISTE = 0 THEN
        V_MSQL := 'ALTER TABLE '||v_esquema||'.CLC_CLIENTE_COMERCIAL ADD CLC_WEBCOM_ID_OLD NUMBER(16,0)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] CLC_CLIENTE_COMERCIAL creada columna CLC_WEBCOM_ID_OLD');       
    END IF; 
  
    EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL set CLC_WEBCOM_ID = CLC_REM_ID where usuariocrear = '''||V_USUARIO||'''');


    --###############################################
    --##### AGRUPACIONES 
    --###############################################

    EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.ACT_AGR_AGRUPACION set AGR_NUM_AGRUP_REM = AGR_NUM_AGRUP_UVEM where AGR_NUM_AGRUP_UVEM IS NOT NULL AND USUARIOMODIFICAR = '''||V_USUARIO||'''');

    -- Obtenemos el valor maximo de la columna AGR_NUM_AGRUP_REM y lo incrementamos en 1
    V_MSQL := 'SELECT NVL(MAX(AGR_NUM_AGRUP_REM),0) FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION';
    EXECUTE IMMEDIATE V_MSQL INTO MAX_NUM;
    
    MAX_NUM := MAX_NUM +1;
    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_AGR_NUM_AGRUP_REM'' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''' INTO V_EXISTE; 
    
    -- Si existe secuencia la borramos
    IF V_EXISTE = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_AGR_NUM_AGRUP_REM';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_AGR_NUM_AGRUP_REM... Secuencia eliminada');    
    END IF;
    
    EXECUTE IMMEDIATE 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_AGR_NUM_AGRUP_REM  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH '||MAX_NUM||' NOCACHE NOORDER  NOCYCLE';
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_AGR_NUM_AGRUP_REM... Secuencia creada e inicializada correctamente.');


    --###############################################################
    --##### [HREOS-2333] - CORREGIR ESTADO DIVISION HORIZONTAL 
    --###############################################################


    DBMS_OUTPUT.PUT_LINE('[INFO] CORRIGIENDO REG_DIV_HOR_INSCRITO...');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL SET REG_DIV_HOR_INSCRITO = NULL WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS CORREGIDOS - '||SQL%ROWCOUNT||''); 

    --
    --

    DBMS_OUTPUT.PUT_LINE('[INFO] CORRIGIENDO ESTADO DIV HORIZONTAL...');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL SET DD_EDH_ID = NULL WHERE (REG_DIV_HOR_INSCRITO IS NULL OR REG_DIV_HOR_INSCRITO = 1)';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS CORREGIDOS - '||SQL%ROWCOUNT||'');

    --###############################################################
    --##### [REMNIVDOS-914] - CORREGIR PROVEEDORES
    --###############################################################

    --DBMS_OUTPUT.PUT_LINE('[INFO] CORRIGIENDO PROVEEDORES PVE_COD_REM...');

    --V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR SET PVE_COD_REM = PVE_WEBCOM_ID WHERE PVE_WEBCOM_ID IS NOT NULL';
    --EXECUTE IMMEDIATE V_MSQL;

    --DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS CORREGIDOS - '||SQL%ROWCOUNT||'');

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO SEQUENCE PVE_COD_REM');

    -- Obtenemos el valor maximo de la columna AGR_NUM_AGRUP_REM y lo incrementamos en 1
    V_MSQL := 'SELECT NVL(MAX(PVE_COD_REM),0) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR';
    EXECUTE IMMEDIATE V_MSQL INTO MAX_NUM;
    
    MAX_NUM := MAX_NUM +1;
    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_PVE_COD_REM'' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''' INTO V_EXISTE; 
    
    -- Si existe secuencia la borramos
    IF V_EXISTE = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_PVE_COD_REM';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_PVE_COD_REM... Secuencia eliminada');    
    END IF;
    
    EXECUTE IMMEDIATE 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_PVE_COD_REM  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH '||MAX_NUM||' NOCACHE NOORDER  NOCYCLE';
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_PVE_COD_REM... Secuencia creada e inicializada correctamente.');


    --#############################################################
    --############ TRABAJOS
    --#############################################################

    DBMS_OUTPUT.PUT_LINE('[INFO] ASIGNANDO ACT_ID EN TRABAJOS MONO-ACTIVO...');

    V_MSQL := '
        MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ 
        USING
        (
            WITH TRABAJOS_MONO_ACTIVO AS (
              SELECT TBJ_ID
              FROM '||V_ESQUEMA||'.ACT_TBJ 
              GROUP BY TBJ_ID
              HAVING COUNT(1) = 1
            )
            SELECT ACT_TBJ.TBJ_ID, ACT_TBJ.ACT_ID
            FROM TRABAJOS_MONO_ACTIVO MONA
              INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = MONA.TBJ_ID AND TBJ.BORRADO = 0
              INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ON TBJ.TBJ_ID = ACT_TBJ.TBJ_ID
        ) SQLI
        ON (TBJ.TBJ_ID = SQLI.TBJ_ID)
        WHEN MATCHED THEN UPDATE
        SET TBJ.ACT_ID = SQLI.ACT_ID
            , USUARIOMODIFICAR = '''||V_USUARIO||'''
    '
    ;
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_TBJ_TRABAJO mergeada. '||SQL%ROWCOUNT||' Filas.');

    --
    --

    DBMS_OUTPUT.PUT_LINE('[INFO] ASIGNANDO GESTORES Y SUPERVISORES A LOS TRABAJOS MULTI_ACTIVO...');

    V_MSQL := '
        MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        USING
        (
          SELECT AUX.TBJ_ID, AUX.ACT_ID, GGEE.USU_ID AS GESTOR, SGEE.USU_ID AS SUPERVISOR, ROW_NUMBER() OVER(PARTITION BY AUX.ACT_ID ORDER BY GGEE.FECHAMODIFICAR DESC, GGEE.FECHACREAR DESC) RN
          FROM
          (
            WITH TRABAJOS_MULTI_ACTIVO AS (
              SELECT TBJ_ID
              FROM '||V_ESQUEMA||'.ACT_TBJ
              GROUP BY TBJ_ID
              HAVING COUNT(1) > 1
            )
            SELECT 
              ACT_TBJ.TBJ_ID
              , ACT_TBJ.ACT_ID
              , TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE
              , TBJ.TBJ_SUPERVISOR_ACT_RESPONSABLE
              , ROW_NUMBER () OVER (PARTITION BY ACT_TBJ.TBJ_ID ORDER BY ACT_TBJ.ACT_ID DESC) RANK
            FROM TRABAJOS_MULTI_ACTIVO MUL
              INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON MUL.TBJ_ID = TBJ.TBJ_ID AND TBJ.BORRADO = 0
              INNER JOIN '||V_ESQUEMA||'.ACT_TBJ ON ACT_TBJ.TBJ_ID = TBJ.TBJ_ID
          ) AUX
          INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GGAC ON GGAC.ACT_ID = AUX.ACT_ID
          INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GGEE ON GGEE.GEE_ID = GGAC.GEE_ID AND GGEE.BORRADO = 0 
          INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR GTGE ON GTGE.DD_TGE_ID = GGEE.DD_TGE_ID AND GTGE.DD_TGE_CODIGO = ''GACT'' AND GTGE.BORRADO = 0
          
          INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO SGAC ON SGAC.ACT_ID = AUX.ACT_ID
          INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD SGEE ON SGEE.GEE_ID = SGAC.GEE_ID AND SGEE.BORRADO = 0 
          INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR STGE ON STGE.DD_TGE_ID = SGEE.DD_TGE_ID AND STGE.DD_TGE_CODIGO = ''SUPACT'' AND STGE.BORRADO = 0
          
          WHERE AUX.RANK = 1 AND (AUX.TBJ_GESTOR_ACTIVO_RESPONSABLE IS NULL OR AUX.TBJ_SUPERVISOR_ACT_RESPONSABLE IS NULL)
        ) SQLI ON (SQLI.TBJ_ID = TBJ.TBJ_ID AND SQLI.RN = 1)
        WHEN MATCHED THEN UPDATE SET
          TBJ.ACT_ID = NULL
          , TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE = SQLI.GESTOR
          , TBJ.TBJ_SUPERVISOR_ACT_RESPONSABLE = SQLI.SUPERVISOR
          , USUARIOMODIFICAR = '''||V_USUARIO||'''
    '
    ;
    EXECUTE IMMEDIATE V_MSQL;
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_TBJ_TRABAJO mergeada. '||SQL%ROWCOUNT||' Filas.');

    --#############################################################
    --############ ACTIVOS
    --#############################################################

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO SITUACION COMERCIAL DE ACTIVOS EN PRODUCCION...');

    EXECUTE IMMEDIATE 'MERGE INTO ACT_ACTIVO T1
        USING (SELECT T2.ACT_ID, T1.SITUACION_COMERCIAL
            FROM REM01.MIG_ACA_CABECERA T1 
            JOIN REM01.ACT_ACTIVO T2 ON T1.ACT_NUMERO_ACTIVO = T2.ACT_NUM_ACTIVO AND T2.BORRADO = 0
            JOIN REM01.DD_SCM_SITUACION_COMERCIAL T3 ON T2.DD_SCM_ID = T3.DD_SCM_ID AND T3.DD_SCM_CODIGO <> T1.SITUACION_COMERCIAL
            WHERE T1.VALIDACION = 1) T2
        ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.DD_SCM_ID = (SELECT SCM.DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL SCM WHERE SCM.DD_SCM_CODIGO = T2.SITUACION_COMERCIAL)';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_ACTIVO mergeada. '||SQL%ROWCOUNT||' Filas.');

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO CAMPO LLAVES EN PODER DE HRE...');

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT 
            SET ACT.ACT_LLAVES_HRE = NULL 
            , USUARIOMODIFICAR = '''||V_USUARIO||'''
        WHERE ACT.ACT_LLAVES_NECESARIAS = 0 AND ACT.ACT_LLAVES_HRE = 0
    '
    ;
    EXECUTE IMMEDIATE V_MSQL;
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_ACTIVO mergeada. '||SQL%ROWCOUNT||' Filas.');

    
    
    
    --#############################################################
    --############ PROPIETARIOS
    --#############################################################

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO A NULO NIF A86602158 CARTERA CAJAMAR...');

    EXECUTE IMMEDIATE 'UPDATE ACT_PRO_PROPIETARIO
                          SET PRO_DOCIDENTIF = NULL
                       where PRO_DOCIDENTIF = ''A86602158''
                         and DD_CRA_ID = (select DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''01'')';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO actualizada. '||SQL%ROWCOUNT||' Filas.');   

    --#############################################################
    --############ AGR_FECHA_BAJA
    --#############################################################

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO A A FECHA ACTUAL AGR_FECHA_BAJA...');

    EXECUTE IMMEDIATE 'UPDATE REM01.ACT_AGR_AGRUPACION SET AGR_FECHA_BAJA = SYSDATE WHERE AGR_ELIMINADO = 1 AND AGR_FECHA_BAJA IS NULL'; 
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_AGR_AGRUPACION actualizada. '||SQL%ROWCOUNT||' Filas.');  

    --EXECUTE IMMEDIATE 'delete from ACT_ADO_ADMISION_DOCUMENTO where ado_id in ( select ado_id from ACT_ADO_ADMISION_DOCUMENTO where (act_id, cfd_id) in ( select act_id, cfd_id from ACT_ADO_ADMISION_DOCUMENTO group by act_id, cfd_id having count(1) > 1) and usuariocrear <> '''||V_USUARIO||''')';


    EXECUTE IMMEDIATE 'update rem01.act_activo act 
        set act.ACT_NUM_ACTIVO_UVEM = (select ACT_NUMERO_UVEM from rem01.mig_aca_cabecera aca where aca.ACT_NUMERO_ACTIVO = act.ACT_NUM_ACTIVO)
        where ACT_NUM_ACTIVO_UVEM is null';


EXECUTE IMMEDIATE
'merge into act_activo  act
using ( select aca.ACT_NUMERO_ACTIVO, aca.ACT_NUMERO_UVEM from rem01.mig_aca_cabecera aca 
        inner join rem01.act_activo act on  (aca.ACT_NUMERO_ACTIVO = act.ACT_NUM_ACTIVO and act.ACT_NUM_ACTIVO_UVEM <> aca.ACT_NUMERO_UVEM) ) datos
        on (act.ACT_NUM_ACTIVO = datos.ACT_NUMERO_ACTIVO)
        when matched then update
        set act.ACT_NUM_ACTIVO_UVEM = datos.ACT_NUMERO_UVEM';


    --###############################################################
    --##### [HREOS-2647] - CORREGIR ESTADO PROVEEDORES
    --###############################################################

    EXECUTE IMMEDIATE 'UPDATE REM01.ACT_PVE_PROVEEDOR PVE
    SET PVE.DD_EPR_ID = (SELECT EPR.DD_EPR_ID FROM REM01.DD_EPR_ESTADO_PROVEEDOR EPR WHERE EPR.DD_EPR_CODIGO = ''07'')
    WHERE PVE.DD_EPR_ID IS NULL';


    --###############################################################
    --##### HREOS-2649 Actualizar el tipo de proveedor (físico/jurídico)
    --###############################################################    
      
       execute immediate 'MERGE INTO REM01.act_pve_proveedor PVE_OLD
                          USING
                             ( select  pve.pve_id, pve.pve_docidentif, tpr.dd_tpr_codigo
                                    , CASE WHEN  tpr.dd_tpr_codigo in (''07'',''08'',''09'',''10'',''11'',''12'',''13'',''14'',''15'',''16'',''17'',''22'',''23'',''28'',''29'',''30'',''31'',''32'',''33'',''34'',''35'',''37'')
                                           THEN (select dd_tpe_id from REMMASTER.DD_TPE_TIPO_PERSONA where dd_tpe_codigo = ''2'') /*JURIDICA*/
                                         ELSE
                                            CASE WHEN 
                                                    REGEXP_SUBSTR (substr(pve.pve_docidentif,length(pve.pve_docidentif),1),''[^1234567890]'') is not null  
                                                   THEN (select dd_tpe_id from REMMASTER.DD_TPE_TIPO_PERSONA where dd_tpe_codigo = ''1'') /*FISICA */
                                                 ELSE (select dd_tpe_id from REMMASTER.DD_TPE_TIPO_PERSONA where dd_tpe_codigo = ''2'') /*JURIDICA*/
                                            END
                                    END  as DD_TPE_ID
                             from REM01.act_pve_proveedor pve
                             inner join REM01.DD_TPR_TIPO_PROVEEDOR tpr on pve.dd_tpr_id  = tpr.dd_tpr_id
                             where pve.DD_TPE_ID is null
                             and pve.borrado = 0
                             and tpr.borrado = 0
                             ) PVE_NEW
                          ON (PVE_OLD.pve_id = PVE_NEW.pve_id )
                          WHEN MATCHED THEN UPDATE
                          SET PVE_OLD.DD_TPE_ID = PVE_NEW.DD_TPE_ID
                            , PVE_OLD.USUARIOMODIFICAR = '''||V_USUARIO||'''
                            , PVE_OLD.FECHAMODIFICAR = sysdate';


    --###############################################################
    --##### HREOS-2952 Actualizar checks de admisión y gestión
    --###############################################################    

    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION SOBRE LA TABLA '||V_ESQUEMA||'.ACT_ACTIVO');
    
    V_MSQL := 'MERGE INTO REM01.ACT_ACTIVO T1
        USING (SELECT T1.DD_CRA_ID, T2.DD_SCR_ID
            FROM REM01.DD_CRA_CARTERA T1
            JOIN REM01.DD_SCR_SUBCARTERA T2 ON T1.DD_CRA_ID = T2.DD_CRA_ID
            WHERE (T1.DD_CRA_CODIGO, T2.DD_SCR_CODIGO) 
                IN ((''01'', ''01''), (''02'', ''03''), (''03'', ''05''), (''04'', ''20''), (''05'', ''12'')) AND T1.USUARIOCREAR = '''||V_USUARIO||''') T2
        ON (T1.DD_CRA_ID = T2.DD_CRA_ID AND T1.DD_SCR_ID = T2.DD_SCR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.ACT_GESTION = 1, T1.ACT_ADMISION = 1, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
        WHERE T1.USUARIOCREAR = '''||V_USUARIO||''' AND (T1.ACT_GESTION <> 1 OR T1.ACT_ADMISION <> 1)';
    EXECUTE IMMEDIATE V_MSQL;
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ACTIVO ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. Check de admisión y gestión actualizados para AAFF.');
    
    V_MSQL := 'MERGE INTO REM01.ACT_ACTIVO T1
        USING (SELECT T1.ACT_ID 
            FROM REM01.ACT_ACTIVO T1
            JOIN REM01.BIE_DATOS_REGISTRALES T2 ON T1.BIE_ID = T2.BIE_ID
            JOIN REM01.ACT_SPS_SIT_POSESORIA T3 ON T3.ACT_ID = T1.ACT_ID
            WHERE T2.BIE_DREG_FECHA_INSCRIPCION IS NOT NULL
                AND T3.SPS_FECHA_TOMA_POSESION IS NOT NULL
                AND T1.ACT_FECHA_REV_CARGAS IS NOT NULL
                AND T1.ACT_ADMISION <> 1
                AND T1.USUARIOCREAR = '''||V_USUARIO||''') T2
        ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.ACT_ADMISION = 1, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ACTIVO ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. Check de admisión.');
    
    V_MSQL := 'MERGE INTO REM01.ACT_ACTIVO T1
        USING (SELECT T1.ACT_ID 
            FROM REM01.ACT_ACTIVO T1
            JOIN REM01.ACT_SPS_SIT_POSESORIA T2 ON T2.ACT_ID = T1.ACT_ID
            WHERE T2.SPS_FECHA_TOMA_POSESION IS NOT NULL
                AND T1.ACT_GESTION <> 1
                AND T1.USUARIOCREAR = '''||V_USUARIO||''') T2
        ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.ACT_GESTION = 1, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ACTIVO ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. Check de gestión.');

V_MSQL := 'MERGE INTO REM01.ACT_ACTIVO T1
USING (SELECT T1.ACT_ID
    FROM REM01.ACT_ACTIVO T1
    JOIN REM01.DD_SCM_SITUACION_COMERCIAL T2 ON T1.DD_SCM_ID = T2.DD_SCM_ID AND T2.DD_SCM_CODIGO = ''02'' AND T1.USUARIOCREAR = '''||V_USUARIO||''') T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
    T1.ACT_FECHA_REV_CARGAS = SYSDATE, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
WHERE T1.ACT_FECHA_REV_CARGAS IS NULL';
    EXECUTE IMMEDIATE V_MSQL;
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ACTIVO ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas.');

V_MSQL := 'MERGE INTO REM01.ACT_SPS_SIT_POSESORIA T1
USING (SELECT T1.ACT_ID
    FROM REM01.ACT_ACTIVO T1
    JOIN REM01.DD_SCM_SITUACION_COMERCIAL T2 ON T1.DD_SCM_ID = T2.DD_SCM_ID AND T2.DD_SCM_CODIGO = ''02'' AND T1.USUARIOCREAR = '''||V_USUARIO||''') T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
    T1.SPS_FECHA_TITULO = SYSDATE, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
WHERE T1.SPS_FECHA_TITULO IS NULL';
    EXECUTE IMMEDIATE V_MSQL;
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas.');

V_MSQL := 'MERGE INTO REM01.ACT_ADN_ADJNOJUDICIAL T1
USING (SELECT T1.ACT_ID
    FROM REM01.ACT_ACTIVO T1
    JOIN REM01.DD_SCM_SITUACION_COMERCIAL T2 ON T1.DD_SCM_ID = T2.DD_SCM_ID AND T2.DD_SCM_CODIGO = ''02'' AND T1.USUARIOCREAR = '''||V_USUARIO||''') T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
    T1.ADN_FECHA_TITULO = SYSDATE, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
WHERE T1.ADN_FECHA_TITULO IS NULL';
    EXECUTE IMMEDIATE V_MSQL;
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas.');

EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''LISTA_ACTIVOS_VENTA_EXTERNA'' AND OWNER = ''PFSREM'' ' INTO V_EXISTE;

IF V_EXISTE = 1 THEN

EXECUTE IMMEDIATE 'merge into rem01.act_activo act
using pfsrem.LISTA_ACTIVOS_VENTA_EXTERNA shg
on (shg.act_num_activo_uvem = act.act_num_activo_uvem)
when matched then update
set ACT_VENTA_DIRECTA_BANKIA = 1';
DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.act_activo ACTUALIZADAS (ACT_VENTA_DIRECTA_BANKIA). '||SQL%ROWCOUNT||' Filas.');

END IF;

    COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  FIN MODIFICACIONES POST_MIGRACION.');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;

/

EXIT;
