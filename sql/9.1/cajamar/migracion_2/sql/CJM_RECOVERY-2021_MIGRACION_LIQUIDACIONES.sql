--/*
--##########################################
--## AUTOR=Manuel Rodriguez Sajardo
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=RECOVERY-2021
--## PRODUCTO=NO
--##
--## Finalidad: MIGRACIÓN HISTÓRICO LIQUIDACIONES DE CIERRE DE DEUDA
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_USR  CM01.PRC_PROCEDIMIENTOS.USUARIOCREAR%type := 'RECOVERY-2021'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO PREVIO DE SEGURIDAD');
  
/***********************************************************/
/** BORRADO PREVIO DE SEGURIDAD DE LA MIGRACION  ANTERIOR **/
/***********************************************************/
--PCO_LIQ_LIQUIDACIONES
	V_SQL := 'delete from '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES prc where usuariocrear = '''||V_USR||'''';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN PCO_LIQ_LIQUIDACIONES...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

--TEX_TAREA EXTERNA
	V_SQL := 'delete from '||V_ESQUEMA||'.TEX_TAREA_EXTERNA prc where usuariocrear = '''||V_USR||'''';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN TEX_TAREA EXTERNA...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

--TAR_TAREAS_NOTIFICACIONES
	V_SQL := 'delete from '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES prc where usuariocrear = '''||V_USR||'''';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN TAR_TAREAS_NOTIFICACIONES...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

--PCO_PRC_HEP_HISTOR_EST_PREP
	V_SQL := 'delete from '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP prc where usuariocrear = '''||V_USR||'''';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN PCO_PRC_HEP_HISTOR_EST_PREP...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

--PCO_PRC_PROCEDIMIENTOS
	V_SQL := 'delete from '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS prc where usuariocrear = '''||V_USR||'''';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN PCO_PRC_PROCEDIMIENTOS...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

--PRB_PRC_BIE
	V_SQL := 'delete from '||V_ESQUEMA||'.PRB_PRC_BIE prc where usuariocrear = '''||V_USR||'''';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN PRB_PRC_BIE...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PRB_PRC_BIE COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

-- PRC_PER
	V_SQL := 'delete from '||V_ESQUEMA||'.prc_per prc where exists (
			  select 1 from '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS aux where usuariocrear = '''||V_USR||''' and aux.prc_id = prc.prc_id
			)';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN PRC_PER...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.prc_per COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

--PRC_CEX
	V_SQL := 'delete from '||V_ESQUEMA||'.prc_cex prc where exists (
			  select 1 from '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS aux where usuariocrear = '''||V_USR||''' and aux.prc_id = prc.prc_id
			)';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN PRC_CEX...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.prc_cex COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

	
-- HAC_HISTORICO_ACCESOS
	V_SQL := 'delete from '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS prc where exists (
			  select 1 from '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS aux where usuariocrear = '''||V_USR||''' and aux.prc_id = prc.prc_id
			)';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN HAC_HISTORICO_ACCESOS...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.HAC_HISTORICO_ACCESOS COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

--PRC_PROCEDIMIENTOS
	V_SQL := 'delete from '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc where usuariocrear = '''||V_USR||'''';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINANDO EN PRC_PROCEDIMIENTOS...'|| sql%rowcount);

	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] BORRADO PREVIO DE SEGURIDAD');  
	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE('[INICIO] MIGRACION HISTÓRICO LIQUIDACIONES.sql');  
	
/********************************/
/** PRC_PROCEDIMIENTOS **/
/********************************/
  
  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.prc_procedimientos
            (prc_id, asu_id, dd_tac_id, dd_tre_id, dd_tpo_id,
             prc_porcentaje_recuperacion, prc_plazo_recuperacion,
             prc_saldo_original_vencido, prc_saldo_original_no_vencido,
             prc_saldo_recuperacion, dd_juz_id, VERSION, USUARIOCREAR,
             fechacrear, borrado, dd_epr_id, dtype, SYS_GUID)
      WITH ASUNTOS_PCO AS (
                SELECT prc.ASU_ID
                FROM '||V_ESQUEMA||'.prc_procedimientos prc 
                INNER JOIN '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on prc.dd_tpo_id = tpo.dd_tpo_id
                WHERE dd_tpo_codigo = ''PCO''
                AND prc.BORRADO = 0
      ), PRC_ASU AS (
                SELECT DISTINCT
                  PRC.PRC_ID, 
                  PRC.ASU_ID
                FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                INNER JOIN '||V_ESQUEMA||'.PRC_CEX PRC_CEX ON PRC_CEX.PRC_ID = PRC.PRC_ID
                INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PRC_CEX.CEX_ID
                INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID
                INNER JOIN '||V_ESQUEMA||'.MIG_EXPEDIENTES_LIQUIDACIONES MIG ON MIG.NUM_CUENTA = CNT.CNT_CONTRATO
                WHERE PRC.BORRADO = 0 
                AND CEX.BORRADO = 0
                AND CNT.BORRADO = 0
      ), PRC_ASU_ORDEN AS (
              SELECT 
                PRC_ID, 
                ASU_ID,
                ROW_NUMBER () OVER (PARTITION BY ASU_ID  ORDER BY PRC_ID DESC) AS ORDEN
              FROM PRC_ASU            
      ) , PRC_ASU_FILTRADO AS (
              SELECT 
                PRC_ID, 
                ASU_ID
              FROM PRC_ASU_ORDEN AUX   
             WHERE NOT EXISTS (
                SELECT 1
                FROM ASUNTOS_PCO PCO
                WHERE PCO.ASU_ID = AUX.ASU_ID
              )
              AND AUX.ORDEN = 1
      )
      SELECT   
          '||V_ESQUEMA||'.s_prc_procedimientos.NEXTVAL AS prc_id,
          PRC.asu_id AS asu_id,
          (SELECT dd_tac_id FROM '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento WHERE dd_tpo_CODIGO = ''PCO'') AS dd_tac_id,
          1 AS dd_tre_id,
          (SELECT dd_TPO_ID FROM '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento WHERE dd_tpo_CODIGO = ''PCO'') AS dd_tpo_id,
          100 AS prc_porcentaje_recuperacion,
          30 AS prc_plazo_recuperacion,
          PRC.PRC_SALDO_ORIGINAL_VENCIDO AS prc_saldo_original_vencido,     
          PRC.PRC_SALDO_ORIGINAL_NO_VENCIDO AS prc_saldo_original_no_vencido,
          PRC.PRC_SALDO_RECUPERACION AS prc_saldo_recuperacion,           
          NULL AS dd_juz_id,
          0 AS VERSION,
          '''||V_USR||''' AS USUARIOCREAR,
          SYSDATE AS fechacrear,
          0 AS borrado,
          3 AS dd_epr_id, -- ESTADO PROCEDIMIENTO = ACEPTADO
          ''MEJProcedimiento'' AS dtype,
          SYS_GUID() AS SYS_GUID
      FROM PRC_ASU_FILTRADO FIL
      INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = FIL.PRC_ID';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN PRC_PROCEDIMIENTOS...'|| sql%rowcount);
  
	--23.907 filas insertadas.
  
	COMMIT;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;


/**********************/
/** PRC_CEX  **/
/**********************/
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.prc_cex (prc_id, cex_id)
    (SELECT DISTINCT PRC.PRC_ID, CEX.CEX_ID
    FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
    INNER JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = PRC.ASU_ID
    INNER JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP ON EXP.EXP_ID = ASU.EXP_ID
    INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.EXP_ID = EXP.EXP_ID
    WHERE  PRC.USUARIOCREAR = '''||V_USR||''')';
         
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN PRC_CEX...'|| sql%rowcount);

	--29.235 filas insertadas.

	COMMIT;
  
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.prc_cex COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;


/**********************/
/** PRC_PER  **/
/**********************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.prc_per (prc_id, per_id)
    (SELECT DISTINCT
      PRC.PRC_ID,
      PEX.PER_ID
    FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
    INNER JOIN '||V_ESQUEMA||'.PRC_CEX ON PRC_CEX.PRC_ID = PRC.PRC_ID
    INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PRC_CEX.CEX_ID
    INNER JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP ON EXP.EXP_ID = CEX.EXP_ID
    INNER JOIN '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE PEX ON PEX.EXP_ID = EXP.EXP_ID
    WHERE PRC.USUARIOCREAR = '''||V_USR||''')';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN PRC_PER...'|| sql%rowcount);
  
	--50.710 filas insertadas.
  
	COMMIT;
  
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.prc_per COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;
  

/**********************/
/** PRB_PRC_BIE  **/
/**********************/

	V_SQL := 'ANALYZE TABLE BIE_CNT COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.prb_prc_bie (PRB_ID,PRC_ID,BIE_ID,DD_SGB_ID, USUARIOCREAR, fechacrear, SYS_GUID)
    SELECT '||V_ESQUEMA||'.s_prb_prc_bie.nextval, prc_id, bie_id, 2, '''||V_USR||''', sysdate, SYS_GUID() AS SYS_GUID
    from ( 
                SELECT DISTINCT PRC.PRC_ID, BC.BIE_ID
                FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                INNER JOIN '||V_ESQUEMA||'.PRC_CEX ON PRC_CEX.PRC_ID = PRC.PRC_ID
                INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PRC_CEX.CEX_ID
                INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID
                INNER JOIN '||V_ESQUEMA||'.BIE_CNT BC ON BC.CNT_ID = CNT.CNT_ID
                WHERE  PRC.USUARIOCREAR = '''||V_USR||'''                
            )';
         
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN PRB_PRC_BIE...'|| sql%rowcount);

	--121.100 filas insertadas.

	COMMIT;

	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.prb_prc_bie COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;


/*************************************/
/** INSERTAR PCO                    **/
/**********************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.pco_prc_procedimientos (PCO_PRC_ID,PRC_ID, PCO_PRC_TIPO_PRC_PROP, PCO_PRC_TIPO_PRC_INICIADO, PCO_PRC_NUM_EXP_EXT, PCO_PRC_NUM_EXP_INT, USUARIOCREAR, fechacrear, SYS_GUID)
				select '||V_ESQUEMA||'.s_pco_prc_procedimientos.nextval, prc_id, DD_TPO_ID as PCO_PRC_TIPO_PRC_PROP, DD_TPO_ID as PCO_PRC_TIPO_PRC_INICIADO, ASU_ID_EXTERNO, ASU_ID_EXTERNO, '''||V_USR||''' , sysdate, SYS_GUID() AS SYS_GUID
				from (
                  select DISTINCT prc.prc_id, ASU.ASU_ID_EXTERNO, PRC.DD_TPO_ID
                  from '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
                  INNER JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = PRC.ASU_ID
                  WHERE  PRC.USUARIOCREAR = '''||V_USR||''' 
               )';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN PCO_PRC_PROCEDIMIENTOS...'|| sql%rowcount);
  
	--23.907  filas insertadas.
  
	COMMIT;
    
	v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.pco_prc_procedimientos COMPUTE STATISTICS';
	
  EXECUTE IMMEDIATE V_SQL;


/*************************************/
/** INSERTAR ESTADO EN FINALIZADO      **/
/*************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, PCO_PRC_HEP_FECHA_FIN, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT 
             '||V_ESQUEMA||'.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, 
					   PCO_PRC_ID,
					   (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''FI'' and BORRADO = 0) as DD_PCO_PEP_ID,-- Finalizado
					   FECHACREAR AS PRC_HEP_FECHA_INICIO,
             FECHACREAR AS PCO_PRC_HEP_FECHA_FIN,
					   '''||V_USR||''' AS USUARIOCREAR,
					   SYSDATE, SYS_GUID() AS SYS_GUID
				FROM(
                    SELECT PCO.PCO_PRC_ID, ASU.FECHACREAR
                    FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                    INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PCO.PRC_ID
                    INNER JOIN '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID = PRC.ASU_ID
                    WHERE  PCO.USUARIOCREAR = '''||V_USR||'''                
                  )';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN PCO_PRC_HEP_HISTOR_EST_PREP...'|| sql%rowcount);
  
	--23.907 filas insertadas.
  
	COMMIT;

	v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;
  
	v_SQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''IDX_PCO_PRC_HEP_HISTOR_EST1''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
		v_SQL := 'CREATE INDEX IDX_PCO_PRC_HEP_HISTOR_EST1 ON '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP(PCO_PRC_ID)';
			
  EXECUTE IMMEDIATE V_SQL;
		
	END IF;	
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;


/*****************************
*   TAR_TAREAS_NOTIFICACIONES *
******************************/	

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
				TAR_FECHA_FIN, TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_TAREA_FINALIZADA, TAR_EMISOR, 
				VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, SYS_GUID)
				SELECT 
             '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL,
					   null AS EXP_ID,
					   PRC.ASU_ID,
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
					   '''||V_USR||''' AS USUARIOCREAR,
					   SYSDATE AS FECHACREAR,
					   0 AS BORRADO,
					   PRC.PRC_ID,
					   ''EXTTareaNotificacion'' AS DTYPE,
					   0 AS NFA_TAR_REVISADA,
					   SYS_GUID() AS SYS_GUID
				FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC,  '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP 
        WHERE TAP_CODIGO = ''PCO_RegistrarTomaDec''
        AND PRC.USUARIOCREAR = '''||V_USR||'''';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN TAR_TAREAS_NOTIFICACIONES...'|| sql%rowcount);

	--23.907  filas insertadas.

	COMMIT;
  
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;
  

/*****************************
*   TEX_TAREA_EXTERNA        *
******************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA(TEX_ID, TAR_ID, TAP_ID, TEX_DETENIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TEX_CANCELADA, TEX_NUM_AUTOP, DTYPE)
				SELECT 
			 '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL,
					   TAR_ID,
					   TAP.TAP_ID AS TAP_ID,
					   0 AS TEX_DETENIDA,
					   0 AS VERSION,
					   '''||V_USR||''' AS USUARIOCREAR,
					   SYSDATE AS FECHACREAR,
					   1 AS BORRADO,
					   0 AS TEX_CANCELADA,
					   0 AS TEX_NUM_AUTOP,
					   ''EXTTareaExterna''  AS DTYPE
				  FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
				  WHERE TAR.USUARIOCREAR = '''||V_USR||'''
		  AND TAR.TAR_TAREA = TAP.TAP_CODIGO';

	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN TEX_TAREA_EXTERNA...'|| sql%rowcount);

	--23.907  filas insertadas.

	COMMIT;
  
	v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;
	

/*****************************
*   PCO_LIQ_LIQUIDACIONES    *
******************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES (PCO_LIQ_ID, PCO_PRC_ID, DD_PCO_LIQ_ID, CNT_ID, PCO_LIQ_FECHA_CIERRE, PCO_LIQ_INTERESES_DEMORA, PCO_LIQ_INTERESES_ORDINARIOS, PCO_LIQ_TOTAL, USUARIOCREAR, FECHACREAR, SYS_GUID)
      select '||V_ESQUEMA||'.S_PCO_LIQ_LIQUIDACIONES.NEXTVAL, PCO_PRC_ID, DD_PCO_LIQ_ID, CNT_ID, PCO_LIQ_FECHA_CIERRE, PCO_LIQ_INTERESES_DEMORA, PCO_LIQ_INTERESES_ORDINARIOS, PCO_LIQ_TOTAL, '''||V_USR||''' , sysdate, SYS_GUID() AS SYS_GUID
			FROM (
                  SELECT DISTINCT
                     PCO.PCO_PRC_ID AS PCO_PRC_ID,
                     LE.DD_PCO_LIQ_ID AS DD_PCO_LIQ_ID, 
                     CNT.CNT_ID AS CNT_ID,
                     MIG.FECHA_CIERRE AS PCO_LIQ_FECHA_CIERRE,
                     MIG.DEMORA_CER AS PCO_LIQ_INTERESES_DEMORA,
                     MIG.INTERES_CER AS PCO_LIQ_INTERESES_ORDINARIOS,
                     MIG.CAPITAL_CER   AS PCO_LIQ_TOTAL
                  FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
                    INNER JOIN '||V_ESQUEMA||'.DD_PCO_LIQ_ESTADO LE ON LE.DD_PCO_LIQ_CODIGO = ''PEN''
                    INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PCO.PRC_ID
                    INNER JOIN '||V_ESQUEMA||'.PRC_CEX PRC_CEX ON PRC_CEX.PRC_ID = PRC.PRC_ID
                    INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PRC_CEX.CEX_ID
                    INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID = CEX.CNT_ID
                    INNER JOIN '||V_ESQUEMA||'.MIG_EXPEDIENTES_LIQUIDACIONES MIG ON MIG.NUM_CUENTA = CNT.CNT_CONTRATO
                  WHERE PCO.USUARIOCREAR = '''||V_USR||''' AND PRC.USUARIOCREAR = '''||V_USR||''' 
                )';


	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN PCO_LIQUIDACIONES...'|| sql%rowcount);
  
	--25.049 filas insertadas.
  
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] MIGRACION HISTÓRICO LIQUIDACIONES.sql');  
	
	v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;  
   
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
