DEFINE num_asuntos = 100
DEFINE esquema = HAYA02
DEFINE master = HAYAMASTER

/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20151026
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-xxx
--## PRODUCTO=NO
--##
--## Finalidad: Inserción de asuntos de Precontencioso
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set timing on
set feedback on

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '&esquema'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '&master'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a TRATAR
    V_DD_TPO_ID NUMBER(16);

    V_SQL_CABECERA VARCHAR2(4000 CHAR); 
    V_SQL_1 VARCHAR2(4000 CHAR); 
    V_SQL_2 VARCHAR2(4000 CHAR); 
    V_SQL_3 VARCHAR2(4000 CHAR); 
    V_SQL_4 VARCHAR2(4000 CHAR); 
    V_SQL_5 VARCHAR2(4000 CHAR); 

    CURSOR TCURSOR IS 
      SELECT cnt.CNT_CONTRATO CNT_CONTRATO, rownum NUM_FILA FROM &esquema .CNT_CONTRATOS cnt
      WHERE cnt.CNT_ID NOT IN 
      (SELECT CNT_ID FROM PRC_CEX PC INNER JOIN cex_contratos_expediente CEX ON CEX.CEX_ID = PC.CEX_ID) 
      AND ROWNUM <= &num_asuntos;

BEGIN 

  DBMS_OUTPUT.PUT_LINE('***************************');
  DBMS_OUTPUT.PUT_LINE('     INSERCION INICIAL     ');
  DBMS_OUTPUT.PUT_LINE('***************************');

  VAR_TABLENAME := 'LIN_ASUNTOS_NUEVOS';
  V_SQL := 'delete from ' ||V_ESQUEMA|| '.' || VAR_TABLENAME;
  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO DE LA TABLA ' || V_ESQUEMA|| '.' || VAR_TABLENAME);

  V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE UPPER(TABLE_NAME) = ''LIN_ASUNTOS_NUEVOS'' and UPPER(OWNER) = UPPER(''&esquema'') and UPPER(column_name) = ''DD_TAS_CODIGO''';
  --DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LIN_ASUNTOS_NUEVOS... El campo DD_TAS_CODIGO ya existe en la tabla');
  ELSE
      V_SQL := 'alter table '||V_ESQUEMA||'.LIN_ASUNTOS_NUEVOS add(DD_TAS_CODIGO varchar2(10))';        
      --DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL; 
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LIN_ASUNTOS_NUEVOS... creado el campo DD_TAS_CODIGO');
  END IF;


  V_SQL := 'SELECT DD_TPO_ID FROM &esquema .DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO=''PCO''';
  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL INTO V_DD_TPO_ID;
  DBMS_OUTPUT.PUT_LINE('[INFO] Insercion de filas en LIN_ASUNTOS_NUEVOS, tipo de procedimiento: ' || V_DD_TPO_ID);
  V_SQL_CABECERA := 'INSERT INTO LIN_ASUNTOS_NUEVOS (N_CASO,CREADO,FECHA_ALTA,N_REFERENCIA,DESPACHO,LETRADO,GRUPO,TIPO_PROC,PROCURADOR,PLAZA,JUZGADO,PRINCIPAL,ID,VERSION,N_LOTE,LIN_ID,PRM_ID,DD_TAS_CODIGO) VALUES (''';
  V_SQL_1 := ''',''N'',SYSDATE,''';
  V_SQL_2 := ''',''14597'',''CM_GE_PCO'',null,''';
  V_SQL_3 := ''',''PROCURADOR'',''16626'',NULL,''';
  V_SQL_4 := '000000'',''';
  V_SQL_5 := ''', ''0'',NULL,NULL,NULL,''01'')' ;
  FOR FILA in TCURSOR LOOP
    V_SQL := V_SQL_CABECERA || FILA.CNT_CONTRATO || V_SQL_1 || FILA.NUM_FILA || V_SQL_2 || V_DD_TPO_ID || V_SQL_3 || FILA.NUM_FILA || V_SQL_4 || FILA.NUM_FILA || V_SQL_5;
    DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || ' :' || FILA.NUM_FILA || ': ' || sql%rowcount);
    EXECUTE IMMEDIATE V_SQL; 
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('***************************');
  DBMS_OUTPUT.PUT_LINE('COMIENZO DEL PRIMER  BLOQUE');
  DBMS_OUTPUT.PUT_LINE('***************************');

  V_SQL := q'[UPDATE &esquema .lin_asuntos_nuevos SET creado = 'S' WHERE creado = 'N'
AND n_caso IN (
  SELECT DISTINCT lin.n_caso FROM &esquema .cnt_contratos cnt 
    JOIN &esquema .lin_asuntos_nuevos lin ON cnt.cnt_contrato = lin.n_caso
    JOIN &esquema .cex_contratos_expediente cex ON cex.cnt_id = cnt.cnt_id
    JOIN &esquema .prc_cex ON prc_cex.cex_id = cex.cex_id
    JOIN &esquema .prc_procedimientos prc ON prc.prc_id = prc_cex.prc_id
    JOIN &esquema .asu_asuntos asu ON asu.asu_id = prc.asu_id
            WHERE prc.borrado = 0 AND cex.borrado = 0 AND asu.dd_eas_id NOT IN (
                            SELECT eas6.dd_eas_id
                              FROM &&master .dd_eas_estado_asuntos eas6
                              WHERE eas6.dd_eas_codigo IN ('05', '06')))]';
  --DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[SELECT COUNT(1) FROM ALL_TABLES WHERE UPPER(OWNER) = UPPER('&esquema') AND TABLE_NAME='LIN_ASUNTOS_PARA_CREAR']';
  --DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS = 1 THEN
    V_SQL := q'[DROP TABLE &esquema .lin_asuntos_para_crear]';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL; 
  END IF;

  V_SQL := q'[CREATE TABLE &esquema .lin_asuntos_para_crear AS SELECT tabla.*,
&esquema .s_cli_clientes.NEXTVAL AS cli_id,
&esquema .s_exp_expedientes.NEXTVAL AS exp_id,
&esquema .s_prc_procedimientos.NEXTVAL AS prc_id,
&esquema .s_asu_asuntos.NEXTVAL AS asu_id
FROM
(SELECT DISTINCT lin.n_caso, cnt.cnt_id, cpe.per_id, cnt.ofi_id,dd_tin_id, lin.DD_TAS_CODIGO
FROM &esquema .lin_asuntos_nuevos lin
JOIN &esquema .cnt_contratos cnt ON lin.n_caso=cnt.cnt_contrato
JOIN &esquema .cpe_contratos_personas cpe ON cpe.cnt_id=cnt.cnt_id 
AND dd_tin_id in (SELECT dd_tin_id FROM &esquema .dd_tin_tipo_intervencion WHERE (dd_tin_codigo = 1 or dd_tin_codigo = 2))
WHERE lin.creado='N') tabla
  ]';
  --DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .cli_clientes (cli_id, per_id, arq_id, dd_est_id, dd_ecl_id, cli_fecha_est_id,
             VERSION, usuariocrear, fechacrear, borrado, cli_fecha_creacion,
             cli_telecobro, ofi_id)
   (SELECT apc.cli_id, apc.per_id, 421 AS arq_id,
           1 AS dd_est_id, 3 AS dd_ecl_id, SYSDATE, 0 AS VERSION,
           'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear, 1 AS borrado,
           SYSDATE AS cli_fecha_creacion, 0 AS cli_telecobro, apc.ofi_id
      FROM &esquema .lin_asuntos_para_crear apc)
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);


  V_SQL := q'[INSERT INTO &esquema .ccl_contratos_cliente (ccl_id, cnt_id, cli_id, ccl_pase, VERSION, usuariocrear, fechacrear, borrado)
(SELECT &esquema .s_ccl_contratos_cliente.NEXTVAL AS ccl_id, apc.cnt_id AS cnt_id,
     apc.cli_id AS cli_id, 1 AS ccl_pase, 0 AS VERSION,
     'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear, 0 AS borrado
  FROM &esquema .lin_asuntos_para_crear apc)]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .exp_expedientes (exp_id, dd_est_id, exp_fecha_est_id, ofi_id, arq_id, VERSION,
             usuariocrear, fechacrear, borrado, dd_eex_id, exp_descripcion)
   (SELECT apc.exp_id, 5 AS dd_est_id, SYSDATE AS exp_fecha_est_id,
           apc.ofi_id AS ofi_id, 421 AS arq_id,
           0 AS VERSION, 'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear,
           0 AS borrado, 4 AS dd_eex_id,
           apc.n_caso || '-'
           || (SELECT MAX (per_nom50)
                 FROM &esquema .per_personas
                WHERE per_id = apc.per_id) AS exp_descripcion
      FROM &esquema .lin_asuntos_para_crear apc)
]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .cex_contratos_expediente (cex_id, cnt_id, exp_id, cex_pase, cex_sin_actuacion, VERSION,
             usuariocrear, fechacrear, borrado, dd_aex_id)
   (SELECT &esquema .s_cex_contratos_expediente.NEXTVAL AS cex_id, apc.cnt_id AS cnt_id,
           apc.exp_id AS exp_id, 1 AS cex_pase, 0 AS cex_sin_actuacion,
           0 AS VERSION, 'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear,
           0 AS borrado, 9 AS dd_aex_id
      FROM &esquema .lin_asuntos_para_crear apc)  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .pex_personas_expediente (pex_id, per_id, exp_id, dd_aex_id, pex_pase, VERSION,
             usuariocrear, fechacrear, borrado)
   (SELECT &esquema .s_pex_personas_expediente.NEXTVAL AS pex_id, apc.per_id AS per_id,
           apc.exp_id AS exp_id, 9 AS dd_aex_id, 1 AS pex_pase, 0 AS VERSION,
           'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear, 0 AS borrado
      FROM &esquema .lin_asuntos_para_crear apc)
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .asu_asuntos (asu_id, dd_est_id, asu_fecha_est_id, asu_nombre, exp_id, VERSION,
             usuariocrear, fechacrear, borrado, dd_eas_id, dtype, lote, dd_tas_id, DD_PAS_ID)
   (SELECT apc.asu_id AS asu_id, 6 AS dd_est_id, SYSDATE AS asu_fecha_est_id,
           SUBSTR (apc.n_caso || '-' || (SELECT MAX (per_nom50)
                                           FROM &esquema .per_personas
                                          WHERE per_id = apc.per_id),
                   0,
                   50
                  ) AS asu_nombre,
           apc.exp_id AS exp_id, 0 AS VERSION, 'CARGA_PCO' AS usuariocrear,
           SYSDATE AS fechacrear, 0 AS borrado, 3 AS dd_eas_id,
           'EXTAsunto' AS dtype,
           (SELECT n_lote
              FROM &esquema .lin_asuntos_nuevos
             WHERE n_caso = apc.n_caso AND creado = 'N') AS lote, (select dd_tas_id from &master .dd_tas_tipos_asunto where dd_tas_codigo = apc.DD_TAS_CODIGO) AS DD_TAS_ID,
             (select DD_PAS_ID from &esquema .dd_pas_propiedad_asunto where dd_pas_codigo = 'CAJAMAR') AS DD_PAS_ID
      FROM &esquema .lin_asuntos_para_crear apc)
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .prc_procedimientos (prc_id, asu_id, dd_tac_id, dd_tre_id, dd_tpo_id,
             prc_porcentaje_recuperacion, prc_plazo_recuperacion,
             prc_saldo_original_vencido, prc_saldo_original_no_vencido,
             prc_saldo_recuperacion, dd_juz_id, VERSION, usuariocrear,
             fechacrear, borrado, dd_epr_id, dtype)
   (SELECT apc.prc_id AS prc_id, apc.asu_id AS asu_id,
           (SELECT dd_tac_id
              FROM &esquema .dd_tpo_tipo_procedimiento
             WHERE dd_tpo_id =
                      (SELECT tipo_proc
                         FROM &esquema .lin_asuntos_nuevos
                        WHERE n_caso = apc.n_caso
                          AND creado = 'N')) AS dd_tac_id,
           1 AS dd_tre_id,
           (SELECT tipo_proc
              FROM &esquema .lin_asuntos_nuevos
             WHERE n_caso = apc.n_caso AND creado = 'N') AS dd_tpo_id,
           100 AS prc_porcentaje_recuperacion, 30 AS prc_plazo_recuperacion,
           (SELECT SUM (mov_pos_viva_vencida + mov_pos_viva_no_vencida)
              FROM &esquema .cpe_contratos_personas cpe 
                  JOIN &esquema .mov_movimientos mov ON mov.cnt_id = cpe.cnt_id
             WHERE mov_fichero_carga =
                      (SELECT *
                         FROM (SELECT DISTINCT (mov_fichero_carga)
                                          FROM &esquema .mov_movimientos
                                      ORDER BY mov_fichero_carga DESC)
                        WHERE ROWNUM <= 1)
               AND per_id = apc.per_id) AS prc_saldo_original_vencido,
           0 AS prc_saldo_original_no_vencido,
           (SELECT principal
              FROM &esquema .lin_asuntos_nuevos
             WHERE n_caso = apc.n_caso
               AND creado = 'N') AS prc_saldo_recuperacion,
           (SELECT juzgado
              FROM &esquema .lin_asuntos_nuevos
             WHERE n_caso = apc.n_caso AND creado = 'N') AS dd_juz_id,
           0 AS VERSION, 'CARGA_PCO' AS usuariocrear, SYSDATE AS fechacrear,
           0 AS borrado, 3 AS dd_epr_id, 'MEJProcedimiento' AS dtype
      FROM &esquema .lin_asuntos_para_crear apc)
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .prc_per (prc_id, per_id, VERSION) (SELECT apc.prc_id, apc.per_id, 0 AS VERSION
      FROM &esquema .lin_asuntos_para_crear apc)
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .prc_cex (prc_id, cex_id, VERSION) (SELECT apc.prc_id, (SELECT distinct cex_id
              FROM &esquema .cex_contratos_expediente
             WHERE fechacrear > SYSDATE - 1 AND cnt_id = apc.cnt_id and rownum=1) AS cex_id,
           0 AS VERSION
      FROM &esquema .lin_asuntos_para_crear apc)
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .prc_per (prc_id, per_id, VERSION)  select * from (SELECT DISTINCT (SELECT MAX (prc_id)
                      FROM &esquema .prc_cex JOIN &esquema .cex_contratos_expediente cex
                           ON prc_cex.cex_id = cex.cex_id
                     WHERE cnt_id = a.cnt_id) AS prc_id, a.per_id,
                   0 AS VERSION
              FROM (SELECT DISTINCT per_id, cnt_id
                               FROM &esquema .cpe_contratos_personas
                              WHERE cnt_id IN (SELECT cnt_id
                                                 FROM &esquema .cex_contratos_expediente)
                    MINUS
                    SELECT prc_per.per_id, cnt.cnt_id
                      FROM &esquema .prc_per JOIN &esquema .prc_cex
                           ON prc_per.prc_id = prc_cex.prc_id
                           JOIN &esquema .cex_contratos_expediente cex
                           ON cex.cex_id = prc_cex.cex_id
                           JOIN &esquema .cnt_contratos cnt ON cex.cnt_id = cnt.cnt_id
                           ) a) where prc_id is not null
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[SELECT COUNT(1) FROM ALL_TABLES WHERE UPPER(OWNER) = UPPER('&esquema') AND TABLE_NAME='TMP_UGASPFS_BPM_INPUT_CON1']';
  --DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS = 1 THEN
    V_SQL := q'[DROP TABLE &esquema .TMP_UGASPFS_BPM_INPUT_CON1]';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL; 
  END IF;

  V_SQL := q'[CREATE TABLE &esquema .tmp_ugaspfs_bpm_input_con1 AS SELECT prc_id,
(select tap_id from &esquema .tap_tarea_procedimiento tap where tap.tap_codigo='PCO_RevisarExpedientePreparar') AS tap_id
FROM lin_asuntos_para_crear apc
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT &esquema .S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL, asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID, 
    &master .dd_tge_tipo_gestor.DD_TGE_ID ,0, 'CARGA_PCO', SYSDATE, 0 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.supervisor'
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID 
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'SUP_PCO' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAA_GESTOR_ADICIONAL_ASUNTO gaa 
            WHERE gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'SUP_PCO'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
SELECT &esquema .s_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL ,asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID ,sysdate, &master .dd_tge_tipo_gestor.DD_TGE_ID ,'CARGA_PCO', SYSDATE 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id 
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.supervisor' 
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID  AND USD_GESTOR_DEFECTO=1
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'SUP_PCO' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gaa 
            WHERE gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'SUP_PCO'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT &esquema .S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL, asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID, 
    &master .dd_tge_tipo_gestor.DD_TGE_ID ,0, 'CARGA_PCO', SYSDATE, 0 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.GestoriaPredoc'
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID 
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'GESTORIA_PREDOC' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAA_GESTOR_ADICIONAL_ASUNTO gaa 
            WHERE gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'GESTORIA_PREDOC'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
SELECT &esquema .s_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL ,asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID ,sysdate, &master .dd_tge_tipo_gestor.DD_TGE_ID ,'CARGA_PCO', SYSDATE 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id 
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.GestoriaPredoc' 
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID  AND USD_GESTOR_DEFECTO=1
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'GESTORIA_PREDOC' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gaa 
            WHERE gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'GESTORIA_PREDOC'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT &esquema .S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL, asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID, 
    &master .dd_tge_tipo_gestor.DD_TGE_ID ,0, 'CARGA_PCO', SYSDATE, 0 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.gestliquidaciones'
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID 
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'CM_GL_PCO' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAA_GESTOR_ADICIONAL_ASUNTO gaa 
            WHERE gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'CM_GL_PCO'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
SELECT &esquema .s_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL ,asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID ,sysdate, &master .dd_tge_tipo_gestor.DD_TGE_ID ,'CARGA_PCO', SYSDATE 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id 
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.gestliquidaciones' 
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID  AND USD_GESTOR_DEFECTO=1
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'CM_GL_PCO' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gaa 
            WHERE gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'CM_GL_PCO'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT &esquema .S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL, asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID, 
    &master .dd_tge_tipo_gestor.DD_TGE_ID ,0, 'CARGA_PCO', SYSDATE, 0 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.gestdocumentacion'
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID 
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'CM_GD_PCO' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAA_GESTOR_ADICIONAL_ASUNTO gaa 
            WHERE gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'CM_GD_PCO'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
SELECT &esquema .s_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL ,asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID ,sysdate, &master .dd_tge_tipo_gestor.DD_TGE_ID ,'CARGA_PCO', SYSDATE 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id 
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.gestdocumentacion' 
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID  AND USD_GESTOR_DEFECTO=1
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'CM_GD_PCO' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gaa 
            WHERE gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'CM_GD_PCO'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT &esquema .S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL, asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID, 
    &master .dd_tge_tipo_gestor.DD_TGE_ID ,0, 'CARGA_PCO', SYSDATE, 0 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.gestestudio'
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID 
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'CM_GE_PCO' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAA_GESTOR_ADICIONAL_ASUNTO gaa 
            WHERE gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'CM_GE_PCO'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[INSERT INTO &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
SELECT &esquema .s_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL ,asu.ASU_ID ,USD_USUARIOS_DESPACHOS.USD_ID ,sysdate, &master .dd_tge_tipo_gestor.DD_TGE_ID ,'CARGA_PCO', SYSDATE 
  FROM &esquema .ASU_ASUNTOS asu 
    INNER JOIN &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id 
    INNER JOIN &master .USU_USUARIOS ON USU_USUARIOS.USU_USERNAME='val.gestestudio' 
    INNER JOIN &esquema .usd_usuarios_despachos ON USU_USUARIOS.USU_ID=USD_USUARIOS_DESPACHOS.USU_ID  AND USD_GESTOR_DEFECTO=1
    INNER JOIN &master .dd_tge_tipo_gestor ON dd_tge_codigo = 'CM_GE_PCO' 
  WHERE NOT EXISTS (SELECT 1 FROM &esquema .GAH_GESTOR_ADICIONAL_HISTORICO gaa 
            WHERE gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
              (SELECT dd_tge_id FROM &master .dd_tge_tipo_gestor WHERE dd_tge_codigo = 'CM_GE_PCO'))
  ]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  V_SQL := q'[UPDATE &esquema .lin_asuntos_nuevos SET creado = 'S' WHERE creado = 'N'
   AND n_caso IN (
          SELECT DISTINCT lin.n_caso
                     FROM &esquema .cnt_contratos cnt JOIN &esquema .lin_asuntos_nuevos lin
                          ON cnt.cnt_contrato = lin.n_caso
                          JOIN &esquema .cex_contratos_expediente cex
                          ON cex.cnt_id = cnt.cnt_id
                          JOIN &esquema .prc_cex ON prc_cex.cex_id = cex.cex_id
                          JOIN &esquema .prc_procedimientos prc
                          ON prc.prc_id = prc_cex.prc_id
                          JOIN &esquema .asu_asuntos asu ON asu.asu_id = prc.asu_id
                    WHERE prc.borrado = 0
                      AND cex.borrado = 0
                      AND asu.dd_eas_id NOT IN (
                                    SELECT eas6.dd_eas_id
                                      FROM &master .dd_eas_estado_asuntos eas6
                                     WHERE eas6.dd_eas_codigo IN ('05', '06')))]';
--  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL; 
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  DBMS_OUTPUT.PUT_LINE('***************************');
  DBMS_OUTPUT.PUT_LINE('COMIENZO DEL SEGUNDO BLOQUE');
  DBMS_OUTPUT.PUT_LINE('***************************');

  V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE UPPER(TABLE_NAME) = ''TMP_UGASPFS_BPM_INPUT_CON1'' and UPPER(OWNER) = UPPER(''&esquema'') and UPPER(column_name) = ''T_REFERENCIA''';
  DBMS_OUTPUT.PUT_LINE(V_SQL);
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_UGASPFS_BPM_INPUT_CON1... El campo T_REFERENCIA ya existe en la tabla');
  ELSE
      V_SQL := 'alter table '||V_ESQUEMA||'.TMP_UGASPFS_BPM_INPUT_CON1 add (T_REFERENCIA NUMBER(16))';        
      --DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL; 
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_UGASPFS_BPM_INPUT_CON1... creado el campo T_REFERENCIA');
  END IF;

V_SQL := q'[UPDATE &esquema .tar_tareas_notificaciones SET t_referencia = NULL WHERE t_referencia IS NOT NULL]';
----DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &esquema .tex_tarea_externa SET t_referencia = NULL WHERE t_referencia IS NOT NULL]';
----DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &master .jbpm_token SET t_referencia = NULL WHERE t_referencia IS NOT NULL]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &master .jbpm_processinstance SET t_referencia = NULL WHERE t_referencia IS NOT NULL]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &esquema .tmp_ugaspfs_bpm_input_con1 SET t_referencia = ROWNUM]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &esquema .tar_tareas_notificaciones (tar_id, asu_id, dd_est_id, dd_ein_id, dd_sta_id, tar_codigo,
             tar_tarea, tar_descripcion, tar_fecha_fin, tar_fecha_ini,
             tar_en_espera, tar_alerta, tar_tarea_finalizada, tar_emisor,
             VERSION, usuariocrear, fechacrear, borrado, prc_id, dtype,
             nfa_tar_revisada, t_referencia)
   SELECT &esquema .s_tar_tareas_notificaciones.NEXTVAL tar_id, prc.asu_id, 6 dd_est_id,
          5 dd_ein_id, NVL(tap.dd_sta_id,39) dd_sta_id, 1 tar_codigo,
          tap.tap_descripcion tar_tarea, tap.tap_descripcion tar_descripcion,
          NULL tar_fecha_fin, SYSDATE tar_fecha_ini, 0 tar_en_espera,
          0 tar_alerta, NULL tar_tarea_finalizada, 'AUTOMATICA' tar_emisor, 0,
          'CARGA_PCO', SYSDATE, 0, prc.prc_id, 'EXTTareaNotificacion' dtype,
          0 nfa_tar_revisada, tmp.t_referencia
     FROM &esquema .tmp_ugaspfs_bpm_input_con1 tmp JOIN &esquema .tap_tarea_procedimiento tap
          ON tmp.tap_id = tap.tap_id
          JOIN &esquema .prc_procedimientos prc ON tmp.prc_id = prc.prc_id
]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &esquema .tex_tarea_externa (tex_id, tar_id, tap_id, tex_token_id_bpm, tex_detenida, VERSION,
             usuariocrear, fechacrear, borrado, dtype, t_referencia)
   SELECT &esquema .s_tex_tarea_externa.NEXTVAL, tar.tar_id, tmp.tap_id, NULL, 0, 0,
          'CARGA_PCO', SYSDATE, 0, 'EXTTareaExterna', tmp.t_referencia
     FROM &esquema .tmp_ugaspfs_bpm_input_con1 tmp JOIN &esquema .tar_tareas_notificaciones tar
          ON tmp.t_referencia = tar.t_referencia]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_processinstance (id_, version_, start_, end_, issuspended_, processdefinition_,
             t_referencia)
   SELECT &master .hibernate_sequence.NEXTVAL, 1 version_, SYSDATE start_,
          NULL end_, 0 issuspended_, maxpd.id_ processdefinition_,
          tmp.t_referencia
     FROM &esquema .tmp_ugaspfs_bpm_input_con1 tmp
                                        --JOIN &esquema .prc_procedimientos prc on tmp.prc_id = prc.prc_id
          JOIN &esquema .tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
          JOIN &esquema .dd_tpo_tipo_procedimiento tpo ON tap.dd_tpo_id = tpo.dd_tpo_id
          JOIN &esquema .tar_tareas_notificaciones tar
          ON tmp.t_referencia = tar.t_referencia
          JOIN
          (SELECT   name_, MAX (id_) id_
               FROM &master .jbpm_processdefinition
           GROUP BY name_) maxpd ON tpo.dd_tpo_xml_jbpm = maxpd.name_]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[MERGE INTO &esquema .prc_procedimientos t1 USING (SELECT prc.prc_id, prc.prc_process_bpm viejo, pi.id_ nuevo
            FROM &esquema .prc_procedimientos prc
            JOIN &esquema .tmp_ugaspfs_bpm_input_con1 tmp ON prc.prc_id = tmp.prc_id
            JOIN &master .jbpm_processinstance pi ON tmp.t_referencia = pi.t_referencia ) q
   ON (t1.prc_id = q.prc_id)
   WHEN MATCHED THEN
      UPDATE SET t1.prc_process_bpm = q.nuevo]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[MERGE INTO &esquema .prc_procedimientos t1 USING (SELECT prc.prc_id, prc.dd_tpo_id viejo, tap.dd_tpo_id nuevo
            FROM &esquema .prc_procedimientos prc
            JOIN &esquema .tmp_ugaspfs_bpm_input_con1 tmp ON prc.prc_id = tmp.prc_id
            JOIN &esquema .tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id ) q
   ON (t1.prc_id = q.prc_id)
   WHEN MATCHED THEN
      UPDATE
         SET t1.dd_tpo_id = q.nuevo]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_token (id_, version_, start_, end_, nodeenter_, issuspended_, node_, processinstance_, t_referencia)
   SELECT &master .hibernate_sequence.NEXTVAL, 1 version_, SYSDATE start_,
          NULL end_, SYSDATE nodeenter_, 0 issuspended_, node.id_ node_,
          pi.id_ processinstance_, tmp.t_referencia
     FROM &esquema .tmp_ugaspfs_bpm_input_con1 tmp JOIN &esquema .tar_tareas_notificaciones tar
          ON tmp.t_referencia = tar.t_referencia
          JOIN &esquema .tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
          JOIN &esquema .prc_procedimientos prc ON tmp.prc_id = prc.prc_id
          JOIN &esquema .dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
          JOIN
          (SELECT   name_, MAX (id_) id_
               FROM &master .jbpm_processdefinition
           GROUP BY name_) maxpd ON tpo.dd_tpo_xml_jbpm = maxpd.name_
          JOIN &master .jbpm_node node ON maxpd.id_ = node.processdefinition_ AND tap.tap_codigo = node.name_
          JOIN &master .jbpm_processinstance pi ON tmp.t_referencia = pi.t_referencia]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[MERGE INTO &master .jbpm_processinstance t1 USING (SELECT pi.ID_, pi.roottoken_ viejo, tk.id_ nuevo
          FROM &master .jbpm_processinstance pi 
          JOIN &master .jbpm_token tk ON pi.t_referencia = tk.t_referencia
          ) q
    ON (t1.ID_ = q.ID_)
   WHEN MATCHED THEN
      UPDATE
         SET t1.roottoken_ = q.nuevo]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[merge into &esquema .tex_tarea_externa t1 using (SELECT tex.tex_id, tex.tex_token_id_bpm viejo, tk.id_ nuevo
                           FROM &esquema .tex_tarea_externa tex 
                           JOIN &master .jbpm_token tk ON tex.t_referencia = tk.t_referencia) q
                            on (t1.tex_id = q.tex_id)
                            when matched then
                            update
                            set t1.tex_token_id_bpm = q.nuevo ]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_moduleinstance (id_, class_, version_, processinstance_, name_)
   SELECT &master .hibernate_sequence.NEXTVAL, 'C' class_, 0 version_,
          prc.prc_process_bpm processinstance_,
          'org.jbpm.context.exe.ContextInstance' name_
     FROM &esquema .prc_procedimientos prc 
      JOIN &master .jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
      JOIN &master .jbpm_token tk ON pi.roottoken_ = tk.id_
      JOIN &master .jbpm_node nd ON tk.node_ = nd.id_
      JOIN &esquema .tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
      JOIN &esquema .tmp_ugaspfs_bpm_input_con1 ug ON ug.prc_id = prc.prc_id
    WHERE NOT EXISTS (SELECT *
                        FROM &master .jbpm_moduleinstance
                       WHERE processinstance_ = prc.prc_process_bpm)]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_tokenvariablemap (id_, version_, token_, contextinstance_)
   SELECT &master .hibernate_sequence.NEXTVAL, 0 version_, pi.roottoken_,
          mi.id_ contextinstance_
     FROM &esquema .prc_procedimientos prc 
     JOIN &master .jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
     JOIN &master .jbpm_moduleinstance mi ON pi.id_ = mi.processinstance_
     JOIN &master .jbpm_token tk ON pi.roottoken_ = tk.id_
     JOIN &master .jbpm_node nd ON tk.node_ = nd.id_
     JOIN &esquema .tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (SELECT *
                        FROM &master .jbpm_tokenvariablemap
                       WHERE token_ = pi.roottoken_)]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_variableinstance (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, longvalue_)
   SELECT &master .hibernate_sequence.NEXTVAL, 'L' class_, 0 version_,
          'DB_ID' name_, pi.roottoken_ tokem_, vm.id_ tokenvariablemap_,
          pi.id_ processinstance_, 1 longvlaue_
     FROM &esquema .prc_procedimientos prc 
      JOIN &master .jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
      JOIN &master .jbpm_tokenvariablemap vm ON pi.roottoken_ = vm.token_
      JOIN &master .jbpm_token tk ON pi.roottoken_ = tk.id_
      JOIN &master .jbpm_node nd ON tk.node_ = nd.id_
      JOIN &esquema .tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (SELECT *
                        FROM &master .jbpm_variableinstance
                       WHERE processinstance_ = pi.id_ AND name_ = 'DB_ID')]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_variableinstance (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, longvalue_)
   SELECT &master .hibernate_sequence.NEXTVAL, 'L' class_, 0 version_,
          'procedimientoTareaExterna' name_, pi.roottoken_ tokem_,
          vm.id_ tokenvariablemap_, pi.id_ processinstance_,
          prc.prc_id longvlaue_
     FROM &esquema .prc_procedimientos prc 
        JOIN &master .jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
          JOIN &master .jbpm_tokenvariablemap vm ON pi.roottoken_ = vm.token_
          JOIN &master .jbpm_token tk ON pi.roottoken_ = tk.id_
          JOIN &master .jbpm_node nd ON tk.node_ = nd.id_
          JOIN &esquema .tex_tarea_externa tex
          ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (
             SELECT *
               FROM &master .jbpm_variableinstance
              WHERE processinstance_ = pi.id_
                AND name_ = 'procedimientoTareaExterna')]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_variableinstance (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, longvalue_)
   SELECT &master .hibernate_sequence.NEXTVAL, 'L' class_, 0 version_,
          'bpmParalizado' name_, pi.roottoken_ tokem_,
          vm.id_ tokenvariablemap_, pi.id_ processinstance_, 0 longvlaue_
     FROM &esquema .prc_procedimientos prc 
     JOIN &master .jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
     JOIN &master .jbpm_tokenvariablemap vm ON pi.roottoken_ = vm.token_
     JOIN &master .jbpm_token tk ON pi.roottoken_ = tk.id_
     JOIN &master .jbpm_node nd ON tk.node_ = nd.id_
     JOIN &esquema .tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (
                   SELECT *
                     FROM &master .jbpm_variableinstance
                    WHERE processinstance_ = pi.id_
                          AND name_ = 'bpmParalizado')]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_variableinstance (id_, class_, version_, name_, token_, tokenvariablemap_,
             processinstance_, longvalue_)
   SELECT &master .hibernate_sequence.NEXTVAL, 'L' class_, 0 version_,
          'id' || nd.name_ name_, pi.roottoken_ tokem_,
          vm.id_ tokenvariablemap_, pi.id_ processinstance_,
          tex.tex_id longvlaue_
     FROM &esquema .prc_procedimientos prc 
      JOIN &esquema .tmp_ugaspfs_bpm_input_con1 tmp ON prc.prc_id = tmp.prc_id
      JOIN &master .jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
      JOIN &master .jbpm_token tk ON pi.roottoken_ = tk.id_
      JOIN &master .jbpm_node nd ON tk.node_ = nd.id_
      JOIN &master .jbpm_tokenvariablemap vm ON pi.roottoken_ = vm.token_
      JOIN &esquema .tex_tarea_externa tex ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
    WHERE NOT EXISTS (
                  SELECT *
                    FROM &master .jbpm_variableinstance
                   WHERE processinstance_ = pi.id_
                         AND name_ = 'id' || nd.name_)
      AND tex.usuariocrear = 'CARGA_PCO']';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &master .jbpm_token SET nextlogindex_ = 0 WHERE nextlogindex_ IS NULL]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &master .jbpm_token SET isabletoreactivateparent_ = 0 WHERE isabletoreactivateparent_ IS NULL]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &master .jbpm_token SET isterminationimplicit_ = 0 WHERE isterminationimplicit_ IS NULL]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &master .jbpm_transition (id_, name_, processdefinition_, from_, to_, fromindex_)
   SELECT &master .hibernate_sequence.NEXTVAL id_, 'activarProrroga' name_,
          pd processdefinition_, nd from_, nd to_,
          (max_fromindex + 1) fromindex_
     FROM (SELECT   nd.id_ nd, nd.processdefinition_ pd,
                    MAX (aux.fromindex_) max_fromindex
               FROM &esquema .tar_tareas_notificaciones tar JOIN &esquema .tex_tarea_externa tex
                    ON tar.tar_id = tex.tar_id
                    JOIN &esquema .tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
                    JOIN &esquema .prc_procedimientos prc ON tar.prc_id = prc.prc_id
                    JOIN &master .jbpm_processinstance pi ON prc.prc_process_bpm = pi.id_
                    JOIN &master .jbpm_token tk ON pi.roottoken_ = tk.id_
                    JOIN &master .jbpm_node nd ON tk.node_ = nd.id_
                    JOIN &esquema .tmp_ugaspfs_bpm_input_con1 ug ON prc.prc_id = ug.prc_id
                    LEFT JOIN &master .jbpm_transition aux ON nd.id_ = aux.from_
                    LEFT JOIN &master .jbpm_transition tr ON nd.id_ = tr.from_ AND tr.name_ = 'activarProrroga'
              WHERE tar.borrado = 0
                AND (   tar.tar_tarea_finalizada IS NULL
                     OR tar.tar_tarea_finalizada = 0
                    )
                AND tar.prc_id IS NOT NULL
                AND tap.tap_autoprorroga = 1
                AND tr.id_ IS NULL
           GROUP BY nd.id_, nd.processdefinition_)]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);



V_SQL := q'[UPDATE &esquema .tar_tareas_notificaciones SET tar_fecha_venc = SYSDATE + (DBMS_RANDOM.VALUE (1, 5)) WHERE fechacrear > SYSDATE - 0.1 AND tar_fecha_venc IS NULL
   AND prc_id IS NOT NULL AND tar_tarea_finalizada IS NULL AND tar_tar_id IS NULL]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &esquema .tar_tareas_notificaciones SET tar_fecha_venc_real = tar_fecha_venc WHERE tar_fecha_venc IS NOT NULL AND tar_fecha_venc_real IS NULL]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  DBMS_OUTPUT.PUT_LINE('***************************');
  DBMS_OUTPUT.PUT_LINE('COMIENZO DEL TERCER  BLOQUE');
  DBMS_OUTPUT.PUT_LINE('***************************');

V_SQL := q'[INSERT INTO &esquema .PCO_PRC_PROCEDIMIENTOS (PCO_PRC_ID, PRC_ID, PCO_PRC_TIPO_PRC_PROP, PCO_PRC_TIPO_PRC_INICIADO, PCO_PRC_PRETURNADO, 
    PCO_PRC_NUM_EXP_EXT, PCO_PRC_NOM_EXP_JUD, PCO_PRC_CNT_PRINCIPAL, PCO_PRC_NUM_EXP_INT, DD_PCO_PTP_ID, 
    USUARIOCREAR, FECHACREAR)
SELECT &esquema .S_PCO_PRC_PROCEDIMIENTOS.NEXTVAL, PRC.PRC_ID, (SELECT DD_TPO_ID FROM &esquema .DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = 'H001'), null, 1, 
    lin.n_caso, prc.prc_cod_proc_en_juzgado, null, null, TPR.DD_PCO_PTP_ID,
    'CARGA_PCO', SYSDATE
  FROM &esquema .PRC_PROCEDIMIENTOS prc 
  inner join &esquema .asu_asuntos asu on asu.asu_id=prc.asu_id
  inner join &esquema .lin_asuntos_para_crear lin on lin.asu_id=asu.asu_id
  inner join &master .dd_tas_tipos_asunto tas on tas.dd_tas_id=asu.dd_tas_id
  LEFT JOIN &esquema .DD_PCO_PRC_TIPO_PREPARACION TPR ON TPR.DD_PCO_PTP_CODIGO='SE'
  inner join &esquema .dd_tpo_tipo_procedimiento tpo on prc.dd_tpo_id= tpo.dd_tpo_id
  where tas.dd_tas_codigo='01'
  and prc.prc_id not in (select pco.prc_id from &esquema .pco_prc_procedimientos pco)
  and tpo.dd_tpo_codigo='PCO']';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &esquema .PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, USUARIOCREAR, FECHACREAR)
SELECT &esquema .S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, PCO.PCO_PRC_ID, PEP.DD_PCO_PEP_ID, SYSDATE, 
    'CARGA_PCO', SYSDATE
  FROM &esquema .PRC_PROCEDIMIENTOS prc 
  inner join &esquema .pco_prc_procedimientos pco on pco.prc_id=prc.prc_id
  inner join &esquema .asu_asuntos asu on asu.asu_id=prc.asu_id
  inner join &master .dd_tas_tipos_asunto tas on tas.dd_tas_id=asu.dd_tas_id
  INNER JOIN &esquema .DD_PCO_PRC_ESTADO_PREPARACION PEP ON PEP.DD_PCO_PEP_CODIGO = 'PT'
  where tas.dd_tas_codigo='01' and 
    NOT EXISTS (SELECT 1 FROM &esquema .PCO_PRC_HEP_HISTOR_EST_PREP HIST WHERE HIST.pco_prc_id= pco.pco_prc_id)]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

/*
V_SQL := q'[INSERT INTO &esquema .PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, USUARIOCREAR, FECHACREAR)
SELECT &esquema .S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, PCO.PCO_PRC_ID, PEP.DD_PCO_PEP_ID, SYSDATE,
    'CARGA_PCO', SYSDATE
  FROM &esquema .PRC_PROCEDIMIENTOS prc 
  inner join &esquema .pco_prc_procedimientos pco on pco.prc_id=prc.prc_id
  inner join &esquema .asu_asuntos asu on asu.asu_id=prc.asu_id
  inner join &master .dd_tas_tipos_asunto tas on tas.dd_tas_id=asu.dd_tas_id
  INNER JOIN &esquema .DD_PCO_PRC_ESTADO_PREPARACION PEP ON PEP.DD_PCO_PEP_CODIGO = 'PR'
  where tas.dd_tas_codigo='01' and 
    NOT EXISTS (SELECT 1 FROM &esquema .PCO_PRC_HEP_HISTOR_EST_PREP HIST WHERE HIST.pco_prc_id= pco.pco_prc_id)]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);
*/

/*
--Anaydir las tareas especiales PCO_GenerarLiq
V_SQL := q'[INSERT INTO &esquema .TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
    TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_EMISOR, 
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA)
SELECT &esquema .S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL, null, PRC.ASU_ID, '6', '5', TAP.DD_STA_ID, '1', TAP.TAP_CODIGO, TAP.TAP_DESCRIPCION, 
    SYSDATE, '0', '0', 'AUTOMATICA', '0', 
    'CARGA_PCO', SYSDATE, '0', prc.PRC_ID, 'EXTTareaNotificacion', '0' 
  FROM &esquema .tmp_ugaspfs_bpm_input_con1 tmp 
    JOIN &esquema .prc_procedimientos prc ON tmp.prc_id = prc.prc_id
    JOIN &esquema .TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = 'PCO_GenerarLiq'
  WHERE NOT EXISTS (SELECT TAR.TAR_ID FROM &esquema .TAR_TAREAS_NOTIFICACIONES TAR WHERE TAR.TAR_CODIGO=TAP.TAP_CODIGO AND TAR.PRC_ID=PRC.PRC_ID)]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &esquema .tex_tarea_externa (tex_id, tar_id, tap_id, tex_token_id_bpm, tex_detenida, VERSION,
             usuariocrear, fechacrear, borrado, dtype)
   SELECT &esquema .s_tex_tarea_externa.NEXTVAL, tar.tar_id, tap.tap_id, NULL, 0, 0,'CARGA_PCO', SYSDATE, 0, 'EXTTareaExterna'
    FROM &esquema .tmp_ugaspfs_bpm_input_con1 tmp
    JOIN &esquema .prc_procedimientos prc ON tmp.prc_id = prc.prc_id
    JOIN &esquema .tar_tareas_notificaciones tar ON tar.prc_id = prc.prc_id
    JOIN &esquema .tap_tarea_procedimiento tap ON TAP.TAP_CODIGO = 'PCO_GenerarLiq'
    WHERE TAR.TAR_TAREA='PCO_GenerarLiq']';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

--Anaydir las tareas especiales PCO_SolicitarDoc
V_SQL := q'[INSERT INTO &esquema .TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
    TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_EMISOR, 
    VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA)
SELECT &esquema .S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL, null, PRC.ASU_ID, '6', '5', TAP.DD_STA_ID, '1', TAP.TAP_CODIGO, TAP.TAP_DESCRIPCION, 
    SYSDATE, '0', '0', 'AUTOMATICA', '0', 
    'CARGA_PCO', SYSDATE, '0', prc.PRC_ID, 'EXTTareaNotificacion', '0' 
  FROM &esquema .tmp_ugaspfs_bpm_input_con1 tmp 
    JOIN &esquema .prc_procedimientos prc ON tmp.prc_id = prc.prc_id
    JOIN &esquema .TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = 'PCO_SolicitarDoc'
  WHERE NOT EXISTS (SELECT TAR.TAR_ID FROM &esquema .TAR_TAREAS_NOTIFICACIONES TAR WHERE TAR.TAR_CODIGO=TAP.TAP_CODIGO AND TAR.PRC_ID=PRC.PRC_ID)]';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[INSERT INTO &esquema .tex_tarea_externa (tex_id, tar_id, tap_id, tex_token_id_bpm, tex_detenida, VERSION,
             usuariocrear, fechacrear, borrado, dtype)
   SELECT &esquema .s_tex_tarea_externa.NEXTVAL, tar.tar_id, tap.tap_id, NULL, 0, 0,'CARGA_PCO', SYSDATE, 0, 'EXTTareaExterna'
    FROM &esquema .tmp_ugaspfs_bpm_input_con1 tmp
    JOIN &esquema .prc_procedimientos prc ON tmp.prc_id = prc.prc_id
    JOIN &esquema .tar_tareas_notificaciones tar ON tar.prc_id = prc.prc_id
    JOIN &esquema .tap_tarea_procedimiento tap ON TAP.TAP_CODIGO = 'PCO_SolicitarDoc'
    WHERE TAR.TAR_TAREA='PCO_SolicitarDoc']';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &esquema .TAR_TAREAS_NOTIFICACIONES SET TAR_TAREA=(SELECT TAP_DESCRIPCION FROM &esquema .TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='PCO_GenerarLiq')
    WHERE TAR_TAREA='PCO_GenerarLiq']';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

V_SQL := q'[UPDATE &esquema .TAR_TAREAS_NOTIFICACIONES SET TAR_TAREA=(SELECT TAP_DESCRIPCION FROM &esquema .TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO='PCO_SolicitarDoc')
    WHERE TAR_TAREA='PCO_SolicitarDoc']';
--DBMS_OUTPUT.PUT_LINE(V_SQL);
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

*/

V_SQL := q'[update &esquema .asu_asuntos set dd_ges_id=(select dd_ges_id from  &esquema .dd_ges_gestion_asunto where dd_ges_codigo='HRE') WHERE usuariocrear='CARGA_PCO']';
EXECUTE IMMEDIATE V_SQL; 
DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);

  DBMS_OUTPUT.PUT_LINE('***************************');
  DBMS_OUTPUT.PUT_LINE('OBJETOS DE PRECONTENCIOSO  ');
  DBMS_OUTPUT.PUT_LINE('***************************');






  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] 99-CreacionAsuntosPco-Bankia.sql');    
   
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