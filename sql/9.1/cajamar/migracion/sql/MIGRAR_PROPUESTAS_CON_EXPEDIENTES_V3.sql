--/*
--##########################################
--## AUTOR=GUSTAVO MORA, ENRIQUE JIMENEZ, LORENZO LERATE
--## FECHA_CREACION=20160217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1510     
--## PRODUCTO=NO
--##
--## Finalidad: Creación del PL/SQL de cambio de gestores masivos
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##        0.2 Utilización de usuario por defecto
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- '#ESQUEMA#';             -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER'; -- '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master
    TABLA VARCHAR(30 CHAR) :='TMP_PROPUESTA_CNT_CON_EXP';
    ITABLE_SPACE VARCHAR(25 CHAR) := 'IRECOVERYONL8M'; -- '#TABLESPACE_INDEX#';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(8500 CHAR);
    V_EXISTE NUMBER (1);
    V_USER_ID NUMBER; --Vble auxiliar para insertar en acu_user_proponente

    /*
    -- <<<....... CURSORES .......>>>>
    */
    -- SIN ESTADO "0" / FONDOS PROPIOS "6" (10.598  Filas)
    CURSOR C_CONTRATOS_FP IS
      select CCE.CNT_ID, CCE.CNT_CONTRATO, CCE.EXP_ID
      from CM01.TMP_PROPUESTA_CNT_CON_EXP CCE
        LEFT OUTER JOIN CM01.acu_acuerdo_procedimientos AAP ON AAP.EXP_ID = CCE.EXP_ID
      WHERE CCE.ESTADO_ACUERDO = 0 AND CCE.TIPO_ACUERDO = 6 AND AAP.EXP_ID IS NULL
        -- AND ROWNUM < 2
        ; 
    V_FOND_PROP C_CONTRATOS_FP%ROWTYPE;
   

 
    -- SIN ESTADO "0" / ALTA DUDOSO "5" (1.233)
    CURSOR C_CONTRATOS_AD IS
      select CCE.CNT_ID, CCE.CNT_CONTRATO, CCE.EXP_ID
      from CM01.TMP_PROPUESTA_CNT_CON_EXP CCE
        LEFT OUTER JOIN CM01.acu_acuerdo_procedimientos AAP ON AAP.EXP_ID = CCE.EXP_ID
      WHERE CCE.ESTADO_ACUERDO = 0 AND CCE.TIPO_ACUERDO = 5 AND AAP.EXP_ID IS NULL
       --  AND ROWNUM < 2
        ; 
    V_ALTA_DUDOSO C_CONTRATOS_AD%ROWTYPE;
  
    
    -- SIN ESTADO "0" / REFINANCIACION NOVACION "4" (123  Filas)
    CURSOR C_CONTRATOS_RN1 IS
      select CCE.CNT_ID, CCE.CNT_CONTRATO, CCE.EXP_ID
      from CM01.TMP_PROPUESTA_CNT_CON_EXP CCE
        LEFT OUTER JOIN CM01.acu_acuerdo_procedimientos AAP ON AAP.EXP_ID = CCE.EXP_ID
      WHERE CCE.ESTADO_ACUERDO = 0 AND CCE.TIPO_ACUERDO = 4 AND AAP.EXP_ID IS NULL 
        -- AND ROWNUM < 2
      ;
    V_REF_NOVA1 C_CONTRATOS_RN1%ROWTYPE;
    
    
    -- OTROS ESTADOS / REFINANCIACION NOVACION "4" (330  Filas)
    CURSOR C_CONTRATOS_RN2 IS
      select CCE.CNT_ID, CCE.CNT_CONTRATO, CCE.EXP_ID
      from CM01.TMP_PROPUESTA_CNT_CON_EXP CCE
        LEFT OUTER JOIN CM01.acu_acuerdo_procedimientos AAP ON AAP.EXP_ID = CCE.EXP_ID
      WHERE CCE.ESTADO_ACUERDO <> 0 AND CCE.TIPO_ACUERDO = 4 AND AAP.EXP_ID IS NULL 
        -- AND ROWNUM < 2
      ;
    V_REF_NOVA2 C_CONTRATOS_RN2%ROWTYPE;
    

    
    
BEGIN 

    DBMS_OUTPUT.PUT_LINE('[INICIO] Carga de Propuestas con Expediente Batch generado.... '||V_ESQUEMA||' -----.... ' );

--   22.098  Filas  (13.370  Filas a Migrar / Sin asunto 12.400  Filas / Expedientes Batch 12.378  Filas)
    
    delete from CM01.TMP_PROPUESTA_CNT_CON_EXP;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Borramos tabla temporal.... '||TABLA||' -----.... ' );
    
    commit;


    insert into CM01.TMP_PROPUESTA_CNT_CON_EXP (CNT_ID, CNT_CONTRATO, EXP_ID, TIPO_ACUERDO, ESTADO_ACUERDO)
    select DISTINCT CNT.cnt_id, CNT.CNT_CONTRATO, exp.EXP_ID, TEA.TIPO_ACUERDO, CAB.ESTADO_ACUERDO
    from CM01.cnt_contratos cnt
--      INNER JOIN CM01.tmp_propuesta_cnt2  CNT2 ON CNT.CNT_CONTRATO = CNT2.CNT_CONTRATO
inner join MIG_PROPUESTAS_TERMI_OPERAC ope on CNT.CNT_CONTRATO = ope.numero_CONTRATO
inner join MIG_PROPUESTAS_TERMINO_ACUERDO tea on ope.id_termino = tea.id_termino
inner join MIG_PROPUESTAS_CABECERA cab on cab.id_propuesta = tea.id_propuesta
      INNER JOIN CM01.cpe_contratos_personas cpe ON cnt.cnt_id = cpe.cnt_id     
      INNER JOIN CM01.CEX_CONTRATOS_EXPEDIENTE cex on cnt.cnt_id = cex.cnt_id
      INNER JOIN CM01.EXP_EXPEDIENTES exp on exp.exp_id = cex.exp_id
      LEFT OUTER JOIN CM01.PRC_CEX pcx on pcx.CEX_ID = cex.CEX_ID
    where cnt.borrado = 0 AND pcx.PRC_ID is null and exp.EXP_MANUAL = 0 and exp.USUARIOCREAR = 'REC-BATCH'
      --  AND CNT2.ESTADO_ACUERDO = 0 AND CNT2.TIPO_ACUERDO = 5 -- SIN ESTADO "0" / ALTA DUDOSO "5" (1.233  Filas)  
      -- AND CNT2.ESTADO_ACUERDO = 0 AND CNT2.TIPO_ACUERDO = 6 -- SIN ESTADO "0" / FONDOS PROPIOS "6" (10.598  Filas)
      -- AND CNT2.ESTADO_ACUERDO = 0 AND CNT2.TIPO_ACUERDO = 4 -- SIN ESTADO "0" / REFINANCIACION NOVACION "4" (123  Filas)
      -- AND CNT2.ESTADO_ACUERDO <> 0 AND CNT2.TIPO_ACUERDO = 4 -- OTROS ESTADOS / REFINANCIACION NOVACION "4" (330  Filas)
    ;  

    commit; 
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertamos tabla temporal.... '||TABLA||' -----.... ' );
    
      --configura V_USER_ID
      BEGIN
		V_MSQL:= 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''PROYFORMS''';
			EXECUTE IMMEDIATE V_MSQL INTO V_USER_ID;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
				V_MSQL:= 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_ID = (SELECT MAX(USU_ID) FROM '||V_ESQUEMA_M||'.USU_USUARIOS)';
			EXECUTE IMMEDIATE V_MSQL INTO V_USER_ID;
      END;
      DBMS_OUTPUT.put_line('=========V_USER_ID: ' ||V_USER_ID||'========');

    
    
   -- SIN ESTADO "0" / FONDOS PROPIOS "6" (10.598  Filas)
   OPEN C_CONTRATOS_FP;
   LOOP
        FETCH C_CONTRATOS_FP INTO V_FOND_PROP;
        EXIT WHEN C_CONTRATOS_FP%NOTFOUND;
        
        -- DBMS_OUTPUT.PUT_LINE('HOLA MUNDO!!.' );
        DBMS_OUTPUT.PUT_LINE('Contrato para trabajar como Fondos Propios... CNT [ ' || V_FOND_PROP.CNT_CONTRATO || ' ], EXP ['|| V_FOND_PROP.EXP_ID ||'].' );
        
      
      
        /*
        Valores a configurarar:> 
            -- DD_EST_ID => CE Completar Expediente (3) [********* 101 Formalizar Propuesta. (Estado del Itinerario)]
            -- dd_eex_id => 1 Propuesto (Estado del Expediente)
            -- arq_id => Migracion
            -- dd_tpx_id => 21 Expediente de Recuperacion (Tipo de Expediente).
       */          
 
       -- dd_eac_id => 1 En preparación
       
       
       V_MSQL  := q'[INSERT INTO CM01.acu_acuerdo_procedimientos
                      (acu_id, dd_sol_id, dd_eac_id, acu_fecha_propuesta, acu_fecha_estado, VERSION,
                      usuariocrear, fechacrear, borrado, dtype, exp_id, acu_fecha_limite, acu_importe_costas, acu_user_proponente
                      )
                      VALUES (CM01.s_acu_acuerdo_procedimientos.NEXTVAL, 1, 1, (SELECT MAX (fecha_propuesta)
                                        FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpta.id_termino = cnt2.id_termino
                                             INNER JOIN cm01.mig_propuestas_cabecera mpc ON mpc.id_propuesta = mpta.id_propuesta
                                       WHERE cnt2.numero_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[), 
                                        (SELECT MAX (fecha_estado)
                                         FROM cm01.mig_propuestas_termi_operac cnt2 
                                                INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpta.id_termino = cnt2.id_termino
                                                INNER JOIN cm01.mig_propuestas_cabecera mpc ON mpc.id_propuesta = mpta.id_propuesta
                                        WHERE cnt2.numero_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[), 0,
                                        'MIGCM01PROPEX', SYSTIMESTAMP, 0, 'EXTAcuerdo', ]'|| V_FOND_PROP.EXP_ID ||q'[
                                        , SYSDATE, (SELECT MAX (importe_costas)
                                                    FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta
                                                         ON mpta.id_termino = cnt2.id_termino
                                                         INNER JOIN cm01.mig_propuestas_cabecera mpc
                                                         ON mpc.id_propuesta = mpta.id_propuesta
                                                   WHERE cnt2.numero_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[), '||V_USER_ID||'
                      )]';       
       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT; 
       -- DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos....[ ' || V_MSQL || ' ].' );                              
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos....' );            
       
       V_MSQL  := q'[INSERT INTO CM01.tea_terminos_acuerdo
                      (tea_id, acu_id, dd_tpa_id, VERSION, usuariocrear, fechacrear, borrado, dd_sbt_id,
                      tea_periodicidad
                      )
                      VALUES (CM01.s_tea_terminos_acuerdo.NEXTVAL, (SELECT MAX (acu_id)
                                                        FROM CM01.acu_acuerdo_procedimientos
                                                       WHERE exp_id = ]'|| V_FOND_PROP.EXP_ID ||q'[),
                                                             (SELECT dd_tpa_id
                                                               FROM CM01.dd_tpa_tipo_acuerdo
                                                              WHERE dd_tpa_codigo = 'EFECFONPRO'), 0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, 1,
                      (SELECT MAX (periodicidad)
                        FROM CM01.mig_propuestas_termino_acuerdo mpta JOIN CM01.mig_propuestas_termi_operac mpto ON mpta.id_termino = mpto.id_termino
                       WHERE mpto.numero_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[)
                      )]';       
       
       
       -- DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos ....' );                     


       V_MSQL  := q'[INSERT INTO CM01.tea_cnt 
                      (TEA_CNT_ID, TEA_ID, CNT_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, SYS_GUID)
                      VALUES (CM01.s_tea_cnt.NEXTVAL, (SELECT tea_id
                                                            FROM CM01.tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM CM01.acu_acuerdo_procedimientos
                                                                            WHERE exp_id = ]'|| V_FOND_PROP.EXP_ID ||q'[)),
                                                            ]'|| V_FOND_PROP.CNT_ID ||q'[
                                                              , 0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, SYS_GUID ())]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos Contratos ....' );            
       

       
       V_MSQL  := q'[INSERT INTO CM01.acu_operaciones_terminos
                    (op_term_id, tea_id, VERSION, usuariocrear, fechacrear, borrado, op_fecha_sol_prevista, op_desc_acuerdo)
                    VALUES (CM01.s_acu_operaciones_terminos.NEXTVAL, (SELECT tea_id
                                                            FROM CM01.tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM CM01.acu_acuerdo_procedimientos
                                                                            WHERE exp_id = ]'|| V_FOND_PROP.EXP_ID ||q'[))
                                                                                       , 0, 'CAJAMAR', SYSTIMESTAMP, 0, SYSDATE,
                     (SELECT MAX (mpc.motivo)
                        FROM cm01.mig_propuestas_cabecera mpc INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpc.id_propuesta = mpta.id_propuesta
                             INNER JOIN cm01.mig_propuestas_termi_operac mpto ON mpto.id_termino = mpta.id_termino
                       WHERE mpto.numero_contrato = ]'|| V_FOND_PROP.CNT_CONTRATO ||q'[)
                    )]';       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Operaciones Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Operaciones Terminos ....' );                     
       -- exit; 
     
          
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------'); 
 
 
   -- SIN ESTADO "0" / ALTA DUDOSO "5" (1.233)
   OPEN C_CONTRATOS_AD;
   LOOP
        FETCH C_CONTRATOS_AD INTO V_ALTA_DUDOSO;
        EXIT WHEN C_CONTRATOS_AD%NOTFOUND;
        
        -- DBMS_OUTPUT.PUT_LINE('HOLA MUNDO!!.' );
        DBMS_OUTPUT.PUT_LINE('Contrato para trabajar como ALTA DUDOSO... CNT [ ' || V_ALTA_DUDOSO.CNT_CONTRATO || ' ], EXP ['|| V_ALTA_DUDOSO.EXP_ID ||'].' );    
    
        /*
        Valores a configurarar:> 
            -- DD_EST_ID => CE Completar Expediente (3) [********* 101 Formalizar Propuesta. (Estado del Itinerario)]
            -- dd_eex_id => 1 Propuesto (Estado del Expediente)
            -- arq_id => Migracion
            -- dd_tpx_id => 21 Expediente de Recuperacion (Tipo de Expediente).
       */
    
       
       V_MSQL  := q'[INSERT INTO CM01.acu_acuerdo_procedimientos
                      (acu_id, dd_sol_id, dd_eac_id, acu_fecha_propuesta, acu_fecha_estado, VERSION,
                      usuariocrear, fechacrear, borrado, dtype, exp_id, acu_fecha_limite, acu_importe_costas, acu_user_proponente
                      )
                      VALUES (CM01.s_acu_acuerdo_procedimientos.NEXTVAL, 1, 1, (SELECT MAX (fecha_propuesta)
                                        FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpta.id_termino = cnt2.id_termino
                                             INNER JOIN cm01.mig_propuestas_cabecera mpc ON mpc.id_propuesta = mpta.id_propuesta
                                       WHERE cnt2.numero_contrato = ]'|| V_ALTA_DUDOSO.CNT_CONTRATO ||q'[), (SELECT MAX (fecha_estado)
                                                                                                             FROM cm01.mig_propuestas_termi_operac cnt2 
                                                                                                                INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpta.id_termino = cnt2.id_termino
                                                                                                                INNER JOIN cm01.mig_propuestas_cabecera mpc ON mpc.id_propuesta = mpta.id_propuesta
                                                                                                            WHERE cnt2.numero_contrato = ]'|| V_ALTA_DUDOSO.CNT_CONTRATO ||q'[), 0,
                      'MIGCM01PROPEX', SYSTIMESTAMP, 0, 'EXTAcuerdo', 
                      ]'|| V_ALTA_DUDOSO.EXP_ID ||q'[,
                       SYSDATE, (SELECT MAX (importe_costas)
                       FROM cm01.mig_propuestas_termi_operac cnt2 
                          INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpta.id_termino = cnt2.id_termino
                          INNER JOIN cm01.mig_propuestas_cabecera mpc ON mpc.id_propuesta = mpta.id_propuesta
                       WHERE cnt2.numero_contrato = ]'|| V_ALTA_DUDOSO.CNT_CONTRATO ||q'[), '||V_USER_ID||'
                      )]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos....' );       
             
             

       
       V_MSQL  := q'[INSERT INTO CM01.tea_terminos_acuerdo
                      (tea_id, acu_id, dd_tpa_id, VERSION, usuariocrear, fechacrear, borrado, dd_sbt_id,
                      tea_periodicidad
                      )
                      VALUES (CM01.s_tea_terminos_acuerdo.NEXTVAL, (SELECT MAX (acu_id)
                                                        FROM CM01.acu_acuerdo_procedimientos
                                                       WHERE exp_id =    ]'|| V_ALTA_DUDOSO.EXP_ID ||q'[),
                                                             (SELECT dd_tpa_id
                                                               FROM CM01.dd_tpa_tipo_acuerdo
                                                              WHERE dd_tpa_codigo = 'SINSOLUCION'), 0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, 1,
                      (SELECT MAX (periodicidad)
                        FROM CM01.mig_propuestas_termino_acuerdo mpta JOIN CM01.mig_propuestas_termi_operac mpto ON mpta.id_termino = mpto.id_termino
                       WHERE mpto.numero_contrato = ]'|| V_ALTA_DUDOSO.CNT_CONTRATO ||q'[)
                      )]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos ....' );                     

       V_MSQL  := q'[INSERT INTO CM01.tea_cnt 
                      (TEA_CNT_ID, TEA_ID, CNT_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, SYS_GUID)
                      VALUES (CM01.s_tea_cnt.NEXTVAL, (SELECT tea_id
                                                            FROM CM01.tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM CM01.acu_acuerdo_procedimientos
                                                                            WHERE exp_id =  ]'|| V_ALTA_DUDOSO.EXP_ID ||q'[)),
                                                             ]'|| V_ALTA_DUDOSO.CNT_ID ||q'[
                                                              , 0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, SYS_GUID ())]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos Contratos ....' );     


       
       V_MSQL  := q'[INSERT INTO CM01.acu_operaciones_terminos
                    (op_term_id, tea_id, VERSION, usuariocrear, fechacrear, borrado, op_fecha_sol_prevista, op_desc_acuerdo)
                    VALUES (CM01.s_acu_operaciones_terminos.NEXTVAL, (SELECT tea_id
                                                            FROM CM01.tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM CM01.acu_acuerdo_procedimientos
                                                                            WHERE exp_id = ]'|| V_ALTA_DUDOSO.EXP_ID ||q'[))
                                                                                             , 0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, SYSDATE,
                     (SELECT MAX (mpc.motivo)
                        FROM cm01.mig_propuestas_cabecera mpc INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpc.id_propuesta = mpta.id_propuesta
                             INNER JOIN cm01.mig_propuestas_termi_operac mpto ON mpto.id_termino = mpta.id_termino
                       WHERE mpto.numero_contrato = ]'|| V_ALTA_DUDOSO.CNT_CONTRATO ||q'[)
                    )]';       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
       -- DBMS_OUTPUT.PUT_LINE('Insert de Operaciones Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Operaciones Terminos ....' );                     

      COMMIT;
     --  exit; 
     
    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------');   



   -- SIN ESTADO "0" / REFINANCIACION NOVACION "4" (123  Filas)
   OPEN C_CONTRATOS_RN1;
   LOOP
    	FETCH C_CONTRATOS_RN1 INTO V_REF_NOVA1;
		EXIT WHEN C_CONTRATOS_RN1%NOTFOUND;
    	DBMS_OUTPUT.PUT_LINE('Contrato para trabajar como Refinanciacion Novación Sin Estado ...CNT [ ' || V_REF_NOVA1.CNT_CONTRATO || ' ], EXP ['|| V_REF_NOVA1.EXP_ID ||'].' );    
        
        /*
        Valores a configurarar:> 
            -- DD_EST_ID => CE Completar Expediente (3) [********* 101 Formalizar Propuesta. (Estado del Itinerario)]
            -- dd_eex_id => 1 Propuesto (Estado del Expediente)
            -- arq_id => Migracion
            -- dd_tpx_id => 21 Expediente de Recuperacion (Tipo de Expediente).
       */
        
 
       -- dd_eac_id => 1 En preparación
       
       V_MSQL  := q'[INSERT INTO CM01.acu_acuerdo_procedimientos
                      (acu_id, dd_sol_id, dd_eac_id, acu_fecha_propuesta, acu_fecha_estado, VERSION,
                      usuariocrear, fechacrear, borrado, dtype, exp_id, acu_fecha_limite, acu_importe_costas, acu_user_proponente
                      )
                      VALUES (CM01.s_acu_acuerdo_procedimientos.NEXTVAL, 1, 1, (SELECT MAX (fecha_propuesta)
                                        FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpta.id_termino = cnt2.id_termino
                                             INNER JOIN cm01.mig_propuestas_cabecera mpc ON mpc.id_propuesta = mpta.id_propuesta
                                       WHERE cnt2.numero_contrato = ]'|| V_REF_NOVA1.CNT_CONTRATO ||q'[), (SELECT MAX (fecha_estado)
                                                                                                             FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta
                                                                                                                  ON mpta.id_termino = cnt2.id_termino
                                                                                                                  INNER JOIN cm01.mig_propuestas_cabecera mpc
                                                                                                                  ON mpc.id_propuesta = mpta.id_propuesta
                                                                                                            WHERE cnt2.numero_contrato = ]'|| V_REF_NOVA1.CNT_CONTRATO ||q'[), 0,
                      'MIGCM01PROPEX', SYSTIMESTAMP, 0, 'EXTAcuerdo', ]'|| V_REF_NOVA1.EXP_ID ||q'[,
                                         SYSDATE, (SELECT MAX (importe_costas)
                                                                                                    FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta
                                                                                                         ON mpta.id_termino = cnt2.id_termino
                                                                                                         INNER JOIN cm01.mig_propuestas_cabecera mpc
                                                                                                         ON mpc.id_propuesta = mpta.id_propuesta
                                                                                                   WHERE cnt2.numero_contrato = ]'|| V_REF_NOVA1.CNT_CONTRATO ||q'[), '||V_USER_ID||'
                      )]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
      COMMIT;                            

--        DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos....' );       
             
             

       
       V_MSQL  := q'[INSERT INTO CM01.tea_terminos_acuerdo
                      (tea_id, acu_id, dd_tpa_id, VERSION, usuariocrear, fechacrear, borrado, dd_sbt_id,
                      tea_periodicidad
                      )
                      VALUES (CM01.s_tea_terminos_acuerdo.NEXTVAL, (SELECT MAX (acu_id)
                                                        FROM CM01.acu_acuerdo_procedimientos
                                                         WHERE exp_id =  ]'|| V_REF_NOVA1.EXP_ID ||q'[),
                                                             (SELECT dd_tpa_id
                                                               FROM CM01.dd_tpa_tipo_acuerdo
                                                              WHERE dd_tpa_codigo = 'REFINOVA'), 0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, 1,
                      (SELECT MAX (periodicidad)
                        FROM CM01.mig_propuestas_termino_acuerdo mpta JOIN CM01.mig_propuestas_termi_operac mpto ON mpta.id_termino = mpto.id_termino
                       WHERE mpto.numero_contrato = ]'|| V_REF_NOVA1.CNT_CONTRATO ||q'[)
                      )]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
      COMMIT;                            

--        DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos ....' );     
 
 
       
       V_MSQL  := q'[INSERT INTO CM01.tea_cnt 
                      (TEA_CNT_ID, TEA_ID, CNT_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, SYS_GUID)
                      VALUES (CM01.s_tea_cnt.NEXTVAL, (SELECT tea_id
                                                            FROM CM01.tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM CM01.acu_acuerdo_procedimientos
                                                                            WHERE exp_id = ]'|| V_REF_NOVA1.EXP_ID ||q'[)),
                                                             ]'|| V_REF_NOVA1.CNT_ID ||q'[,0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, SYS_GUID ())]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
      COMMIT;                            

--       DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos Contratos ....' );          



       
       V_MSQL  := q'[INSERT INTO CM01.acu_operaciones_terminos
                    (op_term_id, tea_id, VERSION, usuariocrear, fechacrear, borrado, op_fecha_sol_prevista, op_desc_acuerdo)
                    VALUES (CM01.s_acu_operaciones_terminos.NEXTVAL, (SELECT tea_id
                                                            FROM CM01.tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM CM01.acu_acuerdo_procedimientos
                                                                            WHERE exp_id = ]'|| V_REF_NOVA1.EXP_ID ||q'[)),
                                                                           0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, SYSDATE,
                     (SELECT MAX (mpc.motivo)
                        FROM cm01.mig_propuestas_cabecera mpc INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpc.id_propuesta = mpta.id_propuesta
                             INNER JOIN cm01.mig_propuestas_termi_operac mpto ON mpto.id_termino = mpta.id_termino
                       WHERE mpto.numero_contrato = ]'|| V_REF_NOVA1.CNT_CONTRATO ||q'[)
                    )]';       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
--        DBMS_OUTPUT.PUT_LINE('Insert de Operaciones Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
        DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Operaciones Terminos ....' );                     


     --    exit; 
                                
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------');



   -- OTROS ESTADOS / REFINANCIACION NOVACION "4" (330  Filas)
   OPEN C_CONTRATOS_RN2;
   LOOP
    	FETCH C_CONTRATOS_RN2 INTO V_REF_NOVA2;
		EXIT WHEN C_CONTRATOS_RN2%NOTFOUND;
    	DBMS_OUTPUT.PUT_LINE('Contrato para trabajar como Refinanciacion Novación Resto de Estados...CNT [ ' || V_REF_NOVA2.CNT_CONTRATO || ' ], EXP ['|| V_REF_NOVA2.EXP_ID ||'].' );    
        
        
        /*
        Valores a configurarar:> 
            -- DD_EST_ID => FP Formalizar Propuesta [********* 101 Formalizar Propuesta. (Estado del Itinerario)]
            -- dd_eex_id => 1 Propuesto (Estado del Expediente)
            -- arq_id => Migracion
            -- dd_tpx_id => 21 Expediente de Recuperacion (Tipo de Expediente).
       */
        

       -- dd_eac_id => 1 En preparación

       
       V_MSQL  := q'[INSERT INTO CM01.acu_acuerdo_procedimientos
                      (acu_id, dd_sol_id, dd_eac_id, acu_fecha_propuesta, acu_fecha_estado, VERSION,
                      usuariocrear, fechacrear, borrado, dtype, exp_id, acu_fecha_limite, acu_importe_costas, acu_user_proponente
                      )
                      VALUES (CM01.s_acu_acuerdo_procedimientos.NEXTVAL, 1, 1, (SELECT MAX (fecha_propuesta)
                                        FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpta.id_termino = cnt2.id_termino
                                             INNER JOIN cm01.mig_propuestas_cabecera mpc ON mpc.id_propuesta = mpta.id_propuesta
                                       WHERE cnt2.numero_contrato = ]'|| V_REF_NOVA2.CNT_CONTRATO ||q'[), (SELECT MAX (fecha_estado)
                                                                                                             FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta
                                                                                                                  ON mpta.id_termino = cnt2.id_termino
                                                                                                                  INNER JOIN cm01.mig_propuestas_cabecera mpc
                                                                                                                  ON mpc.id_propuesta = mpta.id_propuesta
                                                                                                            WHERE cnt2.numero_contrato = ]'|| V_REF_NOVA2.CNT_CONTRATO ||q'[), 0,
                      'MIGCM01PROPEX', SYSTIMESTAMP, 0, 'EXTAcuerdo', ]'|| V_REF_NOVA2.EXP_ID ||q'[
                      , SYSDATE, (SELECT MAX (importe_costas)
                                                                                                    FROM cm01.mig_propuestas_termi_operac cnt2 INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta
                                                                                                         ON mpta.id_termino = cnt2.id_termino
                                                                                                         INNER JOIN cm01.mig_propuestas_cabecera mpc
                                                                                                         ON mpc.id_propuesta = mpta.id_propuesta
                                                                                                   WHERE cnt2.numero_contrato = ]'|| V_REF_NOVA2.CNT_CONTRATO ||q'[), '||V_USER_ID||'
                      )]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
     --   DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Procedimientos....' );       
             
             

       
       V_MSQL  := q'[INSERT INTO CM01.tea_terminos_acuerdo
                      (tea_id, acu_id, dd_tpa_id, VERSION, usuariocrear, fechacrear, borrado, dd_sbt_id,
                      tea_periodicidad
                      )
                      VALUES (CM01.s_tea_terminos_acuerdo.NEXTVAL, (SELECT MAX (acu_id)
                                                        FROM CM01.acu_acuerdo_procedimientos
                                                       WHERE exp_id = ]'|| V_REF_NOVA2.EXP_ID ||q'[),
                                                             (SELECT dd_tpa_id
                                                               FROM CM01.dd_tpa_tipo_acuerdo
                                                              WHERE dd_tpa_codigo = 'REFINOVA'), 0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, 1,
                      (SELECT MAX (periodicidad)
                        FROM CM01.mig_propuestas_termino_acuerdo mpta JOIN CM01.mig_propuestas_termi_operac mpto ON mpta.id_termino = mpto.id_termino
                       WHERE mpto.numero_contrato = ]'|| V_REF_NOVA2.CNT_CONTRATO ||q'[)
                      )]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
--        DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos ....' );     
 
 
       
       V_MSQL  := q'[INSERT INTO CM01.tea_cnt 
                      (TEA_CNT_ID, TEA_ID, CNT_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, SYS_GUID)
                      VALUES (CM01.s_tea_cnt.NEXTVAL, (SELECT tea_id
                                                            FROM CM01.tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM CM01.acu_acuerdo_procedimientos
                                                                            WHERE exp_id = ]'|| V_REF_NOVA2.EXP_ID ||q'[)),
                                                             ]'|| V_REF_NOVA2.CNT_ID ||q'[,
                                                               0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, SYS_GUID ())]';       
       
       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
--       DBMS_OUTPUT.PUT_LINE('Insert de Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Terminos Contratos ....' );          



       
       V_MSQL  := q'[INSERT INTO CM01.acu_operaciones_terminos
                    (op_term_id, tea_id, VERSION, usuariocrear, fechacrear, borrado, op_fecha_sol_prevista, op_desc_acuerdo)
                    VALUES (CM01.s_acu_operaciones_terminos.NEXTVAL, (SELECT tea_id
                                                            FROM CM01.tea_terminos_acuerdo
                                                           WHERE acu_id = (SELECT MAX (acu_id)
                                                                             FROM CM01.acu_acuerdo_procedimientos
                                                                            WHERE exp_id = ]'|| V_REF_NOVA2.EXP_ID ||q'[))
                                                                     , 0, 'MIGCM01PROPEX', SYSTIMESTAMP, 0, SYSDATE,
                     (SELECT MAX (mpc.motivo)
                        FROM cm01.mig_propuestas_cabecera mpc INNER JOIN cm01.mig_propuestas_termino_acuerdo mpta ON mpc.id_propuesta = mpta.id_propuesta
                             INNER JOIN cm01.mig_propuestas_termi_operac mpto ON mpto.id_termino = mpta.id_termino
                       WHERE mpto.numero_contrato = ]'|| V_REF_NOVA2.CNT_CONTRATO ||q'[)
                    )]';       
       
       EXECUTE IMMEDIATE V_MSQL;            
       COMMIT;                            
--        DBMS_OUTPUT.PUT_LINE('Insert de Operaciones Terminos de Acuerdos...[ ' || V_MSQL || ' ].' );       
       DBMS_OUTPUT.PUT_LINE('Insert de Acuerdos Operaciones Terminos ....' );                     
      
     --   EXIT;
                                
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
