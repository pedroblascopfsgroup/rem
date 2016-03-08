create or replace PROCEDURE      SP_MIG_A_TABLA_INTERMEDIA IS

	CURSOR c_PROCS IS
                 SELECT CD_PROCEDIMIENTO,
                        TIPO_PROCEDIMIENTO,
                        DECODE(ULTIMO_HITO,'X',DECODE(TIPO_PROCEDIMIENTO,'P06',1,'P08',20,'P07',10,'P01',29,'P03',40,'P02',59),6,3,18,16,17,16,23,24,26,25,28,27,35,34,36,34,37,34, 42,41,44,43,45,43,46,43,48,47,50,43,51,50,52,51,54,53,55,53,56,53, TO_NUMBER(ULTIMO_HITO)) AS ULTIMO_HITO
                 FROM MIG_PROCEDIMIENTOS_CABECERA
                 --WHERE TIPO_PROCEDIMIENTO = 'P01' --('P01', 'P06', 'P08','P10')
                 --AND ROWNUM < 51
                 --WHERE CD_PROCEDIMIENTO = 51145 --65580--34816 --65580
                 UNION
                 SELECT CD_CONCURSO AS CD_PROCEDIMIENTO,
                        'P90' AS TIPO_PROCEDIMIENTO,
                        DECODE(SUBSTR(FASE_CONCURSO,1,INSTR(FASE_CONCURSO,'-')-1),'FASE COMUN',70,'FASE CONVENIO',73,'FASE LIQUIDACION',75) AS ULTIMO_HITO
                 FROM MIG_CONCURSOS_CABECERA
--                 WHERE CD_CONCURSO = 30797
                 ORDER BY 1;


  CURSOR c_PARAM_HITOS (p_TIPO_PROCEDIMIENTO IN VARCHAR2, p_ULTIMO_HITO IN NUMBER) IS
						 SELECT
                A.MIG_PARAM_HITO_ID,
                A.COD_HITO_ACTUAL,
                A.DD_TPO_CODIGO,
                A.DD_TPO_DESC,
								A.TAP_CODIGO,
								A.ORDEN,
								A.TAR_TAREA_PENDIENTE,
								A.TAR_FINALIZADA,
                A.FLAG_POR_CADA_BIEN
						 FROM MIG_PARAM_HITOS A
             WHERE A.COD_TIPO_PROCEDIMIENTO = p_TIPO_PROCEDIMIENTO
             AND TO_NUMBER(A.COD_HITO_ACTUAL) <= p_ULTIMO_HITO
						 ORDER BY A.ORDEN;

   CURSOR C_PARAM_HITOS_VALORES (p_MIG_PARAM_HITO_ID IN NUMBER) IS
    					 SELECT CAMPO_INTERFAZ,
                      TABLA_MIG,
                      ORDEN,
                      FLAG_ES_FECHA,
                      TEV_NOMBRE
    					 FROM MIG_PARAM_HITOS_VALORES
    					 WHERE MIG_PARAM_HITO_ID = p_MIG_PARAM_HITO_ID
    					 ORDER BY ORDEN;

   CURSOR c_BIENES_PROCEDIMIENTO (p_CD_PROCEDIMIENTO IN VARCHAR2) IS SELECT DISTINCT NVL(CD_BIEN,0) AS CD_BIEN, ULTIMO_HITO_BIEN_PROC
                                                                     FROM MIG_PROCEDIMIENTOS_BIENES
                                                                     WHERE CD_PROCEDIMIENTO = p_CD_PROCEDIMIENTO
                                                                     ORDER BY 2,1;

  v_SQL  VARCHAR2(32000) := NULL;
  v_TEV_VALOR VARCHAR2(1000 CHAR) := NULL;
  v_PRC_ID NUMBER(32) := 0;
  v_PRC_PRC_ID NUMBER(32) := 0;
  v_ORDEN NUMBER(5) := 1;
  v_TAR_ID NUMBER(32) := 0;
  v_TEV_ID NUMBER(32) := 0;

  v_DD_TPO_CODIGO_ANTERIOR VARCHAR2(50) := 'O';

  v_FLAG_VIGILANCIA_EMBARGOS NUMBER(1) := 2;
  v_FLAG_AUTO_DESPACHANDO NUMBER(1) := 2;
  v_FLAG_DECISION_EJECT NUMBER(1) := 2;
  v_FLAG_OPSOSICION_MONIT NUMBER(1) := 2;
  v_PTE_CERT_CARGAS NUMBER(1) := 2;


  v_CD_BIEN VARCHAR2(20) := NULL;
  v_CD_BIEN_ANTERIOR VARCHAR2(20) := NULL;
  v_MAX_HITO_BIEN VARCHAR2(2) := NULL;

  v_VALIDAR_COMITE NUMBER(1):=0;
  v_SUSPENDER_SUBASTA NUMBER(1):=0;

  v_FECHA_TAREA  DATE := NULL;

  v_PRC_EJECUT NUMBER(32) := 0;
  v_PRC_MONITORIO NUMBER(32) := 0;
  v_PRC_CONCURSO  NUMBER(32) := 0;
  v_PRC_ID_SUBASTA NUMBER(32):=0;

  v_PRC_ADJU_ID NUMBER(32) := 0;
  v_ORDEN_ADJU NUMBER(2) := 0;

  v_CONTROL NUMBER(1) := 0;

  v_IMPORTE_DEMANDA NUMBER(16,2) := 0;

  v_PRC_ID_TAREA_PEND NUMBER(32) :=0;
  v_PRC_PRC_ID_TAREA_PEND NUMBER(32) :=0;

  v_CD_PROCEDIMIENTO  NUMBER(32):=0;
  v_COUNT NUMBER(32):=0;

  v_TAR_FINALIZADA NUMBER(1):=NULL;

  EXISTE NUMBER;
  V_ESQUEMA VARCHAR2(10) := 'CM01';
  TABLE_COUNT NUMBER := 0;

  i NUMBER := 0;
  W NUMBER := 0;
  Z NUMBER := 0;

  v_MAX_ORDEN NUMBER(1):=0;
  
  v_ULTIMO_HITO NUMBER(2) := 0;


BEGIN

   ----------------------------------
   -- MIGRACION A TABLA INTERMEDIA --
   ----------------------------------
DBMS_OUTPUT.ENABLE(1000000);

  SELECT COUNT(1)
  INTO V_COUNT
  FROM USER_CONSTRAINTS
  WHERE CONSTRAINT_NAME = 'FK_MIG_MAESTRA_HITOS';

  IF V_COUNT > 0 THEN

      EXECUTE IMMEDIATE 'ALTER TABLE MIG_MAESTRA_HITOS_VALORES DROP CONSTRAINT FK_MIG_MAESTRA_HITOS';

  END IF;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE MIG_MAESTRA_HITOS_VALORES';

  EXECUTE IMMEDIATE 'TRUNCATE TABLE MIG_MAESTRA_HITOS';

  EXECUTE IMMEDIATE 'ALTER TABLE MIG_MAESTRA_HITOS_VALORES ADD CONSTRAINT FK_MIG_MAESTRA_HITOS FOREIGN KEY (TAR_ID) REFERENCES MIG_MAESTRA_HITOS(TAR_ID) ENABLE';

  V_COUNT := 0;

  SELECT COUNT(1)
  INTO V_COUNT
  FROM ALL_TABLES
  WHERE TABLE_NAME = 'TEMP_MIG_MAESTRA_HITOS_BIENES'
  AND OWNER = 'CM01';

 IF V_COUNT = 0 THEN


    EXECUTE IMMEDIATE ('CREATE TABLE TEMP_MIG_MAESTRA_HITOS_BIENES(CD_PROCEDIMIENTO NUMBER(16, 0) NOT NULL,
								   PRC_ID NUMBER(16, 0) NOT NULL,
								   PRC_PRC_ID NUMBER(16, 0) NOT NULL,
								   DD_TPO_CODIGO VARCHAR2(20 BYTE) NOT NULL,
								   CD_BIEN VARCHAR2(20 BYTE) NOT NULL
								  )'
			);


 ELSE

    EXECUTE IMMEDIATE('DROP TABLE TEMP_MIG_MAESTRA_HITOS_BIENES PURGE');

    EXECUTE IMMEDIATE ('CREATE TABLE TEMP_MIG_MAESTRA_HITOS_BIENES(CD_PROCEDIMIENTO NUMBER(16, 0) NOT NULL,
								   PRC_ID NUMBER(16, 0) NOT NULL,
								   PRC_PRC_ID NUMBER(16, 0) NOT NULL,
								   DD_TPO_CODIGO VARCHAR2(20 BYTE) NOT NULL,
								   CD_BIEN VARCHAR2(20 BYTE) NOT NULL
								  )'
			);

 END IF;

   V_COUNT := 0;

   SELECT COUNT(1)
   INTO V_COUNT
   FROM ALL_INDEXES
   WHERE INDEX_NAME = 'IDX_TEMP_MIG_MAE_HITOS_BIENES'
   AND OWNER = 'CM01';

   IF V_COUNT = 0 THEN

      EXECUTE IMMEDIATE ('CREATE INDEX IDX_TEMP_MIG_MAE_HITOS_BIENES ON TEMP_MIG_MAESTRA_HITOS_BIENES(CD_PROCEDIMIENTO,DD_TPO_CODIGO,CD_BIEN)');

   END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''MIG_PROC_CAB_PK'' AND OWNER=''CM01''') INTO V_COUNT;

    IF V_COUNT = 0 THEN
        EXECUTE IMMEDIATE('CREATE UNIQUE INDEX MIG_PROC_CAB_PK ON '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA (cd_procedimiento) nologging');

    END IF;
    EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA COMPUTE STATISTICS FOR ALL INDEXES';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_PROCEDIMIENTOS_CABECERA ANALIZADA');

    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''MIG_CONC_CAB_PK'' AND OWNER=''CM01''') INTO V_COUNT;

    IF V_COUNT = 0 THEN
        EXECUTE IMMEDIATE('CREATE UNIQUE INDEX MIG_CONC_CAB_PK ON '||V_ESQUEMA||'.MIG_CONCURSOS_CABECERA (cd_concurso) nologging');

    END IF;
    EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.MIG_CONCURSOS_CABECERA COMPUTE STATISTICS FOR ALL INDEXES';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_CONCURSOS_CABECERA ANALIZADA');

    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''MIG_PROC_DEMAN_PK'' AND OWNER=''CM01''') INTO V_COUNT;

    IF V_COUNT = 0 THEN
        EXECUTE IMMEDIATE('CREATE INDEX MIG_PROC_DEMAN_PK ON '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_DEMANDADOS (cd_procedimiento) nologging');

    END IF;
    EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_DEMANDADOS COMPUTE STATISTICS FOR ALL INDEXES';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_PROCEDIMIENTOS_DEMANDADOS ANALIZADA');

    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''IDX_MIG_PRC_BIE_X'' AND OWNER=''CM01''') INTO V_COUNT;

    IF V_COUNT = 0 THEN
        EXECUTE IMMEDIATE('CREATE INDEX IDX_MIG_PRC_BIE_X ON '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES (CD_PROCEDIMIENTO, CD_BIEN) nologging');

    END IF;
    EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_BIENES COMPUTE STATISTICS FOR ALL INDEXES';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_PROCEDIMIENTOS_BIENES ANALIZADA');

    SELECT COUNT(1)
    INTO V_COUNT
    FROM USER_SEQUENCES
    WHERE SEQUENCE_NAME  = 'S_PRC_PROCEDIMIENTOS';

    IF V_COUNT = 1 THEN

      v_SQL := 'DROP SEQUENCE S_PRC_PROCEDIMIENTOS';

      EXECUTE IMMEDIATE(v_SQL);

      v_SQL := 'CREATE SEQUENCE  S_PRC_PROCEDIMIENTOS  MINVALUE 100000000 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 100000000 CACHE 20 NOORDER  NOCYCLE';

      EXECUTE IMMEDIATE(v_SQL);

    ELSE

      v_SQL := 'CREATE SEQUENCE  S_PRC_PROCEDIMIENTOS  MINVALUE 100000000 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 100000000 CACHE 20 NOORDER  NOCYCLE';

      EXECUTE IMMEDIATE(v_SQL);

    END IF;

    V_COUNT := 0;

  DBMS_OUTPUT.PUT_LINE('[INICIO] -->  '||TO_CHAR(SYSDATE,'HH24:MI:SS'));

  FOR j IN c_PROCS LOOP

        SELECT S_PRC_PROCEDIMIENTOS.NEXTVAL
        INTO v_PRC_ID
        FROM DUAL;

        v_ORDEN := 1;

        v_PRC_PRC_ID := 0;

        v_DD_TPO_CODIGO_ANTERIOR := '0';

        v_CONTROL := 0;

        v_FLAG_VIGILANCIA_EMBARGOS := 2;
        v_FLAG_AUTO_DESPACHANDO := 2;
        v_FLAG_DECISION_EJECT := 2;
        v_FLAG_OPSOSICION_MONIT := 2;
        v_PTE_CERT_CARGAS := 2;

        v_VALIDAR_COMITE := 2;
        v_SUSPENDER_SUBASTA := 2;

        Z := 0;

        W:= 0;

        v_CD_PROCEDIMIENTO := j.CD_PROCEDIMIENTO;

        v_COUNT := v_COUNT + 1;

        IF MOD(v_COUNT,1000) = 0 THEN

	    EXECUTE IMMEDIATE('TRUNCATE TABLE TEMP_MIG_MAESTRA_HITOS_BIENES');
            COMMIT;
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH24:MI:SS')||' - COMMIT Reached at '||v_COUNT||' / CD_PROCEDIMIENTO = '||v_CD_PROCEDIMIENTO);

        END IF;


       v_ULTIMO_HITO := j.ULTIMO_HITO;
       
--       DBMS_OUTPUT.PUT_LINE('v_ULTIMO_HITO = '||v_ULTIMO_HITO);

       --CONCURSOS --NUEVAS FECHAS
       IF j.TIPO_PROCEDIMIENTO = 'P90' THEN

                 --CALCULO DEL HITO EN CONCURSOS:
                 IF v_ULTIMO_HITO = 70 THEN
                 
                     SELECT DECODE(FECHA_COMUNICACION_CREDITOS,NULL,v_ULTIMO_HITO,71)
                     INTO v_ULTIMO_HITO
                     FROM MIG_CONCURSOS_CABECERA
                     WHERE CD_CONCURSO = j.CD_PROCEDIMIENTO;
                 
                 END IF;
                 
                 SELECT DECODE(FECHA_APROBACION_CONVENIO,NULL,v_ULTIMO_HITO,74)
                 INTO v_ULTIMO_HITO
                 FROM MIG_CONCURSOS_CABECERA
                 WHERE CD_CONCURSO = j.CD_PROCEDIMIENTO;                                  
                 
                 SELECT DECODE(FECHA_APERTURA,NULL,v_ULTIMO_HITO,76)
                 INTO v_ULTIMO_HITO
                 FROM MIG_CONCURSOS_CABECERA
                 WHERE CD_CONCURSO = j.CD_PROCEDIMIENTO;
                 
                 SELECT DECODE(FECHA_APROBACION_PLAN,NULL,v_ULTIMO_HITO,77)
                 INTO v_ULTIMO_HITO
                 FROM MIG_CONCURSOS_CABECERA
                 WHERE CD_CONCURSO = j.CD_PROCEDIMIENTO;
                 
                 SELECT DECODE(ALEGACIONES_PLAN_LIQUIDACION,NULL,v_ULTIMO_HITO,78)
                 INTO v_ULTIMO_HITO
                 FROM MIG_CONCURSOS_CABECERA
                 WHERE CD_CONCURSO = j.CD_PROCEDIMIENTO;
          
                 SELECT DECODE(FECHA_SUBASTA,NULL,v_ULTIMO_HITO,80)
                 INTO v_ULTIMO_HITO
                 FROM MIG_CONCURSOS_CABECERA
                 WHERE CD_CONCURSO = j.CD_PROCEDIMIENTO;

       END IF;

       --DBMS_OUTPUT.PUT_LINE('v_ULTIMO_HITO = '||v_ULTIMO_HITO);



		FOR k IN c_PARAM_HITOS(j.TIPO_PROCEDIMIENTO, v_ULTIMO_HITO) LOOP

        IF k.COD_HITO_ACTUAL = v_ULTIMO_HITO THEN

           v_TAR_FINALIZADA := k.TAR_FINALIZADA;

        ELSIF ((k.TAP_CODIGO = 'H030_SolicitarInformacionCargasAnt' OR k.TAP_CODIGO = 'H058_EstConformidadOAlegacion') AND v_ULTIMO_HITO IN (50,51)) THEN

          v_PTE_CERT_CARGAS := 1;

          v_TAR_FINALIZADA := 0;

        ELSIF ((k.TAP_CODIGO = 'H030_SolicitarInformacionCargasAnt' OR k.TAP_CODIGO = 'H058_EstConformidadOAlegacion') AND v_ULTIMO_HITO > 51 AND v_FLAG_VIGILANCIA_EMBARGOS = 1) THEN

          v_PTE_CERT_CARGAS := 1;

          v_TAR_FINALIZADA := 0;

        ELSE

           v_TAR_FINALIZADA := 1;

        END IF;

        i := 0;

        IF (k.DD_TPO_CODIGO <> 'HC103' AND v_DD_TPO_CODIGO_ANTERIOR <> 'HC103') OR (k.DD_TPO_CODIGO = 'HC103' AND v_TAR_FINALIZADA = 0) THEN

        --DBMS_OUTPUT.PUT_LINE('k.DD_TPO_CODIGO : '||k.DD_TPO_CODIGO||' -  v_DD_TPO_CODIGO_ANTERIOR: '||v_DD_TPO_CODIGO_ANTERIOR||' - k.ORDEN = '||k.ORDEN);

                IF k.DD_TPO_CODIGO = 'H020' AND k.ORDEN = 1 THEN

                     v_PRC_EJECUT := V_PRC_ID;

                ELSIF k.DD_TPO_CODIGO = 'H022' AND k.ORDEN = 1 THEN

                     v_PRC_MONITORIO := v_PRC_ID;

                ELSIF k.DD_TPO_CODIGO = 'H009' AND k.ORDEN = 1 THEN

                     v_PRC_CONCURSO := v_PRC_ID;

                END IF;



           IF (v_DD_TPO_CODIGO_ANTERIOR <> k.DD_TPO_CODIGO AND k.ORDEN > 1) THEN

           --DBMS_OUTPUT.PUT_LINE('k.DD_TPO_CODIGO : '||k.DD_TPO_CODIGO||' -  v_DD_TPO_CODIGO_ANTERIOR: '||v_DD_TPO_CODIGO_ANTERIOR||' - k.ORDEN = '||k.ORDEN);

                IF v_DD_TPO_CODIGO_ANTERIOR = 'H062' THEN

                    v_PRC_ID := v_PRC_ID - 1;

                    v_PRC_PRC_ID := 0;

                    v_ORDEN := v_ORDEN - 1;

                ELSIF (k.DD_TPO_CODIGO IN ('H030','H058') AND v_FLAG_VIGILANCIA_EMBARGOS = 1) OR (v_ULTIMO_HITO IN (50.51)) THEN

                    v_PRC_PRC_ID := v_PRC_EJECUT;

                    SELECT S_PRC_PROCEDIMIENTOS.NEXTVAL
                    INTO v_PRC_ID
                    FROM DUAL;

                     v_ORDEN := v_ORDEN + 1;

                ELSIF v_DD_TPO_CODIGO_ANTERIOR = 'H058' AND k.DD_TPO_CODIGO = 'H020' THEN

                    v_PRC_PRC_ID := 0;

                    v_PRC_ID := v_PRC_EJECUT;

                ELSIF k.DD_TPO_CODIGO IN ('H024','H018','H028') THEN

                      v_PRC_PRC_ID := v_PRC_MONITORIO;

                      SELECT S_PRC_PROCEDIMIENTOS.NEXTVAL
                      INTO v_PRC_ID
                      FROM DUAL;

                ELSIF k.DD_TPO_CODIGO = 'H033' AND v_DD_TPO_CODIGO_ANTERIOR = 'H041' THEN

                      v_PRC_PRC_ID := v_PRC_CONCURSO;

                ELSIF k.DD_TPO_CODIGO NOT IN ('H020','H030','H058','H033') THEN

                  v_PRC_PRC_ID := v_PRC_ID;

                  SELECT S_PRC_PROCEDIMIENTOS.NEXTVAL
                  INTO v_PRC_ID
                  FROM DUAL;

                  v_ORDEN := v_ORDEN + 1;

                END IF;

          END IF;

--          DBMS_OUTPUT.PUT_LINE('v_PRC_ID : '||v_PRC_ID||' -  v_PRC_PRC_ID: '||v_PRC_PRC_ID);

        END IF; -- CAMBIO TPO

        v_DD_TPO_CODIGO_ANTERIOR := k.DD_TPO_CODIGO;

        FOR l IN C_PARAM_HITOS_VALORES(k.MIG_PARAM_HITO_ID) LOOP

            IF k.FLAG_POR_CADA_BIEN = 0 THEN

                   IF l.FLAG_ES_FECHA = 1 THEN

                            IF INSTR(l.CAMPO_INTERFAZ,'FECHA') > 0 AND INSTR(l.CAMPO_INTERFAZ,'DECODE') = 0 THEN

                               IF l.TABLA_MIG <> 'MIG_CONCURSOS_CABECERA' THEN

                                  IF  l.TABLA_MIG = 'MIG_PROCEDIMIENTOS_SUBASTAS' THEN

                                      v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||',''DD-MM-RRRR'')
                                                FROM '||l.TABLA_MIG||'
                                                WHERE CD_SUBASTA = (SELECT MAX(CD_SUBASTA)
                                                                    FROM '||l.TABLA_MIG||'
                                                                    WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO||')';

                                  ELSE

                                      v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||',''DD-MM-RRRR'')
                                            FROM '||l.TABLA_MIG||'
                                            WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO;

                                  END IF;


                               ELSE

                                  v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||',''DD-MM-RRRR'')
                                        FROM '||l.TABLA_MIG||'
                                        WHERE CD_CONCURSO = '||j.CD_PROCEDIMIENTO;

                               END IF;

                            ELSIF INSTR(l.CAMPO_INTERFAZ,'FECHA') = 0 OR INSTR(l.CAMPO_INTERFAZ,'DECODE') > 0 THEN

                                  IF l.TABLA_MIG <> 'MIG_CONCURSOS_CABECERA' THEN

                                      v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                FROM '||l.TABLA_MIG||'
                                                WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO;

                                  ELSIF l.TABLA_MIG = 'MIG_CONCURSOS_CABECERA' THEN

                                        v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                  FROM '||l.TABLA_MIG||'
                                                  WHERE CD_CONCURSO = '||j.CD_PROCEDIMIENTO;
                                  END IF;

                            END IF;

                            BEGIN

                                EXECUTE IMMEDIATE v_SQL INTO v_TEV_VALOR;

                             EXCEPTION
                                 WHEN NO_DATA_FOUND THEN

                                    v_TEV_VALOR := NULL;

                             END;



                            IF k.ORDEN = 1 AND l.CAMPO_INTERFAZ = 'FECHA_PRESENTACION_DEMANDA' AND v_TEV_VALOR IS NULL AND v_ULTIMO_HITO IN (1,20,10,29,40,59) THEN

                                  v_TAR_FINALIZADA := 0;

                                  v_CONTROL := 1;

                            END IF;

                            --CAMBIARIO:
                            -- VEMOS SI HAY EMBARGOS
                            IF k.TAP_CODIGO = 'H016_confAdmiDecretoEmbargo' AND l.TEV_NOMBRE = 'comboBienes' THEN

                                IF TO_NUMBER(v_TEV_VALOR) > 0 OR v_ULTIMO_HITO = 3 THEN

                                   v_FLAG_VIGILANCIA_EMBARGOS := 1;

                                   v_CONTROL := 0;

                                ELSE

                                    v_FLAG_VIGILANCIA_EMBARGOS := 0;

                                    v_CONTROL := 2;

                                END IF;

                            END IF;

                            IF v_CONTROL = 2 AND k.DD_TPO_CODIGO = 'H016' THEN

                                v_cONTROL := 0;

                            ELSIF v_FLAG_VIGILANCIA_EMBARGOS =0 AND k.DD_TPO_CODIGO = 'H062' AND j.TIPO_PROCEDIMIENTO = 'P06' THEN

                                  v_CONTROL := 3;

                            ELSIF v_FLAG_VIGILANCIA_EMBARGOS =0 AND k.TAP_CODIGO = 'H016_registrarDemandaOposicion' AND v_FLAG_AUTO_DESPACHANDO IN (0,2) THEN

                                  v_CONTROL := 0;

                            ELSIF v_FLAG_VIGILANCIA_EMBARGOS = 1 OR (k.COD_HITO_ACTUAL > 3 and k.COD_HITO_ACTUAL < 10) THEN

                                  v_CONTROL := 0;

                            END IF;

                            IF k.TAP_CODIGO = 'H016_registrarDemandaOposicion' AND l.TEV_NOMBRE = 'comboOposicion' AND v_TEV_VALOR = '0' THEN

                               IF v_ULTIMO_HITO = 3 THEN

                                  v_CONTROL := 3;

                               ELSE

                                  v_FLAG_AUTO_DESPACHANDO := 1;

                               END IF;

                            END IF;

                            IF v_FLAG_AUTO_DESPACHANDO = 1 AND (k.COD_HITO_ACTUAL > 5 AND k.COD_HITO_ACTUAL < 8) THEN

                               v_CONTROL := 3;

                               IF v_ULTIMO_HITO = 7 THEN

                                  v_TAR_FINALIZADA := 0;

                               ELSE

                                  v_TAR_FINALIZADA := 1;

                               END IF;

                               IF l.TEV_NOMBRE = 'fecha' AND W = 0 THEN

                                   SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                                        INTO v_TAR_ID
                                        FROM DUAL;

                                   v_TEV_VALOR := TO_CHAR((TO_DATE(v_TEV_VALOR,'DD-MM-RRRR') + 1),'DD-MM-RRRR');

                                   INSERT INTO MIG_MAESTRA_HITOS
                                                 (CD_PROCEDIMIENTO,
                                                  PRC_ID,
                                                  PRC_PRC_ID,
                                                  ORDEN,
                                                  DD_TPO_CODIGO,
                                                  DD_TPO_DESC,
                                                  TAP_CODIGO,
                                                  TAR_ID,
                                                  TAR_TAREA,
                                                  TAR_FECHA,
                                                  TAR_TAREA_FINALIZADA,
                                                  CD_BIEN,
                                                  COD_HITO_ACTUAL,
                                                  ULTIMO_HITO)
                                       VALUES
                                              (j.CD_PROCEDIMIENTO
                                              ,v_PRC_ID
                                              ,v_PRC_PRC_ID
                                              ,v_ORDEN
                                              ,k.DD_TPO_CODIGO
                                              ,k.DD_TPO_DESC
                                              ,'H016_registrarAutoEjecucion'
                                              ,v_TAR_ID
                                              ,'Registrar auto despachando ejecución'
                                              ,v_TEV_VALOR
                                              ,v_TAR_FINALIZADA
                                              , NULL
                                              , k.COD_HITO_ACTUAL
                                              , v_ULTIMO_HITO);

                                        SELECT S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL
                                        INTO v_TEV_ID
                                        FROM DUAL;

                                        INSERT INTO MIG_MAESTRA_HITOS_VALORES
                                                (TEV_ID
                                                ,TAR_ID
                                                ,TAR_TAREA
                                                ,TAP_CODIGO
                                                ,TEV_ORDEN
                                                ,TEV_NOMBRE
                                                ,TEV_VALOR)
                                         VALUES
                                               (v_TEV_ID
                                               ,v_TAR_ID
                                               ,'Registrar auto despachando ejecución'
                                               ,'H016_registrarAutoEjecucion'
                                               ,1
                                               ,'fecha'
                                               ,v_TEV_VALOR);

                                       W := 1;

                                  END IF;

                            ELSIF v_CONTROL = 3 AND k.COD_HITO_ACTUAL IN (8,9) THEN

                                  v_TAR_FINALIZADA := k.TAR_FINALIZADA;

                                  v_CONTROL := 0;

                            END IF;

                            -- ORDINARIO
                            IF k.TAP_CODIGO = 'H024_RegistrarAudienciaPrevia' AND l.TEV_NOMBRE = 'comboResultado' AND v_TEV_VALOR = '0' THEN

                               IF v_TAR_FINALIZADA = 1 THEN

                                  v_CONTROL := 0;

                               ELSIF v_TAR_FINALIZADA = 0 THEN

                                  v_CONTROL := 6;

                               END IF;

                            ELSIF k.TAP_CODIGO = 'H024_RegistrarAudienciaPrevia' AND l.TEV_NOMBRE = 'comboResultado' AND v_TEV_VALOR = '1' THEN

                               v_CONTROL := 5;

                            END IF;

                            IF v_CONTROL = 5 AND k.COD_HITO_ACTUAL = 14 THEN

                                   v_CONTROL := 3;

                                   IF v_TAR_FINALIZADA = 0 THEN

                                         SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                                         INTO v_TAR_ID
                                         FROM DUAL;

                                         INSERT INTO MIG_MAESTRA_HITOS
                                                       (CD_PROCEDIMIENTO,
                                                        PRC_ID,
                                                        PRC_PRC_ID,
                                                        ORDEN,
                                                        DD_TPO_CODIGO,
                                                        DD_TPO_DESC,
                                                        TAP_CODIGO,
                                                        TAR_ID,
                                                        TAR_TAREA,
                                                        TAR_FECHA,
                                                        TAR_TAREA_FINALIZADA,
                                                        CD_BIEN,
                                                        COD_HITO_ACTUAL
                                                      , ULTIMO_HITO)
                                             VALUES
                                                    (j.CD_PROCEDIMIENTO
                                                    ,v_PRC_ID
                                                    ,v_PRC_PRC_ID
                                                    ,v_ORDEN
                                                    ,k.DD_TPO_CODIGO
                                                    ,k.DD_TPO_DESC
                                                    ,'H024_RegistrarResolucion'
                                                    ,v_TAR_ID
                                                    ,'Registrar resolucion'
                                                    ,NULL -- v_TEV_VALOR
                                                    ,0 -- v_TAR_FINALIZADA
                                                    ,NULL
                                                    , k.COD_HITO_ACTUAL
                                              , v_ULTIMO_HITO);

                                   END IF;

                            ELSIF v_CONTROL = 6 AND k.COD_HITO_ACTUAL = 15 THEN

                                   v_CONTROL := 3;

                            ELSIF v_CONTROL = 3 AND k.DD_TPO_CODIGO = 'H024' AND k.COD_HITO_ACTUAL >= 15 THEN

                               IF v_ULTIMO_HITO = 15 THEN

                                   v_TAR_FINALIZADA := k.TAR_FINALIZADA;

                                   v_CONTROL := 0;

                               ELSIF v_ULTIMO_HITO > 15 THEN

                                   v_TAR_FINALIZADA := 1;

                                   v_CONTROL := 0;

                               END IF;

                            END IF;


                            -- P. HIPOTECARIO
                            IF L.TEV_NOMBRE = 'cargasPrevias' AND TO_NUMBER(v_TEV_VALOR) <= 0 THEN

                               v_CONTROL := 3;

                               v_TAR_FINALIZADA := 0;

                               IF v_CONTROL = 3 AND v_ULTIMO_HITO  = 32 THEN
                               
                                   DELETE FROM MIG_MAESTRA_HITOS_VALORES
                                   WHERE TAR_ID IN (SELECT DISTINCT TAR_ID
                                                    FROM MIG_MAESTRA_HITOS
                                                    WHERE CD_PROCEDIMIENTO = j.CD_PROCEDIMIENTO
                                                    AND TAP_CODIGO IN ('H001_RegistrarCertificadoCargas','H001_ConfirmarNotificacionReqPago')
                                                    );

                                   UPDATE MIG_MAESTRA_HITOS
                                          SET TAR_FECHA = NULL,
                                              TAR_TAREA_FINALIZADA = v_TAR_FINALIZADA
                                    WHERE CD_PROCEDIMIENTO = j.CD_PROCEDIMIENTO
                                      AND TAP_CODIGO IN ('H001_RegistrarCertificadoCargas','H001_ConfirmarNotificacionReqPago');

                               ELSIF L.TEV_NOMBRE = 'cargasPrevias' AND TO_NUMBER(v_TEV_VALOR) > 0 THEN

                                  v_CONTROL := 0;

                               END IF;

                             END IF;

                             IF k.COD_HITO_ACTUAL = 33 AND v_ULTIMO_HITO = 33 THEN

                                 v_CONTROL := 3;

                                 v_TAR_FINALIZADA := 0;

                                  IF Z = 0 THEN

                                    SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                                    INTO v_TAR_ID
                                    FROM DUAL;

                                     INSERT INTO MIG_MAESTRA_HITOS
                                                   (CD_PROCEDIMIENTO,
                                                    PRC_ID,
                                                    PRC_PRC_ID,
                                                    ORDEN,
                                                    DD_TPO_CODIGO,
                                                    DD_TPO_DESC,
                                                    TAP_CODIGO,
                                                    TAR_ID,
                                                    TAR_TAREA,
                                                    TAR_FECHA,
                                                    TAR_TAREA_FINALIZADA,
                                                    CD_BIEN
                                                    ,COD_HITO_ACTUAL
                                              , ULTIMO_HITO)
                                         VALUES
                                                (j.CD_PROCEDIMIENTO
                                                ,v_PRC_ID
                                                ,v_PRC_PRC_ID
                                                ,v_ORDEN
                                                ,k.DD_TPO_CODIGO
                                                ,k.DD_TPO_DESC
                                                ,'H001_ConfirmarSiExisteOposicion'
                                                ,v_TAR_ID
                                                ,'Confirmar si existe oposición'
                                                ,NULL
                                                ,v_TAR_FINALIZADA
                                                ,NULL
                                                ,k.COD_HITO_ACTUAL
                                                ,v_ULTIMO_HITO);

                                       Z := 1;

                                    END IF;

                            ELSIF (k.TAP_CODIGO = 'H001_ConfirmarSiExisteOposicion' AND l.TEV_NOMBRE = 'comboResultado' AND v_TEV_VALOR = '0' AND v_ULTIMO_HITO > 33) THEN

                                  v_CONTROL := 3;

                            ELSIF k.TAP_CODIGO = 'H001_ConfirmarSiExisteOposicion' AND l.TEV_NOMBRE = 'comboResultado' AND v_TEV_VALOR = '1' AND v_ULTIMO_HITO > 33 THEN

                                  v_CONTROL := 0;

                            END IF;

                            IF k.COD_HITO_ACTUAL  > 33 AND j.TIPO_PROCEDIMIENTO = 'P01' THEN

                                  v_CONTROL := 0;

                            END IF;

                             --P. ETNJ
                            -- VEMOS SI HAY EMBARGOS

                            IF k.TAP_CODIGO = 'H020_AutoDespaEjecMasDecretoEmbargo' AND l.TEV_NOMBRE = 'bienesEmbargables' THEN

                                IF TO_NUMBER(v_TEV_VALOR) > 0 OR v_ULTIMO_HITO IN (50,51) THEN

                                   v_FLAG_VIGILANCIA_EMBARGOS := 1;

                                   v_CONTROL := 0;

                                ELSIF TO_NUMBER(v_TEV_VALOR) = 0 AND v_ULTIMO_HITO NOT IN (50,51) AND j.TIPO_PROCEDIMIENTO = 'P03' THEN

                                    v_FLAG_VIGILANCIA_EMBARGOS := 0;

                                END IF;

                            END IF;

                            IF v_FLAG_VIGILANCIA_EMBARGOS = 0 AND k.DD_TPO_CODIGO = 'H020' THEN

                                  v_cONTROL := 0;

                            ELSIF v_FLAG_VIGILANCIA_EMBARGOS =0 AND k.DD_TPO_CODIGO = 'H062' THEN

                                  v_CONTROL := 3;

                            ELSIF v_FLAG_VIGILANCIA_EMBARGOS =0 AND k.TAP_CODIGO = 'H020_ConfirmarSiExisteOposicion' THEN

                                  v_CONTROL := 0;

                            ELSIF v_FLAG_VIGILANCIA_EMBARGOS = 0 AND v_ULTIMO_HITO IN (50,51) THEN

                              v_CONTROL := 0;

                            ELSIF v_FLAG_VIGILANCIA_EMBARGOS = 0 AND v_ULTIMO_HITO NOT IN (50,51) AND j.TIPO_PROCEDIMIENTO = 'P03' THEN

                              v_CONTROL := 3;

                            ELSIF v_FLAG_VIGILANCIA_EMBARGOS = 1 OR k.COD_HITO_ACTUAL >= 43 AND j.TIPO_PROCEDIMIENTO = 'P03' THEN

                                  v_CONTROL := 0;

                            END IF;

                            IF k.TAP_CODIGO = 'H020_ConfirmarSiExisteOposicion' AND v_TEV_VALOR = '0' THEN

                               v_FLAG_DECISION_EJECT := 1;

                            END IF;

                            IF v_FLAG_DECISION_EJECT = 1 AND k.COD_HITO_ACTUAL = 52 THEN

                               v_CONTROL := 3;

                               IF v_ULTIMO_HITO = 52 AND k.TAP_CODIGO = 'H020_ResolucionFirme' THEN

                                  IF v_FLAG_VIGILANCIA_EMBARGOS = 0 THEN

                                            SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                                            INTO v_TAR_ID
                                            FROM DUAL;

                                             INSERT INTO MIG_MAESTRA_HITOS
                                                           (CD_PROCEDIMIENTO,
                                                            PRC_ID,
                                                            PRC_PRC_ID,
                                                            ORDEN,
                                                            DD_TPO_CODIGO,
                                                            DD_TPO_DESC,
                                                            TAP_CODIGO,
                                                            TAR_ID,
                                                            TAR_TAREA,
                                                            TAR_FECHA,
                                                            TAR_TAREA_FINALIZADA,
                                                            CD_BIEN,
                                                            COD_HITO_ACTUAL
                                                          , ULTIMO_HITO)
                                                 VALUES
                                                        (j.CD_PROCEDIMIENTO
                                                        ,v_PRC_ID
                                                        ,v_PRC_PRC_ID
                                                        ,v_ORDEN
                                                        ,k.DD_TPO_CODIGO
                                                        ,k.DD_TPO_DESC
                                                        ,'H020_JudicialDecision'
                                                        ,v_TAR_ID
                                                        ,'Tarea toma de decisión'
                                                        ,NULL --v_TEV_VALOR
                                                        ,0 -- v_TAR_FINALIZADA
                                                        ,NULL
                                                        , k.COD_HITO_ACTUAL
                                                  , v_ULTIMO_HITO);

                                      END IF;

                               ELSIF v_ULTIMO_HITO > 52 AND k.TAP_CODIGO = 'H020_ResolucionFirme' THEN

                                   SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                                   INTO v_TAR_ID
                                   FROM DUAL;

                                   INSERT INTO MIG_MAESTRA_HITOS
                                                 (CD_PROCEDIMIENTO,
                                                  PRC_ID,
                                                  PRC_PRC_ID,
                                                  ORDEN,
                                                  DD_TPO_CODIGO,
                                                  DD_TPO_DESC,
                                                  TAP_CODIGO,
                                                  TAR_ID,
                                                  TAR_TAREA,
                                                  TAR_FECHA,
                                                  TAR_TAREA_FINALIZADA,
                                                  CD_BIEN,
                                                  COD_HITO_ACTUAL
                                                , ULTIMO_HITO)
                                       VALUES
                                              (j.CD_PROCEDIMIENTO
                                              ,v_PRC_ID
                                              ,v_PRC_PRC_ID
                                              ,v_ORDEN
                                              ,k.DD_TPO_CODIGO
                                              ,k.DD_TPO_DESC
                                              ,'H020_JudicialDecision'
                                              ,v_TAR_ID
                                              ,'Tarea toma de decisión'
                                              ,v_TEV_VALOR
                                              ,1 -- v_TAR_FINALIZADA
                                              ,NULL
                                              , k.COD_HITO_ACTUAL
                                        , v_ULTIMO_HITO);

                                END IF;

                            END IF;

                            IF v_FLAG_DECISION_EJECT = 1 AND v_CONTROL = 3 AND k.COD_HITO_ACTUAL > 52 AND j.TIPO_PROCEDIMIENTO = 'P03' THEN

                                V_CONTROL := 0;

                            END IF;

                            IF v_CONTROL = 3 AND v_FLAG_DECISION_EJECT = 0 AND k.COD_HITO_ACTUAL > 51 AND j.TIPO_PROCEDIMIENTO = 'P03' THEN

                               v_CONTROL := 0;

                            END IF;

                            --MONITORIO
                            IF k.COD_HITO_ACTUAL = 59 AND k.TAP_CODIGO = 'H022_InterposicionDemanda' AND l.TEV_NOMBRE = 'principalDemanda' THEN

                               v_IMPORTE_DEMANDA := TO_NUMBER(v_TEV_VALOR);

                            END IF;

                            IF k.COD_HITO_ACTUAL = 61 AND k.TAP_CODIGO = 'H022_ConfirmarOposicionCuantia' AND l.TEV_NOMBRE = 'comboResultado' AND v_TEV_VALOR = '0' THEN

                               v_FLAG_OPSOSICION_MONIT := 0;

                            ELSIF k.COD_HITO_ACTUAL = 61 AND k.TAP_CODIGO = 'H022_ConfirmarOposicionCuantia' AND l.TEV_NOMBRE = 'comboResultado' AND v_TEV_VALOR = '1' THEN

                               v_FLAG_OPSOSICION_MONIT := 1;

                            END IF;

                            IF v_FLAG_OPSOSICION_MONIT = 0 AND k.COD_HITO_ACTUAL = 62 THEN

                               IF k.DD_TPO_CODIGO = 'H018' THEN

                                  v_CONTROL := 0;

                               ELSIF k.DD_TPO_CODIGO <> 'H018' THEN

                                  v_CONTROL := 3;

                               END IF;

                            END IF;

                            IF v_FLAG_OPSOSICION_MONIT = 1 AND k.COD_HITO_ACTUAL = 62 THEN

                               IF v_IMPORTE_DEMANDA > 6000 THEN

                                  IF k.DD_TPO_CODIGO <> 'H024' THEN

                                     v_CONTROL := 3;

                                  ELSIF k.DD_TPO_CODIGO = 'H024' THEN

                                     v_CONTROL := 0;

                                  END IF;

                               ELSIF v_IMPORTE_DEMANDA <= 6000 THEN

                                  IF k.DD_TPO_CODIGO <> 'H028' THEN

                                     v_CONTROL := 3;

                                  ELSIF k.DD_TPO_CODIGO = 'H028' THEN

                                     v_CONTROL := 0;

                                  END IF;

                                END IF;

                             END IF;

                             -- SUBASTAS:
                             IF (j.TIPO_PROCEDIMIENTO = 'P01' AND v_ULTIMO_HITO > 34) OR (j.TIPO_PROCEDIMIENTO = 'P03' AND v_ULTIMO_HITO > 53) THEN  -- Si se va a llegar a ADJUDICACION o POSESIÓN:

                                 IF k.TAP_CODIGO = 'H002_ValidarInformeDeSubasta' AND l.TEV_NOMBRE = 'comboAtribuciones' AND v_TEV_VALOR ='0' THEN

                                    v_VALIDAR_COMITE := 1;

                                 ELSIF k.TAP_CODIGO = 'H002_ValidarInformeDeSubasta' AND l.TEV_NOMBRE = 'comboAtribuciones' AND v_TEV_VALOR ='1' THEN

                                    v_VALIDAR_COMITE := 0;

                                 END IF;


                                 IF v_VALIDAR_COMITE = 1 AND k.TAP_CODIGO = 'H002_ObtenerValidacionComite' THEN

                                    v_CONTROL := 0;

                                 ELSIF v_VALIDAR_COMITE = 0 AND k.TAP_CODIGO = 'H002_ObtenerValidacionComite' THEN

                                    v_TAR_FINALIZADA := 0;

                                    v_CONTROL := 3;

                                 END IF;

                                 IF k.TAP_CODIGO = 'H002_DictarInstruccionesSubasta' AND l.TEV_NOMBRE = 'comboSuspender' AND v_TEV_VALOR = 1 THEN

                                    v_SUSPENDER_SUBASTA := 1;

                                 ELSIF k.TAP_CODIGO = 'H002_DictarInstruccionesSubasta' AND l.TEV_NOMBRE = 'comboSuspender' AND v_TEV_VALOR = 0 THEN

                                    v_SUSPENDER_SUBASTA := 0;

                                 END IF;

                                 IF v_SUSPENDER_SUBASTA = 1 THEN

                                    IF k.COD_HITO_ACTUAL IN (36,55) THEN

                                       v_CONTROL := 3;

                                    ELSIF k.COD_HITO_ACTUAL in (34,37,53,56) THEN

                                       v_TAR_FINALIZADA := 1;

                                       v_CONTROL := 0;

                                    END IF;

                                 ELSIF v_SUSPENDER_SUBASTA = 0 THEN

                                     IF k.COD_HITO_ACTUAL IN (37,56) THEN

                                        v_CONTROL := 3;

                                     ELSIF k.COD_HITO_ACTUAL IN (34,35,36,53,54,55) AND v_CONTROL <> 3 THEN

                                        v_TAR_FINALIZADA := 1;

                                        v_CONTROL := 0;

                                     END IF;

                                 END IF;

                             END IF; -- Subastas
                             
                             
                             
                             -- CONCURSOS
                             IF v_ULTIMO_HITO > 74 AND k.DD_TPO_CODIGO = 'H017' THEN  -- SI FASE de LIQUIDACION, Esta será HIJA del T. de FASE COMÚN Y NO SE DAN DE ALTA LAS TAREAS DE FASE de CONVENIO.
  
                                v_CONTROL := 3;
                              
                             ELSIF k.DD_TPO_CODIGO IN ('H009','H033') THEN
                              
                                v_CONTROL := 0;
                              
                             END IF;
                             
                            
                             IF v_TAR_FINALIZADA = 1 AND v_CONTROL NOT IN (2,3) AND (l.TEV_NOMBRE LIKE '%fecha%' OR l.TEV_NOMBRE = 'comboAtribuciones' OR l.TEV_NOMBRE = 'comboCelebrada'
                                OR (k.DD_TPO_CODIGO = 'H009' AND (l.TEV_NOMBRE = 'comboResultado' OR l.TEV_NOMBRE = 'comboAdmitida' OR l.TEV_NOMBRE = 'observaciones' OR l.TEV_NOMBRE = 'comFavorable'))
                                OR (k.DD_TPO_CODIGO = 'H033' AND l.TEV_NOMBRE = 'comboAlegaciones'))
                             THEN

                                IF l.TEV_NOMBRE = 'comboAtribuciones' THEN

                                    SELECT TO_CHAR(MAX(FECHA_SOLICITUD_SUBASTA)+3,'DD-MM-RRRR')
                                    INTO v_FECHA_TAREA
                                    FROM MIG_PROCEDIMIENTOS_SUBASTAS
                                    WHERE CD_SUBASTA = (SELECT MAX(CD_SUBASTA)
                                                        FROM MIG_PROCEDIMIENTOS_SUBASTAS
                                                        WHERE CD_PROCEDIMIENTO = j.CD_PROCEDIMIENTO);

                                ELSIF l.TEV_NOMBRE = 'comboCelebrada' THEN

                                    SELECT TO_CHAR(MAX(FECHA_SENALAMIENTO_SUBASTA),'DD-MM-RRRR')
                                    INTO v_FECHA_TAREA
                                    FROM MIG_PROCEDIMIENTOS_SUBASTAS
                                    WHERE CD_SUBASTA = (SELECT MAX(CD_SUBASTA)
                                                        FROM MIG_PROCEDIMIENTOS_SUBASTAS
                                                        WHERE CD_PROCEDIMIENTO = j.CD_PROCEDIMIENTO);

                                END IF;

                                SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                                INTO v_TAR_ID
                                FROM DUAL;

                                 INSERT INTO MIG_MAESTRA_HITOS
                                               (CD_PROCEDIMIENTO,
                                                PRC_ID,
                                                PRC_PRC_ID,
                                                ORDEN,
                                                DD_TPO_CODIGO,
                                                DD_TPO_DESC,
                                                TAP_CODIGO,
                                                TAR_ID,
                                                TAR_TAREA,
                                                TAR_FECHA,
                                                TAR_TAREA_FINALIZADA,
                                                CD_BIEN
                                                ,COD_HITO_ACTUAL
                                                ,ULTIMO_HITO)
                                     VALUES
                                            (j.CD_PROCEDIMIENTO
                                            ,v_PRC_ID
                                            ,v_PRC_PRC_ID
                                            ,v_ORDEN
                                            ,k.DD_TPO_CODIGO
                                            ,k.DD_TPO_DESC
                                            ,k.TAP_CODIGO
                                            ,v_TAR_ID
                                            ,k.TAR_TAREA_PENDIENTE
                                            ,DECODE(v_TEV_VALOR,'0',v_FECHA_TAREA,'1',v_FECHA_TAREA,v_TEV_VALOR)
                                            ,v_TAR_FINALIZADA
                                            ,NULL
                                            ,k.COD_HITO_ACTUAL
                                            ,v_ULTIMO_HITO);

                              END IF; -- TAR_FINALIZADA = 1

               END IF; --FLAG_ES_FECHA=1

               IF l.FLAG_ES_FECHA = 0 THEN

                       IF INSTR(l.CAMPO_INTERFAZ,'FECHA') = 0 THEN

                             IF l.TABLA_MIG <> 'MIG_CONCURSOS_CABECERA' THEN

                                   IF l.TABLA_MIG = 'MIG_PROCS_SUBASTA_LOTES_BIENES' THEN

                                       v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                 FROM '||l.TABLA_MIG||' A, MIG_PROCEDIMIENTOS_SUBASTAS B, MIG_PROCS_SUBASTAS_LOTES C
                                                 WHERE A.CD_LOTE = C.CD_LOTE
                                                 AND C.CD_SUBASTA = B.CD_SUBASTA
                                                 AND B.CD_SUBASTA = (SELECT MAX(CD_SUBASTA)
                                                                     FROM MIG_PROCEDIMIENTOS_SUBASTAS
                                                                     WHERE B.CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO ||')';

                                   ELSIF l.TABLA_MIG = 'MIG_PROCS_SUBASTAS_LOTES' THEN

                                       v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                 FROM '||l.TABLA_MIG||' A, MIG_PROCEDIMIENTOS_SUBASTAS B
                                                 WHERE A.CD_SUBASTA = B.CD_SUBASTA
                                                 AND B.CD_SUBASTA = (SELECT MAX(CD_SUBASTA)
                                                                     FROM MIG_PROCEDIMIENTOS_SUBASTAS
                                                                     WHERE B.CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO ||')';


                                   ELSIF  l.TABLA_MIG = 'MIG_PROCEDIMIENTOS_SUBASTAS' THEN

                                      v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                FROM '||l.TABLA_MIG||'
                                                WHERE CD_SUBASTA = (SELECT MAX(CD_SUBASTA) FROM '||l.TABLA_MIG||'
                                                                    WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO||')';


                                  ELSE

                                        v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                  FROM '||l.TABLA_MIG||'
                                                  WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO;

                                   END IF;

                            ELSE

                                v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                      FROM '||l.TABLA_MIG||'
                                      WHERE CD_CONCURSO = '||j.CD_PROCEDIMIENTO;

                            END IF; -- <> 'CONCURSO'

                       ELSIF INSTR(l.CAMPO_INTERFAZ,'FECHA') > 0 AND INSTR(l.CAMPO_INTERFAZ,'DECODE') = 0 THEN

                            IF l.TABLA_MIG <> 'MIG_CONCURSOS_CABECERA' THEN

                                  IF  l.TABLA_MIG = 'MIG_PROCEDIMIENTOS_SUBASTAS' THEN

                                      v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||',''DD-MM-RRRR'')
                                                FROM '||l.TABLA_MIG||'
                                                WHERE CD_SUBASTA = (SELECT MAX(CD_SUBASTA)
                                                                    FROM '||l.TABLA_MIG||'
                                                                    WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO||')';

                                  ELSE

                                      v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||',''DD-MM-RRRR'')
                                            FROM '||l.TABLA_MIG||'
                                            WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO;

                                  END IF;

                            ELSE

                                v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||',''DD-MM-RRRR'')
                                    FROM '||l.TABLA_MIG||'
                                    WHERE CD_CONCURSO = '||j.CD_PROCEDIMIENTO;

                            END IF;

                       ELSE
                              IF l.TABLA_MIG <> 'MIG_CONCURSOS_CABECERA' THEN

                                        v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                  FROM '||l.TABLA_MIG||'
                                                  WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO;

                              ELSE

                                        v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                  FROM '||l.TABLA_MIG||'
                                                  WHERE CD_CONCURSO = '||j.CD_PROCEDIMIENTO;
                              END IF;

                       END IF; --- INSTR

                       BEGIN

                          EXECUTE IMMEDIATE v_SQL INTO v_TEV_VALOR;

                       EXCEPTION
                           WHEN NO_DATA_FOUND THEN

                                v_TEV_VALOR := NULL;

                       END;

            END IF;--FLAG_ES_FECHA=0

       --DBMS_OUTPUT.PUT_LINE('TAP : '||k.TAP_CODIGO||' - v_TAR_FINALIZADA : '||v_TAR_FINALIZADA);
       --DBMS_OUTPUT.PUT_LINE('k.COD_HITO_ACTUAL :'|| k.COD_HITO_ACTUAL || 'v_ULTIMO_HITO : ' || v_ULTIMO_HITO||' - v_CONTROL: '||v_CONTROL);

            IF (v_TAR_FINALIZADA = 1 AND v_CONTROL <> 3) OR (l.TEV_NOMBRE IN ('avaluoInterno','avaluoExterno')) THEN

                SELECT S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL
                INTO v_TEV_ID
                FROM DUAL;

                INSERT INTO MIG_MAESTRA_HITOS_VALORES
                        (TEV_ID
                        ,TAR_ID
                        ,TAR_TAREA
                        ,TAP_CODIGO
                        ,TEV_ORDEN
                        ,TEV_NOMBRE
                        ,TEV_VALOR)
                 VALUES
                       (v_TEV_ID
                       ,v_TAR_ID
                       ,k.TAR_TAREA_PENDIENTE
                       ,k.TAP_CODIGO
                       ,l.ORDEN
                       ,l.TEV_NOMBRE
                       ,v_TEV_VALOR);

            END IF;

            IF k.DD_TPO_CODIGO = 'H002' THEN

                v_CONTROL := 0;

                v_PRC_ID_SUBASTA := v_PRC_ID;

             END IF;


            END IF; --FLAG_POR_cADA_BIEN = 0

            -------- HITOS X CADA BIEN (SOLO 38 - ADJUDICACION Y 39 - POSESION)
            IF k.FLAG_POR_CADA_BIEN = 1 THEN --HITOS DE BIENES

               FOR z IN c_BIENES_PROCEDIMIENTO(j.CD_PROCEDIMIENTO) LOOP  -- abrimos loop de bienes

                        v_CD_BIEN := z.CD_BIEN;

                        v_MAX_HITO_BIEN := z.ULTIMO_HITO_BIEN_PROC;

                        IF k.COD_HITO_ACTUAL <= v_MAX_HITO_BIEN THEN -- HITO BIEN

                            IF k.DD_TPO_CODIGO = 'H002' THEN -- T. DE ADJUDICACION

                               v_ORDEN_ADJU := v_ORDEN +1;

                               v_PRC_PRC_ID := v_PRC_ID_SUBASTA;

                            END IF;

                            BEGIN

                              SELECT DISTINCT PRC_ID, PRC_PRC_ID
                              INTO v_PRC_ID, v_PRC_PRC_ID
                              FROM TEMP_MIG_MAESTRA_HITOS_BIENES
                              WHERE CD_PROCEDIMIENTO = j.CD_PROCEDIMIENTO
                              AND DD_TPO_CODIGO = k.DD_TPO_CODIGO
                              AND CD_BIEN = v_CD_BIEN;

                            EXCEPTION
                              WHEN NO_DATA_FOUND THEN

                                IF v_CD_BIEN_ANTERIOR <> v_CD_BIEN THEN

                                   SELECT S_PRC_PROCEDIMIENTOS.NEXTVAL
                                   INTO v_PRC_ID
                                   FROM DUAL;

                                END IF;

                                v_CD_BIEN_ANTERIOR := v_CD_BIEN;

                            END;

                            IF k.DD_TPO_CODIGO IN('H015') THEN


                              SELECT DISTINCT  PRC_ID
                              INTO v_PRC_PRC_ID
                              FROM TEMP_MIG_MAESTRA_HITOS_BIENES
                              WHERE CD_PROCEDIMIENTO = j.CD_PROCEDIMIENTO
                              AND DD_TPO_CODIGO = 'H005'
                              AND CD_BIEN = v_CD_BIEN;

                              v_ORDEN := v_ORDEN_ADJU;

                            END IF;

                        END IF;

                        IF l.FLAG_ES_FECHA = 1 THEN

                            IF INSTR(l.CAMPO_INTERFAZ,'FECHA') > 0 AND INSTR(l.CAMPO_INTERFAZ,'DECODE') = 0 THEN

                                IF l.TABLA_MIG = 'MIG_PROCEDIMIENTOS_BIENES' THEN


                                    v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||',''DD-MM-YYYY'')
                                              FROM '||l.TABLA_MIG||'
                                              WHERE CD_PROCEDIMIENTO = '||J.CD_PROCEDIMIENTO||'
                                              AND CD_BIEN = '''||v_CD_BIEN||'''';

                                ELSE -- MIG_PROCEDIMIENTOS_SUBASTAS

                                      v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                FROM '||l.TABLA_MIG||'
                                                WHERE CD_SUBASTA = (SELECT MAX(CD_SUBASTA) FROM '||l.TABLA_MIG||'
                                                                    WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO||')';

                                END IF;

                            END IF;

                        ELSIF l.FLAG_ES_FECHA = 0 THEN


                               IF INSTR(l.CAMPO_INTERFAZ,'FECHA') = 0 OR INSTR(l.CAMPO_INTERFAZ,'DECODE') > 0 THEN

                                   v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                             FROM '||l.TABLA_MIG||'
                                             WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO||'
                                             AND CD_BIEN = '''||v_CD_BIEN||'''';

                               ELSE

                                      IF l.TABLA_MIG = 'MIG_PROCEDIMIENTOS_BIENES' THEN


                                          v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||',''DD-MM-YYYY'')
                                                    FROM '||l.TABLA_MIG||'
                                                    WHERE CD_PROCEDIMIENTO = '||J.CD_PROCEDIMIENTO||'
                                                    AND CD_BIEN = '''||v_CD_BIEN||'''';

                                      ELSE -- MIG_PROCEDIMIENTOS_SUBASTAS

                                            v_SQL := 'SELECT TO_CHAR('||l.CAMPO_INTERFAZ||')
                                                      FROM '||l.TABLA_MIG||'
                                                      WHERE CD_SUBASTA = (SELECT MAX(CD_SUBASTA) FROM '||l.TABLA_MIG||'
                                                                          WHERE CD_PROCEDIMIENTO = '||j.CD_PROCEDIMIENTO||')';

                                      END IF;

                               END IF;

                        END IF;


                        BEGIN

                          EXECUTE IMMEDIATE v_SQL INTO v_TEV_VALOR;

                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN

                                 v_TEV_VALOR := NULL;

                        END;

                        IF (v_TAR_FINALIZADA = 1 AND v_CONTROL <> 3 AND l.FLAG_ES_FECHA = 1) THEN

                             INSERT INTO TEMP_MIG_MAESTRA_HITOS_BIENES
                                         (CD_PROCEDIMIENTO
                                          ,PRC_ID
                                          ,PRC_PRC_ID
                                          ,DD_TPO_CODIGO
                                          ,CD_BIEN)
                             VALUES(j.CD_PROCEDIMIENTO
                                    ,v_PRC_ID
                                    ,v_PRC_PRC_ID
                                    ,k.DD_TPO_CODIGO
                                    ,v_CD_BIEN);


                             SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                             INTO v_TAR_ID
                             FROM DUAL;



                             INSERT INTO MIG_MAESTRA_HITOS
                                           (CD_PROCEDIMIENTO,
                                            PRC_ID,
                                            PRC_PRC_ID,
                                            ORDEN,
                                            DD_TPO_CODIGO,
                                            DD_TPO_DESC,
                                            TAP_CODIGO,
                                            TAR_ID,
                                            TAR_TAREA,
                                            TAR_FECHA,
                                            TAR_TAREA_FINALIZADA,
                                            CD_BIEN
                                            ,COD_HITO_ACTUAL
                                            ,ULTIMO_HITO)
                             VALUES
                                        (j.CD_PROCEDIMIENTO
                                        ,v_PRC_ID
                                        ,v_PRC_PRC_ID
                                        ,v_ORDEN
                                        ,k.DD_TPO_CODIGO
                                        ,k.DD_TPO_DESC
                                        ,k.TAP_CODIGO
                                        ,v_TAR_ID
                                        ,k.TAR_TAREA_PENDIENTE
                                        ,DECODE(v_TEV_VALOR,'0',v_FECHA_TAREA,'1',v_FECHA_TAREA,v_TEV_VALOR)
                                        ,v_TAR_FINALIZADA
                                        ,v_CD_BIEN
                                        ,k.COD_HITO_ACTUAL
                                        ,v_ULTIMO_HITO);


                             SELECT S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL
                             INTO v_TEV_ID
                             FROM DUAL;

                             INSERT INTO MIG_MAESTRA_HITOS_VALORES
                                    (TEV_ID
                                    ,TAR_ID
                                    ,TAR_TAREA
                                    ,TAP_CODIGO
                                    ,TEV_ORDEN
                                    ,TEV_NOMBRE
                                    ,TEV_VALOR)
                             VALUES
                                   (v_TEV_ID
                                   ,v_TAR_ID
                                   ,k.TAR_TAREA_PENDIENTE
                                   ,k.TAP_CODIGO
                                   ,l.ORDEN
                                   ,l.TEV_NOMBRE
                                   ,v_TEV_VALOR);

                        END IF; --v_CONTROL <> 3

                        IF  (v_TAR_FINALIZADA = 1 AND v_CONTROL <> 3 AND l.FLAG_ES_FECHA = 0) THEN


                             SELECT S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL
                             INTO v_TEV_ID
                             FROM DUAL;

                             INSERT INTO MIG_MAESTRA_HITOS_VALORES
                                    (TEV_ID
                                    ,TAR_ID
                                    ,TAR_TAREA
                                    ,TAP_CODIGO
                                    ,TEV_ORDEN
                                    ,TEV_NOMBRE
                                    ,TEV_VALOR)
                             VALUES
                                   (v_TEV_ID
                                   ,v_TAR_ID
                                   ,k.TAR_TAREA_PENDIENTE
                                   ,k.TAP_CODIGO
                                   ,l.ORDEN
                                   ,l.TEV_NOMBRE
                                   ,v_TEV_VALOR);

                        END IF;

                        IF (k.COD_HITO_ACTUAL = v_ULTIMO_HITO AND v_TAR_FINALIZADA = 0 AND v_CONTROL <> 3) THEN --TAREA PENDIENTE X CADA BIEN

                               SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                               INTO v_TAR_ID
                               FROM DUAL;

                               INSERT INTO MIG_MAESTRA_HITOS
                                       (CD_PROCEDIMIENTO,
                                        PRC_ID,
                                        PRC_PRC_ID,
                                        ORDEN,
                                        DD_TPO_CODIGO,
                                        DD_TPO_DESC,
                                        TAP_CODIGO,
                                        TAR_ID,
                                        TAR_TAREA,
                                        TAR_FECHA,
                                        TAR_TAREA_FINALIZADA,
                                        CD_BIEN
                                        ,COD_HITO_ACTUAL
                                        ,ULTIMO_HITO)
                               VALUES
                                      (j.CD_PROCEDIMIENTO
                                      ,v_PRC_ID
                                      ,v_PRC_PRC_ID
                                      ,v_ORDEN
                                      ,k.DD_TPO_CODIGO
                                      ,k.DD_TPO_DESC
                                      ,k.TAP_CODIGO
                                      ,v_TAR_ID
                                      ,k.TAR_TAREA_PENDIENTE
                                      ,NULL
                                      ,v_TAR_FINALIZADA
                                      ,v_CD_BIEN
                                      ,k.COD_HITO_ACTUAL
                                      ,v_ULTIMO_HITO);

                        END IF;
--       DBMS_OUTPUT.PUT_LINE('TAP : '||k.TAP_CODIGO||' - v_TAR_FINALIZADA : '||v_TAR_FINALIZADA);
--       DBMS_OUTPUT.PUT_LINE('k.COD_HITO_ACTUAL :'|| k.COD_HITO_ACTUAL || 'v_ULTIMO_HITO : ' || v_ULTIMO_HITO||' - v_CONTROL: '||v_CONTROL);

                END LOOP; ---BIENES

             END IF; -- X CADA BIEN

             v_CD_BIEN := NULL;

      END LOOP; --l VALORES

    IF k.FLAG_POR_CADA_BIEN = 0 THEN

          IF (k.COD_HITO_ACTUAL = v_ULTIMO_HITO AND v_TAR_FINALIZADA = 0 AND v_CONTROL <> 3) OR v_CONTROL = 1 OR (v_PTE_CERT_CARGAS = 1 AND v_TAR_FINALIZADA =0) THEN -- TAREA PENDIENTE DEL PROCEDIMIENTO

       --DBMS_OUTPUT.PUT_LINE('TAP : '||k.TAP_CODIGO||' - v_TAR_FINALIZADA : '||v_TAR_FINALIZADA);
       --DBMS_OUTPUT.PUT_LINE('k.COD_HITO_ACTUAL :'|| k.COD_HITO_ACTUAL || 'v_ULTIMO_HITO : ' || v_ULTIMO_HITO||' - v_CONTROL: '||v_CONTROL);


                 SELECT S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL
                 INTO v_TAR_ID
                 FROM DUAL;

                 INSERT INTO MIG_MAESTRA_HITOS
                         (CD_PROCEDIMIENTO,
                          PRC_ID,
                          PRC_PRC_ID,
                          ORDEN,
                          DD_TPO_CODIGO,
                          DD_TPO_DESC,
                          TAP_CODIGO,
                          TAR_ID,
                          TAR_TAREA,
                          TAR_FECHA,
                          TAR_TAREA_FINALIZADA,
                          CD_BIEN
                          ,COD_HITO_ACTUAL
                          ,ULTIMO_HITO)
                 VALUES
                        (j.CD_PROCEDIMIENTO
                        ,v_PRC_ID
                        ,v_PRC_PRC_ID
                        ,v_ORDEN
                        ,k.DD_TPO_CODIGO
                        ,k.DD_TPO_DESC
                        ,k.TAP_CODIGO
                        ,v_TAR_ID
                        ,k.TAR_TAREA_PENDIENTE
                        ,NULL
                        ,v_TAR_FINALIZADA
                        ,NULL
                        ,k.COD_HITO_ACTUAL
                        ,v_ULTIMO_HITO);

          END IF;

       END IF; --FLAG_POR_cADA_BIEN = 0

   END LOOP; --k

 END LOOP;--j

 DELETE FROM MIG_MAESTRA_HITOS_VALORES WHERE TAP_CODIGO IN ('H016_CambiarioDecision','H009_RegistrarInsinuacionCreditos','H009_RevisarInsinuacionCreditos');

 COMMIT;

    DBMS_OUTPUT.PUT_LINE('PROCESO de MIGRACION a Tabla MAESTRA TERMINADO CORRECTAMENTE. Last CD_PROCEDIMIENTO = '||v_CD_PROCEDIMIENTO);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_COUNT||' PROCEDIMIENTOS Procesados');

    EXECUTE IMMEDIATE ('SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME=''INDX_MIGRACION_MAE'' AND OWNER=''CM01''') INTO V_COUNT;

    IF V_COUNT = 0 THEN
        EXECUTE IMMEDIATE('create INDEX INDX_MIGRACION_MAE ON '||V_ESQUEMA||'.MIG_MAESTRA_HITOS(CD_PROCEDIMIENTO,CD_BIEN) nologging');

    END IF;

    EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.MIG_MAESTRA_HITOS COMPUTE STATISTICS';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' MIG_MAESTRA_HITOS ANALIZADA. INDICES CREADOS');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(v_SQL);

      DBMS_OUTPUT.PUT_LINE(SQLERRM);

END;
/

EXEC SP_MIG_A_TABLA_INTERMEDIA;
/

EXIT;
