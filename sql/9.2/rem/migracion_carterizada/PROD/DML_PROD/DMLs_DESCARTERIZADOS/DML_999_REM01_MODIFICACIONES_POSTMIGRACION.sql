--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20170705
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
    V_EXISTE NUMBER (5);
    MAX_NUM NUMBER (16);
    V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_MSQL VARCHAR2(2000 CHAR);
  
    V_REG_TOTAL NUMBER(10,0) := 0;
    V_REG_ACTUALIZADOS NUMBER(10,0) := 0;

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
  
    EXECUTE IMMEDIATE('update '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL set CLC_WEBCOM_ID_OLD = CLC_WEBCOM_ID where usuariocrear = '''||V_USUARIO||'''');
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

    DBMS_OUTPUT.PUT_LINE('[INFO] CORRIGIENDO PROVEEDORES PVE_COD_REM...');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR SET PVE_COD_REM = PVE_WEBCOM_ID WHERE PVE_WEBCOM_ID IS NOT NULL';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS CORREGIDOS - '||SQL%ROWCOUNT||'');

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

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' mergeada. '||SQL%ROWCOUNT||' Filas.');

    --
    --

    DBMS_OUTPUT.PUT_LINE('[INFO] ASIGNANDO GESTORES Y SUPERVISORES A LOS TRABAJOS MULTI_ACTIVO...');

    V_MSQL := '
        MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        USING
        (
          SELECT DISTINCT AUX.TBJ_ID, AUX.ACT_ID, GGEE.USU_ID AS GESTOR, SGEE.USU_ID AS SUPERVISOR
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
        ) SQLI ON (SQLI.TBJ_ID = TBJ.TBJ_ID)
        WHEN MATCHED THEN UPDATE SET
          TBJ.ACT_ID = NULL
          , TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE = SQLI.GESTOR
          , TBJ.TBJ_SUPERVISOR_ACT_RESPONSABLE = SQLI.SUPERVISOR
          , USUARIOMODIFICAR = '''||V_USUARIO||'''
    '
    ;
    EXECUTE IMMEDIATE V_MSQL;
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_TBJ_TRABAJO mergeada. '||SQL%ROWCOUNT||' Filas.');

    --
    --

    DBMS_OUTPUT.PUT_LINE('[INFO] CORRIGIENDO EL ACT_ID DE TRABAJOS DE AGRUPACIONES...');

    V_MSQL := '
        UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
        SET ACT_ID = NULL
            , USUARIOCREAR = '''||V_USUARIO||''' 
        WHERE AGR_ID IS NOT NULL AND ACT_ID IS NOT NULL
    '
    ;
    EXECUTE IMMEDIATE V_MSQL;
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' mergeada. '||SQL%ROWCOUNT||' Filas.');

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

    COMMIT;

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
