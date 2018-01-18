--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3613
--## PRODUCTO=NO
--## Finalidad: Procedimiento que asigna Gestores de todos los tipos.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


create or replace PROCEDURE SP_AGA_ASIGNA_GESTOR_ACTIVO_V3 (
        V_USUARIO       VARCHAR2 DEFAULT 'SP_AGA_V3',
        PL_OUTPUT       OUT VARCHAR2,
        P_ACT_ID                IN #ESQUEMA#.act_activo.act_id%TYPE,
        P_ALL_ACTIVOS       IN NUMBER,
        P_CLASE_ACTIVO  IN VARCHAR2
)
AS
--v0.3

V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_NUM NUMBER(16);
v_count_1 NUMBER(16);
CODIGO_GESTOR VARCHAR2(15 CHAR);
V_CLASE_ACTIVO VARCHAR (500 CHAR);
V_TIPO_GESTOR_01 VARCHAR (500 CHAR) := '''GPUBL'',''SPUBL'',''GCOM'',''SCOM'',''FVDNEG'',''FVDBACKOFR'',''FVDBACKVNT'',''SUPFVD'',''SFORM''';
V_TIPO_GESTOR_02 VARCHAR (500 CHAR) := '''GADM'',''SUPADM'',''GACT'',''SUPACT'',''GPREC'',''SPREC'',''GPUBL'',''SPUBL'',''GCOM'',''SCOM'',''FVDNEG'',''FVDBACKOFR'',''FVDBACKVNT'',''SUPFVD'',''SFORM'',''GGADM'',''GIAFORM'',''GTOCED'',''CERT''';
V_TIPO_GESTOR_03 VARCHAR (500 CHAR);                

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A PROCEDER A CREAR LA RELACION DE ACTIVOS CON SU GESTOR.');


  DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBACIÓN DE TABLA TMP_GEST_ACT...');

  EXECUTE IMMEDIATE '
  SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME LIKE ''TMP_GEST_ACT'' AND OWNER LIKE '''||V_ESQUEMA||'''
  '
  INTO V_NUM
  ;

  IF V_NUM != 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO DE TMP_GEST_ACT...');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TMP_GEST_ACT';

  END IF;


  DBMS_OUTPUT.PUT_LINE('[INFO] CREACION DE TMP_GEST_ACT...');

  EXECUTE IMMEDIATE '
    CREATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT (
      ACT_ID                      NUMBER(16,0),
      USU_ID                      NUMBER(16,0),
      GEE_ID                      NUMBER(16,0),
      GEH_ID                      NUMBER(16,0),
      TIPO_GESTOR                 VARCHAR2(20 CHAR)
    )
  ';


IF P_CLASE_ACTIVO = '01' THEN
        V_TIPO_GESTOR_03 := V_TIPO_GESTOR_01;
        V_CLASE_ACTIVO :=  'LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                            LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
                                            WHERE SCR.DD_SCR_CODIGO = DECODE (CRA.DD_CRA_CODIGO, ''01'', ''01'',     ''02'', ''03'',     ''03'', ''05'',     ''04'', ''10'',     ''05'', ''12'', ''09'',''21'')';
ELSE
        V_TIPO_GESTOR_03 := V_TIPO_GESTOR_02;
        V_CLASE_ACTIVO := 'LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                           LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
                                           WHERE SCR.DD_SCR_CODIGO <> DECODE (CRA.DD_CRA_CODIGO, ''01'', ''01'',     ''02'', ''03'',     ''03'', ''05'',     ''04'', ''10'',     ''05'', ''12'', ''09'',''21'')';
END IF;

--------------------------------------------------------------------
----------- ASIGNAMOS GESTORES ---------------------------
--------------------------------------------------------------------

        DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' TMP_GEST_ACT cargada. '||v_count_1||' Filas.');


        EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT';
                 
                 
        EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.TMP_GEST_ACT (
                            ACT_ID,
                            USU_ID,
                            GEE_ID,
                            GEH_ID,
                            TIPO_GESTOR
                          )
                          SELECT
                              ACT.ACT_ID,
                              USU.USU_ID,
                              '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL GEE_ID,
                              '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL GEH_ID,
                              GEST.TIPO_GESTOR
                              FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                              INNER JOIN '||V_ESQUEMA||'.V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR IN ('||V_TIPO_GESTOR_03||')
                              INNER JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
                              '||V_CLASE_ACTIVO||'
                              AND NOT EXISTS (
                              SELECT 1 FROM (  SELECT DISTINCT ACT.ACT_ID, GEH.GEH_ID, GEE.GEE_ID, TGE.DD_TGE_CODIGO
                                              FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                                              INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH  ON ACT.ACT_ID = GAH.ACT_ID
                                              INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC        ON GAC.ACT_ID = GAH.ACT_ID
                                              INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH      ON GEH.GEH_ID = GAH.GEH_ID
                                              INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE           ON GEE.GEE_ID = GAC.GEE_ID
                                              INNER JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE                 ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_ID = GEH.DD_TGE_ID
                                              '||V_CLASE_ACTIVO||'
                                              AND TGE.DD_TGE_CODIGO IN ('||V_TIPO_GESTOR_03||')
                                              AND GEE.BORRADO = 0 AND GEH.BORRADO = 0
                                              AND act.borrado = 0) TMP
                              WHERE TMP.ACT_ID = ACT.ACT_ID)
                                AND act.borrado = 0'
                               ;                 

         v_count_1 := SQL%ROWCOUNT;
         DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' TMP_GEST_ACT cargada. '||v_count_1||' Filas.');

         COMMIT;

         REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','TMP_GEST_ACT','10');

         DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_GEST_ACT ANALIZADA.');

         DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO LA TABLA GEE_GESTOR_ENTIDAD...');

                  EXECUTE IMMEDIATE '
                  INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD (
                  gee_id,
                  usu_id,
                  dd_tge_id,
                  VERSION,
                  usuariocrear,
                  fechacrear,
                  borrado
                  )
                  SELECT
                  TMP.gee_id,
                  TMP.usu_id,
                  TGE.dd_tge_id,
                  0,
                  '''||V_USUARIO||''',
                  SYSDATE,
                  0
                  FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
                  INNER JOIN '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor TGE ON TGE.dd_tge_codigo = TMP.TIPO_GESTOR
                  '
                  ;

                  v_count_1 := SQL%ROWCOUNT;
                  PL_OUTPUT := '[INFO] INSERTADOS '||v_count_1||' REGISTROS EN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD PARA GESTORES DEL ACTIVO. '||CHR(10);

                  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GEE_GESTOR_ENTIDAD cargada. '||v_count_1||' Filas.');


                  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO LA TABLA GAC_GESTOR_ADD_ACTIVO...');

                  EXECUTE IMMEDIATE '
                  INSERT INTO '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (
                  gee_id,
                  act_id
                  )
                  SELECT
                  TMP.gee_id,
                  TMP.act_id
                  FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
                  '
                  ;

                  v_count_1 := SQL%ROWCOUNT;
                  PL_OUTPUT := PL_OUTPUT||'[INFO] INSERTADOS '||v_count_1||' REGISTROS EN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO PARA GESTORES DEL ACTIVO. '||CHR(10);

                  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GAC_GESTOR_ADD_ACTIVO cargada. '||v_count_1||' Filas.');


                  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO LA TABLA GEH_GESTOR_ENTIDAD_HIST...');

                  EXECUTE IMMEDIATE '
                  INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (
                  geh_id,
                  usu_id,
                  dd_tge_id,
                  geh_fecha_desde,
                  geh_fecha_hasta,
                  VERSION,
                  usuariocrear,
                  fechacrear,
                  borrado
                  )
                  SELECT
                  tmp.geh_id,
                  tmp.usu_id,
                  tge.dd_tge_id,
                  sysdate as geh_fecha_desde,
                  NULL as geh_fecha_hasta,
                  1 as VERSION,
                  '''||V_USUARIO||''' as usuariocrear,
                  SYSDATE as fechacrear,
                  0 as borrado
                  FROM  '||V_ESQUEMA||'.TMP_GEST_ACT TMP
                  INNER JOIN '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor TGE ON TGE.dd_tge_codigo = TMP.TIPO_GESTOR
                  '
                  ;

                  v_count_1 := SQL%ROWCOUNT;

                  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GEH_GESTOR_ENTIDAD_HIST cargada. '||v_count_1||' Filas.');


                  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO LA TABLA GAH_GESTOR_ACTIVO_HISTORICO...');

                  EXECUTE IMMEDIATE '
                  INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO (
                  geh_id,
                  act_id
                  )
                  SELECT
                  TMP.geh_id,
                  TMP.act_id
                  FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
                  '
                  ;

                  v_count_1 := SQL%ROWCOUNT;

                  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GAH_GESTOR_ACTIVO_HISTORICO cargada. '||v_count_1||' Filas.');

                  COMMIT;

                  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Analizando tablas.');
                  
                  
                  REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','GEE_GESTOR_ENTIDAD','10');
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD.'); 

                  REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','GAC_GESTOR_ADD_ACTIVO','10');
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO.'); 

                  REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','GEH_GESTOR_ENTIDAD_HIST','10');
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST.');                  
                  
                  REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','GAH_GESTOR_ACTIVO_HISTORICO','10');
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO.');

  DBMS_OUTPUT.PUT_LINE('[OK] - PROCESO ASIGNACIÓN GESTORES DE ACTIVO FINALIZADO.');

EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;

END SP_AGA_ASIGNA_GESTOR_ACTIVO_V3;

/
EXIT;