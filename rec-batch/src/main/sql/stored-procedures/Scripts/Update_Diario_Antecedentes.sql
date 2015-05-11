-- Script de Actualización de Antecentes. V.1.0
SET SERVEROUTPUT ON;
SET TIMING ON;

DECLARE 

    --v_esquema     VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    v_esquema     VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquema
    
    err_num       NUMBER; -- Numero de errores
    err_msg       VARCHAR2(2048); -- Mensaje de error
   
    v_msql        VARCHAR2(12000 CHAR);
    v_usuario     VARCHAR2(50 CHAR) := 'REC-BATCH';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Inicio de Actualización de Antecentes.');

    -- Limpiamos temporal
    v_msql := 'DELETE FROM '||v_esquema||'.TMP_ANTECEDENTES_PER';
    Execute Immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - Fin Truncate TMP_ANTECEDENTES_PER.');
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
    COMMIT;


    -- Asignamos ANT_ID a las Personas Nuevas
    v_msql :='UPDATE(Select a.ANT_ID as ANT_ID_OLD
                          , b.ANT_ID as ANT_ID_NEW
                          , a.USUARIOMODIFICAR
                          , a.FECHAMODIFICAR
                     From '||v_esquema||'.PER_PERSONAS a
                       Inner join '||v_esquema||'.TMP_ANTECEDENTES_PER b
                          on a.PER_ID = b.PER_ID)
             SET ANT_ID_OLD = ANT_ID_NEW
               , USUARIOMODIFICAR = '''||v_usuario||'''
               , FECHAMODIFICAR = Sysdate';
    Execute Immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - PER_PERSONAS Actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    -- Sumamos los nuevos Ciclos al contador en Antecedentes.
    v_msql:='MERGE INTO '||v_esquema||'.ANT_ANTECEDENTES old
            USING ( SELECT b.ANT_ID
                         , COUNT(distinct a.CRP_ID) as CICLOS
                      FROM '||v_esquema||'.CRP_CICLO_RECOBRO_PER a
                         , '||v_esquema||'.PER_PERSONAS b 
                     WHERE a.PER_ID = b.PER_ID
                       AND TRUNC(a.FECHACREAR) = TRUNC(sysdate)
                       AND TRUNC(a.CRP_FECHA_ALTA) <> TRUNC(nvl(a.CRP_FECHA_BAJA,to_timestamp(''00010101'',''yyyymmdd'')))
                     GROUP BY b.ANT_ID ) new
            ON (old.ANT_ID = new.ANT_ID)
            WHEN MATCHED THEN UPDATE
            SET ANT_REINCIDENCIA_INTERNOS = ANT_REINCIDENCIA_INTERNOS + CICLOS
              , USUARIOMODIFICAR = '''||v_usuario||'''
              , FECHAMODIFICAR = Sysdate';
    Execute Immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||to_char(sysdate,'HH24:MI:SS')||' - ANT_ANTECEDENTES Actualizada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

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
 

 