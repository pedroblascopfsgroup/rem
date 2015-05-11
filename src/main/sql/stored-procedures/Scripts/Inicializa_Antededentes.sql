/* Script de Incicialización de Antecedentes de Persona */
SET SERVEROUTPUT ON;
SET TIMING ON;

DECLARE 

    err_num NUMBER;
    err_msg VARCHAR2(255);
    v_count NUMBER;
    v_msql   VARCHAR2(12000);
    
    --v_esquema  VARCHAR2(25 CHAR):= USER; 
    v_esquema  VARCHAR2(25 CHAR):= 'BANK01';
    v_usuario  VARCHAR2(50 CHAR):= 'REC-BATCH'; 
    
BEGIN

 /* Creamos tmp con Personas con Contrato e ID de antecedente y Contamos sus ciclos de recobro */
 v_msql := 'DELETE FROM '||v_esquema||'.TMP_ANTECEDENTES_PER';
 Execute Immediate v_msql;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Fin Truncate TMP_ANTECEDENTES_PER.');
 COMMIT;
 
 v_msql:= 'INSERT INTO '||v_esquema||'.TMP_ANTECEDENTES_PER (PER_ID, ANT_ID, ANT_REINCIDENCIA_INTERNOS)
            SELECT GUI.PER_ID
                 , NVL(ANT.ANT_ID,'||v_esquema||'.S_ANT_ANTECEDENTES.nextval) as ANT_ID
                 , GUI.CICLOS as ANT_REINCIDENCIA_INTERNOS
              FROM (select cpe.per_id
                         , per.ant_id
                         , nvl(count(distinct crp.crp_id),0) as ciclos
                      from '||v_esquema||'.CPE_CONTRATOS_PERSONAS cpe
                         , '||v_esquema||'.PER_PERSONAS per
                         , '||v_esquema||'.CRP_CICLO_RECOBRO_PER crp
                     where cpe.per_id = per.per_id 
                       and cpe.per_id = crp.per_id(+)
                       and trunc(crp.crp_fecha_alta(+)) <> trunc(crp_fecha_baja(+))
                     group by cpe.per_id, per.ant_id)  GUI
                 , '||v_esquema||'.ANT_ANTECEDENTES ANT
             WHERE GUI.ANT_ID = ANT.ANT_ID(+)
               AND ANT.BORRADO(+) = 0';
 Execute Immediate v_msql;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - TMP_ANTECEDENTES_PER Creada. '||SQL%ROWCOUNT||' Filas.');
 
 v_msql:='analyze table '||v_esquema||'.TMP_ANTECEDENTES_PER estimate statistics';
 Execute Immediate v_msql;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Estadísticas de TMP_ANTECEDENTES_PER actualizadas.');

 /*Asignamos valor a la variable de reincidencia */
 v_msql:= 'MERGE INTO '||v_esquema||'.ANT_ANTECEDENTES old
          USING '||v_esquema||'.TMP_ANTECEDENTES_PER new
          ON (old.ANT_ID = new.ANT_ID)
          WHEN MATCHED
            THEN UPDATE 
                 SET  old.ANT_REINCIDENCIA_INTERNOS = new.ANT_REINCIDENCIA_INTERNOS
                   , USUARIOMODIFICAR = '''||v_usuario||'''
                   , FECHAMODIFICAR = sysdate
                 WHERE old.ANT_REINCIDENCIA_INTERNOS < new.ANT_REINCIDENCIA_INTERNOS
          WHEN NOT MATCHED
            THEN INSERT (ANT_ID,ANT_REINCIDENCIA_INTERNOS,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)
                 VALUES (new.ANT_ID,new.ANT_REINCIDENCIA_INTERNOS,0,'''||v_usuario||''',sysdate,0)';
 Execute Immediate v_msql;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - ANT_ANTECEDENTES Actualizada. '||SQL%ROWCOUNT||' Filas.');
 COMMIT;
 
 v_msql:='analyze table '||v_esquema||'.ANT_ANTECEDENTES estimate statistics';
 Execute Immediate v_msql;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Estadísticas de ANT_ANTECEDENTES actualizadas.');


 /* Asignamos ID de antecedente a la Persona */
 v_msql:='MERGE INTO '||v_esquema||'.PER_PERSONAS old
         USING ( Select tmp.PER_ID
                      , tmp.ANT_ID
                   From '||v_esquema||'.TMP_ANTECEDENTES_PER tmp
                      , '||v_esquema||'.PER_PERSONAS per
                  Where tmp.PER_ID = per.PER_ID(+)
                    And tmp.ANT_ID = per.ANT_ID(+)
                    And per.PER_ID is null ) new
         ON (old.PER_ID = new.PER_ID)
         WHEN MATCHED
           THEN UPDATE 
                SET old.ANT_ID = new.ANT_ID
                  , USUARIOMODIFICAR = '''||v_usuario||'''
                  , FECHAMODIFICAR = sysdate';
 Execute Immediate v_msql;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - PER_PERSONAS Actualizada. '||SQL%ROWCOUNT||' Filas.');
 COMMIT;
 
 v_msql:='analyze table '||v_esquema||'.PER_PERSONAS estimate statistics';
 Execute Immediate v_msql;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Estadísticas de ANT_ANTECEDENTES actualizadas.');

EXCEPTION

  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
    DBMS_OUTPUT.put_line(v_msql);
    ROLLBACK;
    RAISE;   
    
END;