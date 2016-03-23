--/*
--##########################################
--## AUTOR=ENRIQUEJIMENEZ
--## FECHA_CREACION=20160117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-792
--## PRODUCTO=SI
--##
--## Finalidad: Creación del PL/SQL de calculo de Antecedentes
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--## 	    0.2 EJD:> Incluimos el parámetro de Salida del PL/SQL, se tengan en cuenta Ciclos de Recobro anteriores.
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE CALCULO_ANTECEDENTES (RESULT_EXE OUT VARCHAR2 ) AUTHID CURRENT_USER AS

    --v_esquema_u   VARCHAR2(25 CHAR):= user; -- Configuracion Esquema actual (PFSRECOVERY en Prod)
    v_esquema     VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema Datos
    err_num       NUMBER; -- Numero de errores
    err_msg       VARCHAR2(2048); -- Mensaje de error
    v_msql        VARCHAR2(12000 CHAR);
    v_sql         VARCHAR2(12000 CHAR);
    v_usuario     VARCHAR2(50 CHAR) := 'PROC_ANT';
    V_MAX_NUM_DIA NUMBER; --ultimo dia en el que se calcularon antecedentes en cnt
    v_count VARCHAR (25 CHAR) :='0';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Inicio de Actualizacion de Antecentes.');

    -- Limpiamos temporal
    v_msql := 'DELETE FROM '||v_esquema||'.TMP_ANTECEDENTES_PER';
    Execute Immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Fin Truncate TMP_ANTECEDENTES_PER.');
    RESULT_EXE := 'Truncado TMP_ANTECEDENTES_PER.';
    COMMIT;


    -- Buscamos posibles Personas Nuevas
    v_msql:= 'INSERT INTO '||v_esquema||'.TMP_ANTECEDENTES_PER
            ( PER_ID, ANT_ID, ANT_REINCIDENCIA_INTERNOS )
            SELECT PER_ID, '||v_esquema||'.S_ANT_ANTECEDENTES.nextval, 0
            FROM ( SELECT a.PER_ID
                   FROM '||v_esquema||'.CPE_CONTRATOS_PERSONAS a
                      , '||v_esquema||'.PER_PERSONAS b
                      , '||v_esquema||'.ANT_ANTECEDENTES c
                   WHERE a.PER_ID = b.PER_ID
                   AND   b.ANT_ID = c.ANT_ID(+)
                   AND   c.ANT_ID is null
                   GROUP BY a.PER_ID )';
    Execute Immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - TMP_ANTECEDENTES_PER Cargada. '||SQL%ROWCOUNT||' Filas.');
    RESULT_EXE := RESULT_EXE||'| TMP_ANTECEDENTES_PER: '||SQL%ROWCOUNT||' Insertadas.';
    COMMIT;


    -- Inicializamos su contador en Antecedentes
    v_msql:='INSERT INTO '||v_esquema||'.ANT_ANTECEDENTES
             (ANT_ID, ANT_REINCIDENCIA_INTERNOS, VERSION, USUARIOCREAR, FECHACREAR, BORRADO )
            SELECT ANT_ID
                 , 0 as ANT_REINCIDENCIA_INTERNOS
                 , 0 as VERSION
                 , '''||v_usuario||''' as USUARIOCREAR
                 , Sysdate as FECHACREAR
                 , 0 as BORRADO
              FROM '||v_esquema||'.TMP_ANTECEDENTES_PER';
    Execute Immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - ANT_ANTECEDENTES Cargada. '||SQL%ROWCOUNT||' Filas.');
    RESULT_EXE := RESULT_EXE||'| ANT_ANTECEDENTES: '||SQL%ROWCOUNT||' Insertadas.';
    COMMIT;


    -- Asignamos ANT_ID a las Personas Nuevas
/*    
    v_msql :='UPDATE(Select a.ANT_ID as ANT_ID_OLD
                          , b.ANT_ID as ANT_ID_NEW
                          , a.USUARIOMODIFICAR
                          , a.FECHAMODIFICAR
                       From '||v_esquema||'.PER_PERSONAS a
                         Inner join '||v_esquema||'.TMP_ANTECEDENTES_PER b on a.PER_ID = b.PER_ID
                    )
              SET ANT_ID_OLD = ANT_ID_NEW
                , USUARIOMODIFICAR = '''||v_usuario||'''
                , FECHAMODIFICAR = SYSTIMESTAMP 
              WHERE ANT_ID_NEW IS NOT NULL';
*/              
              
    v_msql :='MERGE INTO '||v_esquema||'.PER_PERSONAS PER USING 
              (
              Select      a.PER_ID
                          , a.ANT_ID as ANT_ID_OLD
                          , b.ANT_ID as ANT_ID_NEW
                          , a.USUARIOMODIFICAR
                          , a.FECHAMODIFICAR
              From '||v_esquema||'.PER_PERSONAS a
               Inner join '||v_esquema||'.TMP_ANTECEDENTES_PER b on a.PER_ID = b.PER_ID
              )  TMP
              ON (PER.PER_ID = TMP.PER_ID)
              WHEN MATCHED THEN 
              UPDATE SET PER.ANT_ID = TMP.ANT_ID_NEW, 
                         PER.USUARIOMODIFICAR = '''||v_usuario||''',
                         FECHAMODIFICAR = SYSTIMESTAMP              
              ';                         
              
    Execute Immediate v_msql;
    v_count := nvl(sql%rowcount, '0');
    -- dbms_output.put_line('number of rows insert: '||v_count);    
    
    IF (v_count = '0') THEN
          DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - PER_PERSONAS Actualizada. '||v_count||' Filas1.');
          RESULT_EXE := RESULT_EXE||'| PER_PERSONAS: '||to_char(v_count)||' Act.';
     ELSE           
          DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - PER_PERSONAS Actualizada. '||v_count||' Filas.');
          RESULT_EXE := RESULT_EXE||'| PER_PERSONAS: '||to_char(v_count)||' Act.';
    END IF;
    
    COMMIT;
    

    -- Sumamos los nuevos Ciclos al contador en Antecedentes.
    v_msql:='MERGE INTO '||v_esquema||'.ANT_ANTECEDENTES old
            USING ( SELECT b.ANT_ID
                         , COUNT(distinct a.CRP_ID) as CICLOS
                      FROM '||v_esquema||'.CRP_CICLO_RECOBRO_PER a
                         , '||v_esquema||'.PER_PERSONAS b
                     WHERE a.PER_ID = b.PER_ID
			  AND TRUNC(a.FECHACREAR) BETWEEN TRUNC(a.FECHACREAR+1) AND TRUNC(sysdate)
                       AND TRUNC(a.CRP_FECHA_ALTA) <> TRUNC(nvl(a.CRP_FECHA_BAJA,to_timestamp(''00010101'',''yyyymmdd'')))
                     GROUP BY b.ANT_ID ) new
            ON (old.ANT_ID = new.ANT_ID)
            WHEN MATCHED THEN UPDATE
            SET ANT_REINCIDENCIA_INTERNOS = ANT_REINCIDENCIA_INTERNOS + CICLOS
              , USUARIOMODIFICAR = '''||v_usuario||'''
              , FECHAMODIFICAR = Sysdate';
    Execute Immediate v_msql;
    
    v_count := nvl(sql%rowcount, '0');  
    IF (v_count = '0') THEN    
        DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - ANT_ANTECEDENTES Actualizada. '||v_count||' Filas.');        
        RESULT_EXE := RESULT_EXE||'| ANT_ANTECEDENTES: '||v_count||' Act.';
    ELSE           
        DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - ANT_ANTECEDENTES Actualizada. '||v_count||' Filas.');
        RESULT_EXE := RESULT_EXE||'| ANT_ANTECEDENTES: '||v_count||' Act.';
    END IF;
    
    COMMIT;

    --Ahora calculamos los antecedentes a nivel de contrato
    v_sql := 'select nvl(max(dpr_num_dia), 0) from '||v_esquema||'.ACN_ANTECED_CONTRATOS';
    EXECUTE IMMEDIATE v_sql INTO V_MAX_NUM_DIA;

    v_msql:='Merge into '||v_esquema||'.ACN_ANTECED_CONTRATOS org
            Using (select a.cnt_id, b.dpr_num_dia
                 from '||v_esquema||'.mov_movimientos a, '||v_esquema||'.ACN_ANTECED_CONTRATOS b
                where mov_fecha_extraccion = trunc(sysdate)-1
                  and mov_deuda_irregular > 0
                  and a.cnt_id = b.cnt_id(+)
                ) mrg
            on (org.cnt_id = mrg.cnt_id)
            When matched
             then Update
                 Set org.acn_num_reinciden = decode(mrg.dpr_num_dia, ('||V_MAX_NUM_DIA||')
                                           , org.acn_num_reinciden
                                           , org.acn_num_reinciden + 1)
                  , org.usuariomodificar = '''||v_usuario||'''
                  , org.fechamodificar = sysdate
                  , org.dpr_num_dia = ('||V_MAX_NUM_DIA||'+1)
            When not matched
             then Insert values
                 ( mrg.cnt_id, 1, 0, '''||v_usuario||''', sysdate, null, null, null, null, 0,('||V_MAX_NUM_DIA||'+1))';

	Execute Immediate v_msql;
  
    v_count := nvl(sql%rowcount, '0');  
    IF (v_count = '0') THEN    
        DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - ANT_ANTECED_CONTRATOS Actualizada. '||v_count||' Filas.');
--         RESULT_EXE := RESULT_EXE||'| ANT_ANTECED_CONTRATOS';
        RESULT_EXE := RESULT_EXE||'| ANT_ANTECED_CONTRATOS: '||v_count||' Act.';
    ELSE           
        DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - ANT_ANTECED_CONTRATOS Actualizada. '||v_count||' Filas.');
        RESULT_EXE := RESULT_EXE||'| ANT_ANTECED_CONTRATOS: '||v_count||' Act.';
    END IF;  
  
  
    
    -- RESULT_EXE := RESULT_EXE||' | ANT_ANTECED_CONTRATOS Actualizada. '||SQL%ROWCOUNT||' Filas.';
    COMMIT;

EXCEPTION

  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
    DBMS_OUTPUT.put_line(v_msql);
    RESULT_EXE := 'Error:'||TO_CHAR(ERR_NUM)||'['||ERR_MSG||']';
    ROLLBACK;
    RAISE;

END CALCULO_ANTECEDENTES;
/
EXIT;
