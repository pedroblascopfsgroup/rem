--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200411
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-6939
--## PRODUCTO=NO
--## 
--## Finalidad: Relacionar AGR_ID agrupaciones restringidas en la oferta. Creacion de lotes comerciales y Relacionar AGR_ID en la oferta.
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Continuacion, se realizan los merges y los inserts.');
    --DBMS_OUTPUT.PUT_LINE('[INFO] El perimetro de AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO consiste en OFERTAS con más de un Activo y el AGR_ID nulo.');


    -----------------------------
    --ESTO SE PASA AL OTRO DML---
    ------------------------------
    /*
execute immediate 'CREATE TABLE '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO (OFERTA NUMBER(16), NUM_ACTIVOS_OFR NUMBER(3), ACTIVO_MUESTRA NUMBER(16), NUM_ACTIVOS_AGR NUMBER(3),ES_AGRUPADO NUMBER(1), ES_RESTRINGIDA NUMBER(1), AGRUPACION_ID NUMBER(16))' ;
execute immediate 'CREATE TABLE '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO1 (OFERTA NUMBER(16), AGRUPACION_ID NUMBER(16), NUM_ACTIVOS_OFR NUMBER(3), ACTIVOS_QUE_SON_IGUALES_EN_AGR NUMBER(3))' ;
execute immediate 'CREATE TABLE '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO2 (OFERTA NUMBER(16), AGRUPACION_ID NUMBER(16), NUM_ACTIVOS_OFR NUMBER(3), ACTS_EN_AGR NUMBER(3), AGR_ID_NUEVO NUMBER(16))' ;
*/
    --SACAR LAS OFERTAS MAS DE UN ACTIVO
    --VER SI LOS ACTIVOS PERTENECEN A AGRUPACION RESTRINGIDO, Y SI PERTENECEN MIRO SI TODOS ESOS ACTIVOS ESTAN EN ESE  (MIRAR QUE EL TIPO SEA RESTRINGIDA Y QUE ESTE VIGENTE)
    --NADA MAS QUE UN ACTIVO DE LOS DE LA OFERTA NO ESTE EN LA AGRUPACION RESTRINGIDA
    --SI TIENE MENOS ES LOTE COMERCIAL Y SI TIENE MAS ES LOTE COMERCIAL TAMBIEN

    -----------------------------
    --ESTO SE PASA AL OTRO DML---
    ------------------------------
    /*
    execute immediate 'TRUNCATE table '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO';

    v_msql := '
    INSERT INTO '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO 
    WITH OFR_MORE_THAN_1_ACT AS (
        SELECT OFR.OFR_ID, COUNT(1) NUM 
        FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
        INNER JOIN '||V_ESQUEMA||'.ACT_OFR ON ACT_OFR.OFR_ID = OFR.OFR_ID 
        WHERE OFR.USUARIOCREAR = ''MIG_DIVARIAN'' AND OFR.BORRADO = 0 AND OFR.AGR_ID IS NULL
        GROUP BY OFR.OFR_ID HAVING COUNT(1) > 1
        --CON ESTO ME COJO TODAS LAS OFERTAS QUE TIENEN RELACIONADO MAS DE UN ACTIVO Y NO TIENEN AGR_ID
    ),
    AGRUPACIONES_ACTIVOS AS (
        SELECT DISTINCT AGR_ID, ACT_ID 
        FROM '||V_ESQUEMA||'.act_aga_agrupacion_activo AGA 
        WHERE AGA.USUARIOCREAR = ''MIG_DIVARIAN'' AND BORRADO = 0 
        --CON ESTO ME COJO LAS RELACIONES AGRUPACION - ACTIVO DE DIVARIAN QUE NO ESTEN BORRADAS
    ),
    AGRUPACIONES_RESTRINGIDAS_VIG AS (
        SELECT DISTINCT AGR_ID 
        FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION 
        WHERE USUARIOCREAR = ''MIG_DIVARIAN'' AND DD_TAG_ID = 2 AND AGR_FECHA_BAJA IS NULL AND BORRADO = 0
        --CON ESTO ME COJO LAS AGRUPACIONES RESTRINGIDAS VIGENTES DE DIVARIAN
    )
    SELECT 
        PUNTO_PARTIDA.OFERTA,
        (SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_OFR WHERE ACT_OFR.OFR_ID = PUNTO_PARTIDA.OFERTA) NUM_ACTIVOS_OFR,
        PUNTO_PARTIDA.ACTIVO_MUESTRA,
        (SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO WHERE ACT_AGA_AGRUPACION_ACTIVO.AGR_ID = VIG.AGR_ID) NUM_ACTIVOS_AGR,
        CASE WHEN AGA.AGR_ID IS NOT NULL THEN 1 ELSE 0 END AS ES_AGRUPADO,
        CASE WHEN VIG.AGR_ID IS NOT NULL THEN 1 ELSE 0 END AS ES_RESTRINGIDA,
        CASE WHEN VIG.AGR_ID IS NOT NULL THEN VIG.AGR_ID ELSE -1 END AS AGRUPACION_ID
        --PARA OBTENER EL PERIMETRO DE PARTIDA:
        --ME COJO UNA OFERTA DE LAS DE MAS DE UN ACTIVO, UN ACTIVO DE MUESTRA Y HAGO LEFT JOIN CON AGRUPACIONES_ACTIVOS Y CON AGRUPACIONES_RESTRINGIDAS_VIG
        --Y PONGO EN COLUMNAS LA OFERTA, LA CANTIDAD DE ACTIVOS EN ESA OFERTA, EL ACTIVO DE MUESTRA, LA CANTIDAD DE ACTIVOS EN LA AGRUPACION/ES DONDE SE ENCUENTRA ESE ACTIVO DE MUESTRA,
        --SI EL ACTIVO EXISTE EN UNA AGRUPACION O NO (ES_AGRUPADO), SI EXISTE, SI ES AGRUPACION RESTRINGIDA O NO (ES_RESTRINGIDA), Y EL ID DE LA AGRUPACION EN CASO QUE SEA AGRUPACION RESTRINGIDA VIGENTE
    FROM (
        SELECT 
        ACT_OFR.OFR_ID OFERTA, 
        MAX(ACT_OFR.ACT_ID) ACTIVO_MUESTRA 
        FROM ACT_OFR 
        WHERE EXISTS (
            SELECT 1 FROM OFR_MORE_THAN_1_ACT TMP WHERE TMP.OFR_ID = ACT_OFR.OFR_ID) 
        GROUP BY ACT_OFR.OFR_ID ) PUNTO_PARTIDA
    LEFT JOIN '||V_ESQUEMA||'.AGRUPACIONES_ACTIVOS AGA ON AGA.ACT_ID = PUNTO_PARTIDA.ACTIVO_MUESTRA
    LEFT JOIN '||V_ESQUEMA||'.AGRUPACIONES_RESTRINGIDAS_VIG VIG ON VIG.AGR_ID = AGA.AGR_ID
    ORDER BY 1 ASC
    ';
    execute immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO cargada. '||SQL%ROWCOUNT||' Filas.');
    --SELECT 
    --* FROM AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO;--1.367
    --CON ESTO TENDRIAMOS LAS OFERTAS QUE ESTAN EN AGRUPACIONES O NO, QUE SI ESTAN, SI SON RESTRINGIDAS O NO, Y SI SON RESTRINGIDA, SU ID
    commit;
    ---------------
    -----CASO 1----
    ---------------

    --COGEMOS SOLO EL PERIMETRO DEL PRIMER CASO, OFERTAS CUYO ACTIVO MUESTRA ESTA EN UNA AGRUPACION RESTRINGIDA VIGENTE Y ADEMAS COINCIDE EN VOLUMETRIA
    --CON ESTO COMPROBAREMOS SI LOS ACTIVOS SON LOS MISMOS
    --EN ESTE PASO, PARTIMOS DE LA AUXILIAR DEL PERIMETRO PARA SOLO QUEDARNOS LAS QUE COINCIDEN EN NUMERO

    execute immediate 'TRUNCATE table '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO1';

    v_msql := '
    INSERT INTO '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO1 
    WITH PERIMETRO AS (
        SELECT 
        DISTINCT OFERTA, ACTIVO_MUESTRA, AGRUPACION_ID, NUM_ACTIVOS_OFR
        FROM '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO PER
        WHERE NUM_ACTIVOS_OFR = NUM_ACTIVOS_AGR AND NUM_ACTIVOS_AGR IS NOT NULL
        ORDER BY 2 DESC , 1 DESC
        --PARA ELLO NOS  HACEMOS UN PERIMETRO SOLO CON LAS QUE COINCIDE EL NUMERO DE ACTIVOS DE LA OFERTA CON EL DE LA AGRUPACION, DE MOMENTO SOLO COINCIDIRIAN EN NUMERO
    ),
    ACT_OFR_IN_AGR AS (
    select OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR,act_ofr.act_id , case when act_id in (select distinct act_id from '||V_ESQUEMA||'.act_aga_agrupacion_activo aga where aga.agr_id = perimetro.agrupacion_id) then 1 else 0 end as IS_IN_AGR
        from perimetro 
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON PERIMETRO.OFERTA = OFR.OFR_ID
        inner join '||V_ESQUEMA||'.act_ofr on act_ofr.ofr_id = perimetro.oferta
        WHERE OFR.AGR_ID IS NULL
        order by 1 desc
        --SACAMOS LA OFERTA
    )
    SELECT OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR, ACTIVOS_QUE_SON_IGUALES_EN_AGR FROM (
        SELECT OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR, COUNT(IS_IN_AGR) ACTIVOS_QUE_SON_IGUALES_EN_AGR
        FROM '||V_ESQUEMA||'.ACT_OFR_IN_AGR 
        GROUP BY OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR) TMP
    WHERE NUM_ACTIVOS_OFR = ACTIVOS_QUE_SON_IGUALES_EN_AGR'
    ;
    execute immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO1 cargada. '||SQL%ROWCOUNT||' Filas.');
    --SELECT 
    --* FROM AUX_AGR_COMERCIAL_REMVIP_6939_CASO1;--60
    COMMIT;
*/
    --HACEMOS EL MERGE PARA PONER EL AGR_ID DE LAS AGRUPACIONES RESTRINGIDAS QUE COINCIDEN EN ACTIVOS CON LOS DE LA OFERTA, PARA PONERSELO EN LA OFERTA
    v_msql := '
    MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS OFR USING (
        SELECT DISTINCT OFERTA, AGRUPACION_ID 
        FROM '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO1
    ) TMP
    ON (TMP.OFERTA = OFR.OFR_ID)
    WHEN MATCHED THEN UPDATE SET
    OFR.AGR_ID = TMP.AGRUPACION_ID,
    OFR.USUARIOMODIFICAR = ''REMVIP-6939'',
    OFR.FECHAMODIFICAR = SYSDATE
    WHERE OFR.AGR_ID IS NULL'
    ;
    execute immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.OFR_OFERTAS mergeada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    ---------------
    -----CASO 2----
    ---------------

    --COGEMOS EL PERIMETRO, QUE SE VERA REDUCIDO POR EL PRIMER CASO, Y SON, DE LOS QUE QUEDAN, LAS OFERTAS QUE TIENEN ACTIVOS QUE NO ESTAN NINGUNO EN NINGUNA AGRUPACION
    --A ESTOS LE CREAREMOS UNA AGRUPACION LOTE COMERCIAL Y LE ASIGNAREMOS EL AGR_ID A LA OFERTA

    -----------------------------
    --ESTO SE PASA AL OTRO DML---
    ------------------------------
    /*
    execute immediate 'TRUNCATE table '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO2';

    v_msql := '
    INSERT INTO '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO2
    WITH PERIMETRO AS (
        SELECT 
        DISTINCT OFERTA, ACTIVO_MUESTRA, AGRUPACION_ID, NUM_ACTIVOS_OFR
        FROM '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO PER
        ORDER BY 2 DESC , 1 DESC
    )
    SELECT OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR, ACTS_EN_AGR, '||V_ESQUEMA||'.S_ACT_AGR_AGRUPACION.NEXTVAL AS AGR_ID_NUEVO FROM (
        SELECT OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR, SUM(IS_IN_ANY_AGR) ACTS_EN_AGR FROM (
            select OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR,act_ofr.act_id , 
            case when act_id in (select distinct act_id from '||V_ESQUEMA||'.act_aga_agrupacion_activo aga inner join '||V_ESQUEMA||'.act_agr_agrupacion agr on agr.agr_id = aga.agr_id where dd_tag_id = 2 and agr.USUARIOCREAR = ''MIG_DIVARIAN'') then 1 else 0 end as IS_IN_ANY_AGR
                from perimetro 
                INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON PERIMETRO.OFERTA = OFR.OFR_ID
                inner join '||V_ESQUEMA||'.act_ofr on act_ofr.ofr_id = perimetro.oferta
                WHERE OFR.AGR_ID IS NULL
                order by 1 desc
        ) TMP
    GROUP BY OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR)
    WHERE ACTS_EN_AGR = 0'
    ;
    execute immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO2 cargada. '||SQL%ROWCOUNT||' Filas.');
    --SELECT 
    --* FROM AUX_AGR_COMERCIAL_REMVIP_6939_CASO2;--1.261
    COMMIT;
*/
    -----EN ESTE PUNTO HAY QUE CREAR LA AGRUPACION
    ------------------------------------------------
    --INSERCION EN ACT_AGR_AGRUPACION--
    -------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN ACT_AGR_AGRUPACION');
  

    --INSERTAMOS EN ACT_AGR_AGRUPACION
    EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.ACT_AGR_AGRUPACION (
        AGR_ID,
        DD_TAG_ID,
        AGR_NOMBRE,
        AGR_DESCRIPCION,
        AGR_NUM_AGRUP_REM,
        AGR_NUM_AGRUP_UVEM,
        AGR_FECHA_ALTA,
        AGR_ELIMINADO,
        AGR_FECHA_BAJA,
        AGR_URL,
        AGR_PUBLICADO,
        AGR_SEG_VISITAS,
        AGR_TEXTO_WEB,
        AGR_ACT_PRINCIPAL,
        AGR_GESTOR_ID,
        AGR_MEDIADOR_ID,
        AGR_INI_VIGENCIA,
        AGR_FIN_VIGENCIA,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO,
        AGR_IS_FORMALIZACION
    )
    SELECT DISTINCT
        MIG.AGR_ID_NUEVO                                        AGR_ID,
        TAGT.DD_TAG_ID                                          DD_TAG_ID,
        OFR.OFR_NUM_OFERTA                                      AGR_NOMBRE,
        OFR.OFR_NUM_OFERTA                                      AGR_DESCRIPCION,
        MIG.AGR_ID_NUEVO                                        AGR_NUM_AGRUP_REM,
        NULL                                                    AGR_NUM_AGRUP_UVEM,
        SYSDATE                                                 AGR_FECHA_ALTA,
        0                                                       AGR_ELIMINADO,
        NULL                                                    AGR_FECHA_BAJA,
        NULL                                                    AGR_URL,
        0                                                       AGR_PUBLICADO,
        NULL                                                    AGR_SEG_VISITAS,
        NULL                                                    AGR_TEXTO_WEB,
        (SELECT MAX(ACT_ID) FROM '||V_ESQUEMA||'.ACT_OFR AUX WHERE AUX.OFR_ID = MIG.OFERTA GROUP BY AUX.OFR_ID)                                                AGR_ACT_PRINCIPAL,
        NULL                                                    AGR_GESTOR_ID,
        NULL                                                    AGR_MEDIADOR_ID,
        SYSDATE                                                  AGR_INI_VIGENCIA,
        NULL                                                  AGR_FIN_VIGENCIA,
        ''0''                                                   VERSION,
        ''REMVIP-6939''                                         USUARIOCREAR,
        SYSDATE                                                 FECHACREAR,
        0                                                       BORRADO,
        1                                                  AGR_IS_FORMALIZACION
    FROM '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO2  MIG
    INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = MIG.OFERTA
    LEFT JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION TAB ON TAB.AGR_ID = MIG.AGR_ID_NUEVO
    JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAGT ON TAGT.DD_TAG_CODIGO = ''14''--COMERCIAL VENTA
    WHERE TAB.AGR_ID IS NULL
    ');

    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_AGR_AGRUPACION cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.ACT_LCO_LOTE_COMERCIAL T4 (AGR_ID)
    WITH AGRUPACIONES AS (
            SELECT AGR.AGR_ID
            FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION     AGR
            INNER JOIN '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO2             MIG     ON MIG.AGR_ID_NUEVO = AGR.AGR_ID
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.ACT_LCO_LOTE_COMERCIAL AUX WHERE AUX.AGR_ID = AGR.AGR_ID
            )
    )
    SELECT
        AGR.AGR_ID
    FROM AGRUPACIONES AGR
    ');

    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_LCO_LOTE_COMERCIAL cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    -------------------------------------------------
    --INSERCION EN ACT_AGA_AGRUPACION_ACTIVO--
    -------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN ACT_AGA_AGRUPACION_ACTIVO'); 
  
  
    EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO (
        AGA_ID,
        AGR_ID,
        ACT_ID,
        AGA_FECHA_INCLUSION,
        AGA_PRINCIPAL,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO
    )
    WITH ACT_NUMERO_ACTIVO AS (
        SELECT DISTINCT 
            MIG.ACT_ID                                                                                                             ACT_ID,
            AGR.AGR_ID                                                                                                                  AGR_ID,
            case when mig.act_id = (SELECT MAX(ACT_ID) FROM '||V_ESQUEMA||'.ACT_OFR AUX WHERE AUX.OFR_ID = MIG.oferta GROUP BY AUX.OFR_ID) then 1 else 0 end as  AGA_PRINCIPAL,
            SYSDATE                                                                                                                     AGA_FECHA_INCLUSION
        FROM (SELECT DISTINCT
            OFERTA,
            ACT_OFR.ACT_ID,
            AGR_ID_NUEVO AGR_ID
            FROM '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO2 AUX
            INNER JOIN '||V_ESQUEMA||'.ACT_OFR ON ACT_OFR.OFR_ID = AUX.OFERTA)             MIG
        JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION             AGR ON AGR.AGR_ID = MIG.AGR_ID
        LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = MIG.ACT_ID AND AGA.AGR_ID = AGR.AGR_ID
        WHERE AGA.AGA_ID IS NULL
    )
    SELECT
        '||V_ESQUEMA||'.S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL     AGA_ID,
        MIG.AGR_ID                                              AGR_ID,
        MIG.ACT_ID                                              ACT_ID,
        MIG.AGA_FECHA_INCLUSION                                 AGA_FECHA_INCLUSION,
        MIG.AGA_PRINCIPAL                                       AGA_PRINCIPAL,
        ''0''                                                   VERSION,
        ''REMVIP-6939''                                         USUARIOCREAR,
        SYSDATE                                                 FECHACREAR,
        0                                                       BORRADO
    FROM ACT_NUMERO_ACTIVO MIG
  ');

  DBMS_OUTPUT.PUT_LINE('    [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;

    ----EN ESTA PUNTO SE MERGEA LA AGRUPACION EN LA OFERTA
    --HACEMOS EL MERGE PARA PONER EL AGR_ID DE LAS AGRUPACIONES LOTE COMERCIAL QUE HEMOS CREADO, PARA PONERSELO EN LA OFERTA
    v_msql := '
    MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS OFR USING (
        SELECT DISTINCT OFERTA, AGR_ID_NUEVO 
        FROM '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO2
    ) TMP
    ON (TMP.OFERTA = OFR.OFR_ID)
    WHEN MATCHED THEN UPDATE SET
    OFR.AGR_ID = TMP.AGR_ID_NUEVO,
    OFR.USUARIOMODIFICAR = ''REMVIP-6939'',
    OFR.FECHAMODIFICAR = SYSDATE
    WHERE OFR.AGR_ID IS NULL'
    ;
    execute immediate v_msql;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.OFR_OFERTAS mergeada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    ---------------
    -----CASO 3----
    ---------------

    --COGEMOS EL PERIMETRO, QUE SE VERA REDUCIDO POR EL PRIMER CASO Y EL SEGUNDO CASO, Y SON, DE LOS QUE QUEDAN, LAS OFERTAS QUE TIENEN ACTIVOS EN AGRUPACIONES RESTRINGIDAS PERO O BIEN NO TIENE TODOS, O BIEN TIENE MAS
    --ESTA POR DEFINIR QUE HACEMOS CON ESTOS
/*
    execute immediate 'TRUNCATE table '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO3';

    v_msql := '
    INSERT INTO '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_CASO3
    WITH PERIMETRO AS (
        SELECT 
        DISTINCT OFERTA, ACTIVO_MUESTRA, AGRUPACION_ID, NUM_ACTIVOS_OFR
        FROM '||V_ESQUEMA||'.AUX_AGR_COMERCIAL_REMVIP_6939_FROM_OFR_PERIMETRO PER
        ORDER BY 2 DESC , 1 DESC
    )
    SELECT OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR, ACTS_EN_AGR, '||V_ESQUEMA||'.S_ACT_AGR_AGRUPACION.NEXTVAL AS AGR_ID_NUEVO FROM (
        SELECT OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR, SUM(IS_IN_ANY_AGR) ACTS_EN_AGR FROM (
            select OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR,act_ofr.act_id , 
            case when act_id in (select distinct act_id from '||V_ESQUEMA||'.act_aga_agrupacion_activo aga inner join '||V_ESQUEMA||'.act_agr_agrupacion agr on agr.agr_id = aga.agr_id where dd_tag_id = 2 and agr.USUARIOCREAR = ''MIG_DIVARIAN'') then 1 else 0 end as IS_IN_ANY_AGR
                from perimetro 
                INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON PERIMETRO.OFERTA = OFR.OFR_ID
                inner join '||V_ESQUEMA||'.act_ofr on act_ofr.ofr_id = perimetro.oferta
                WHERE OFR.AGR_ID IS NULL
                order by 1 desc
        ) TMP
    GROUP BY OFERTA, AGRUPACION_ID, NUM_ACTIVOS_OFR)
    WHERE ACTS_EN_AGR <> 0'
    ;
    --SELECT 
    --* FROM AUX_AGR_COMERCIAL_REMVIP_6939_CASO3;--46

*/

    ------¡¡¡ESTE CASO ESTA POR DEFINIR QUE HACEMOS CON EL, YA QUE ES MAS COMPLEJO Y SOLO SON 46 OFERTAS!!!!








    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
