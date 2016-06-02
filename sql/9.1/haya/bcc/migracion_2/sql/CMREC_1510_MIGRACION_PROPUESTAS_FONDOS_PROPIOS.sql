--/*
--##########################################
--## AUTOR=ENRIQUE JIMENEZ
--## FECHA_CREACION=20160205
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1510 	
--## PRODUCTO=NO
--##
--## Finalidad: Creación del PL/SQL de cambio de gestores masivos
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA02'; -- '#ESQUEMA#';             -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master
    TABLA VARCHAR(30 CHAR) :='MIG_PROPUESTAS_TERMI_OPERAC';
    ITABLE_SPACE VARCHAR(25 CHAR) := 'IRECOVERYONL8M'; -- '#TABLESPACE_INDEX#';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(8500 CHAR);
    V_EXISTE NUMBER (1);
    
    -- SIN ESTADO "0" / FONDOS PROPIOS "6"
    CURSOR C_CONTRATOS_FP IS
        SELECT TT.CNT_CONTRATO FROM (
            select DISTINCT CNT.CNT_CONTRATO 
            from cnt_contratos cnt
                INNER JOIN HAYA02.MIG_PROPUESTAS_TERMI_OPERAC CNT2 ON CNT.CNT_CONTRATO = CNT2.NUMERO_CONTRATO||CNT2.NUMERO_ESPEC
                INNER JOIN HAYA02.MIG_PROPUESTAS_TERMINO_ACUERDO MPTA ON MPTA.ID_TERMINO = CNT2.ID_TERMINO
                INNER JOIN HAYA02.MIG_PROPUESTAS_CABECERA MPC ON MPC.ID_PROPUESTA = MPTA.ID_PROPUESTA
                left outer join CEX_CONTRATOS_EXPEDIENTE cex on cnt.cnt_id = cex.cnt_id  
            where cnt.borrado = 0 and cex.cex_id is null 
            AND MPC.ESTADO_ACUERDO = 0 AND MPTA.TIPO_ACUERDO = 6 
        ) TT;        
    V_FOND_PROP C_CONTRATOS_FP%ROWTYPE;
    

BEGIN 


    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||' -----.... ' );
    
   -- Cambio de gestores que entran como sustitutos
   OPEN C_CONTRATOS_FP;
   LOOP
    	FETCH C_CONTRATOS_FP INTO V_FOND_PROP;
		EXIT WHEN C_CONTRATOS_FP%NOTFOUND;
    	DBMS_OUTPUT.PUT_LINE('Contrato para trabajar como Fondos Propios...[ ' || V_FOND_PROP.CNT_CONTRATO || ' ].' );
        
        /*
        Valores a configurarar:> 
            -- DD_EST_ID => 101 Formalizar Propuesta. (Estado del Itinerario)
            -- dd_eex_id => 1 Propuesto (Estado del Expediente)
            -- arq_id => Migracion
            -- dd_tpx_id => 21 Expediente de Recuperacion (Tipo de Expediente).
       */
        
        V_MSQL  := q'[INSERT INTO exp_expedientes
            (exp_id, dd_est_id, exp_fecha_est_id, ofi_id, arq_id, exp_process_bpm, exp_manual, 
            VERSION, usuariocrear, fechacrear, usuariomodificar, fechamodificar, borrado, dd_eex_id,
            exp_descripcion, dd_tpx_id, SYS_GUID
            )
                VALUES (s_exp_expedientes.NEXTVAL, 101, SYSTIMESTAMP, 
                          (select ofi_id from cnt_contratos cntx where cntx.cnt_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[), 
                          (SELECT arq_id FROM arq_arquetipos WHERE arq_nombre = 'Migracion'), NULL, 0, 0, 'DD', SYSTIMESTAMP, 'val.oficina', SYSTIMESTAMP, 0, 1,
                     ']'|| V_FOND_PROP.CNT_CONTRATO ||q'['||' | '|| (SELECT * FROM (SELECT   per.per_doc_id|| '-' ||per.per_nom50 
                                         FROM per_personas per 
                                            JOIN cpe_contratos_personas cpe ON per.per_id = cpe.per_id 
                                            JOIN dd_tin_tipo_intervencion tin ON cpe.dd_tin_id = tin.dd_tin_id 
                                JOIN cnt_contratos cnt ON cnt.cnt_id = cpe.cnt_id AND cnt.cnt_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||'
                                                        WHERE tin.dd_tin_titular = 1
                                                     ORDER BY cpe.cpe_orden ASC)
                                              WHERE ROWNUM < 2), 21, SYS_GUID ()
                    )';
        
        
        EXECUTE IMMEDIATE V_MSQL;            
        COMMIT;                    
        -- DBMS_OUTPUT.PUT_LINE('Insert de Expedientes...[ ' || V_MSQL || ' ].' );
        DBMS_OUTPUT.PUT_LINE('Insert de Expedientes....' );
        -- exit;    
        
/*  */
       V_MSQL  := q'[INSERT INTO cex_contratos_expediente
                    (cex_id, cnt_id, exp_id, cex_pase, VERSION, usuariocrear, fechacrear, borrado, dd_aex_id
                    )
             VALUES (s_cex_contratos_expediente.NEXTVAL, (SELECT cnt_id
                                                            FROM cnt_contratos
                                                           WHERE cnt_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[), 
                                                         (SELECT exp_id
                                                            FROM exp_expedientes EXP
                                                           WHERE exp_descripcion LIKE ']'|| V_FOND_PROP.CNT_CONTRATO ||q'[%'), 1, 0, 'DD', SYSTIMESTAMP, 0, 1
                    )]';        
        
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Contratos Expedientes...[ ' || V_MSQL || ' ].' );
       DBMS_OUTPUT.PUT_LINE('Insert de Contratos Expedientes....' );
       
       
       
      
       V_MSQL  := q'[Insert into PEX_PERSONAS_EXPEDIENTE
                     (PEX_ID, PER_ID, EXP_ID, DD_AEX_ID, PEX_PASE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   Values
                     (S_PEX_PERSONAS_EXPEDIENTE.NEXTVAL, (SELECT max(PER.PER_ID)
                                                          FROM PER_PERSONAS PER
                                                              INNER JOIN CPE_CONTRATOS_PERSONAS CPE ON PER.PER_ID = CPE.PER_ID
                                                              INNER JOIN DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID AND TIN.DD_TIN_TITULAR = 1 
                                                              INNER JOIN CNT_CONTRATOS CNT ON CNT.CNT_ID = CPE.CNT_ID
                                                          WHERE CNT_CONTRATO = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[  
                                                              AND CPE.CPE_ORDEN = (SELECT MIN (cpe_orden)
                                                                                   FROM cpe_contratos_personas cpe2 INNER JOIN dd_tin_tipo_intervencion tin2
                                                                                      ON tin2.dd_tin_id = cpe2.dd_tin_id AND tin2.dd_tin_titular = 1
                                                                                      INNER JOIN cnt_contratos cnt2 ON cpe2.cnt_id = cnt2.cnt_id
                                                                                  WHERE cnt2.cnt_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[
                                                                                  )
                                                         ), (select exp_id from EXP_EXPEDIENTES where EXP_DESCRIPCION like ']'|| V_FOND_PROP.CNT_CONTRATO ||q'[%'), 9, 1, 0, 'DD', SYSTIMESTAMP, 0)]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Personas Expedientes...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Personas Expedientes....' );       
 


       
       V_MSQL  := q'[INSERT INTO acu_acuerdo_procedimientos
                      (acu_id, dd_sol_id, dd_eac_id, acu_fecha_propuesta, acu_fecha_estado, VERSION,
                      usuariocrear, fechacrear, borrado, dtype, exp_id, acu_fecha_limite, acu_importe_costas, acu_user_proponente
                      )
                      VALUES (s_acu_acuerdo_procedimientos.NEXTVAL, 1, 2, (SELECT MAX (fecha_propuesta)
                                        FROM HAYA02.mig_propuestas_termi_operac cnt2 INNER JOIN HAYA02.mig_propuestas_termino_acuerdo mpta ON mpta.id_termino = cnt2.id_termino
                                             INNER JOIN HAYA02.mig_propuestas_cabecera mpc ON mpc.id_propuesta = mpta.id_propuesta
                                       WHERE cnt2.numero_contrato || cnt2.numero_espec = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[), (SELECT MAX (fecha_estado)
                                                                                                             FROM HAYA02.mig_propuestas_termi_operac cnt2 INNER JOIN HAYA02.mig_propuestas_termino_acuerdo mpta
                                                                                                                  ON mpta.id_termino = cnt2.id_termino
                                                                                                                  INNER JOIN HAYA02.mig_propuestas_cabecera mpc
                                                                                                                  ON mpc.id_propuesta = mpta.id_propuesta
                                                                                                            WHERE cnt2.numero_contrato || cnt2.numero_espec = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[), 0,
                      'val.oficina', SYSTIMESTAMP, 0, 'EXTAcuerdo', (SELECT exp_id
                                          FROM exp_expedientes
                                         WHERE exp_descripcion LIKE ']'|| V_FOND_PROP.CNT_CONTRATO ||q'[%'), SYSDATE, (SELECT MAX (importe_costas)
                                                                                                    FROM HAYA02.mig_propuestas_termi_operac cnt2 INNER JOIN HAYA02.mig_propuestas_termino_acuerdo mpta
                                                                                                         ON mpta.id_termino = cnt2.id_termino
                                                                                                         INNER JOIN HAYA02.mig_propuestas_cabecera mpc
                                                                                                         ON mpc.id_propuesta = mpta.id_propuesta
                                                                                                   WHERE cnt2.numero_contrato || cnt2.numero_espec = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[), 34863
                      )]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos....' );       
             
             

       
       V_MSQL  := q'[INSERT INTO tea_terminos_acuerdo
                      (tea_id, acu_id, dd_tpa_id, VERSION, usuariocrear, fechacrear, borrado, dd_sbt_id,
                      tea_periodicidad
                      )
                      VALUES (s_tea_terminos_acuerdo.NEXTVAL, (SELECT MAX (acu_id)
                                                        FROM acu_acuerdo_procedimientos
                                                       WHERE exp_id = (SELECT exp_id
                                                                         FROM exp_expedientes
                                                                        WHERE exp_descripcion LIKE ']'|| V_FOND_PROP.CNT_CONTRATO ||q'[%')), 
                                                             (SELECT dd_tpa_id
                                                               FROM dd_tpa_tipo_acuerdo
                                                              WHERE dd_tpa_codigo = 'EFECFONPRO'), 0, 'val.oficina', SYSTIMESTAMP, 0, 1,
                      (SELECT MAX (periodicidad)
                        FROM mig_propuestas_termino_acuerdo mpta JOIN mig_propuestas_termi_operac mpto ON mpta.id_termino = mpto.id_termino
                       WHERE mpto.numero_contrato || mpto.numero_espec = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[)
                      )]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos ....' );                     



       
       V_MSQL  := q'[INSERT INTO acu_operaciones_terminos
                    (op_term_id, tea_id, VERSION, usuariocrear, fechacrear, borrado, op_fecha_sol_prevista, op_desc_acuerdo)
                    VALUES (s_acu_operaciones_terminos.NEXTVAL, (SELECT tea_id
                                                            FROM tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM acu_acuerdo_procedimientos
                                                                            WHERE exp_id = (SELECT exp_id
                                                                                              FROM exp_expedientes
                                                                                             WHERE exp_descripcion LIKE ']'|| V_FOND_PROP.CNT_CONTRATO ||q'[%'))), 0, 'CAJAMAR', SYSTIMESTAMP, 0, SYSDATE,
                     (SELECT MAX (mpc.motivo)
                        FROM HAYA02.mig_propuestas_cabecera mpc INNER JOIN HAYA02.mig_propuestas_termino_acuerdo mpta ON mpc.id_propuesta = mpta.id_propuesta
                             INNER JOIN HAYA02.mig_propuestas_termi_operac mpto ON mpto.id_termino = mpta.id_termino
                       WHERE mpto.numero_contrato || mpto.numero_espec = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[)
                    )]';       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Operaciones Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Operaciones Terminos ....' );                     


       -- exit; 
                                
    END LOOP;

       DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------');



    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||' -----.... ' );
    
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

