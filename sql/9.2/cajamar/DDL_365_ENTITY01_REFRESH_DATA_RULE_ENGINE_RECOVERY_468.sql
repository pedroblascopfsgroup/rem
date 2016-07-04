--/*
--##########################################
--## AUTOR=Luis Ruiz
--## FECHA_CREACION=20160622
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2.6
--## INCIDENCIA_LINK=RECOVERY-468
--## PRODUCTO=NO
--## Finalidad: DDL PARA MODIFICAR EL REFRESCO DE LA VISTA
--##
--## INSTRUCCIONES: ---
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_MSQL2        VARCHAR2(32000 CHAR); -- Sentencia a ejecutar continuacion
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX     VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] CREAR PROCEDURE REFRESH_DATA_RULE_ENGINE ');

  V_MSQL :=
  'CREATE OR REPLACE PROCEDURE '||V_ESQUEMA||'.REFRESH_DATA_RULE_ENGINE
   as
   CURSOR CUR IS
     SELECT /*+ PARALLEL */
            per.per_id,
            per_riesgo,
            per_riesgo_autorizado,
            per_riesgo_ind,
            per_riesgo_dir_vencido,
            per_sexo,
            CASE
               WHEN per_empleado = 1
                THEN dd_si.dd_sin_id
               ELSE dd_no.dd_sin_id
            END as PER_EMPLEADO,
            per.dd_cos_id,
            CASE
               WHEN per.dd_cos_id = 20
                 THEN 0
                 ELSE 1
            END as COLECTIVO_SINGULAR,
            per.dd_pnv_id,
            CASE
               WHEN per_arq.titular IS NULL
                 THEN 0
               ELSE per_arq.titular
            END as PER_TITULAR,
            per_riesgo_dispuesto,
            per.per_deuda_irregular_dir,
            per_nacionalidad,
            per_ecv,
            dd_sce_id,
            ant.ant_reincidencia_internos,
            per.dd_tpe_id,
            per_pais_nacimiento,
            dd_pol_id,
            per_fecha_nacimiento,
            per_arq.serv_nomina_pension as SERV_NOMINA_PENSION,
            dd_rex_id,
            per_fecha_constitucion,
            per.ofi_id,
            CASE
               WHEN per_arq.per_domic_ext is null
                 THEN 0
               ELSE per_arq.per_domic_ext
            END as PER_DOMICI_EXT,
            CASE
               WHEN per_arq.per_deuda_desc is null
                 THEN 0
               ELSE per_arq.per_deuda_desc
            END as PER_DEUDA_DESC,
            mov_int_remuneratorios,
            mov_int_moratorios,
            dd_apo_id,
            dd_gc1_id,
            cnt_fecha_esc,
            cnt_fecha_constitucion,
            TRUNC (sysdate - mov.mov_fecha_pos_vencida) as DIAS_IRREGULAR,
            mov_deuda_irregular,
            mov_saldo_dudoso,
            mov_provision,
            mov_provision_porcentaje,
            mov_riesgo_garant,
            cnt_fecha_efc_ant,
            mov_ltv_ini,
            cnt_fecha_efc,
            mov_comisiones,
            mov_dispuesto,
            dd_fno_id,
            cnt.dd_efc_id,
            dd_mon_id,
            cnt.dd_tpe_id as DD_CT1_ID,
            cnt_domici_ext,
            cnt.dd_esc_id,
            cnt_arq.dd_ece_id,
            cnt_arq.iac_propietario as ENT_PROPIE,
            cnt_arq.segmento_cartera,
            mov_ltv_fin,
            cnt_limite_ini,
            mov_saldo_pasivo,
            mov_fecha_pos_vencida,
            mov_limite_desc,
            cnt_fecha_venc,
            cnt_fecha_creacion,
            mov_saldo_exce,
            mov_scoring,
            cnt_limite_fin,
            dd_efc_id_ant,
            mov_gastos,
            per_arq.per_deuda_irregular_hipo,
            NVL(cnt_arq.cnt_dias_irregular_hipo, 0) as CNT_DIAS_IRREGULAR_HIPO,
             CASE
                WHEN niv_codigoN0 =''0'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                ELSE ''0'' END as CENTRONIVEL0,
             CASE
                WHEN niv_codigoN0 =''1'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''1'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                ELSE ''0'' END as CENTRONIVEL1,
             CASE
                WHEN niv_codigoN0 =''2'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''2'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                WHEN niv_codigoN2 =''2'' THEN SUBSTR(zon_num_centroN2,-6, 4)
                ELSE ''0'' END as CENTRONIVEL2,
             CASE
                WHEN niv_codigoN0 =''3'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''3'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                WHEN niv_codigoN2 =''3'' THEN SUBSTR(zon_num_centroN2,-6, 4)
                WHEN niv_codigoN3 =''3'' THEN SUBSTR(zon_num_centroN3,-6, 4)
                ELSE ''0'' END as CENTRONIVEL3,
             CASE
                WHEN niv_codigoN0 =''4'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''4'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                WHEN niv_codigoN2 =''4'' THEN SUBSTR(zon_num_centroN2,-6, 4)
                WHEN niv_codigoN3 =''4'' THEN SUBSTR(zon_num_centroN3,-6, 4)
                WHEN niv_codigoN4 =''4'' THEN SUBSTR(zon_num_centroN4,-6, 4)
                ELSE ''0'' END as CENTRONIVEL4,
             CASE
                WHEN niv_codigoN0 =''5'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''5'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                WHEN niv_codigoN2 =''5'' THEN SUBSTR(zon_num_centroN2,-6, 4)
                WHEN niv_codigoN3 =''5'' THEN SUBSTR(zon_num_centroN3,-6, 4)
                WHEN niv_codigoN4 =''5'' THEN SUBSTR(zon_num_centroN4,-6, 4)
                WHEN niv_codigoN5 =''5'' THEN SUBSTR(zon_num_centroN5,-6, 4)
                ELSE ''0'' END as CENTRONIVEL5,
             CASE
                WHEN niv_codigoN0 =''6'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''6'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                WHEN niv_codigoN2 =''6'' THEN SUBSTR(zon_num_centroN2,-6, 4)
                WHEN niv_codigoN3 =''6'' THEN SUBSTR(zon_num_centroN3,-6, 4)
                WHEN niv_codigoN4 =''6'' THEN SUBSTR(zon_num_centroN4,-6, 4)
                WHEN niv_codigoN5 =''6'' THEN SUBSTR(zon_num_centroN5,-6, 4)
                WHEN niv_codigoN6 =''6'' THEN SUBSTR(zon_num_centroN6,-6, 4)
                ELSE ''0'' END as CENTRONIVEL6,
             CASE
                WHEN niv_codigoN0 =''7'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''7'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                WHEN niv_codigoN2 =''7'' THEN SUBSTR(zon_num_centroN2,-6, 4)
                WHEN niv_codigoN3 =''7'' THEN SUBSTR(zon_num_centroN3,-6, 4)
                WHEN niv_codigoN4 =''7'' THEN SUBSTR(zon_num_centroN4,-6, 4)
                WHEN niv_codigoN5 =''7'' THEN SUBSTR(zon_num_centroN5,-6, 4)
                WHEN niv_codigoN6 =''7'' THEN SUBSTR(zon_num_centroN6,-6, 4)
                WHEN niv_codigoN7 =''7'' THEN SUBSTR(zon_num_centroN7,-6, 4)
                ELSE ''0'' END as CENTRONIVEL7,
             CASE
                WHEN niv_codigoN0 =''8'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''8'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                WHEN niv_codigoN2 =''8'' THEN SUBSTR(zon_num_centroN2,-6, 4)
                WHEN niv_codigoN3 =''8'' THEN SUBSTR(zon_num_centroN3,-6, 4)
                WHEN niv_codigoN4 =''8'' THEN SUBSTR(zon_num_centroN4,-6, 4)
                WHEN niv_codigoN5 =''8'' THEN SUBSTR(zon_num_centroN5,-6, 4)
                WHEN niv_codigoN6 =''8'' THEN SUBSTR(zon_num_centroN6,-6, 4)
                WHEN niv_codigoN7 =''8'' THEN SUBSTR(zon_num_centroN7,-6, 4)
                WHEN niv_codigoN8 =''8'' THEN SUBSTR(zon_num_centroN8,-6, 4)
                ELSE ''0'' END as CENTRONIVEL8,
             CASE
                WHEN niv_codigoN0 =''9'' THEN SUBSTR(zon_num_centroN0,-6, 4)
                WHEN niv_codigoN1 =''9'' THEN SUBSTR(zon_num_centroN1,-6, 4)
                WHEN niv_codigoN2 =''9'' THEN SUBSTR(zon_num_centroN2,-6, 4)
                WHEN niv_codigoN3 =''9'' THEN SUBSTR(zon_num_centroN3,-6, 4)
                WHEN niv_codigoN4 =''9'' THEN SUBSTR(zon_num_centroN4,-6, 4)
                WHEN niv_codigoN5 =''9'' THEN SUBSTR(zon_num_centroN5,-6, 4)
                WHEN niv_codigoN6 =''9'' THEN SUBSTR(zon_num_centroN6,-6, 4)
                WHEN niv_codigoN7 =''9'' THEN SUBSTR(zon_num_centroN7,-6, 4)
                WHEN niv_codigoN8 =''9'' THEN SUBSTR(zon_num_centroN8,-6, 4)
                WHEN niv_codigoN9 =''9'' THEN SUBSTR(zon_num_centroN9,-6, 4)
                ELSE ''0'' END as CENTRONIVEL9,
             CASE
                WHEN niv_codigoPN0 =''0'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER0,
             CASE
                WHEN niv_codigoPN0 =''1'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''1'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER1,
             CASE
                WHEN niv_codigoPN0 =''2'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''2'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                WHEN niv_codigoPN2 =''2'' THEN SUBSTR(zon_num_centroPN2,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER2,
             CASE
                WHEN niv_codigoPN0 =''3'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''3'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                WHEN niv_codigoPN2 =''3'' THEN SUBSTR(zon_num_centroPN2,-6, 4)
                WHEN niv_codigoPN3 =''3'' THEN SUBSTR(zon_num_centroPN3,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER3,
             CASE
                WHEN niv_codigoPN0 =''4'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''4'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                WHEN niv_codigoPN2 =''4'' THEN SUBSTR(zon_num_centroPN2,-6, 4)
                WHEN niv_codigoPN3 =''4'' THEN SUBSTR(zon_num_centroPN3,-6, 4)
                WHEN niv_codigoPN4 =''4'' THEN SUBSTR(zon_num_centroPN4,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER4,
             CASE
                WHEN niv_codigoPN0 =''5'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''5'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                WHEN niv_codigoPN2 =''5'' THEN SUBSTR(zon_num_centroPN2,-6, 4)
                WHEN niv_codigoPN3 =''5'' THEN SUBSTR(zon_num_centroPN3,-6, 4)
                WHEN niv_codigoPN4 =''5'' THEN SUBSTR(zon_num_centroPN4,-6, 4)
                WHEN niv_codigoPN5 =''5'' THEN SUBSTR(zon_num_centroPN5,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER5,
             CASE
                WHEN niv_codigoPN0 =''6'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''6'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                WHEN niv_codigoPN2 =''6'' THEN SUBSTR(zon_num_centroPN2,-6, 4)
                WHEN niv_codigoPN3 =''6'' THEN SUBSTR(zon_num_centroPN3,-6, 4)
                WHEN niv_codigoPN4 =''6'' THEN SUBSTR(zon_num_centroPN4,-6, 4)
                WHEN niv_codigoPN5 =''6'' THEN SUBSTR(zon_num_centroPN5,-6, 4)
                WHEN niv_codigoPN6 =''6'' THEN SUBSTR(zon_num_centroPN6,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER6,
             CASE
                WHEN niv_codigoPN0 =''7'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''7'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                WHEN niv_codigoPN2 =''7'' THEN SUBSTR(zon_num_centroPN2,-6, 4)
                WHEN niv_codigoPN3 =''7'' THEN SUBSTR(zon_num_centroPN3,-6, 4)
                WHEN niv_codigoPN4 =''7'' THEN SUBSTR(zon_num_centroPN4,-6, 4)
                WHEN niv_codigoPN5 =''7'' THEN SUBSTR(zon_num_centroPN5,-6, 4)
                WHEN niv_codigoPN6 =''7'' THEN SUBSTR(zon_num_centroPN6,-6, 4)
                WHEN niv_codigoPN7 =''7'' THEN SUBSTR(zon_num_centroPN7,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER7,
             CASE
                WHEN niv_codigoPN0 =''8'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''8'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                WHEN niv_codigoPN2 =''8'' THEN SUBSTR(zon_num_centroPN2,-6, 4)
                WHEN niv_codigoPN3 =''8'' THEN SUBSTR(zon_num_centroPN3,-6, 4)
                WHEN niv_codigoPN4 =''8'' THEN SUBSTR(zon_num_centroPN4,-6, 4)
                WHEN niv_codigoPN5 =''8'' THEN SUBSTR(zon_num_centroPN5,-6, 4)
                WHEN niv_codigoPN6 =''8'' THEN SUBSTR(zon_num_centroPN6,-6, 4)
                WHEN niv_codigoPN7 =''8'' THEN SUBSTR(zon_num_centroPN7,-6, 4)
                WHEN niv_codigoPN8 =''8'' THEN SUBSTR(zon_num_centroPN8,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER8,
             CASE
                WHEN niv_codigoPN0 =''9'' THEN SUBSTR(zon_num_centroPN0,-6, 4)
                WHEN niv_codigoPN1 =''9'' THEN SUBSTR(zon_num_centroPN1,-6, 4)
                WHEN niv_codigoPN2 =''9'' THEN SUBSTR(zon_num_centroPN2,-6, 4)
                WHEN niv_codigoPN3 =''9'' THEN SUBSTR(zon_num_centroPN3,-6, 4)
                WHEN niv_codigoPN4 =''9'' THEN SUBSTR(zon_num_centroPN4,-6, 4)
                WHEN niv_codigoPN5 =''9'' THEN SUBSTR(zon_num_centroPN5,-6, 4)
                WHEN niv_codigoPN6 =''9'' THEN SUBSTR(zon_num_centroPN6,-6, 4)
                WHEN niv_codigoPN7 =''9'' THEN SUBSTR(zon_num_centroPN7,-6, 4)
                WHEN niv_codigoPN8 =''9'' THEN SUBSTR(zon_num_centroPN8,-6, 4)
                WHEN niv_codigoPN9 =''9'' THEN SUBSTR(zon_num_centroPN9,-6, 4)
                ELSE ''0'' END as CENTRONIVELPER9
           , NVL(tin.dd_tin_titular, 0) as ES_TITULAR
           , NVL(per_arq.max_dias_irregular, 0) as MAX_DIAS_IRREGULAR
           , per_arq.dd_tcn_id
           , cnt_arq.dd_mrf_id
           , cnt_arq.dd_mom_id
           , cnt_arq.dd_idn_id
           , NVL(acn.acn_num_reinciden, 0) as ACN_NUM_REINCIDEN
           , pto.pto_intervalo
           , pto.pto_puntuacion
            ,cnt.dd_ges_id
            ,eic.dd_eic_id
            ,cnt.dd_cre_id
            ,gcl.dd_tgl_id
            ,NVL(per.per_riesgo_total,0) as PER_RIESGO_TOTAL
            ,NVL(GCL.gcl_nombre,''DESCONOCIDO'') as GCL_NOMBRE
            ,(NVL(tmp_per.tmp_num_extra3,0) - NVL(tmp_per.TMP_NUM_EXTRA6,0)) as PER_RIESGO_TOTAL_FALLIDO
            ,tmp_per.tmp_num_extra7 as DEUDA_IRREG_FALLIDOS
            ,CASE
                WHEN tmp_cnt.tmp_cnt_flag_extra7 = 1
                THEN dd_si.dd_sin_id
                ELSE dd_no.dd_sin_id
            END as PROD_ATENCION_SOCIAL
            ,CASE
                WHEN tmp_per.TMP_PER_FLAG_EXTRA2 = ''S''
                  THEN dd_si.dd_sin_id
                WHEN tmp_per.TMP_PER_FLAG_EXTRA2 = ''N''
                  THEN dd_no.dd_sin_id
                ELSE null
            END as PER_EMP_PROD_GESTION
        FROM  '||V_ESQUEMA||'.PER_PERSONAS per
          LEFT JOIN  '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS cpe ON per.per_id = cpe.per_id --PER_CPE
          LEFT JOIN  '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION tin ON cpe.dd_tin_id = tin.dd_tin_id
          LEFT JOIN  '||V_ESQUEMA||'.CNT_CONTRATOS cnt ON cpe.cnt_id = cnt.cnt_id        --CPE_CNT
          LEFT JOIN  (select iac.cnt_id, iac.iac_value from '||V_ESQUEMA||'.EXT_IAC_INFO_ADD_CONTRATO iac where iac.dd_ifc_id = (select ifc.dd_ifc_id from '||V_ESQUEMA||'.EXT_DD_IFC_INFO_CONTRATO ifc where ifc.dd_ifc_codigo = ''char_extra10'')) CNT_CHAR_EXTRA10 ON CNT_CHAR_EXTRA10.CNT_ID=CNT.CNT_ID
          LEFT JOIN  '||V_ESQUEMA||'.DD_EIC_ESTADO_INTERNO_ENTIDAD EIC ON CNT_CHAR_EXTRA10.IAC_VALUE = EIC.DD_EIC_CODIGO
          LEFT JOIN  '||V_ESQUEMA||'.MOV_MOVIMIENTOS mov ON cnt.cnt_id = mov.cnt_id AND cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion --CNT_MOV
          LEFT JOIN  '||V_ESQUEMA||'.ANT_ANTECEDENTES ant ON ant.ant_id = per.ant_id
          LEFT JOIN  '||V_ESQUEMA||'.PTO_PUNTUACION_TOTAL pto ON pto.per_id = per.per_id AND (pto.pto_activo = 1 OR pto.pto_activo IS NULL) --PER_PTO
          LEFT JOIN  '||V_ESQUEMA||'.PER_GCL pg ON pg.per_id = per.per_id
          LEFT JOIN  '||V_ESQUEMA||'.GCL_GRUPOS_CLIENTES gcl ON pg.gcl_id = gcl.gcl_id
          LEFT JOIN  '||V_ESQUEMA||'.PER_PRECALCULO_ARQ per_arq ON per.per_cod_cliente_entidad = per_arq.per_cod_cliente_entidad
          LEFT JOIN  '||V_ESQUEMA||'.CNT_PRECALCULO_ARQ cnt_arq ON cnt.cnt_contrato = cnt_arq.cnt_contrato
          LEFT JOIN  '||V_ESQUEMA||'.ACN_ANTECED_CONTRATOS acn ON acn.cnt_id=cnt.cnt_id
          LEFT JOIN  '||V_ESQUEMA||'.TMP_PER_PERSONAS tmp_per ON tmp_per.tmp_per_cod_persona = per.per_cod_cliente_entidad
          LEFT JOIN  '||V_ESQUEMA||'.TMP_CNT_CONTRATOS tmp_cnt ON tmp_cnt.tmp_cnt_id = cnt.cnt_id
          LEFT JOIN (select dd_sin_id, dd_sin_codigo from ' || V_ESQUEMA_M || '.DD_SIN_SINO) dd_si ON dd_si.dd_sin_codigo = ''01''
          LEFT JOIN (select dd_sin_id, dd_sin_codigo from ' || V_ESQUEMA_M || '.DD_SIN_SINO) dd_no ON dd_no.dd_sin_codigo = ''02''
          LEFT JOIN (select cnt_id,
                            zonN0.zon_id as zon_idN0, zonN0.zon_cod as zon_codN0, zonN0.zon_num_centro as zon_num_centroN0, zonN0.zon_descripcion as zon_descripcionN0, zonN0.zon_pid as zon_pidN0, nivN0.niv_id as niv_idN0, nivN0.niv_codigo as niv_codigoN0, nivN0.niv_descripcion as niv_descripcionN0,
                            zonN1.zon_id as zon_idN1, zonN1.zon_cod as zon_codN1, zonN1.zon_num_centro as zon_num_centroN1, zonN1.zon_descripcion as zon_descripcionN1, zonN1.zon_pid as zon_pidN1, nivN1.niv_id as niv_idN1, nivN1.niv_codigo as niv_codigoN1, nivN1.niv_descripcion as niv_descripcionN1,
                            zonN2.zon_id as zon_idN2, zonN2.zon_cod as zon_codN2, zonN2.zon_num_centro as zon_num_centroN2, zonN2.zon_descripcion as zon_descripcionN2, zonN2.zon_pid as zon_pidN2, nivN2.niv_id as niv_idN2, nivN2.niv_codigo as niv_codigoN2, nivN2.niv_descripcion as niv_descripcionN2,
                            zonN3.zon_id as zon_idN3, zonN3.zon_cod as zon_codN3, zonN3.zon_num_centro as zon_num_centroN3, zonN3.zon_descripcion as zon_descripcionN3, zonN3.zon_pid as zon_pidN3, nivN3.niv_id as niv_idN3, nivN3.niv_codigo as niv_codigoN3, nivN3.niv_descripcion as niv_descripcionN3,
                            zonN4.zon_id as zon_idN4, zonN4.zon_cod as zon_codN4, zonN4.zon_num_centro as zon_num_centroN4, zonN4.zon_descripcion as zon_descripcionN4, zonN4.zon_pid as zon_pidN4, nivN4.niv_id as niv_idN4, nivN4.niv_codigo as niv_codigoN4, nivN4.niv_descripcion as niv_descripcionN4,
                            zonN5.zon_id as zon_idN5, zonN5.zon_cod as zon_codN5, zonN5.zon_num_centro as zon_num_centroN5, zonN5.zon_descripcion as zon_descripcionN5, zonN5.zon_pid as zon_pidN5, nivN5.niv_id as niv_idN5, nivN5.niv_codigo as niv_codigoN5, nivN5.niv_descripcion as niv_descripcionN5,
                            zonN6.zon_id as zon_idN6, zonN6.zon_cod as zon_codN6, zonN6.zon_num_centro as zon_num_centroN6, zonN6.zon_descripcion as zon_descripcionN6, zonN6.zon_pid as zon_pidN6, nivN6.niv_id as niv_idN6, nivN6.niv_codigo as niv_codigoN6, nivN6.niv_descripcion as niv_descripcionN6,
                            zonN7.zon_id as zon_idN7, zonN7.zon_cod as zon_codN7, zonN7.zon_num_centro as zon_num_centroN7, zonN7.zon_descripcion as zon_descripcionN7, zonN7.zon_pid as zon_pidN7, nivN7.niv_id as niv_idN7, nivN7.niv_codigo as niv_codigoN7, nivN7.niv_descripcion as niv_descripcionN7,
                            zonN8.zon_id as zon_idN8, zonN8.zon_cod as zon_codN8, zonN8.zon_num_centro as zon_num_centroN8, zonN8.zon_descripcion as zon_descripcionN8, zonN8.zon_pid as zon_pidN8, nivN8.niv_id as niv_idN8, nivN8.niv_codigo as niv_codigoN8, nivN8.niv_descripcion as niv_descripcionN8,
                            zonN9.zon_id as zon_idN9, zonN9.zon_cod as zon_codN9, zonN9.zon_num_centro as zon_num_centroN9, zonN9.zon_descripcion as zon_descripcionN9, zonN9.zon_pid as zon_pidN9, nivN9.niv_id as niv_idN9, nivN9.niv_codigo as niv_codigoN9, nivN9.niv_descripcion as niv_descripcionN9
                       from '||V_ESQUEMA||'.CNT_CONTRATOS cnt
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN0 on cnt.zon_id=zonN0.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN0 on zonN0.niv_id=nivN0.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN1 on zonN0.zon_pid=zonN1.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN1 on zonN1.niv_id=nivN1.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN2 on zonN1.zon_pid=zonN2.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN2 on zonN2.niv_id=nivN2.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN3 on zonN2.zon_pid=zonN3.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN3 on zonN3.niv_id=nivN3.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN4 on zonN3.zon_pid=zonN4.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN4 on zonN4.niv_id=nivN4.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN5 on zonN4.zon_pid=zonN5.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN5 on zonN5.niv_id=nivN5.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN6 on zonN5.zon_pid=zonN6.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN6 on zonN6.niv_id=nivN6.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN7 on zonN6.zon_pid=zonN7.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN7 on zonN7.niv_id=nivN7.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN8 on zonN7.zon_pid=zonN8.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN8 on zonN8.niv_id=nivN8.niv_id
                         join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonN9 on zonN8.zon_pid=zonN9.zon_id
                         join  '||V_ESQUEMA||'.NIV_NIVEL nivN9 on zonN9.niv_id=nivN9.niv_id) nivelescnt ON nivelescnt.cnt_id = cnt.cnt_id
             -- LEFT JOIN  DATA_RULE_ENGINE_PER_NIV NIVELESPER ON NIVELESPER.PER_ID=PER.PER_ID
             LEFT JOIN (select per.per_id,
                               zonPN0.zon_id as zon_idPN0, zonPN0.zon_cod as zon_codPN0, zonPN0.zon_num_centro as zon_num_centroPN0, zonPN0.zon_descripcion as zon_descripcionPN0, zonPN0.zon_pid as zon_pidPN0, nivN0.niv_id as niv_idPN0, nivN0.niv_codigo as niv_codigoPN0, nivN0.niv_descripcion as niv_descripcionPN0,
                               zonPN1.zon_id as zon_idPN1, zonPN1.zon_cod as zon_codPN1, zonPN1.zon_num_centro as zon_num_centroPN1, zonPN1.zon_descripcion as zon_descripcionPN1, zonPN1.zon_pid as zon_pidPN1, nivN1.niv_id as niv_idPN1, nivN1.niv_codigo as niv_codigoPN1, nivN1.niv_descripcion as niv_descripcionPN1,
                               zonPN2.zon_id as zon_idPN2, zonPN2.zon_cod as zon_codPN2, zonPN2.zon_num_centro as zon_num_centroPN2, zonPN2.zon_descripcion as zon_descripcionPN2, zonPN2.zon_pid as zon_pidPN2, nivN2.niv_id as niv_idPN2, nivN2.niv_codigo as niv_codigoPN2, nivN2.niv_descripcion as niv_descripcionPN2,
                               zonPN3.zon_id as zon_idPN3, zonPN3.zon_cod as zon_codPN3, zonPN3.zon_num_centro as zon_num_centroPN3, zonPN3.zon_descripcion as zon_descripcionPN3, zonPN3.zon_pid as zon_pidPN3, nivN3.niv_id as niv_idPN3, nivN3.niv_codigo as niv_codigoPN3, nivN3.niv_descripcion as niv_descripcionPN3,
                               zonPN4.zon_id as zon_idPN4, zonPN4.zon_cod as zon_codPN4, zonPN4.zon_num_centro as zon_num_centroPN4, zonPN4.zon_descripcion as zon_descripcionPN4, zonPN4.zon_pid as zon_pidPN4, nivN4.niv_id as niv_idPN4, nivN4.niv_codigo as niv_codigoPN4, nivN4.niv_descripcion as niv_descripcionPN4,
                               zonPN5.zon_id as zon_idPN5, zonPN5.zon_cod as zon_codPN5, zonPN5.zon_num_centro as zon_num_centroPN5, zonPN5.zon_descripcion as zon_descripcionPN5, zonPN5.zon_pid as zon_pidPN5, nivN5.niv_id as niv_idPN5, nivN5.niv_codigo as niv_codigoPN5, nivN5.niv_descripcion as niv_descripcionPN5,
                               zonPN6.zon_id as zon_idPN6, zonPN6.zon_cod as zon_codPN6, zonPN6.zon_num_centro as zon_num_centroPN6, zonPN6.zon_descripcion as zon_descripcionPN6, zonPN6.zon_pid as zon_pidPN6, nivN6.niv_id as niv_idPN6, nivN6.niv_codigo as niv_codigoPN6, nivN6.niv_descripcion as niv_descripcionPN6,
                               zonPN7.zon_id as zon_idPN7, zonPN7.zon_cod as zon_codPN7, zonPN7.zon_num_centro as zon_num_centroPN7, zonPN7.zon_descripcion as zon_descripcionPN7, zonPN7.zon_pid as zon_pidPN7, nivN7.niv_id as niv_idPN7, nivN7.niv_codigo as niv_codigoPN7, nivN7.niv_descripcion as niv_descripcionPN7,
                               zonPN8.zon_id as zon_idPN8, zonPN8.zon_cod as zon_codPN8, zonPN8.zon_num_centro as zon_num_centroPN8, zonPN8.zon_descripcion as zon_descripcionPN8, zonPN8.zon_pid as zon_pidPN8, nivN8.niv_id as niv_idPN8, nivN8.niv_codigo as niv_codigoPN8, nivN8.niv_descripcion as niv_descripcionPN8,
                               zonPN9.zon_id as zon_idPN9, zonPN9.zon_cod as zon_codPN9, zonPN9.zon_num_centro as zon_num_centroPN9, zonPN9.zon_descripcion as zon_descripcionPN9, zonPN9.zon_pid as zon_pidPN9, nivN9.niv_id as niv_idPN9, nivN9.niv_codigo as niv_codigoPN9, nivN9.niv_descripcion as niv_descripcionPN9
                          from '||V_ESQUEMA||'.PER_PERSONAS per
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN0 on per.ofi_id=zonPN0.ofi_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN0 on zonPN0.niv_id=nivN0.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN1 on zonPN0.zon_pid=zonPN1.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN1 on zonPN1.niv_id=nivN1.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN2 on zonPN1.zon_pid=zonPN2.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN2 on zonPN2.niv_id=nivN2.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN3 on zonPN2.zon_pid=zonPN3.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN3 on zonPN3.niv_id=nivN3.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN4 on zonPN3.zon_pid=zonPN4.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN4 on zonPN4.niv_id=nivN4.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN5 on zonPN4.zon_pid=zonPN5.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN5 on zonPN5.niv_id=nivN5.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN6 on zonPN5.zon_pid=zonPN6.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN6 on zonPN6.niv_id=nivN6.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN7 on zonPN6.zon_pid=zonPN7.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN7 on zonPN7.niv_id=nivN7.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN8 on zonPN7.zon_pid=zonPN8.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN8 on zonPN8.niv_id=nivN8.niv_id
                            join  '||V_ESQUEMA||'.ZON_ZONIFICACION zonPN9 on zonPN8.zon_pid=zonPN9.zon_id
                            join  '||V_ESQUEMA||'.NIV_NIVEL nivN9 on zonPN9.niv_id=nivN9.niv_id) nivelesper ON nivelesper.per_id = per.per_id
         WHERE per.per_fecha_extraccion = (select max(per_fecha_extraccion) from '||V_ESQUEMA||'.PER_PERSONAS);

      TYPE T_DATA IS TABLE OF CUR%ROWTYPE INDEX BY BINARY_INTEGER;
      L_DATA T_DATA;
  ';
  V_MSQL2 :=
  'BEGIN
     EXECUTE IMMEDIATE ''TRUNCATE TABLE DATA_RULE_ENGINE'';

      OPEN CUR;
      LOOP
        FETCH CUR  BULK COLLECT INTO L_DATA LIMIT 1000;
        FORALL I IN 1..L_DATA.COUNT
        INSERT INTO '||V_ESQUEMA||'.DATA_RULE_ENGINE
                (PER_ID
                ,PER_RIESGO
                ,PER_RIESGO_AUTORIZADO
                ,PER_RIESGO_IND
                ,PER_RIESGO_DIR_VENCIDO
                ,PER_SEXO
                ,PER_EMPLEADO
                ,DD_COS_ID
                ,COLECTIVO_SINGULAR
                ,DD_PNV_ID
                ,PER_TITULAR
                ,PER_RIESGO_DISPUESTO
                ,PER_DEUDA_IRREGULAR_DIR
                ,PER_NACIONALIDAD
                ,PER_ECV
                ,DD_SCE_ID
                ,ANT_REINCIDENCIA_INTERNOS
                ,DD_TPE_ID
                ,PER_PAIS_NACIMIENTO
                ,DD_POL_ID
                ,PER_FECHA_NACIMIENTO
                ,SERV_NOMINA_PENSION
                ,DD_REX_ID
                ,PER_FECHA_CONSTITUCION
                ,OFI_ID
                ,PER_DOMICI_EXT
                ,PER_DEUDA_DESC
                ,MOV_INT_REMUNERATORIOS
                ,MOV_INT_MORATORIOS
                ,DD_APO_ID
                ,DD_GC1_ID
                ,CNT_FECHA_ESC
                ,CNT_FECHA_CONSTITUCION
                ,DIAS_IRREGULAR
                ,MOV_DEUDA_IRREGULAR
                ,MOV_SALDO_DUDOSO
                ,MOV_PROVISION
                ,MOV_PROVISION_PORCENTAJE
                ,MOV_RIESGO_GARANT
                ,CNT_FECHA_EFC_ANT
                ,MOV_LTV_INI
                ,CNT_FECHA_EFC
                ,MOV_COMISIONES
                ,MOV_DISPUESTO
                ,DD_FNO_ID
                ,DD_EFC_ID
                ,DD_MON_ID
                ,DD_CT1_ID
                ,CNT_DOMICI_EXT
                ,DD_ESC_ID
                ,DD_ECE_ID
                ,ENT_PROPIE
                ,SEGMENTO_CARTERA
                ,MOV_LTV_FIN
                ,CNT_LIMITE_INI
                ,MOV_SALDO_PASIVO
                ,MOV_FECHA_POS_VENCIDA
                ,MOV_LIMITE_DESC
                ,CNT_FECHA_VENC
                ,CNT_FECHA_CREACION
                ,MOV_SALDO_EXCE
                ,MOV_SCORING
                ,CNT_LIMITE_FIN
                ,DD_EFC_ID_ANT
                ,MOV_GASTOS
                ,PER_DEUDA_IRREGULAR_HIPO
                ,CNT_DIAS_IRREGULAR_HIPO
                ,CENTRONIVEL0
                ,CENTRONIVEL1
                ,CENTRONIVEL2
                ,CENTRONIVEL3
                ,CENTRONIVEL4
                ,CENTRONIVEL5
                ,CENTRONIVEL6
                ,CENTRONIVEL7
                ,CENTRONIVEL8
                ,CENTRONIVEL9
                ,CENTRONIVELPER0
                ,CENTRONIVELPER1
                ,CENTRONIVELPER2
                ,CENTRONIVELPER3
                ,CENTRONIVELPER4
                ,CENTRONIVELPER5
                ,CENTRONIVELPER6
                ,CENTRONIVELPER7
                ,CENTRONIVELPER8
                ,CENTRONIVELPER9
                ,ES_TITULAR
                ,MAX_DIAS_IRREGULAR
                ,DD_TCN_ID
                ,DD_MRF_ID
                ,DD_MOM_ID
                ,DD_IDN_ID
                ,ACN_NUM_REINCIDEN
                ,PTO_INTERVALO
                ,PTO_PUNTUACION
                ,DD_GES_ID
                ,DD_EIC_ID
                ,DD_CRE_ID
                ,DD_TGL_ID
                ,PER_RIESGO_TOTAL
                ,GCL_NOMBRE
                ,PER_RIESGO_TOTAL_FALLIDO
                ,DEUDA_IRREG_FALLIDOS
                ,PROD_ATENCION_SOCIAL
                ,PER_EMP_PROD_GESTION)
        VALUES
          (L_DATA(I).PER_ID
                ,L_DATA(I).PER_RIESGO
                ,L_DATA(I).PER_RIESGO_AUTORIZADO
                ,L_DATA(I).PER_RIESGO_IND
                ,L_DATA(I).PER_RIESGO_DIR_VENCIDO
                ,L_DATA(I).PER_SEXO
                ,L_DATA(I).PER_EMPLEADO
                ,L_DATA(I).DD_COS_ID
                ,L_DATA(I).COLECTIVO_SINGULAR
                ,L_DATA(I).DD_PNV_ID
                ,L_DATA(I).PER_TITULAR
                ,L_DATA(I).PER_RIESGO_DISPUESTO
                ,L_DATA(I).PER_DEUDA_IRREGULAR_DIR
                ,L_DATA(I).PER_NACIONALIDAD
                ,L_DATA(I).PER_ECV
                ,L_DATA(I).DD_SCE_ID
                ,L_DATA(I).ANT_REINCIDENCIA_INTERNOS
                ,L_DATA(I).DD_TPE_ID
                ,L_DATA(I).PER_PAIS_NACIMIENTO
                ,L_DATA(I).DD_POL_ID
                ,L_DATA(I).PER_FECHA_NACIMIENTO
                ,L_DATA(I).SERV_NOMINA_PENSION
                ,L_DATA(I).DD_REX_ID
                ,L_DATA(I).PER_FECHA_CONSTITUCION
                ,L_DATA(I).OFI_ID
                ,L_DATA(I).PER_DOMICI_EXT
                ,L_DATA(I).PER_DEUDA_DESC
                ,L_DATA(I).MOV_INT_REMUNERATORIOS
                ,L_DATA(I).MOV_INT_MORATORIOS
                ,L_DATA(I).DD_APO_ID
                ,L_DATA(I).DD_GC1_ID
                ,L_DATA(I).CNT_FECHA_ESC
                ,L_DATA(I).CNT_FECHA_CONSTITUCION
                ,L_DATA(I).DIAS_IRREGULAR
                ,L_DATA(I).MOV_DEUDA_IRREGULAR
                ,L_DATA(I).MOV_SALDO_DUDOSO
                ,L_DATA(I).MOV_PROVISION
                ,L_DATA(I).MOV_PROVISION_PORCENTAJE
                ,L_DATA(I).MOV_RIESGO_GARANT
                ,L_DATA(I).CNT_FECHA_EFC_ANT
                ,L_DATA(I).MOV_LTV_INI
                ,L_DATA(I).CNT_FECHA_EFC
                ,L_DATA(I).MOV_COMISIONES
                ,L_DATA(I).MOV_DISPUESTO
                ,L_DATA(I).DD_FNO_ID
                ,L_DATA(I).DD_EFC_ID
                ,L_DATA(I).DD_MON_ID
                ,L_DATA(I).DD_CT1_ID
                ,L_DATA(I).CNT_DOMICI_EXT
                ,L_DATA(I).DD_ESC_ID
                ,L_DATA(I).DD_ECE_ID
                ,L_DATA(I).ENT_PROPIE
                ,L_DATA(I).SEGMENTO_CARTERA
                ,L_DATA(I).MOV_LTV_FIN
                ,L_DATA(I).CNT_LIMITE_INI
                ,L_DATA(I).MOV_SALDO_PASIVO
                ,L_DATA(I).MOV_FECHA_POS_VENCIDA
                ,L_DATA(I).MOV_LIMITE_DESC
                ,L_DATA(I).CNT_FECHA_VENC
                ,L_DATA(I).CNT_FECHA_CREACION
                ,L_DATA(I).MOV_SALDO_EXCE
                ,L_DATA(I).MOV_SCORING
                ,L_DATA(I).CNT_LIMITE_FIN
                ,L_DATA(I).DD_EFC_ID_ANT
                ,L_DATA(I).MOV_GASTOS
                ,L_DATA(I).PER_DEUDA_IRREGULAR_HIPO
                ,L_DATA(I).CNT_DIAS_IRREGULAR_HIPO
                ,L_DATA(I).CENTRONIVEL0
                ,L_DATA(I).CENTRONIVEL1
                ,L_DATA(I).CENTRONIVEL2
                ,L_DATA(I).CENTRONIVEL3
                ,L_DATA(I).CENTRONIVEL4
                ,L_DATA(I).CENTRONIVEL5
                ,L_DATA(I).CENTRONIVEL6
                ,L_DATA(I).CENTRONIVEL7
                ,L_DATA(I).CENTRONIVEL8
                ,L_DATA(I).CENTRONIVEL9
                ,L_DATA(I).CENTRONIVELPER0
                ,L_DATA(I).CENTRONIVELPER1
                ,L_DATA(I).CENTRONIVELPER2
                ,L_DATA(I).CENTRONIVELPER3
                ,L_DATA(I).CENTRONIVELPER4
                ,L_DATA(I).CENTRONIVELPER5
                ,L_DATA(I).CENTRONIVELPER6
                ,L_DATA(I).CENTRONIVELPER7
                ,L_DATA(I).CENTRONIVELPER8
                ,L_DATA(I).CENTRONIVELPER9
                ,L_DATA(I).ES_TITULAR
                ,L_DATA(I).MAX_DIAS_IRREGULAR
                ,L_DATA(I).DD_TCN_ID
                ,L_DATA(I).DD_MRF_ID
                ,L_DATA(I).DD_MOM_ID
                ,L_DATA(I).DD_IDN_ID
                ,L_DATA(I).ACN_NUM_REINCIDEN
                ,L_DATA(I).PTO_INTERVALO
                ,L_DATA(I).PTO_PUNTUACION
                ,L_DATA(I).DD_GES_ID
                ,L_DATA(I).DD_EIC_ID
                ,L_DATA(I).DD_CRE_ID
                ,L_DATA(I).DD_TGL_ID
                ,L_DATA(I).PER_RIESGO_TOTAL
                ,L_DATA(I).GCL_NOMBRE
                ,L_DATA(I).PER_RIESGO_TOTAL_FALLIDO
                ,L_DATA(I).DEUDA_IRREG_FALLIDOS
                ,L_DATA(I).PROD_ATENCION_SOCIAL
                ,L_DATA(I).PER_EMP_PROD_GESTION);
        EXIT WHEN CUR%NOTFOUND;

      END LOOP;
      CLOSE CUR;
      COMMIT;
    END REFRESH_DATA_RULE_ENGINE;';

EXECUTE IMMEDIATE V_MSQL||V_MSQL2;

  DBMS_OUTPUT.PUT_LINE('[FIN] PROCEDURE CREADO CORRECTAMENTE');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;
END;
/
EXIT;
