WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    USUARIO varchar2(20 CHAR) := 'MIGRACM01PCO';

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO] CAJAMAR MIGRACION TEV_VALORES PRECONTENCIOSO');

    --** TEV_VALOR
    ----------------
    v_sql := 'Insert into '||v_esquema||'.TEV_TAREA_EXTERNA_VALOR (tev_id, tex_id, tev_nombre, tev_valor, version, usuariocrear, fechacrear, tev_valor_clob, DType)
                select '||v_esquema||'.s_tev_tarea_externa_valor.nextval as tev_id
                     , tex.tex_id
                     , tev.tev_nombre
                     , decode( tev.tev_nombre
                             , ''fecha_fin_revision'', to_char(NVL(FECHA_REALIZ_ESTUDIO_SOLV,sysdate),''yyyy-mm-dd'')
                             , ''proc_iniciar'', CASE CAB.TIPO_PROCEDIMIENTO
                                                  WHEN ''P01'' THEN ''H001''
                                                  WHEN ''P02'' THEN ''H022''
                                                  WHEN ''P03'' THEN ''H020''
                                                  WHEN ''P06'' THEN ''H016''
                                                  WHEN ''P07'' THEN ''H024''
                                                  WHEN ''P08'' THEN ''H026''
                                               END
                             , ''observaciones'', null
                             ) as tev_valor
                     , 0 as version
                     , '''||USUARIO||''' as usuariocrear
                     , sysdate as fechacrear
                     , 0 as tev_valor_clob
                     , ''EXTTareaExternaValor'' as DType
                  from '||v_esquema||'.TMP_CREA_ASUNTOSPCO_NUEVOS TMP
                     , '||v_esquema||'.ASU_ASUNTOS                ASU
                     , '||v_esquema||'.TAR_TAREAS_NOTIFICACIONES  TAR
                     , '||v_esquema||'.TAP_TAREA_PROCEDIMIENTO    TAP
                     , '||v_esquema||'.TEX_TAREA_EXTERNA          TEX
		     , '||v_esquema||'.MIG_EXPEDIENTES_CABECERA   CAB
                     --** Obtenemos valores por producto cartesiano
                     , (Select ''fecha_fin_revision'' as tev_nombre from dual
                        union all
                        Select ''proc_iniciar'' as tev_nombre from dual
                        union all
                        Select ''observaciones'' as tev_nombre from dual) TEV
                  WHERE tmp.COD_RECOVERY = asu.ASU_ID_EXTERNO
                    AND asu.asu_id = tar.asu_id
                    AND tar.tar_id = tex.tar_id
                    AND tap.tap_id = tex.tap_id
		    AND TMP.COD_RECOVERY = CAB.CD_EXPEDIENTE
        	    AND TAP.TAP_CODIGO=''PCO_RevisarExpedientePreparar''';

    execute immediate v_sql;
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - Tabla '||v_esquema||'.TEV_TAREA_EXTERNA_VALOR cargada. '||SQL%ROWCOUNT||' Filas');
    Commit;


DBMS_OUTPUT.PUT_LINE('[FIN] CAJAMAR MIGRACION TEV_VALORES PRECONTENCIOSO');

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
