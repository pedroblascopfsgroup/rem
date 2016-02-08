/***************************************/
-- CREAR ASUNTOS PRECONTENCIOSO CAJAMAR (BCC)
-- Creador: Jaime Sánchez-Cuenca, PFS Group
-- Modificador: 
-- Fecha: 10/12/2015
-- Modificacion: 
--	EJD:> Incluimos filtro por "and cab.fecha_asignacion is null"
--	EJD:> Incluimos control sobre indice IDX_USUAMOD_PEX
--	GMN:> Se asigna el DD_TPX_ID (tipo de expediente a recuperaciones - RECU)
--	GMN:> Reasignación de estados de expedientes
--	GMN:> incluimos paralizados sin fecha asignación informada
/***************************************/

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

/*********************************************/
/**       BORRAR LOS WORKFLOWS YA GENERADOS **/
/*********************************************/

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO] CAJAMAR MIGRACION PRECONTENCIOSO.sql');  

	V_SQL := 'SELECT COUNT(1) FROM TAB WHERE TNAME = ''TMP_CREA_ASUNTOSPCO_NUEVOS''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS
							(
							  COD_RECOVERY VARCHAR(20 CHAR),
							  COD_WORKFLOW VARCHAR(20 CHAR), 
							  FECHA_SAREB TIMESTAMP, 
							  FECHA_PETICION TIMESTAMP, 
							  CNT_CONTRATO VARCHAR(42 CHAR)
							)';
							
		EXECUTE IMMEDIATE V_SQL;		
		DBMS_OUTPUT.PUT_LINE('TABLA TMP_CREA_ASUNTOSPCO_NUEVOS CREADA');

	END IF;
	
	V_SQL := 'delete from '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS';

	EXECUTE IMMEDIATE V_SQL;
	
	COMMIT;

	v_SQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''PK_TMP_CREA_ASUNTOSPCO_NUEVOS''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
		v_SQL := 'ALTER TABLE '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS ADD CONSTRAINT PK_TMP_CREA_ASUNTOSPCO_NUEVOS PRIMARY KEY (COD_RECOVERY)';
		
		EXECUTE IMMEDIATE V_SQL;
		
	END IF;	
	
	
	V_SQL := 'SELECT COUNT(1) FROM TAB WHERE TNAME = ''TMP_BPM_INPUT_CON1''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
		V_SQL := 'CREATE '||V_ESQUEMA||'.TABLE TMP_BPM_INPUT_CON1
											(
											 PRC_ID NUMBER(16,0), 
											 TAP_ID NUMBER, 
											 T_REFERENCIA NUMBER(16,0)
											)';
							
		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('TABLA TMP_BPM_INPUT_CON1 CREADA');

	END IF;
	
	v_SQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''IDX_CD_EXPEDIENTE''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
		v_SQL := 'CREATE UNIQUE INDEX IDX_CD_EXPEDIENTE ON '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA(CD_EXPEDIENTE)';
			
		EXECUTE IMMEDIATE V_SQL;
		
	END IF;	
	
	v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA COMPUTE STATISTICS';
	
		EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS
                            select DISTINCT
                                   cab.cd_expediente cod_recovery, 
                                   cab.cd_expediente cod_workflow, 
                                   null fecha_sareb, 
                                   null fecha_peticion, 
                                   op.NUMERO_CONTRATO cnt_contrato
                            from '||V_ESQUEMA||'.mig_expedientes_cabecera cab
                            inner join '||V_ESQUEMA||'.mig_expedientes_operaciones op on cab.cd_expediente = op.cd_expediente
                            where --cab.fecha_baja is null and cab.MOTIVO_BAJA is null AND CAB.FECHA_ACEPTACION_LETRADO IS NULL
                                  cab.fecha_asignacion is not null
--                                 ( cab.fecha_asignacion is not null                                                          
--                                   OR (cab.fecha_asignacion is null and fecha_paralizacion is not null))                                  
                              and NOT EXISTS(SELECT 1 
                                                FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA C 
                                                WHERE C.CD_EXPEDIENTE_NUSE = CAB.CD_EXPEDIENTE) -- LOS QUE EVOLUCIONAN A PROCEDIMIENTOS NO SE MIGRAN COMO PRECONTENCIOSOS.
--                                  AND NOT EXISTS(SELECT 1 
--                                                FROM '||V_ESQUEMA||'.MIG_CONCURSOS_CABECERA CON
--                                                   , '||V_ESQUEMA||'.ASU_ASUNTOS ASU
--                                                WHERE CON.CD_CONCURSO = ASU.ASU_ID_EXTERNO) -- LOS QUE EVOLUCIONAN A CONCURSOS NO SE MIGRAN COMO PRECONTENCIOSOS.
                                   AND NOT EXISTS (SELECT 1 FROM (select distinct eop.cd_expediente as cod_recovery
                                                  from '||V_ESQUEMA||'.TMP_CNT_CONTRATOS           cnt             
                                                     , '||V_ESQUEMA||'.MIG_EXPEDIENTES_OPERACIONES eop             
                                                 where cnt.tmp_cnt_contrato = eop.numero_contrato
                                                   and cnt.tmp_cnt_remu_gest_especial = ''EX'') tmp  
                                                         where tmp.cod_recovery = cab.CD_EXPEDIENTE) ';

        COMMIT;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

-- 206.725 filas insertadas. ( 1 EXP --> 1 OPERACION)

	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.CNT_CONTRATOS COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.MOV_MOVIMIENTOS COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PER_PERSONAS COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;
	

/***************************************/
/**       CLI_CLIENTES         **/
/***************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.CLI_CLIENTES
				(cli_id, per_id, arq_id, dd_est_id, dd_ecl_id, cli_fecha_est_id,
				VERSION, usuariocrear, fechacrear, borrado, cli_fecha_creacion,
				cli_telecobro, ofi_id, USUARIOMODIFICAR)
			SELECT '||V_ESQUEMA||'.s_cli_clientes.NEXTVAL,
				   apc.per_id, 
				   (SELECT arq_id FROM '||V_ESQUEMA||'.arq_arquetipos WHERE ARQ_NOMBRE = ''Migracion''  AND BORRADO = 1) AS arq_id,
				   1 AS dd_est_id,
				   3 AS dd_ecl_id,
				   SYSDATE,
				   0 AS VERSION,
				   '''||USUARIO||''' AS usuariocrear,
				   SYSDATE AS fechacrear, 1 AS borrado,
				   SYSDATE AS cli_fecha_creacion,
				   0 AS cli_telecobro,
				   apc.ofi_id,
				   APC.COD_RECOVERY AS usuarioMODIFICAR
			FROM (
			SELECT MIN(COD_RECOVERY) COD_RECOVERY, PER_ID, MAX(OFI_ID) OFI_ID FROM(
				   SELECT * FROM(
					  SELECT TMP.COD_RECOVERY, cnt.cnt_id, CPE.PER_ID, NVL(PER.OFI_ID, CNT.OFI_ID) OFI_ID, CPE.CPE_ORDEN, 
							 rank() over (partition by CPE.CNT_ID order by cpe.cpe_orden) as ranking,
							 rank() over (partition by per.per_id order by mov.mov_pos_viva_vencida + mov.mov_pos_viva_no_vencida desc) as ranking_mov,
							 mov.mov_pos_viva_vencida + mov.mov_pos_viva_no_vencida total
					  FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN
						   '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO INNER JOIN
						   '||V_ESQUEMA||'.mov_movimientos mov on mov.cnt_id = cnt.cnt_id and mov.mov_fecha_extraccion = cnt.cnt_fecha_extraccion inner join 
						   '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID INNER JOIN
						   '||V_ESQUEMA||'.PER_PERSONAS PER ON PER.PER_ID = CPE.PER_ID INNER JOIN
						   '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1
					  )
				  WHERE RANKING = 1
				  AND RANKING_MOV = 1) Z
			WHERE NOT EXISTS(SELECT 1
					 FROM '||V_ESQUEMA||'.CLI_CLIENTES CLI
					 WHERE CLI.PER_ID = Z.PER_ID)
			GROUP BY PER_ID) APC';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
  COMMIT;

-- 145.739 filas insertadas.

/*************************************************/
/**          haya01.CCL_CONTRATOS_CLIENTES      **/
/**
/*************************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ccl_contratos_cliente
            (ccl_id, cnt_id, cli_id, ccl_pase, VERSION, usuariocrear,
             fechacrear, borrado)
			(SELECT '||V_ESQUEMA||'.s_ccl_contratos_cliente.NEXTVAL AS ccl_id,
			   apc.cnt_id AS cnt_id,
			   apc.cli_id AS cli_id,
			   case when RANKING = 1 THEN 1 ELSE 0 END AS ccl_pase,
			   0 AS VERSION,
			   '''||USUARIO||''' AS usuariocrear,
			   SYSDATE AS fechacrear,
			   0 AS borrado
		  FROM (
			SELECT DISTINCT TMP.COD_RECOVERY, CNT.CNT_ID, CLI.CLI_ID, rank() over (partition by TMP.COD_RECOVERY,CLI.CLI_ID order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC) RANKING
			FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
				 '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO INNER JOIN 
				 '||V_ESQUEMA||'.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION INNER JOIN
				 '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID INNER JOIN 
				 '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1 INNER JOIN
				 '||V_ESQUEMA||'.CLI_CLIENTES CLI ON CLI.PER_ID = CPE.PER_ID AND CLI.USUARIOMODIFICAR = TMP.COD_RECOVERY
				) APC
		  )';
      
-- 145.739 filas insertadas.

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
  	COMMIT;

/*************************************************/
/** EXP_EXPEDIENTES               **/
/*************************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.exp_expedientes
            (exp_id, dd_est_id, exp_fecha_est_id, ofi_id, arq_id, VERSION, usuariocrear, fechacrear, borrado, dd_eex_id, dd_tpx_id, exp_descripcion, usuariomodificar, CD_EXPEDIENTE_NUSE, SYS_GUID)
				WITH VIP AS
				(
				  SELECT MIN(PER_NOM50) AS PER_NOM50, COD_RECOVERY
				  FROM
				  (
					SELECT DISTINCT PER_NOM50, TMP.COD_RECOVERY, DD_TIN_ID, CPE_ORDEN, rank() over (partition by TMP.COD_RECOVERY order by DD_TIN_ID, CPE_ORDEN DESC) RANKING
					FROM '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS cpe
					INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS cnt ON cnt.cnt_id = cpe.cnt_id
					INNER JOIN '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP ON tmp.cnt_contrato = cnt.cnt_contrato
					INNER JOIN '||V_ESQUEMA||'.PER_PERSONAS per ON per.per_id = cpe.per_id )
				  WHERE RANKING = 1
				  GROUP BY COD_RECOVERY
				)
				SELECT '||V_ESQUEMA||'.s_exp_expedientes.NEXTVAL EXP_ID,
					   5 AS dd_est_id,
					   SYSDATE AS exp_fecha_est_id,
					   apc.ofi_id AS ofi_id,
					   (SELECT arq_id FROM '||V_ESQUEMA||'.arq_arquetipos WHERE ARQ_NOMBRE = ''Migracion''  AND BORRADO = 1) AS arq_id,
					   0 AS VERSION,
					   '''||USUARIO||''' AS usuariocrear,
					   SYSDATE AS fechacrear,
					   0 AS borrado,
					   4 AS dd_eex_id,
					   (select dd_TPX_ID from '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE where DD_TPX_CODIGO = ''RECU'') as dd_tpx_id,
					   apc.CNT_CONTRATO || '' | ''|| apc.per_nom50 AS exp_descripcion,
					   apc.COD_RECOVERY as usuariomodificar,
					   APC.COD_RECOVERY AS CD_EXPEDIENTE_NUSE,
					   SYS_GUID() AS SYS_GUID
				FROM 
				(  
				SELECT CNT_ID,CNT.COD_RECOVERY,OFI_ID,CNT_CONTRATO,PER_NOM50, RANKING
				FROM
				(
				  SELECT DISTINCT 
						 CNT.CNT_ID,TMP.COD_RECOVERY,CNT.OFI_ID,CNT.CNT_CONTRATO, rank() over (partition by TMP.COD_RECOVERY order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA), MOV.MOV_ID DESC) RANKING
				  FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP
				  INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO
				  INNER JOIN '||V_ESQUEMA||'.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION
				  ) cnt
				INNER JOIN VIP
				ON VIP.COD_RECOVERY = cnt.COD_RECOVERY
				WHERE RANKING = 1
				) APC';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
  	
  COMMIT;	


	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.EXP_EXPEDIENTES COMPUTE STATISTICS';
	
		EXECUTE IMMEDIATE V_SQL;

--193.643 filas insertadas.

/**********************************************/
/** CEX_CONTRATOS_EXPEDIENTE **/
/**********************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.cex_contratos_expediente
            (cex_id, cnt_id, exp_id, cex_pase, cex_sin_actuacion, VERSION,
             usuariocrear, fechacrear, borrado, dd_aex_id, usuariomodificar, SYS_GUID)
				   (SELECT '||V_ESQUEMA||'.s_cex_contratos_expediente.NEXTVAL AS cex_id,
						   apc.cnt_id AS cnt_id,
						   apc.exp_id AS exp_id,
						   case when RANKING = 1 THEN 1 ELSE 0 END AS cex_pase,
						   0 AS cex_sin_actuacion,
						   0 AS VERSION, '''||USUARIO||''' AS usuariocrear,
						   SYSDATE AS fechacrear,
						   0 AS borrado,
						   9 AS dd_aex_id,
						   COD_RECOVERY,
						   SYS_GUID() AS SYS_GUID
					  FROM (
					  SELECT DISTINCT TMP.COD_RECOVERY, CNT.CNT_ID, exp.exp_id,
							 rank() over (partition by TMP.COD_RECOVERY order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC) RANKING
					  FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
						   '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO inner join
						   '||V_ESQUEMA||'.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION INNER JOIN
						   '||V_ESQUEMA||'.exp_expedientes exp on exp.usuariomodificar = tmp.COD_RECOVERY)
					apc)';
    
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
  COMMIT;

--193.643 filas insertadas.

/*********************************************/
/** PEX_PERSONAS_EXPEDIENTE **/
/*********************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.pex_personas_expediente
            (pex_id, per_id, exp_id, dd_aex_id, pex_pase, VERSION,
             usuariocrear, fechacrear, borrado, USUARIOMODIFICAR)
				SELECT '||V_ESQUEMA||'.s_pex_personas_expediente.NEXTVAL AS pex_id,
						   apc.per_id AS per_id,
						   apc.exp_id AS exp_id,
						   9 AS dd_aex_id,
						   case when PER_ID_PASE = PER_ID THEN 1 ELSE 0 END AS pex_pase,
						   0 AS VERSION,
						   '''||USUARIO||''' AS usuariocrear,
						   SYSDATE AS fechacrear,
						   0 AS borrado,
						   COD_RECOVERY
				FROM (
					  SELECT DISTINCT TMP.COD_RECOVERY, CPE.PER_ID, AUX_PER_ID_PASE.PER_ID PER_ID_PASE, EXP.EXP_ID
					  FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP,
						   '||V_ESQUEMA||'.CNT_CONTRATOS CNT, 
						   '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE, 
						   '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION TIN, 
						   '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP,
						   (SELECT AUX2.COD_RECOVERY, MAX(PER_ID) PER_ID
									FROM (
									  SELECT AUX1.COD_RECOVERY, AUX1.CNT_ID, PER.PER_ID, CPE.CPE_ORDEN, rank() over (partition by CPE.CNT_ID order by cpe.cpe_orden) as ranking
									  FROM (
										SELECT DISTINCT TMP.COD_RECOVERY, CNT.CNT_ID, CNT.OFI_ID,
										rank() over (partition by TMP.COD_RECOVERY order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC) as ranking
										FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
											 '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO INNER JOIN 
											 '||V_ESQUEMA||'.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION 
									  ) AUX1 INNER JOIN 
										'||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = AUX1.CNT_ID  INNER JOIN 
										'||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1 INNER JOIN 
										'||V_ESQUEMA||'.PER_PERSONAS PER ON PER.PER_ID = CPE.PER_ID
									  WHERE AUX1.RANKING = 1
									) AUX2
							WHERE AUX2.RANKING = 1 
							GROUP BY AUX2.COD_RECOVERY) AUX_PER_ID_PASE
					  WHERE CNT.CNT_CONTRATO = TMP.CNT_CONTRATO
					  AND CPE.CNT_ID = CNT.CNT_ID
					  AND TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1
					  AND EXP.USUARIOMODIFICAR =TMP.COD_RECOVERY
					  AND AUX_PER_ID_PASE.COD_RECOVERY = TMP.COD_RECOVERY) APC';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

--265.998 filas insertadas.

/*********************************************/
/** ASU_ASUNTOS **************/
/*********************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.asu_asuntos
            (asu_id, dd_est_id, asu_fecha_est_id, asu_nombre, exp_id, VERSION,
             usuariocrear, fechacrear, borrado, dd_eas_id, dtype/*, lote*/, dd_tas_id, DD_PAS_ID, USUARIOMODIFICAR, ASU_ID_EXTERNO, DD_GES_ID, SYS_GUID)
				(SELECT '||V_ESQUEMA||'.s_asu_asuntos.NEXTVAL AS asu_id,
					   (SELECT DD_EST_ID FROM '||V_ESQUEMA_MASTER||'.DD_EST_ESTADOS_ITINERARIOS WHERE DD_eST_CODIGO = ''AS'') AS dd_est_id, -- ASUNTO
					   SYSDATE AS asu_fecha_est_id,
					   substr(EXP_DESCRIPCION,0,50) AS asu_nombre,
					   exp_id,
					   0 AS VERSION,
					   '''||USUARIO||''' AS usuariocrear,
					   SYSDATE AS fechacrear,
					   0 AS borrado,
					   3 AS dd_eas_id, -- ESTADOASUNTO Aceptado
					   ''EXTAsunto'' AS dtype,
					   (select dd_tas_id from '||V_ESQUEMA_MASTER||'.dd_tas_tipos_asunto where dd_tas_DESCRIPCION = ''Litigio'') AS DD_TAS_ID,
					   (select DD_PAS_ID FROM '||V_ESQUEMA||'.dd_pas_propiedad_asunto where dd_pas_codigo = ''CAJAMAR'') AS DD_PAS_ID,
					   COD_RECOVERY AS USUARIOMODIFICAR,
					   COD_RECOVERY AS ASU_ID_EXTERNO,
					   (select dd_ges_id from '||V_ESQUEMA||'.DD_GES_GESTION_ASUNTO where dd_ges_codigo = ''HAYA'') AS DD_GES_ID,
					   SYS_GUID() AS SYS_GUID
				  FROM (
						SELECT DISTINCT TMP.COD_RECOVERY, 
										EXP.EXP_ID exp_id,
										EXP.EXP_DESCRIPCION
						FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP 
						INNER JOIN '||V_ESQUEMA||'.EXP_EXPEDIENTES EXP ON EXP.USUARIOMODIFICAR = TMP.COD_RECOVERY
					  )
				  apc)';
  
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

    
    v_SQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''IDX_ASU_ID_EXTERNO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN
	v_SQL := 'CREATE INDEX IDX_ASU_ID_EXTERNO ON '||V_ESQUEMA||'.ASU_ASUNTOS (ASU_ID_EXTERNO)';		
	EXECUTE IMMEDIATE V_SQL;
    END IF;	
    v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.ASU_ASUNTOS COMPUTE STATISTICS';
    EXECUTE IMMEDIATE V_SQL;

    -- PEX_PERSONAS_EXPEDIENTE
    v_SQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''IDX_USUARIOMODIFICAR''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
	v_SQL := 'DROP INDEX IDX_USUARIOMODIFICAR';
	EXECUTE IMMEDIATE V_SQL;
    END IF;

    v_SQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''IDX_USUAMOD_PEX''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN
	v_SQL := 'CREATE INDEX IDX_USUAMOD_PEX ON '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE (USUARIOMODIFICAR)';		
	EXECUTE IMMEDIATE V_SQL;
    END IF;	

    v_SQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''IDX_USUA_PEX_2''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN
	v_SQL := 'CREATE INDEX IDX_USUA_PEX_2 ON '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE (USUARIOMODIFICAR, PEX_PASE)';		
	EXECUTE IMMEDIATE V_SQL;
    END IF;

    v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS COMPUTE STATISTICS';
    EXECUTE IMMEDIATE V_SQL;


-- 193.643 filas insertadas.

/********************************/
/** haya01.PRC_PROCEDIMIENTOS **/
/********************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.prc_procedimientos
            (prc_id, asu_id, dd_tac_id, dd_tre_id, dd_tpo_id,
             prc_porcentaje_recuperacion, prc_plazo_recuperacion,
             prc_saldo_original_vencido, prc_saldo_original_no_vencido,
             prc_saldo_recuperacion, dd_juz_id, VERSION, usuariocrear,
             fechacrear, borrado, dd_epr_id, dtype, USUARIOMODIFICAR, SYS_GUID)
				SELECT    '||V_ESQUEMA||'.s_prc_procedimientos.NEXTVAL AS prc_id,
						   apc.asu_id AS asu_id,
						   (SELECT dd_tac_id FROM '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento WHERE dd_tpo_CODIGO = ''PCO'') AS dd_tac_id,
						   1 AS dd_tre_id,
						   (SELECT dd_TPO_ID FROM '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento WHERE dd_tpo_CODIGO = ''PCO'') AS dd_tpo_id,
						   100 AS prc_porcentaje_recuperacion,
						   30 AS prc_plazo_recuperacion,
						   APC.VENCIDO AS prc_saldo_original_vencido,
						   APC.NO_VENCIDO AS prc_saldo_original_no_vencido,
						   APC.PRINCIPAL AS prc_saldo_recuperacion,
						   NULL AS dd_juz_id,
						   0 AS VERSION,
						   '''||USUARIO||''' AS usuariocrear,
						   SYSDATE AS fechacrear,
						   0 AS borrado,
						   3 AS dd_epr_id, -- ESTADO PROCEDIMIENTO = ACEPTADO
						   ''MEJProcedimiento'' AS dtype,
						   APC.COD_RECOVERY,
						   SYS_GUID() AS SYS_GUID
				FROM (
					  SELECT DISTINCT TMP.COD_RECOVERY, ASU.ASU_ID, AUX_PER_ID_PASE.PRINCIPAL, AUX_PER_ID_PASE.VENCIDO , AUX_PER_ID_PASE.NO_VENCIDO
					  FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP,
						   '||V_ESQUEMA||'.ASU_ASUNTOS ASU,
						   (SELECT DISTINCT AUX1.COD_RECOVERY, PEX.PER_ID, SUM(AUX1.MOV_POS_VIVA_VENCIDA + AUX1.MOV_POS_VIVA_NO_VENCIDA) PRINCIPAL, SUM(AUX1.MOV_POS_VIVA_VENCIDA) VENCIDO, SUM(AUX1.MOV_POS_VIVA_NO_VENCIDA) NO_VENCIDO FROM
									  (SELECT DISTINCT TMP.COD_RECOVERY, CNT.CNT_ID, CNT.OFI_ID, MOV_POS_VIVA_VENCIDA, MOV_POS_VIVA_NO_VENCIDA,
											  rank() over (partition by TMP.COD_RECOVERY order by (MOV.MOV_POS_VIVA_VENCIDA + MOV_POS_VIVA_NO_VENCIDA) DESC) as ranking
									  FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
										   '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO INNER JOIN 
										   '||V_ESQUEMA||'.MOV_MOVIMIENTOS MOV ON MOV.CNT_ID = CNT.CNT_ID AND MOV.MOV_FECHA_EXTRACCION = CNT.CNT_FECHA_EXTRACCION 
									   ) AUX1,  PEX_PERSONAS_EXPEDIENTE PEX 
									   WHERE PEX.USUARIOMODIFICAR = AUX1.COD_RECOVERY AND PEX.PEX_PASE = 1 and  AUX1.ranking = 1
							GROUP BY AUX1.COD_RECOVERY, PEX.PER_ID) AUX_PER_ID_PASE
					  WHERE ASU.ASU_ID_EXTERNO =TMP.COD_RECOVERY
					  AND AUX_PER_ID_PASE.COD_RECOVERY = TMP.COD_RECOVERY) APC';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;
    
    v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE COMPUTE STATISTICS';
    
    	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS COMPUTE STATISTICS';
	
		EXECUTE IMMEDIATE V_SQL;

--193.643 filas insertadas.

/**********************/
/** BANK01.PRC_PER  **/
/**********************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.prc_per
            (prc_id, per_id)
			   (SELECT DISTINCT PRC.PRC_ID, CPE.PER_ID
				FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
					 '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_CONTRATO = TMP.CNT_CONTRATO INNER JOIN 
					 '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID INNER JOIN 
					 '||V_ESQUEMA||'.DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1 INNER JOIN
					 '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.USUARIOMODIFICAR = TMP.COD_RECOVERY)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

--265.998 filas insertadas.

/**********************/
/** haya01.PRC_CEX  **/
/**********************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.prc_cex
            (prc_id, cex_id)
				(SELECT DISTINCT PRC.PRC_ID, CEX.CEX_ID
				 FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
					  '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.USUARIOMODIFICAR = TMP.COD_RECOVERY INNER JOIN
					  '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.USUARIOMODIFICAR = TMP.COD_RECOVERY)';
         
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
  
--193.643 filas insertadas.

/**********************/
/** haya01.PRB_BIE_PCR  **/
/**********************/

	V_SQL := 'ANALYZE TABLE BIE_CNT COMPUTE STATISTICS';

	EXECUTE IMMEDIATE V_SQL;

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.prb_prc_bie(PRB_ID,PRC_ID,BIE_ID,DD_SGB_ID, usuariocrear,fechacrear,SYS_GUID)
				(SELECT '||V_ESQUEMA||'.s_prb_prc_bie.nextval, prc_id, bie_id, 2, '''||USUARIO||''', sysdate, SYS_GUID() AS SYS_GUID
				 from (  SELECT DISTINCT PRC.PRC_ID, bc.bie_id
						 FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
							  '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.USUARIOMODIFICAR = TMP.COD_RECOVERY INNER JOIN
							  '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.USUARIOMODIFICAR = TMP.COD_RECOVERY inner join 
							  '||V_ESQUEMA||'.bie_cnt bc on bc.cnt_id = cex.cnt_id)
				)';
         
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

--121.076 filas insertadas.


/*************************************/
/** INSERTAR PCO                    **/
/**********************/


	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.pco_prc_procedimientos (PCO_PRC_ID,PRC_ID, PCO_PRC_NUM_EXP_EXT, PCO_PRC_NUM_EXP_INT, usuariocrear, fechacrear, SYS_GUID)
				select '||V_ESQUEMA||'.s_pco_prc_procedimientos.nextval, prc_id, COD_WORKFLOW, COD_RECOVERY, '''||USUARIO||''', sysdate, SYS_GUID() AS SYS_GUID
				from (select DISTINCT prc.prc_id, TMP.COD_WORKFLOW, TMP.COD_RECOVERY
					  from '||V_ESQUEMA||'.asu_asuntos asu inner join 
						   '||V_ESQUEMA||'.prc_procedimientos prc on prc.asu_id = asu.asu_id inner join 
						   '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP ON PRC.USUARIOMODIFICAR = TMP.COD_RECOVERY INNER JOIN
						   '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO tpo on tpo.dd_tpo_id = prc.dd_tpo_id left join 
						   '||V_ESQUEMA||'.pco_prc_procedimientos pco on pco.prc_id = prc.prc_id left join 
						   '||V_ESQUEMA||'.pco_prc_hep_histor_est_prep estp on estp.pco_prc_id = pco.pco_prc_id
					  where tpo.dd_tpo_codigo = ''PCO'' and asu.borrado = 0
					  and pco.pco_prc_id is null)';
      
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;
    
	v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS COMPUTE STATISTICS';
	
		EXECUTE IMMEDIATE V_SQL;

--193.643  filas insertadas.

	V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS A
				SET PCO_PRC_TIPO_PRC_PROP = (SELECT DISTINCT TPO.DD_TPO_ID  
											 FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC, '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP, '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO,
											 (SELECT COD_TIPO_PROCEDIMIENTO, DECODE(MIN(DD_TPO_CODIGO) ,''H002'',''H020'',''H018'',''H022'',MIN(DD_TPO_CODIGO)) DD_TPO_CODIGO FROM '||V_ESQUEMA||'.MIG_PARAM_HITOS MPH GROUP BY COD_TIPO_PROCEDIMIENTO) PAR
											 WHERE A.PCO_PRC_NUM_EXP_EXT = EXP.CD_EXPEDIENTE
											 AND EXP.TIPO_PROCEDIMIENTO <> ''P10''
											 AND EXP.TIPO_PROCEDIMIENTO = PAR.COD_TIPO_PROCEDIMIENTO
											 AND PAR.DD_TPO_CODIGO = TPO.DD_TPO_CODIGO
											 AND NOT EXISTS(SELECT 1
															FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA CAB
															WHERE CAB.CD_EXPEDIENTE_NUSE = EXP.CD_EXPEDIENTE)
											  AND PRC.PRC_ID = A.PRC_ID)
				WHERE A.PCO_PRC_NUM_EXP_EXT IN (SELECT CD_EXPEDIENTE FROM '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA WHERE TIPO_PROCEDIMIENTO <> ''P10'')';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;


/*************************************/
/** INSERTAR ESTADO PARALIZADO      **/
/*************************************/    

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, 
					   PCO_PRC_ID,
					   (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PA'') ,-- PARALIZADO
					   NVL(FECHA_PARALIZACION, (SYSDATE-2)) AS PRC_HEP_FECHA_INICIO,
					   '''||USUARIO||''' AS USUARIOCREAR,
					   SYSDATE, SYS_GUID() AS SYS_GUID
				FROM(
				SELECT PCO.PCO_PRC_ID, FECHA_PARALIZACION
				FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
				   , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
				   , '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP
				   , '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS tmp
				WHERE PCO.PRC_ID = PRC.PRC_ID
				  AND PCO.PCO_PRC_NUM_EXP_EXT = EXP.CD_EXPEDIENTE
				  AND EXP.CD_EXPEDIENTE = tmp.COD_RECOVERY  -- Solo procedimientos de precontenciosos "no GAE"
--				  AND EXP.FECHA_ASIGNACION IS NOT NULL -- Pdte de revisión si debe tener fecha asignacion a nulo
				  AND EXP.FECHA_PARALIZACION IS NOT NULL)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;
    
/*************************************/
/** INSERTAR ESTADO ENVIADO         **/
/*************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, 
					   PCO_PRC_ID,
					   (SELECT DD_PCO_PEP_ID FROM DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''EN'') AS DD_PCO_PEP_ID,-- ENVIADO
					   NVL(FECHA_ENVIO_LETRADO, (SYSDATE-2)) AS PRC_HEP_FECHA_INICIO,
					   '''||USUARIO||''' AS USUARIOCREAR,
					   SYSDATE, SYS_GUID() AS SYS_GUID
				FROM(
				SELECT PCO.PCO_PRC_ID, FECHA_ENVIO_LETRADO
				FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
				   , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
				   , '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP
				   , '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS tmp
				WHERE PCO.PRC_ID = PRC.PRC_ID
				  AND PCO.PCO_PRC_NUM_EXP_EXT = EXP.CD_EXPEDIENTE
				  AND EXP.CD_EXPEDIENTE = tmp.COD_RECOVERY  -- Solo procedimientos de precontenciosos "no GAE"	
				  AND EXP.FECHA_ASIGNACION IS NOT NULL      
			      -- No paralizados
				  AND NOT EXISTS(SELECT 1
						   FROM '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP EST
						  WHERE PCO.PCO_PRC_ID = EST.PCO_PRC_ID
						    AND EST.DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PA'')
						)
			      -- enviados
				  AND FECHA_REALIZ_ESTUDIO_SOLV is not null
				  AND FECHA_ENVIO_LETRADO is not null				  
				  )';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

--3.680 filas insertadas.    

/*************************************/
/** INSERTAR ESTADO EN PREPARACION  **/
/*************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, 
					   PCO_PRC_ID,
					   (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PR'') ,-- EN PREPARACION
					   NVL(FECHA_REALIZ_ESTUDIO_SOLV, (SYSDATE-2)) AS PRC_HEP_FECHA_INICIO,
					   '''||USUARIO||''' AS USUARIOCREAR,
					   SYSDATE, SYS_GUID() AS SYS_GUID
				FROM(
				SELECT PCO.PCO_PRC_ID, FECHA_REALIZ_ESTUDIO_SOLV
				FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
				   , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
				   , '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP
				   , '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS tmp
				WHERE PCO.PRC_ID = PRC.PRC_ID
				AND PCO.PCO_PRC_NUM_EXP_EXT = EXP.CD_EXPEDIENTE
				  AND EXP.CD_EXPEDIENTE = tmp.COD_RECOVERY  -- Solo procedimientos de precontenciosos "no GAE"	
				  AND EXP.FECHA_ASIGNACION IS NOT NULL      
				  -- No (paralizados, enviados)
				  AND NOT EXISTS(SELECT 1
						   FROM '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP EST
						  WHERE PCO.PCO_PRC_ID = EST.PCO_PRC_ID
						    AND EST.DD_PCO_PEP_ID IN (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO IN (''PA'', ''EN''))
						)
				-- preparacion
				AND EXP.FECHA_REALIZ_ESTUDIO_SOLV IS NOT NULL)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;


/*************************************/
/** INSERTAR ESTADO EN ESTUDIO      **/
/*************************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP (PCO_PRC_HEP_ID, PCO_PRC_ID, DD_PCO_PEP_ID, PCO_PRC_HEP_FECHA_INCIO, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_PCO_PRC_HEP_HIST_EST_PREP.NEXTVAL, 
					   PCO_PRC_ID,
					   (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PT'') ,-- EN ESTUDIO
					   NVL(FECHA_ASIGNACION, (SYSDATE-2)) AS PRC_HEP_FECHA_INICIO,
					   '''||USUARIO||''' AS USUARIOCREAR,
					   SYSDATE, SYS_GUID() AS SYS_GUID
				FROM(
				SELECT PCO.PCO_PRC_ID, FECHA_ASIGNACION
				FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
				   , '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC
				   , '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP
				   , '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS tmp				   
				WHERE PCO.PRC_ID = PRC.PRC_ID
				AND PCO.PCO_PRC_NUM_EXP_EXT = EXP.CD_EXPEDIENTE
				  AND EXP.CD_EXPEDIENTE = tmp.COD_RECOVERY  -- Solo procedimientos de precontenciosos "no GAE"	
				  AND EXP.FECHA_ASIGNACION IS NOT NULL      
				  -- No (paralizados, enviados, preparados)
				  AND NOT EXISTS(SELECT 1
						   FROM '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP EST
						  WHERE PCO.PCO_PRC_ID = EST.PCO_PRC_ID
						    AND EST.DD_PCO_PEP_ID IN (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO IN (''PA'', ''EN'', ''PR''))
						)
				-- En estudio es el resto
                                )';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

--189.293 filas insertadas.



	V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS A
				SET PCO_PRC_TIPO_PRC_INICIADO = (SELECT DISTINCT TPO.DD_TPO_ID  
											 FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC, '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP, '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO,
											 (SELECT COD_TIPO_PROCEDIMIENTO, DECODE(MIN(DD_TPO_CODIGO) ,''H002'',''H020'',''H018'',''H022'',MIN(DD_TPO_CODIGO)) DD_TPO_CODIGO FROM '||V_ESQUEMA||'.MIG_PARAM_HITOS MPH GROUP BY COD_TIPO_PROCEDIMIENTO) PAR
											 WHERE A.PCO_PRC_NUM_EXP_EXT = EXP.CD_EXPEDIENTE
											 AND EXP.TIPO_PROCEDIMIENTO <> ''P10''
											 AND EXP.TIPO_PROCEDIMIENTO = PAR.COD_TIPO_PROCEDIMIENTO
											 AND PAR.DD_TPO_CODIGO = TPO.DD_TPO_CODIGO
											 AND NOT EXISTS(SELECT 1
															FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA CAB
															WHERE CAB.CD_EXPEDIENTE_NUSE = EXP.CD_EXPEDIENTE)
											  AND PRC.PRC_ID = A.PRC_ID)
				WHERE A.PCO_PRC_NUM_EXP_EXT IN (SELECT CD_EXPEDIENTE FROM MIG_EXPEDIENTES_CABECERA WHERE TIPO_PROCEDIMIENTO <> ''P10'')
				AND A.PCO_PRC_ID IN (SELECT PCO_PRC_ID FROM PCO_PRC_HEP_HISTOR_EST_PREP WHERE DD_PCO_PEP_ID IN (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO IN (''EN'')))';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

/*****************************
*   TAR_TAREAS_NOTIFICACIONES *
******************************/

	v_SQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''IDX_PCO_PRC_HEP_HISTOR_EST1''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
		v_SQL := 'CREATE INDEX IDX_PCO_PRC_HEP_HISTOR_EST1 ON '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP(PCO_PRC_ID)';
			
		EXECUTE IMMEDIATE V_SQL;
		
	END IF;	
	
	V_SQL := 'ANALYZE TABLE PCO_PRC_HEP_HISTOR_EST_PREP COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;
	
	
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
					TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_EMISOR, 
					VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL,
					   null AS EXP_ID,
					   ASU.ASU_ID,
					   6 AS DD_EST_ID,
					   5 AS DD_EIN_ID,
					   NVL(tap.dd_sta_id,39) AS DD_STA_ID, -- 39 = TAREA EXTERNA (GESTOR)
					   1 AS TAR_CODIGO,
					   TAP.TAP_CODIGO TAR_TAREA,
					   TAP.TAP_DESCRIPCION AS TAR_DESCRIPCION, 
					   NVL(EXP.FECHA_ASIGNACION, TRUNC(SYSDATE)) AS TAR_FECHA_INI,
					   0 AS TAR_EN_ESPERA,
					   0 AS TAR_ALERTA,
					   ''AUTOMATICA'' AS TAR_EMISOR,
					   0 AS VERSION, 
					   '''||USUARIO||''' AS USUARIOCREAR,
					   SYSDATE AS FECHACREAR,
					   0 AS BORRADO,
					   PRC.PRC_ID,
					   ''EXTTareaNotificacion'' AS DTYPE,
					   0 AS NFA_TAR_REVISADA,
					   SYS_GUID() AS SYS_GUID
				FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN
					 '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP ON EXP.CD_EXPEDIENTE = TMP.COD_RECOVERY INNER JOIN
					 '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID_EXTERNO = EXP.CD_EXPEDIENTE INNER JOIN
					 '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID = PRC.PRC_ID INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PT'') --EN ESTUDIO
					 INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP_CODIGO = ''PCO_RevisarExpedientePreparar''';
     
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
					TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_EMISOR, 
					VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL,
					   null AS EXP_ID,
					   ASU.ASU_ID,
					   6 AS DD_EST_ID,
					   5 AS DD_EIN_ID,
					   NVL(tap.dd_sta_id,39) AS DD_STA_ID, -- 39 = TAREA EXTERNA (GESTOR)
					   1 AS TAR_CODIGO,
					   TAP.TAP_CODIGO TAR_TAREA,
					   TAP.TAP_DESCRIPCION AS TAR_DESCRIPCION, 
					   NVL(EXP.FECHA_REALIZ_ESTUDIO_SOLV, TRUNC(SYSDATE)) AS TAR_FECHA_INI,
					   0 AS TAR_EN_ESPERA,
					   0 AS TAR_ALERTA,
					   ''AUTOMATICA'' AS TAR_EMISOR,
					   0 AS VERSION, 
					   '''||USUARIO||''' AS USUARIOCREAR,
					   SYSDATE AS FECHACREAR,
					   0 AS BORRADO,
					   PRC.PRC_ID,
					   ''EXTTareaNotificacion'' AS DTYPE,
					   0 AS NFA_TAR_REVISADA,
					   SYS_GUID() AS SYS_GUID
				FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN
					 '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP ON EXP.CD_EXPEDIENTE = TMP.COD_RECOVERY INNER JOIN
					 '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID_EXTERNO = EXP.CD_EXPEDIENTE INNER JOIN
					 '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID = PRC.PRC_ID INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PR'') --EN PREPARACION
					 INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP_CODIGO = ''PCO_PrepararExpediente''';
     
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
  
--189.293 filas insertadas.

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, EXP_ID, ASU_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, 
					TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_EMISOR, 
					VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PRC_ID, DTYPE, NFA_TAR_REVISADA, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL, Z.* FROM(
				SELECT DISTINCT
					   null AS EXP_ID,
					   ASU.ASU_ID,
					   6 AS DD_EST_ID,
					   5 AS DD_EIN_ID,
					   NVL(tap.dd_sta_id,39) AS DD_STA_ID, -- TAREA EXTERNA (GESTOR)
					   1 AS TAR_CODIGO,
					   TAP.TAP_CODIGO AS TAR_TAREA,
					   TAP.TAP_DESCRIPCION AS TAR_DESCRIPCION, 
					   NVL(EXP.FECHA_ENVIO_LETRADO, TRUNC(SYSDATE)) AS TAR_FECHA_INI,
					   0 AS TAR_EN_ESPERA,
					   0 AS TAR_ALERTA,
					   ''AUTOMATICA'' AS TAR_EMISOR,
					   0 AS VERSION, 
					   '''||USUARIO||''' AS USUARIOCREAR,
					   SYSDATE AS FECHACREAR,
					   0 AS BORRADO,
					   PRC.PRC_ID,
					   ''EXTTareaNotificacion'' AS DTYPE,
					   0 AS NFA_TAR_REVISADA,
					   SYS_GUID() AS SYS_GUID					   
				FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN
					 '||V_ESQUEMA||'.MIG_EXPEDIENTES_CABECERA EXP ON EXP.CD_EXPEDIENTE = TMP.COD_RECOVERY INNER JOIN
					 '||V_ESQUEMA||'.ASU_ASUNTOS ASU ON ASU.ASU_ID_EXTERNO = EXP.CD_EXPEDIENTE INNER JOIN
					 '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.ASU_ID = ASU.ASU_ID INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID = PRC.PRC_ID INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''EN'') -- ENVIADO
					 INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP_CODIGO = ''PCO_RegistrarTomaDec'') Z';
     
-- 3.703 filas insertadas.
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
  
	V_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;

/*****************************
*   TEX_TAREA_EXTERNA        *
******************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA(TEX_ID, TAR_ID, TAP_ID, TEX_DETENIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TEX_CANCELADA, TEX_NUM_AUTOP, DTYPE)
				SELECT '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL,
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
				  FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR, '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
				  WHERE TAR.USUARIOCREAR = '''||USUARIO||'''
          AND TAR.TAR_TAREA = TAP.TAP_CODIGO';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
  
  v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;
  
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET TAR_TAREA=(SELECT TAP_DESCRIPCION FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''PCO_RevisarExpedientePreparar'')
              WHERE TAR_TAREA=''PCO_RevisarExpedientePreparar''';

  EXECUTE IMMEDIATE V_SQL; 
  
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);
  
  commit;

    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET TAR_TAREA=(SELECT TAP_DESCRIPCION FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''PCO_PrepararExpediente'')
              WHERE TAR_TAREA=''PCO_PrepararExpediente''';

  EXECUTE IMMEDIATE V_SQL; 
  
  DBMS_OUTPUT.PUT_LINE(substr(V_SQL, 1, 60) || '...' || sql%rowcount);
  
  commit;

    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET TAR_TAREA=(SELECT TAP_DESCRIPCION FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''PCO_RegistrarTomaDec'')
              WHERE TAR_TAREA=''PCO_RegistrarTomaDec''';

  EXECUTE IMMEDIATE V_SQL; 
  
  DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
  COMMIT;

/*****************************
*   PCO_DOCUMENTOS           *
******************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS (PCO_DOC_PDD_ID, PCO_PRC_ID, DD_PCO_DED_ID, DD_PCO_DTD_ID, DD_TFA_ID, PCO_DOC_PDD_UG_ID, PCO_DOC_PDD_UG_DESC, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_PCO_DOC_DOCUMENTOS.NEXTVAL,
					   PCO.PCO_PRC_ID,
					   DED.DD_PCO_DED_ID,
					   DTD.DD_PCO_DTD_ID, 
					   CONF.DD_TFA_ID,
					   CNT.CNT_ID,
					   CNT.CNT_CONTRATO, 
					   '''||USUARIO||''',
					   SYSDATE,
					   SYS_GUID() AS SYS_GUID
				  FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
					INNER JOIN '||V_ESQUEMA||'.DD_PCO_DOC_ESTADO DED ON DED.DD_PCO_DED_CODIGO = ''PS''
					INNER JOIN '||V_ESQUEMA||'.DD_PCO_DOC_UNIDADGESTION DTD ON DTD.DD_PCO_DTD_CODIGO = ''CO''
					INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=PCO.PRC_ID
					INNER JOIN '||V_ESQUEMA||'.PCO_CDE_CONF_TFA_TIPOENTIDAD CONF ON CONF.DD_PCO_DTD_ID=DTD.DD_PCO_DTD_ID AND CONF.DD_TPO_ID=PCO.PCO_PRC_TIPO_PRC_PROP
					INNER JOIN '||V_ESQUEMA||'.PRC_CEX PCEX ON PCEX.PRC_ID = PCO.PRC_ID
					INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PCEX.CEX_ID
					INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID=CEX.CNT_ID
					INNER JOIN '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''EN'')'; -- ENVIADO
    
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;
--18.726 filas insertadas.

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS (PCO_DOC_PDD_ID, PCO_PRC_ID, DD_PCO_DED_ID, DD_PCO_DTD_ID, DD_TFA_ID, PCO_DOC_PDD_UG_ID, PCO_DOC_PDD_UG_DESC, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_PCO_DOC_DOCUMENTOS.NEXTVAL,
					   PCO.PCO_PRC_ID,
					   DED.DD_PCO_DED_ID,
					   DTD.DD_PCO_DTD_ID, 
					   CONF.DD_TFA_ID,
					   PER.PER_ID,
					   PER.PER_NOM50,
					   '''||USUARIO||''',
					   SYSDATE,
					   SYS_GUID() AS SYS_GUID
				  FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
					INNER JOIN '||V_ESQUEMA||'.DD_PCO_DOC_ESTADO DED ON DED.DD_PCO_DED_CODIGO = ''PS''
					INNER JOIN '||V_ESQUEMA||'.DD_PCO_DOC_UNIDADGESTION DTD ON DTD.DD_PCO_DTD_CODIGO = ''PE''
					INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=PCO.PRC_ID
					INNER JOIN '||V_ESQUEMA||'.PCO_CDE_CONF_TFA_TIPOENTIDAD CONF ON CONF.DD_PCO_DTD_ID=DTD.DD_PCO_DTD_ID AND CONF.DD_TPO_ID=PCO.PCO_PRC_TIPO_PRC_PROP
					INNER JOIN '||V_ESQUEMA||'.PRC_CEX PCEX ON PCEX.PRC_ID = PCO.PRC_ID
					INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PCEX.CEX_ID
					INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID=CEX.CNT_ID
					INNER JOIN '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID
					INNER JOIN '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE PEX ON PEX.PER_ID = CPE.PER_ID AND PEX.PEX_PASE = 1 AND PEX.EXP_ID = CEX.EXP_ID
					INNER JOIN '||V_ESQUEMA||'.PER_PERSONAS PER ON PER.PER_ID = PEX.PER_ID
					INNER JOIN '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''EN'')'; -- ENVIADO
    
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
    COMMIT;

-- FALTAN INSERTS EN PCO_CONF_TFA_TIPOENTIDAD


/*****************************
*   PCO_LIQUIDACIONES        *
******************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES (PCO_LIQ_ID, PCO_PRC_ID, DD_PCO_LIQ_ID, CNT_ID, USUARIOCREAR, FECHACREAR, SYS_GUID)
				select '||V_ESQUEMA||'.S_PCO_LIQ_LIQUIDACIONES.NEXTVAL,
					   PCO.PCO_PRC_ID,
					   LE.DD_PCO_LIQ_ID, 
					   CNT.CNT_ID,
					   '''||USUARIO||''',
					   SYSDATE,
					   SYS_GUID() AS SYS_GUID
				FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
					INNER JOIN '||V_ESQUEMA||'.DD_PCO_LIQ_ESTADO LE ON LE.DD_PCO_LIQ_CODIGO = ''PEN''
					INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=PCO.PRC_ID
					INNER JOIN '||V_ESQUEMA||'.PRC_CEX PCEX ON PCEX.PRC_ID = PCO.PRC_ID
					INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PCEX.CEX_ID
					INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID=CEX.CNT_ID
					INNER JOIN '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''EN'')'; -- ENVIADO


	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);   
  
    COMMIT;
--193.643 filas insertadas.

/*****************************
*   PCO_BUROFAX              *
******************************/

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_BUR_BUROFAX (PCO_BUR_BUROFAX_ID, PCO_PRC_ID, PER_ID, DD_PCO_BFE_ID, CNT_ID, DD_TIN_ID, USUARIOCREAR, FECHACREAR, SYS_GUID)
				SELECT '||V_ESQUEMA||'.S_PCO_BUR_BUROFAX_ID.NEXTVAL,
					   PCO.PCO_PRC_ID,
					   CPE.PER_ID,
					   BFE.DD_PCO_BFE_ID, 
					   CPE.CNT_ID,
					   CPE.DD_TIN_ID,
					   '''||USUARIO||''',
					   SYSDATE,
					   SYS_GUID() AS SYS_GUID
				FROM '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
					INNER JOIN '||V_ESQUEMA||'.DD_PCO_BFE_ESTADO BFE ON BFE.DD_PCO_BFE_CODIGO=''KO''
					INNER JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID=PCO.PRC_ID
					INNER JOIN '||V_ESQUEMA||'.PRC_CEX PCEX ON PCEX.PRC_ID = PCO.PRC_ID
					INNER JOIN '||V_ESQUEMA||'.CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CEX_ID = PCEX.CEX_ID
					INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS CNT ON CNT.CNT_ID=CEX.CNT_ID
					INNER JOIN '||V_ESQUEMA||'.CPE_CONTRATOS_PERSONAS CPE ON CPE.CNT_ID = CNT.CNT_ID
					INNER JOIN '||V_ESQUEMA||'.PEX_PERSONAS_EXPEDIENTE PEX ON PEX.PER_ID = CPE.PER_ID AND PEX.PEX_PASE = 1 AND PEX.EXP_ID = CEX.EXP_ID
					INNER JOIN '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''EN'')'; -- ENVIADO
    
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
--193.657 filas insertadas.

    
/**********************/
/** Insertar en tabla para BPMS  **/
/**********************/

	V_SQL := 'Delete from '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1';
  
  EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
  
  COMMIT;

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1(PRC_ID,	TAP_ID)
				(SELECT DISTINCT PRC.prc_id, (SELECT tap.tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento tap where tap.tap_codigo = ''PCO_RevisarExpedientePreparar'')
				FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
					 '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.USUARIOMODIFICAR = TMP.COD_RECOVERY INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID = PRC.PRC_ID INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''PT'')
					 )';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

	COMMIT;

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1(PRC_ID,	TAP_ID)
				(SELECT DISTINCT PRC.prc_id, (SELECT tap.tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento tap where tap.tap_codigo = ''PCO_RegistrarTomaDec'')
				FROM '||V_ESQUEMA||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP INNER JOIN 
					 '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.USUARIOMODIFICAR = TMP.COD_RECOVERY INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID = PRC.PRC_ID INNER JOIN
					 '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP HIS ON HIS.PCO_PRC_ID = PCO.PCO_PRC_ID AND DD_PCO_PEP_ID = (SELECT DD_PCO_PEP_ID FROM '||V_ESQUEMA||'.DD_PCO_PRC_ESTADO_PREPARACION WHERE DD_PCO_PEP_CODIGO = ''EN'')
					 )';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
  
  v_SQL := 'ANALYZE TABLE '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 COMPUTE STATISTICS';
	
	EXECUTE IMMEDIATE V_SQL;
  
-- Limpiando restos de ejecuciones anteriores

	V_SQL := 'UPDATE '||V_ESQUEMA||'.tar_tareas_notificaciones
			   SET t_referencia = NULL
			 WHERE t_referencia IS NOT NULL';
 
 	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
 
  COMMIT;
  
	V_SQL := 'UPDATE '||V_ESQUEMA||'.tex_tarea_externa
			   SET t_referencia = NULL
			 WHERE t_referencia IS NOT NULL';
 
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

	V_SQL := 'UPDATE '||V_ESQUEMA_MASTER||'.jbpm_token
				SET t_referencia = NULL
			  WHERE t_referencia IS NOT NULL';

	EXECUTE IMMEDIATE V_SQL;
	
  DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount); 

	  COMMIT;
  
  V_SQL := 'UPDATE '||V_ESQUEMA_MASTER||'.jbpm_processinstance
				SET t_referencia = NULL
			  WHERE t_referencia IS NOT NULL';
 
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

	V_SQL := 'UPDATE '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1
				SET t_referencia = ROWNUM';


	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR USING
				(SELECT PRC_ID, T_REFERENCIA
				 FROM '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 TMP) TMP
				 ON (TAR.PRC_ID = TMP.PRC_ID)
				WHEN MATCHED THEN 
				  UPDATE SET TAR.T_REFERENCIA = TMP.T_REFERENCIA';
  
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

	V_SQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX
				SET T_REFERENCIA = (SELECT TAR.T_REFERENCIA FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR WHERE TAR.TAR_ID = TEX.TAR_ID AND TAR.T_REFERENCIA IS NOT NULL)
				WHERE USUARIOCREAR='''||USUARIO||'''';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);


  COMMIT;

	V_SQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.jbpm_processinstance
            (id_, version_, start_, end_, issuspended_, processdefinition_,
             t_referencia)
			   SELECT '||V_ESQUEMA_MASTER||'.hibernate_sequence.NEXTVAL, 1 version_, SYSDATE start_,
					  NULL end_, 0 issuspended_, maxpd.id_ processdefinition_,
					  tmp.t_referencia
				 FROM '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 tmp
					  JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
					  JOIN '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo ON tap.dd_tpo_id = tpo.dd_tpo_id
					  JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones tar
					  ON tmp.t_referencia = tar.t_referencia
					  JOIN
					  (SELECT   name_, MAX (id_) id_
						   FROM '||V_ESQUEMA_MASTER||'.jbpm_processdefinition
					   GROUP BY name_) maxpd ON tpo.dd_tpo_xml_jbpm = maxpd.name_
					  ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

	
		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.prc_procedimientos t1
				   USING (SELECT prc.prc_id, prc.prc_process_bpm viejo, pi.id_ nuevo
							FROM '||V_ESQUEMA||'.prc_procedimientos prc
								 JOIN '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 tmp ON prc.prc_id = tmp.prc_id
								 JOIN '||V_ESQUEMA_MASTER||'.jbpm_processinstance pi
								 ON tmp.t_referencia = pi.t_referencia
								 ) q
				   ON (t1.prc_id = q.prc_id)
				   WHEN MATCHED THEN
					  UPDATE
						 SET t1.prc_process_bpm = q.nuevo';
         
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
    
  
    COMMIT;
    
    	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.prc_procedimientos t1
				   USING (SELECT prc.prc_id, prc.dd_tpo_id viejo, tap.dd_tpo_id nuevo
										   FROM '||V_ESQUEMA||'.prc_procedimientos prc
										   JOIN '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 tmp ON prc.prc_id = tmp.prc_id
										   JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
												) q
				   ON (t1.prc_id = q.prc_id)
				   WHEN MATCHED THEN
					  UPDATE
						 SET t1.dd_tpo_id = q.nuevo';
         
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
  
	V_SQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.jbpm_token
            (id_, version_, start_, end_, nodeenter_, issuspended_, node_,
             processinstance_, t_referencia)
			   SELECT '||V_ESQUEMA_MASTER||'.hibernate_sequence.NEXTVAL, 1 version_, SYSDATE start_,
					  NULL end_, SYSDATE nodeenter_, 0 issuspended_, node.id_ node_,
					  pi.id_ processinstance_, tmp.t_referencia
				 FROM '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 tmp JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones tar
					  ON tmp.t_referencia = tar.t_referencia
					  JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tmp.tap_id = tap.tap_id
					  JOIN '||V_ESQUEMA||'.prc_procedimientos prc ON tmp.prc_id = prc.prc_id
					  JOIN '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo ON prc.dd_tpo_id = tpo.dd_tpo_id
					  JOIN
					  (SELECT   name_, MAX (id_) id_
						   FROM '||V_ESQUEMA_MASTER||'.jbpm_processdefinition
					   GROUP BY name_) maxpd ON tpo.dd_tpo_xml_jbpm = maxpd.name_
					  JOIN '||V_ESQUEMA_MASTER||'.jbpm_node node
					  ON maxpd.id_ = node.processdefinition_
					AND tap.tap_codigo = node.name_
					  JOIN '||V_ESQUEMA_MASTER||'.jbpm_processinstance pi
					  ON tmp.t_referencia = pi.t_referencia
					  ';
          
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);


  COMMIT;     
     
     	V_SQL := 'MERGE INTO '||V_ESQUEMA_MASTER||'.jbpm_processinstance t1
					 USING (SELECT pi.ID_, pi.roottoken_ viejo, tk.id_ nuevo
										   FROM '||V_ESQUEMA_MASTER||'.jbpm_processinstance pi JOIN '||V_ESQUEMA_MASTER||'.jbpm_token tk
												ON pi.t_referencia = tk.t_referencia
												) q
					 ON (t1.ID_ = q.ID_)
					 WHEN MATCHED THEN
					  UPDATE SET t1.roottoken_ = q.nuevo';


	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

			V_SQL := 'merge INTO '||V_ESQUEMA||'.tex_tarea_externa t1 
						using (SELECT tex.tex_id, tex.tex_token_id_bpm viejo, tk.id_ nuevo
										   FROM '||V_ESQUEMA||'.tex_tarea_externa tex JOIN '||V_ESQUEMA_MASTER||'.jbpm_token tk
												ON tex.t_referencia = tk.t_referencia
												) q
											on (t1.tex_id = q.tex_id)
											when matched then
											update
											set t1.tex_token_id_bpm = q.nuevo';
   
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

	V_SQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.jbpm_moduleinstance
            (id_, class_, version_, processinstance_, name_)
			   SELECT '||V_ESQUEMA_MASTER||'.hibernate_sequence.NEXTVAL, ''C'' class_, 0 version_,
					  prc.prc_process_bpm processinstance_,
					  ''org.jbpm.context.exe.ContextInstance'' name_
				 FROM '||V_ESQUEMA||'.prc_procedimientos prc JOIN '||V_ESQUEMA_MASTER||'.jbpm_processinstance pi
					  ON prc.prc_process_bpm = pi.id_
					  JOIN '||V_ESQUEMA_MASTER||'.jbpm_token tk ON pi.roottoken_ = tk.id_
					  JOIN '||V_ESQUEMA_MASTER||'.jbpm_node nd ON tk.node_ = nd.id_
					  JOIN '||V_ESQUEMA||'.tex_tarea_externa tex
					  ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
					  JOIN '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 ug ON ug.prc_id = prc.prc_id
				WHERE NOT EXISTS (SELECT 1
									FROM '||V_ESQUEMA_MASTER||'.jbpm_moduleinstance
								   WHERE processinstance_ = prc.prc_process_bpm)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

			V_SQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.jbpm_variableinstance
								(id_, class_, version_, name_, token_, tokenvariablemap_,
								 processinstance_, longvalue_)
					   SELECT '||V_ESQUEMA_MASTER||'.hibernate_sequence.NEXTVAL, ''L'' class_, 0 version_,
							  ''procedimientoTareaExterna'' name_, pi.roottoken_ tokem_,
							  vm.id_ tokenvariablemap_, pi.id_ processinstance_,
							  prc.prc_id longvlaue_
						 FROM '||V_ESQUEMA||'.prc_procedimientos prc JOIN '||V_ESQUEMA_MASTER||'.jbpm_processinstance pi
							  ON prc.prc_process_bpm = pi.id_
							  JOIN '||V_ESQUEMA_MASTER||'.jbpm_tokenvariablemap vm ON pi.roottoken_ =
																						 vm.token_
							  JOIN '||V_ESQUEMA_MASTER||'.jbpm_token tk ON pi.roottoken_ = tk.id_
							  JOIN '||V_ESQUEMA_MASTER||'.jbpm_node nd ON tk.node_ = nd.id_
							  JOIN '||V_ESQUEMA||'.tex_tarea_externa tex
							  ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
						WHERE NOT EXISTS (
								 SELECT 1
								   FROM '||V_ESQUEMA_MASTER||'.jbpm_variableinstance
								  WHERE processinstance_ = pi.id_
									AND name_ = ''procedimientoTareaExterna'')';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

			V_SQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.jbpm_variableinstance
								(id_, class_, version_, name_, token_, tokenvariablemap_,
								 processinstance_, longvalue_)
					   SELECT '||V_ESQUEMA_MASTER||'.hibernate_sequence.NEXTVAL, ''L'' class_, 0 version_,
							  ''bpmParalizado'' name_, pi.roottoken_ tokem_,
							  vm.id_ tokenvariablemap_, pi.id_ processinstance_, 0 longvlaue_
						 FROM '||V_ESQUEMA||'.prc_procedimientos prc JOIN '||V_ESQUEMA_MASTER||'.jbpm_processinstance pi
							  ON prc.prc_process_bpm = pi.id_
							  JOIN '||V_ESQUEMA_MASTER||'.jbpm_tokenvariablemap vm ON pi.roottoken_ =
																						 vm.token_
							  JOIN '||V_ESQUEMA_MASTER||'.jbpm_token tk ON pi.roottoken_ = tk.id_
							  JOIN '||V_ESQUEMA_MASTER||'.jbpm_node nd ON tk.node_ = nd.id_
							  JOIN '||V_ESQUEMA||'.tex_tarea_externa tex
							  ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
						WHERE NOT EXISTS (
									   SELECT *
										 FROM '||V_ESQUEMA_MASTER||'.jbpm_variableinstance
										WHERE processinstance_ = pi.id_
											  AND name_ = ''bpmParalizado'')';

	EXECUTE IMMEDIATE V_SQL;
	
  DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

	  COMMIT;
  
  V_SQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.jbpm_variableinstance
						(id_, class_, version_, name_, token_, tokenvariablemap_,
						 processinstance_, longvalue_)
			   SELECT '||V_ESQUEMA_MASTER||'.hibernate_sequence.NEXTVAL, ''L'' class_, 0 version_,
					  ''id'' || nd.name_ name_, pi.roottoken_ tokem_,
					  vm.id_ tokenvariablemap_, pi.id_ processinstance_,
					  tex.tex_id longvlaue_
				 FROM '||V_ESQUEMA||'.prc_procedimientos prc JOIN '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 tmp
					  ON prc.prc_id = tmp.prc_id
					  JOIN '||V_ESQUEMA_MASTER||'.jbpm_processinstance pi ON prc.prc_process_bpm =
																					pi.id_
					  JOIN '||V_ESQUEMA_MASTER||'.jbpm_token tk ON pi.roottoken_ = tk.id_
					  JOIN '||V_ESQUEMA_MASTER||'.jbpm_node nd ON tk.node_ = nd.id_
					  JOIN '||V_ESQUEMA_MASTER||'.jbpm_tokenvariablemap vm ON pi.roottoken_ =
																				 vm.token_
					  JOIN '||V_ESQUEMA||'.tex_tarea_externa tex
					  ON tk.id_ = tex.tex_token_id_bpm AND tex.borrado = 0
				WHERE NOT EXISTS (
							  SELECT *
								FROM '||V_ESQUEMA_MASTER||'.jbpm_variableinstance
							   WHERE processinstance_ = pi.id_
									 AND name_ = ''id'' || nd.name_)
				  AND tex.usuariocrear = '''||USUARIO||'''';

	EXECUTE IMMEDIATE V_SQL;
	
  DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
  
  
	V_SQL := 'UPDATE '||V_ESQUEMA_MASTER||'.jbpm_token
			   SET nextlogindex_ = 0
			 WHERE nextlogindex_ IS NULL';
       
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
 
  COMMIT;       
 
	V_SQL := 'UPDATE '||V_ESQUEMA_MASTER||'.jbpm_token
			   SET isabletoreactivateparent_ = 0
			 WHERE isabletoreactivateparent_ IS NULL';
 
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
 
  COMMIT;


	V_SQL := 'UPDATE '||V_ESQUEMA_MASTER||'.jbpm_token
			   SET isterminationimplicit_ = 0
			 WHERE isterminationimplicit_ IS NULL';
 
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);
 
  COMMIT;

 	V_SQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.jbpm_transition
            (id_, name_, processdefinition_, from_, to_, fromindex_)
			   SELECT '||V_ESQUEMA_MASTER||'.hibernate_sequence.NEXTVAL id_, ''activarProrroga'' name_,
					  pd processdefinition_, nd from_, nd to_,
					  (max_fromindex + 1) fromindex_
				 FROM (SELECT   nd.id_ nd, nd.processdefinition_ pd,
								MAX (aux.fromindex_) max_fromindex
						   FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tar JOIN '||V_ESQUEMA||'.tex_tarea_externa tex
								ON tar.tar_id = tex.tar_id
								JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id =
																				tap.tap_id
								JOIN '||V_ESQUEMA||'.prc_procedimientos prc ON tar.prc_id = prc.prc_id
								JOIN '||V_ESQUEMA_MASTER||'.jbpm_processinstance pi
								ON prc.prc_process_bpm = pi.id_
								JOIN '||V_ESQUEMA_MASTER||'.jbpm_token tk ON pi.roottoken_ = tk.id_
								JOIN '||V_ESQUEMA_MASTER||'.jbpm_node nd ON tk.node_ = nd.id_
								JOIN '||V_ESQUEMA||'.TMP_BPM_INPUT_CON1 ug ON prc.prc_id =
																				 ug.prc_id
								LEFT JOIN '||V_ESQUEMA_MASTER||'.jbpm_transition aux
								ON nd.id_ = aux.from_
								LEFT JOIN '||V_ESQUEMA_MASTER||'.jbpm_transition tr
								ON nd.id_ = tr.from_ AND tr.name_ = ''activarProrroga''
						  WHERE tar.borrado = 0
							AND (   tar.tar_tarea_finalizada IS NULL
								 OR tar.tar_tarea_finalizada = 0
								)
							AND tar.prc_id IS NOT NULL
							AND tap.tap_autoprorroga = 1
							AND tr.id_ IS NULL
					   GROUP BY nd.id_, nd.processdefinition_)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);


  COMMIT;
-- Ponemos fechas de vencimiento 

	V_SQL := 'UPDATE '||V_ESQUEMA||'.tar_tareas_notificaciones
			   SET tar_fecha_venc = SYSDATE + (DBMS_RANDOM.VALUE (1, 5))
			 WHERE fechacrear > SYSDATE - 1
			   AND tar_fecha_venc IS NULL
			   AND prc_id IS NOT NULL
			   AND tar_tarea_finalizada = 0
			   AND tar_tar_id IS NULL
			   AND USUARIOCREAR = '''||USUARIO||'''';
   
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;

	V_SQL := 'UPDATE '||V_ESQUEMA||'.tar_tareas_notificaciones
			   SET tar_fecha_venc_real = tar_fecha_venc
			 WHERE tar_fecha_venc IS NOT NULL AND tar_fecha_venc_real IS NULL
			 AND USUARIOCREAR = '''||USUARIO||'''';
 
 
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE(RPAD(substr(V_SQL, 1, 60), 60, ' ') || '...' || sql%rowcount);

  COMMIT;
 
  DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR MIGRACION PRECONTENCIOSO.sql');    
   
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
