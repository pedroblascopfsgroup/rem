--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20170510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1975
--## PRODUCTO=NO
--## Finalidad: Procedimiento que asigna Gestores de todos los tipos.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-1470 & HREOS-1770
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE SP_AGA_ASIGNA_GESTOR_ACTIVO_V2 (
	V_USUARIO	VARCHAR2 DEFAULT 'SP_AGA_V2',
	PL_OUTPUT       OUT VARCHAR2,
	P_ACT_ID		IN REM01.act_activo.act_id%TYPE,
    P_ALL_ACTIVOS	IN NUMBER
)
AS
--v0.3

V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_NUM NUMBER(16);
v_count_1 NUMBER(16);
CODIGO_GESTOR VARCHAR2(15 CHAR);


TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5050);
TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('GADM'),
		T_TIPO_DATA('GPUBL'),
		T_TIPO_DATA('GMARK'),
		T_TIPO_DATA('GPREC'),
		T_TIPO_DATA('GTOPDV'),
		T_TIPO_DATA('GTOPLUS'),
		T_TIPO_DATA('GESTLLA'),
		T_TIPO_DATA('GADMT'),
		T_TIPO_DATA('GFSV'),
		T_TIPO_DATA('GCAL'),
		T_TIPO_DATA('GCCBANKIA'),
		T_TIPO_DATA('GACT'),
		T_TIPO_DATA('GGADM'),
		T_TIPO_DATA('GIAADMT'),
		T_TIPO_DATA('GIAFORM'),
		T_TIPO_DATA('GCOM')
		); 
V_TMP_TIPO_DATA T_TIPO_DATA;


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
    
    DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO DE GESTOR_ACTIVOS_NO_INSERTAR...');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.GESTOR_ACTIVOS_NO_INSERTAR';    

  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] CREACION DE TMP_GEST_ACT...');

  EXECUTE IMMEDIATE '
    CREATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT (
      ACT_ID                      NUMBER(16,0),
      USU_ID                      NUMBER(16,0),
      GEE_ID                      NUMBER(16,0),
      GEH_ID                      NUMBER(16,0)
    )
  ';
  
  DBMS_OUTPUT.PUT_LINE('[INFO] CREACION DE GESTOR_ACTIVOS_NO_INSERTAR...');
  
  EXECUTE IMMEDIATE '
    CREATE TABLE '||V_ESQUEMA||'.GESTOR_ACTIVOS_NO_INSERTAR (
      ACT_ID                    NUMBER(16,0),
      GEH_ID     				NUMBER(16,0),
      GEE_ID                    NUMBER(16,0),
      DD_TGE_CODIGO    			VARCHAR2(20 CHAR)
    )
  ';



 
--------------------------------------------------------------------
----------- ASIGNAMOS GESTORES ---------------------------
--------------------------------------------------------------------    
  
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  	LOOP
  		  V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		  DBMS_OUTPUT.PUT_LINE('[INFO] --GESTORES DE '||V_TMP_TIPO_DATA(1)||'--');
		  DBMS_OUTPUT.PUT_LINE('');
		  
		  EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.GESTOR_ACTIVOS_NO_INSERTAR';  
		  EXECUTE IMMEDIATE '
		  INSERT INTO '||V_ESQUEMA||'.GESTOR_ACTIVOS_NO_INSERTAR (
		      ACT_ID,
		      GEH_ID,
		      GEE_ID,
		      DD_TGE_CODIGO
		  )
		    SELECT DISTINCT ACT.ACT_ID, GEH.GEH_ID, GEE.GEE_ID, TGE.DD_TGE_CODIGO
		    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		    INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
		      ON ACT.ACT_ID = GAH.ACT_ID
		    INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
		      ON GAC.ACT_ID = GAH.ACT_ID
		    INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
		      ON GEH.GEH_ID = GAH.GEH_ID
		    INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
		      ON GEE.GEE_ID = GAC.GEE_ID
		    INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE
		      ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_ID = GEH.DD_TGE_ID
		    WHERE TGE.DD_TGE_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
		    AND GEE.BORRADO = 0 AND GEH.BORRADO = 0'
		  ;
		
		
		  EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT';
		  EXECUTE IMMEDIATE '
		  INSERT INTO '||V_ESQUEMA||'.TMP_GEST_ACT (
		    ACT_ID,
		    USU_ID,
		    GEE_ID,
		    GEH_ID
		  )
			SELECT
			ACT.ACT_ID,
			USU.USU_ID,
			'||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL GEE_ID,
			'||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL GEH_ID
			FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			INNER JOIN '||V_ESQUEMA||'.V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR = '''||V_TMP_TIPO_DATA(1)||'''
			INNER JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
			WHERE NOT EXISTS (
			SELECT 1 FROM '||V_ESQUEMA||'.GESTOR_ACTIVOS_NO_INSERTAR TMP WHERE TMP.ACT_ID = ACT.ACT_ID)
			'
			;
		
		  v_count_1 := SQL%ROWCOUNT;
		  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' TMP_GEST_ACT cargada. '||v_count_1||' Filas.');
		
		  COMMIT;
		
		  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT COMPUTE STATISTICS');
		
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
		  (SELECT dd_tge_id FROM '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor WHERE dd_tge_codigo = '''||V_TMP_TIPO_DATA(1)||'''),
		  0,
		  '''||V_USUARIO||''',
		  SYSDATE,
		  0
		  FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
		  WHERE TMP.USU_ID IS NOT NULL
		  '
		  ;
		
		  v_count_1 := SQL%ROWCOUNT;
		  PL_OUTPUT := '[INFO] INSERTADOS '||v_count_1||' REGISTROS EN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD PARA GESTORES DEL ACTIVO. '||CHR(10);
		
		  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GEE_GESTOR_ENTIDAD cargada. '||v_count_1||' Filas.');
		
		  COMMIT;
		
		  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD COMPUTE STATISTICS');
		
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
		  WHERE TMP.USU_ID IS NOT NULL
		  '
		  ;
		
		  v_count_1 := SQL%ROWCOUNT;
		  PL_OUTPUT := PL_OUTPUT||'[INFO] INSERTADOS '||v_count_1||' REGISTROS EN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO PARA GESTORES DEL ACTIVO. '||CHR(10);
		
		  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GAC_GESTOR_ADD_ACTIVO cargada. '||v_count_1||' Filas.');
		
		  COMMIT;
		
		  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO COMPUTE STATISTICS');
		
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
		  gee.dd_tge_id,
		  SYSDATE,
		  NULL,
		  1,
		  '''||V_USUARIO||''',
		  SYSDATE,
		  0
		  FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
		  INNER JOIN '||V_ESQUEMA||'.TMP_GEST_ACT TMP
		    ON TMP.GEE_ID = GEE.GEE_ID
		  WHERE TMP.USU_ID IS NOT NULL
		  '
		  ;
		
		  v_count_1 := SQL%ROWCOUNT;
		
		  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GEH_GESTOR_ENTIDAD_HIST cargada. '||v_count_1||' Filas.');
		
		  COMMIT;
		
		  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST COMPUTE STATISTICS');
		
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
		  WHERE TMP.USU_ID IS NOT NULL
		  '
		  ;
		  
		  v_count_1 := SQL%ROWCOUNT;
		
		  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' GAH_GESTOR_ACTIVO_HISTORICO cargada. '||v_count_1||' Filas.');
		
		  COMMIT;
		
		  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO COMPUTE STATISTICS');
	END LOOP;


  DBMS_OUTPUT.PUT_LINE('[OK] - PROCESO ASIGNACIÓN GESTORES DE ACTIVO FINALIZADO.');  
	
EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;

END SP_AGA_ASIGNA_GESTOR_ACTIVO_V2;
/
EXIT;
