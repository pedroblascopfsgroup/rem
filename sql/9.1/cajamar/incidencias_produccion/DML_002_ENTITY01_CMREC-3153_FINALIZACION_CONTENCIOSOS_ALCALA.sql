--/*
--##########################################
--## AUTOR=JAIME
--## FECHA_CREACION=20160419
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3153
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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

    USUARIO varchar2(50 CHAR) := 'CMREC-3137:FINALIZACION ALCALA CONTENCIOSOS';

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] CAJAMAR-HRE FINALIZACION ALCALA CONTENCIOSO');

	V_SQL := 'INSERT INTO '||v_esquema||'.DPR_DECISIONES_PROCEDIMIENTOS	(DPR_ID,PRC_ID,TAR_ID,DPR_FINALIZA,DPR_PARALIZA,DD_CDE_ID,DD_EDE_ID,DPR_PROCESS_BPM,DPR_FECHA_PARA,DPR_COMENTARIOS,USUARIOCREAR,FECHACREAR,DD_DFI_ID,DD_DPA_ID,DPR_ENTIDAD)
			SELECT '||v_esquema||'.S_DPR_DEC_PROCEDIMIENTOS.nextval,
			       PRC_ID,
			       NULL TAR_ID,
			       1 DPR_FINALIZA,
			       0 DPR_PARALIZA,
			       NULL DD_CDE_ID,
			       dd_ede_id,
			       NULL DPR_PROCESS_BPM,
			       NULL DPR_FECHA_PARA,
			       ''FINALIZACION CONTRATO ALCALA CONTENCIOSO'' DPR_COMENTARIOS,
			       '''||USUARIO||''' AS USUARIOCREAR,
			       sysdate AS FECHACREAR,
			       dd_df_id,
			       dd_dpa_id,
			       NULL DPR_ENTIDAD
			FROM (
			  SELECT MAX(prc.prc_id) PRC_ID,
				(SELECT ede.DD_EDE_ID FROM '||v_esquema_MASTER||'.DD_EDE_ESTADOS_DECISION ede WHERE ede.DD_EDE_CODIGO = ''03'' ) dd_ede_id,
				(SELECT DD_DFI_ID FROM '||v_esquema||'.DD_DFI_DECISION_FINALIZAR WHERE DD_DFI_CODIGO = ''INSTRUC'' ) dd_df_id,
				null dd_dpa_id
			  FROM '||v_esquema||'.CNT_CONTRATOS CNT, '||v_esquema||'.DD_CRE_CONDICIONES_REMUN_EXT CRE, '||v_esquema||'.CEX_CONTRATOS_EXPEDIENTE CEX, '||v_esquema||'.EXP_EXPEDIENTES EXP, '||v_esquema||'.ASU_ASUNTOS ASU, '||v_esquema||'.PRC_PROCEDIMIENTOS PRC
			  WHERE CNT.DD_CRE_ID = CRE.DD_CRE_ID
			  AND DD_CRE_CODIGO=''AL''
			  AND CNT.CNT_ID = CEX.CNT_ID
			  AND CEX.EXP_ID = EXP.EXP_ID
			  AND EXP.EXP_ID = ASU.EXP_ID
			  AND ASU.ASU_ID = PRC.ASU_ID
			  AND NOT EXISTS(SELECT 1
					 FROM '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS PCO
					 WHERE PCO.PRC_ID = PRC.PRC_ID)
			  GROUP BY ASU.ASU_ID
			  )';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - INSERT (1) EN DPR_DECISIONES_PROCEDIMIENTOS... '||SQL%ROWCOUNT||' Filas');
    Commit;

	V_SQL:= 'UPDATE '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES TAR
			SET TAR_FECHA_FIN = SYSDATE,
			    TAR_TAREA_FINALIZADA = 1,
			    USUARIOMODIFICAR = '''||USUARIO||''',
			    FECHAMODIFICAR =SYSDATE
			WHERE TAR.TAR_FECHA_FIN IS NULL
			AND NOT EXISTS(SELECT 1
				       FROM '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS PCO
				       WHERE PCO.PRC_ID = TAR.PRC_ID)
			AND TAR.ASU_ID IN (SELECT DISTINCT ASU.ASU_ID
					FROM '||v_esquema||'.CNT_CONTRATOS CNT, '||v_esquema||'.DD_CRE_CONDICIONES_REMUN_EXT CRE, '||v_esquema||'.CEX_CONTRATOS_EXPEDIENTE CEX, '||v_esquema||'.EXP_EXPEDIENTES EXP, '||v_esquema||'.ASU_ASUNTOS ASU, '||v_esquema||'.PRC_PROCEDIMIENTOS PRC
					WHERE CNT.DD_CRE_ID = CRE.DD_CRE_ID
					AND DD_CRE_CODIGO=''AL''
					AND CNT.CNT_ID = CEX.CNT_ID
					AND CEX.EXP_ID = EXP.EXP_ID
					AND EXP.EXP_ID = ASU.EXP_ID
					AND ASU.ASU_ID = PRC.ASU_ID
					)';
          
    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - UPDATE(1) EN TAR. FINALIZAMOS TAREAS PENDIENTES... '||SQL%ROWCOUNT||' Filas');
    Commit;

    V_SQL := 'UPDATE '||v_esquema||'.PRC_PROCEDIMIENTOS
		  SET DD_EPR_ID = (SELECT DD_EPR_ID FROM '||v_esquema_MASTER||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_DESCRIPCION = ''Cerrado''),
		      USUARIOMODIFICAR = '''||USUARIO||''',
		      FECHAMODIFICAR =SYSDATE
		WHERE PRC_ID IN (
		  SELECT MAX(prc.prc_id) PRC_ID
		  FROM '||v_esquema||'.CNT_CONTRATOS CNT, '||v_esquema||'.DD_CRE_CONDICIONES_REMUN_EXT CRE, '||v_esquema||'.CEX_CONTRATOS_EXPEDIENTE CEX, '||v_esquema||'.EXP_EXPEDIENTES EXP, '||v_esquema||'.ASU_ASUNTOS ASU, '||v_esquema||'.PRC_PROCEDIMIENTOS PRC
		  WHERE CNT.DD_CRE_ID = CRE.DD_CRE_ID
		  AND DD_CRE_CODIGO=''AL''
		  AND CNT.CNT_ID = CEX.CNT_ID
		  AND CEX.EXP_ID = EXP.EXP_ID
		  AND EXP.EXP_ID = ASU.EXP_ID
		  AND ASU.ASU_ID = PRC.ASU_ID
		  AND NOT EXISTS(SELECT 1
				 FROM '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS PCO
				 WHERE PCO.PRC_ID = PRC.PRC_ID)
		  GROUP BY ASU.ASU_ID)';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - UPDATE(2) EN PRC. FINALIZAMOS ULTIMO TRAMITE DE LOS ASUNTOS ALCALA... '||SQL%ROWCOUNT||' Filas');
    Commit;

   V_SQL := 'UPDATE '||v_esquema||'.ASU_ASUNTOS
		  SET DD_EAS_ID = (SELECT DD_EAS_ID FROM '||v_esquema_MASTER||'.DD_EAS_ESTADO_ASUNTOS WHERE DD_EAS_DESCRIPCION = ''Cerrado''),
		      USUARIOMODIFICAR = '''||USUARIO||''',
		      FECHAMODIFICAR =SYSDATE
		WHERE ASU_ID IN (
		  SELECT DISTINCT ASU.ASU_ID
		  FROM '||v_esquema||'.CNT_CONTRATOS CNT, '||v_esquema||'.DD_CRE_CONDICIONES_REMUN_EXT CRE, '||v_esquema||'.CEX_CONTRATOS_EXPEDIENTE CEX, '||v_esquema||'.EXP_EXPEDIENTES EXP, '||v_esquema||'.ASU_ASUNTOS ASU, '||v_esquema||'.PRC_PROCEDIMIENTOS PRC
		  WHERE CNT.DD_CRE_ID = CRE.DD_CRE_ID
		  AND DD_CRE_CODIGO=''AL''
		  AND CNT.CNT_ID = CEX.CNT_ID
		  AND CEX.EXP_ID = EXP.EXP_ID
		  AND EXP.EXP_ID = ASU.EXP_ID
		  AND ASU.ASU_ID = PRC.ASU_ID
		  AND NOT EXISTS(SELECT 1
				 FROM '||v_esquema||'.PCO_PRC_PROCEDIMIENTOS PCO
				 WHERE PCO.PRC_ID = PRC.PRC_ID)
		  )';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - UPDATE(3) EN ASU_ASUNTOS. CAMBIAMOS ESTADO A CERRADO DE ... '||SQL%ROWCOUNT||' Filas');
    Commit;

    DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR-HRE FINALIZACION ALCALA CONTENCIOSO');

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
