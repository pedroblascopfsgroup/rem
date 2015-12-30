/**************  Asignamos Asuntos HRE *****************

 Si recibimos la marca de agencia, hay que lanzar una actuación de preparación de expediente judicial, completar la tarea de "estudio", indicando que se marca como "en gestión por agencias" y finalizar la actuación.

 Si NO recibimos la marca de agencia, pero SI recibimos información de expediente de precontencioso

        Recibimos la fecha realización estudio solvencia, completar la tarea de "estudio" con esa fecha y dejarlo "en preparación"

        Si viene la fecha de aceptación del letrado, lanzamos el trámite de preparación de expediente judicial en la tarea pendiente de enviar al letrado

        Recibimos la fecha de envío a letrado, lanzamos el trámite de preparación de expediente judicial ya enviado al letrado, pendiente de revisión de la documentación

        Recibimos fecha y motivo de paralización, lanzamos la actuación de preparación de expediente judicial, con una decisión de paralización

 Si NO recibimos la marca de agencia, y TAMPOCO recibimos información de expediente de precontencioso
         Confirmar con BCC que hay que lanzar una actuación de preparación de expediente judicial, completar la tarea de "estudio", indicando que se marca como "sin gestión" y finalizar la actuación o si se trata de un error

*********************************************************/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set timing on
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO varchar2(20 CHAR) := 'MIGRACM01PCO';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] CAJAMAR MIGRACION CONTRATOS MARCA HAYA');


    --** Borramos tablas de maniobra
    ----------------------------------
    v_sql := 'Select Count(1) From all_all_tables Where table_name = ''TMP_GUIA_CONTRATOS_HRE''';
    execute immediate v_sql into v_num_tablas;
    If v_num_tablas > 0
     Then v_sql := 'Drop table '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE';
          execute immediate v_sql;
          DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla temporal '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE borrada');
    End If;

    v_sql := 'Select Count(1) From all_all_tables Where table_name = ''TMP_EXP_EXPEDIENTES_HRE''';
    execute immediate v_sql into v_num_tablas;
    If v_num_tablas > 0
     Then v_sql := 'Drop table '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE';
          execute immediate v_sql;
          DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla temporal '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE borrada');
    End If;


    --** Conjunto base de contratos HRE
    ----------------------------------------------
    v_sql:='Create table '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE nologging as
        select distinct g.cnt_id, g.cnt_cod_entidad, g.cnt_cod_oficina, g.cnt_cod_centro, g.cnt_contrato
             , eop.cd_expediente as cod_recovery
             , tmp.tmp_cnt_char_extra7
             , Case When tmp.tmp_cnt_char_extra7 is not null
                     Then ''AGE'' -- Gestion Externa
                    When tmp.tmp_cnt_char_extra7 is null and eop.cd_expediente is not null
                     Then ''PCO'' -- Precontencioso
                    Else ''GES''  -- Sin gestión
               End as cdTipoAct
          from '||v_esquema||'.cnt_contratos g, '||v_esquema||'.dd_ges_gestion_especial b, '||v_esquema||'.cex_contratos_expediente c, '||v_esquema||'.dd_cre_condiciones_remun_ext r
             , '||v_esquema||'.MIG_EXPEDIENTES_OPERACIONES eop
             , '||v_esquema||'.TMP_CNT_CONTRATOS           tmp
         where g.dd_ges_id = b.dd_ges_id and g.dd_cre_id = r.dd_cre_id
           and g.cnt_id  = c.cnt_id(+) and c.cex_id is null
           and b.dd_ges_codigo = ''HAYA'' and r.dd_cre_codigo in (''EX'',''CN'',''IM'',''AR'',''MA'',''SC'')
           and g.cnt_contrato = eop.numero_contrato(+)
           and g.cnt_cod_entidad = eop.cod_entidad(+)
           and g.cnt_contrato = tmp.tmp_cnt_contrato(+)
           and g.cnt_cod_entidad = tmp.tmp_cnt_cod_entidad(+)
           ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla temporal '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE creada. '||SQL%ROWCOUNT||' Filas');

    DBMS_STATS.GATHER_TABLE_STATS (ownname => v_esquema, tabname => 'TMP_GUIA_CONTRATOS_HRE', estimate_percent => 20);
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Estadisticas '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE actualizadas');




    --** Creamos CLIENTES
    ------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.CLI_CLIENTES
                    (cli_id, per_id, arq_id, dd_est_id, dd_ecl_id, cli_fecha_est_id,
                    VERSION, usuariocrear, fechacrear, borrado, cli_fecha_creacion,
                    cli_telecobro, ofi_id)
                SELECT '||v_esquema||'.s_cli_clientes.NEXTVAL,
                       apc.per_id,
                       (SELECT arq_id FROM '||v_esquema||'.arq_arquetipos WHERE ARQ_NOMBRE = ''Migracion''  AND BORRADO = 1) AS arq_id,
                       1 AS dd_est_id,
                       3 AS dd_ecl_id,
                       SYSDATE,
                       0 AS VERSION,
                       '''||USUARIO||''' AS usuariocrear,
                       SYSDATE AS fechacrear, 1 AS borrado,
                       SYSDATE AS cli_fecha_creacion,
                       0 AS cli_telecobro,
                       apc.ofi_id
                FROM (
                SELECT MIN(COD_RECOVERY) COD_RECOVERY, PER_ID, MAX(OFI_ID) OFI_ID FROM(
                       SELECT * FROM(
                          SELECT TMP.COD_RECOVERY, cnt.cnt_id, CPE.PER_ID, NVL(PER.OFI_ID, CNT.OFI_ID) OFI_ID, CPE.CPE_ORDEN,
                                 rank() over (partition by CPE.CNT_ID order by cpe.cpe_orden) as ranking,
                                 rank() over (partition by per.per_id order by mov.mov_pos_viva_vencida + mov.mov_pos_viva_no_vencida desc) as ranking_mov,
                                 mov.mov_pos_viva_vencida + mov.mov_pos_viva_no_vencida total
                          FROM '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE TMP INNER JOIN
                               '||v_esquema||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO INNER JOIN
                               '||v_esquema||'.MOV_MOVIMIENTOS MOV ON mov.cnt_id = cnt.cnt_id and mov.mov_fecha_extraccion = cnt.cnt_fecha_extraccion inner join
                               '||v_esquema||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID INNER JOIN
                               '||v_esquema||'.PER_PERSONAS PER ON PER.PER_ID = CPE.PER_ID INNER JOIN
                               '||v_esquema||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1
                      )
                      WHERE RANKING = 1
                      AND RANKING_MOV = 1) Z
                WHERE NOT EXISTS(SELECT 1 FROM '||v_esquema||'.CLI_CLIENTES CLI WHERE CLI.PER_ID = Z.PER_ID)
                GROUP BY PER_ID) APC
    ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.CLI_CLIENTES cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;


    --** Insertamos Relación CCL_CONTRATOS_CLIENTES
    -------------------------------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.CCL_CONTRATOS_CLIENTE
                (ccl_id, cnt_id, cli_id, ccl_pase, VERSION, usuariocrear,fechacrear, borrado)
            SELECT '||v_esquema||'.s_ccl_contratos_cliente.NEXTVAL AS ccl_id,
                   apc.cnt_id AS cnt_id,
                   apc.cli_id AS cli_id,
                   case when RANKING = 1 THEN 1 ELSE 0 END AS ccl_pase,
                   0 AS VERSION,
                   '''||USUARIO||''' AS usuariocrear,
                   SYSDATE AS fechacrear,
                   0 AS borrado
              FROM (
                SELECT DISTINCT TMP.COD_RECOVERY, CNT.CNT_ID, CLI.CLI_ID, rank() over (partition by TMP.COD_RECOVERY, CLI.CLI_ID order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC) RANKING
                FROM '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE TMP INNER JOIN
                     '||v_esquema||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO INNER JOIN
                     '||v_esquema||'.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION INNER JOIN
                     '||v_esquema||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID INNER JOIN
                     '||v_esquema||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1 INNER JOIN
                     '||v_esquema||'.CLI_CLIENTES CLI ON CLI.PER_ID = CPE.PER_ID
                    ) APC';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.CCL_CONTRATOS_CLIENTE cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;



    --** Creamos EXP_EXPEDIENTES nuevos
    ------------------------------------------
    v_sql := 'Create table '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE nologging AS
                With APC
                  As ( select cnt_id, cnt_contrato, ofi_id, cod_recovery, cdTipoAct, min(per_id) as per_id
                         from ( Select tmp.cnt_id, tmp.cnt_contrato, cnt.ofi_id
                                     , per.per_id, dd_tin_id, cpe.cpe_orden
                                     , tmp.cod_recovery, tmp.cdTipoAct
                                     , rank() over (partition by tmp.cnt_id order by dd_tin_id, cpe_orden desc) Ranking
                                  From '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE  tmp
                                     , '||v_esquema||'.CPE_CONTRATOS_PERSONAS  cpe
                                     , '||v_esquema||'.PER_PERSONAS            per
                                     , '||v_esquema||'.CNT_CONTRATOS           cnt
                                 Where tmp.cnt_id = cpe.cnt_id
                                   And cpe.per_id = per.per_id
                                   And tmp.cnt_contrato = cnt.cnt_contrato )
                        where Ranking = 1
                        group by cnt_id, cnt_contrato, ofi_id, cod_recovery, cdTipoAct
                     )
                SELECT '||v_esquema||'.s_exp_expedientes.nextval exp_id,
                       5 as dd_est_id,
                       sysdate as exp_fecha_est_id,
                       a.ofi_id as ofi_id,
                      (select arq_id from '||v_esquema||'.arq_arquetipos where arq_nombre = ''Migracion''  and borrado = 1) as arq_id,
                       0 as version,
                       '''||USUARIO||''' as usuariocrear,
                       sysdate as fechacrear,
                       0 as borrado,
                       4 as dd_eex_id,
                       a.cnt_contrato ||'' | ''|| b.per_nom50 as exp_descripcion,
                       a.cod_recovery as cd_expediente_nuse,
                       sys_guid() as sys_guid,
                       a.cnt_id,
                       b.per_id,
                       a.cdTipoAct
                FROM APC a, '||v_esquema||'.PER_PERSONAS b
                WHERE a.per_id = b.per_id
            ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla temporal '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE creada. '||SQL%ROWCOUNT||' Filas');
    Commit;

    DBMS_STATS.GATHER_TABLE_STATS (ownname => v_esquema, tabname => 'TMP_EXP_EXPEDIENTES_HRE', estimate_percent => 20);
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Estadisticas '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE actualizadas');

    v_sql := 'INSERT INTO '||v_esquema||'.EXP_EXPEDIENTES
                (exp_id, dd_est_id, exp_fecha_est_id, ofi_id, arq_id, VERSION, usuariocrear, fechacrear, borrado, dd_eex_id, exp_descripcion, usuariomodificar, CD_EXPEDIENTE_NUSE, SYS_GUID)
              SELECT exp_id, dd_est_id, exp_fecha_est_id, ofi_id, arq_id, VERSION, usuariocrear, fechacrear, borrado, dd_eex_id, exp_descripcion, null as usuariomodificar, null as CD_EXPEDIENTE_NUSE, SYS_GUID
                FROM TMP_EXP_EXPEDIENTES_HRE
             ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.EXP_EXPEDIENTES cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;

    --** Creamos relación CEX_CONTRATOS_EXPEDIENTE
    ------------------------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.CEX_CONTRATOS_EXPEDIENTE
                (cex_id, cnt_id, exp_id, cex_pase, cex_sin_actuacion, VERSION, usuariocrear, fechacrear, borrado, dd_aex_id, usuariomodificar, SYS_GUID)
                        SELECT '||v_esquema||'.s_cex_contratos_expediente.NEXTVAL AS cex_id,
                               cnt_id AS cnt_id,
                               exp_id AS exp_id,
                               1 AS cex_pase,
                               0 AS cex_sin_actuacion,
                               0 AS VERSION, '''||USUARIO||''' AS usuariocrear,
                               SYSDATE AS fechacrear,
                               0 AS borrado,
                               9 AS dd_aex_id,
                               null AS usuariomodificar,
                               SYS_GUID() AS SYS_GUID
                          FROM '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE
             ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.CEX_CONTRATOS_EXPEDIENTE cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;


    --** Creamos relación PEX_PERSONAS_EXPEDIENTE
    --------------------------------------------------------------------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.PEX_PERSONAS_EXPEDIENTE
                (pex_id, per_id, exp_id, dd_aex_id, pex_pase, version, usuariocrear, fechacrear, borrado)
                    select '||v_esquema||'.s_pex_personas_expediente.nextval as pex_id,
                           cpe.per_id AS per_id,
                           tmp.exp_id AS exp_id,
                           9 AS dd_aex_id,
                           case when tmp.per_id = cpe.per_id then 1 else 0 end as pex_pase,
                           0 AS VERSION,
                           '''||USUARIO||''' AS usuariocrear,
                           SYSDATE AS fechacrear,
                           0 AS borrado
                      FROM '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE tmp
                         , '||v_esquema||'.CPE_CONTRATOS_PERSONAS cpe
                     WHERE tmp.cnt_id = cpe.cnt_id
             ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.PEX_PERSONAS_EXPEDIENTE cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;


    --** Creamos Asuntos nuevos
    --------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.ASU_ASUNTOS
                (asu_id, dd_est_id, asu_fecha_est_id, asu_nombre, exp_id, VERSION, usuariocrear, fechacrear, borrado, dd_eas_id, dtype, dd_tas_id, DD_PAS_ID, ASU_ID_EXTERNO, DD_GES_ID, SYS_GUID)
                    SELECT '||v_esquema||'.s_asu_asuntos.nextval as asu_id,
                           (SELECT DD_EST_ID FROM '||v_esquema_master||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_eST_CODIGO = ''AS'') AS dd_est_id, -- ASUNTO
                           sysdate as asu_fecha_est_id,
                           substr(exp_descripcion,0,50) as asu_nombre,
                           exp_id,
                           0 as version,
                           '''||USUARIO||''' as usuariocrear,
                           sysdate as fechacrear,
                           0 as borrado,
                           3 as dd_eas_id, -- estadoasunto aceptado
                           ''EXTAsunto'' as dtype,
                           (SELECT dd_tas_id FROM '||v_esquema_master||'.dd_tas_tipos_asunto WHERE dd_tas_descripcion = ''Litigio'') as dd_tas_id,
                           (SELECT dd_pas_id FROM '||v_esquema||'.dd_pas_propiedad_asunto WHERE dd_pas_codigo = ''CAJAMAR'') as dd_pas_id,  -->>> haya??
                           cd_expediente_nuse as asu_id_externo,
                           (select dd_ges_id FROM '||v_esquema||'.dd_ges_gestion_asunto WHERE dd_ges_codigo = ''CAJAMAR'') as dd_ges_id,
                           sys_guid() as sys_guid
                      FROM '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.ASU_ASUNTOS cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;


    --** Creamos PROCEDIMIENTOS nuevos
    ----------------------------------------------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.PRC_PROCEDIMIENTOS
             ( prc_id, asu_id, dd_tac_id, dd_tre_id, dd_tpo_id,prc_porcentaje_recuperacion, prc_plazo_recuperacion, prc_saldo_original_vencido, prc_saldo_original_no_vencido
             , prc_saldo_recuperacion, dd_juz_id, Version, usuariocrear, fechacrear, borrado, dd_epr_id, dtype,SYS_GUID)
                    SELECT     '||v_esquema||'.s_prc_procedimientos.nextval AS prc_id,
                               asu.asu_id AS asu_id,
                              (SELECT dd_tac_id FROM '||v_esquema||'.dd_tpo_tipo_procedimiento WHERE dd_tpo_CODIGO = ''PCO'') AS dd_tac_id,
                               1 AS dd_tre_id,
                              (SELECT dd_TPO_ID FROM '||v_esquema||'.dd_tpo_tipo_procedimiento WHERE dd_tpo_CODIGO = ''PCO'') AS dd_tpo_id,
                               100 AS prc_porcentaje_recuperacion,
                               30  AS prc_plazo_recuperacion,
                               mov_pos_viva_vencida    AS prc_saldo_original_vencido,
                               mov_pos_viva_no_vencida AS prc_saldo_original_no_vencido,
                               mov_pos_viva_vencida + mov_pos_viva_no_vencida AS prc_saldo_recuperacion,
                               Null AS dd_juz_id,
                               0 AS Version,
                               '''||USUARIO||''' AS usuariocrear,
                               SYSDATE AS fechacrear,
                               0 AS borrado,
                              (select dd_epr_id from '||v_esquema_master||'.dd_epr_estado_procedimiento WHERE dd_epr_codigo = ''CERRADO'') AS dd_epr_id, -- ESTADO PROCEDIMIENTO = ACEPTADO  ---lrc
                               ''MEJProcedimiento'' AS dtype,
                               SYS_GUID() AS SYS_GUID
                    FROM  '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE TMP
                       ,  '||v_esquema||'.ASU_ASUNTOS ASU
                       ,  '||v_esquema||'.CNT_CONTRATOS CNT
                       ,  '||v_esquema||'.MOV_MOVIMIENTOS MOV
                   WHERE tmp.exp_id = asu.exp_id
                     AND tmp.cnt_id = cnt.cnt_id
                     AND cnt.cnt_id = mov.cnt_id
                     AND cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion
               ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.PRC_PROCEDIMIENTOS cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;

    --** Creamos relaciones PRC_PER
    ---------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.PRC_PER (prc_id, per_id)
                SELECT DISTINCT PRC.PRC_ID, CPE.PER_ID
                FROM '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE   TMP
                   , '||v_esquema||'.CNT_CONTRATOS             CNT
                   , '||v_esquema||'.CPE_CONTRATOS_PERSONAS    CPE
                   , '||v_esquema||'.DD_TIN_TIPO_INTERVENCION  TIN
                   , '||v_esquema||'.ASU_ASUNTOS               ASU
                   , '||v_esquema||'.PRC_PROCEDIMIENTOS        PRC
                WHERE  tmp.cnt_id = cnt.cnt_id
                AND    cnt.cnt_id = cpe.cnt_id
                AND cpe.dd_tin_id = tin.dd_tin_id AND tin.dd_tin_titular = 1
                AND    tmp.exp_id = asu.exp_id
                AND    asu.asu_id = prc.asu_id';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.PRC_PER cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;

    --** Creamos relaciones PRC_CEX
    ---------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.PRC_CEX (prc_id, cex_id)
                Select Distinct PRC.PRC_ID, CEX.CEX_ID
                  From '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE    TMP
                     , '||v_esquema||'.CEX_CONTRATOS_EXPEDIENTE   CEX
                     , '||v_esquema||'.ASU_ASUNTOS                ASU
                     , '||v_esquema||'.PRC_PROCEDIMIENTOS         PRC
                 Where tmp.exp_id = cex.exp_id
                   And tmp.exp_id = asu.exp_id
                   And asu.asu_id = prc.asu_id';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.PRC_CEX cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;

    --** Creamos relaciones  PRC_BIE
    ---------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.PRB_PRC_BIE (prb_id ,prc_id ,bie_id ,dd_sgb_id ,usuariocrear ,fechacrear ,sys_guid)
                SELECT '||v_esquema||'.s_prb_prc_bie.nextval, prc_id, bie_id, 2, '''||USUARIO||''', sysdate, SYS_GUID() AS SYS_GUID
                 FROM (  SELECT DISTINCT PRC.PRC_ID, bc.bie_id
                           FROM '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE TMP INNER JOIN
                                '||v_esquema||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.EXP_ID = TMP.EXP_ID INNER JOIN
                                '||v_esquema||'.ASU_ASUNTOS ASU ON CEX.EXP_ID = ASU.EXP_ID INNER JOIN
                                '||v_esquema||'.PRC_PROCEDIMIENTOS PRC ON ASU.ASU_ID = PRC.ASU_ID INNER JOIN
                                '||v_esquema||'.BIE_CNT BC ON BC.CNT_ID = CEX.CNT_ID )';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.PRB_PRC_BIE cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;

    --** Nuevos PCO_PRC_PROCEDIMIENTOS
    ------------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS (PCO_PRC_ID,PRC_ID, PCO_PRC_NUM_EXP_EXT, PCO_PRC_NUM_EXP_INT, usuariocrear, fechacrear, SYS_GUID)
                    select '||v_esquema||'.s_pco_prc_procedimientos.nextval, prc_id, cd_expediente_nuse, cd_expediente_nuse, '''||USUARIO||''', sysdate, SYS_GUID() AS SYS_GUID
                    from (Select distinct prc.prc_id, tmp.cd_expediente_nuse
                            from '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE   TMP
                               , '||v_esquema||'.ASU_ASUNTOS               ASU
                               , '||v_esquema||'.PRC_PROCEDIMIENTOS        PRC
                               , '||v_esquema||'.DD_TPO_TIPO_PROCEDIMIENTO TPO
                               , '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS    PCO
                           Where tmp.exp_id = asu.exp_id
                             And asu.asu_id = prc.asu_id
                             And prc.dd_tpo_id = tpo.dd_tpo_id
                             And prc.prc_id = pco.prc_id(+)
                             And pco.pco_prc_id is null
                             And tpo.dd_tpo_codigo = ''PCO''
                             And asu.borrado = 0 )';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;

    --** Si SI recibimos la marca de agencia, hay que lanzar una actuación de preparación de expediente judicial, completar la tarea de "estudio", indicando que se marca como "en gestión por agencias" y finalizar la actuación.
    --** Si NO recibimos la marca de agencia, hay que lanzar una actuación de preparación de expediente judicial, completar la tarea de "estudio", indicando que se marca como "sin gestión" y finalizar la actuación.
    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, PCO_PRC_HEP_FECHA_FIN, USUARIOCREAR, FECHACREAR, SYS_GUID)
                    SELECT '||v_esquema||'.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL AS PCO_PRC_HEP_ID,
                           pco.PCO_PRC_ID,
                          (SELECT DD_PCO_PEP_ID FROM '||v_esquema||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''FI'') ,-- Metemos directamente ''Finalizar'' para "finalizar la actuación". Si hay que tener también ''En estudio'' -> DD_PCO_PEP_CODIGO =''PT'' y crear tarea en tar_tareas
                           SYSDATE-2 AS PCO_PRC_HEP_FECHA_INICIO,
                           SYSDATE   AS PCO_PRC_HEP_FECHA_FIN,
                           '''||USUARIO||''' AS USUARIOCREAR,
                           SYSDATE   AS FECHACREAR,
                           SYS_GUID() AS SYS_GUID
                    FROM '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE   TMP
                       , '||v_esquema||'.ASU_ASUNTOS               ASU
                       , '||v_esquema||'.PRC_PROCEDIMIENTOS        PRC
                       , '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS    PCO
                       , '||v_esquema||'.DD_TPO_TIPO_PROCEDIMIENTO TPO
                    WHERE tmp.exp_id = asu.exp_id
                      AND asu.asu_id = prc.asu_id
                      AND prc.dd_tpo_id = tpo.dd_tpo_id
                      AND prc.prc_id = pco.prc_id
                      AND tpo.dd_tpo_codigo = ''PCO''
             ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.PCO_PRC_HEP_HISTOR_EST_PREP cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;


    --** TAR_TAREAS_NOTIFICACIONES
    -------------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION,
                                                                     TAR_FECHA_FIN, TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_TAREA_FINALIZADA ,TAR_EMISOR,
                                                                     VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, SYS_GUID)
                    SELECT '||v_esquema||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL,
                           null AS EXP_ID,
                           ASU.ASU_ID,
                           6 AS DD_EST_ID,
                           5 AS DD_EIN_ID,
                           NVL(tap.dd_sta_id,39) AS DD_STA_ID, -- 39 = TAREA EXTERNA (GESTOR)
                           1 AS TAR_CODIGO,
                           TAP.TAP_CODIGO TAR_TAREA,
                           TAP.TAP_DESCRIPCION AS TAR_DESCRIPCION,
                           TRUNC(SYSDATE) AS TAR_FECHA_FIN,
                           TRUNC(SYSDATE) AS TAR_FECHA_INI,
                           0 AS TAR_EN_ESPERA,
                           0 AS TAR_ALERTA,
                           1 AS TAR_TAREA_FINALIZADA,
                           ''AUTOMATICA'' AS TAR_EMISOR,
                           0 AS VERSION,
                           '''||USUARIO||''' AS USUARIOCREAR,
                           SYSDATE AS FECHACREAR,
                           0 AS BORRADO,
                           PRC.PRC_ID,
                           ''EXTTareaNotificacion'' AS DTYPE,
                           0 AS NFA_TAR_REVISADA,
                           SYS_GUID() AS SYS_GUID
                    FROM '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE TMP INNER JOIN
                         '||v_esquema||'.ASU_ASUNTOS ASU ON ASU.EXP_ID = TMP.EXP_ID INNER JOIN
                         '||v_esquema||'.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID INNER JOIN
                         '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID = PRC.PRC_ID INNER JOIN
                         '||v_esquema||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||v_esquema||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''FI'')
                         INNER JOIN '||v_esquema||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP_CODIGO = ''PCO_RevisarExpedientePreparar''';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;


    --** TEX_TAREA_EXTERNA
    ----------------------------------
    v_sql := 'INSERT INTO '||v_esquema||'.TEX_TAREA_EXTERNA(TEX_ID, TAR_ID, TAP_ID, TEX_DETENIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TEX_CANCELADA, TEX_NUM_AUTOP, DTYPE)
                    SELECT '||v_esquema||'.S_TEX_TAREA_EXTERNA.NEXTVAL,
                           TAR_ID,
                           TAP.TAP_ID AS TAP_ID,
                           0 AS TEX_DETENIDA,
                           0 AS VERSION,
                           '''||USUARIO||''' AS USUARIOCREAR,
                           SYSDATE AS FECHACREAR,
                           0 AS BOORADO,
                           0 AS TEX_CANCELADA,
                           0 AS TEX_NUM_AUTOP,
                           ''EXTTareaExterna''  AS DTYPE
                      FROM '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE    TMP
                         , '||v_esquema||'.ASU_ASUNTOS                ASU
                         , '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES  TAR
                         , '||v_esquema||'.TAP_TAREA_PROCEDIMIENTO    TAP
                      WHERE tmp.exp_id = asu.exp_id
                        AND asu.asu_id = tar.asu_id
                        AND tar.tar_tarea = tap.tap_codigo
                        AND tar.usuariocrear = '''||USUARIO||'''
              ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.TEX_TAREA_EXTERNA cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;

    --** TEV_VALOR
    ----------------
    v_sql := 'Insert into '||v_esquema||'.TEV_TAREA_EXTERNA_VALOR (tev_id, tex_id, tev_nombre, tev_valor, version, usuariocrear, fechacrear, tev_valor_clob, DType)
                select '||v_esquema||'.s_tev_tarea_externa_valor.nextval as tev_id
                     , tex.tex_id
                     , tev.tev_nombre
                     , decode( tev.tev_nombre
                             , ''fecha_fin'', to_char(sysdate,''yyyy-mm-dd'')
                             , ''gestion'', decode(tmp.cdTipoAct,''AGE'',''AGENCIA_EXTERNA''
                                                                ,''PCO'',''SIN_GESTION''
                                                                ,''GES'',''SIN_GESTION'')
                             , ''proc_iniciar'', null
                             , ''observaciones'', null
                             ) as tev_valor
                     , 0 as version
                     , '''||USUARIO||''' as usuariocrear
                     , sysdate as fechacrear
                     , 0 as tev_valor_clob
                     , ''EXTTareaExternaValor'' as DType
                  from '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE    TMP
                     , '||v_esquema||'.ASU_ASUNTOS                ASU
                     , '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES  TAR
                     , '||v_esquema||'.TAP_TAREA_PROCEDIMIENTO    TAP
                     , '||v_esquema||'.TEX_TAREA_EXTERNA          TEX
                     --** Obtenemos valores por producto cartesiano
                     , (Select ''fecha_fin'' as tev_nombre from dual
                        union all
                        Select ''gestion'' as tev_nombre from dual
                        union all
                        Select ''proc_iniciar'' as tev_nombre from dual
                        union all
                        Select ''observaciones'' as tev_nombre from dual) TEV
                  WHERE tmp.exp_id = asu.exp_id
                    AND asu.asu_id = tar.asu_id
                    AND tar.tar_tarea = tap.tap_codigo
                    AND tar.tar_id = tex.tar_id
                    AND tap.tap_id = tex.tap_id
             ';
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.TEV_TAREA_EXTERNA_VALOR cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;


    --** Borramos tablas de maniobra
    ----------------------------------
/*
    v_sql := 'Select Count(1) From all_all_tables Where table_name = ''TMP_GUIA_CONTRATOS_HRE''';
    execute immediate v_sql into v_num_tablas;
    If v_num_tablas > 0
     Then v_sql := 'Drop table '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE';
          execute immediate v_sql;
          DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.TMP_GUIA_CONTRATOS_HRE borrada');
    End If;

    v_sql := 'Select Count(1) From all_all_tables Where table_name = ''TMP_EXP_EXPEDIENTES_HRE''';
    execute immediate v_sql into v_num_tablas;
    If v_num_tablas > 0
     Then v_sql := 'Drop table '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE';
          execute immediate v_sql;
          DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.TMP_EXP_EXPEDIENTES_HRE borrada');
    End If;
*/
DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR MIGRACION CONTRATOS MARCA HAYA');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;
