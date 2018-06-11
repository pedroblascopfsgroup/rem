--/*
--##########################################
--## AUTOR=David González
--## FECHA_CREACION=20180611
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-4166
--## PRODUCTO=NO
--## Finalidad: Evitar que las tablas HLD_HISTORICO_LANZA_PER_DETA y HLP_HISTORICO_LANZA_PERIODICO tengan un tamaño inmanejable.
--## Info: https://link-doc.pfsgroup.es/confluence/display/REOS/SP_EXT_LIMPIEZA_HISTORICOS
--##       Mantengamos la documentación al día. Si subimos de versión, reflejemoslo en el SP.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_EXT_LIMPIEZA_HISTORICOS (

    --Parametros de entrada
    NUM_DIAS                    IN NUMBER,

    --Variables de salida
    COD_RETORNO                 OUT VARCHAR2 -- 0 OK / 1 KO

) AS

    --Configuracion
    V_ESQUEMA                       VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER                VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';

    --Info
    V_DESC_SP                       VARCHAR2(400 CHAR) := '[INICIO] Evitar que las tablas HLD_HISTORICO_LANZA_PER_DETA y HLP_HISTORICO_LANZA_PERIODICO tengan un tamaño inmanejable.';

    --Queries
    V_MSQL                          VARCHAR2(4000 CHAR);

    --Utiles
    V_NUM                           NUMBER(16);
    V_ERROR_DESC                    VARCHAR2(1000 CHAR) := '';
    V_FECHA_REQ                     DATE;
    V_NUM_DIAS                      NUMBER(16);
    V_REGS                          NUMBER(16) := 0;
    V_REGS_CANDIDATOS               NUMBER(16) := 0;

    --Excepciones
    ERR_NEGOCIO EXCEPTION;

BEGIN
--v0.1

    COD_RETORNO := 0;
    DBMS_OUTPUT.PUT_LINE(V_DESC_SP);

    --1. Comprobación de los parametros de entrada.
    -------------------------------------------------------

    CASE
        WHEN NUM_DIAS IS NULL OR NUM_DIAS < 1
            THEN V_ERROR_DESC := '[ERROR] El NUM_DIAS indicado como parámetro de entrada es demasiado pequeño o no se ha ingresado. Por favor ingrese un número mayor que 0.';
                 COD_RETORNO := 1;
                 V_NUM_DIAS := -1;
    ELSE
        COD_RETORNO := COD_RETORNO;
        --ASIGNAMOS A LA VARIABLE V_FECHA_REQ LA FECHA HASTA LA CUAL QUEREMOS BORRAR REGISTROS (BORRAMOS FECHA < V_FECHA_REQ)
        V_NUM_DIAS := NUM_DIAS;
        V_FECHA_REQ := TRUNC(SYSDATE-NUM_DIAS);
    END CASE;

    IF COD_RETORNO = 1 THEN DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC); END IF;

    --1.1 Comprobación de las tablas donde vamos a escribir.
    -------------------------------------------------------

    IF COD_RETORNO = 0 THEN 
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN (''HLP_HISTORICO_LANZA_PERIODICO'',''HLD_HISTORICO_LANZA_PER_DETA'') AND OWNER LIKE '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

        IF V_NUM > 1 THEN
            COD_RETORNO := 0;
            DBMS_OUTPUT.PUT_LINE('[INFO] Existen las tablas HLP_HISTORICO_LANZA_PERIODICO y HLD_HISTORICO_LANZA_PER_DETA. Continuamos la ejecución.');
        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] NO existe la tabla HLP_HISTORICO_LANZA_PERIODICO ó HLD_HISTORICO_LANZA_PER_DETA. O no existen ambas. Paramos la ejecución.';
            DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
        END IF;
    END IF;

    --2. Realizamos comprobaciones sobre HLD_HISTORICO_LANZA_PER_DETA y HLP_HISTORICO_LANZA_PERIODICO
    -------------------------------------------------------------------------------------------------

    --2.1 Comprobaciones previas HLD
    IF COD_RETORNO = 0 THEN 
        V_MSQL := '
        SELECT 
        COUNT(1)
        FROM '||V_ESQUEMA||'.HLD_HISTORICO_LANZA_PER_DETA
        WHERE TRUNC(HLD_FECHA_EJEC) < '''||V_FECHA_REQ||'''
        ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

        IF V_NUM > 0 THEN 
            COD_RETORNO := 0;
            V_REGS_CANDIDATOS := V_REGS_CANDIDATOS+V_NUM;
            DBMS_OUTPUT.PUT_LINE('[INFO] Se va a proceder a borrar '||V_NUM||'. registros en HLD_HISTORICO_LANZA_PER_DETA, correspondientes a días anteriores a '||V_FECHA_REQ||'.');
        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] No existen registros en HLD_HISTORICO_LANZA_PER_DETA correspondientes a días anteriores a '||V_FECHA_REQ||'.';
            DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
        END IF;
    END IF;

    --2.2 Comprobaciones previas HLP
    IF COD_RETORNO = 0 THEN 
        V_MSQL := '
        SELECT 
        COUNT(1)
        FROM '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO
        WHERE TRUNC(HLP_FECHA_EJEC) < '''||V_FECHA_REQ||'''
        ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

        IF V_NUM > 0 THEN 
            COD_RETORNO := 0;
            V_REGS_CANDIDATOS := V_REGS_CANDIDATOS+V_NUM;
            DBMS_OUTPUT.PUT_LINE('[INFO] Se va a proceder a borrar '||V_NUM||'. registros en HLP_HISTORICO_LANZA_PERIODICO, correspondientes a días anteriores a '||V_FECHA_REQ||'.');
        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] No existen registros en HLP_HISTORICO_LANZA_PERIODICO correspondientes a días anteriores a '||V_FECHA_REQ||'.';
            DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
        END IF;
    END IF;

    --3. Ejecutamos el borrado sobre HLD_HISTORICO_LANZA_PER_DETA y HLP_HISTORICO_LANZA_PERIODICO si hemos encontrado registros
    ---------------------------------------------------------------------------------------------------------------------------
    
    --3.1 Borramos en HLD
    IF COD_RETORNO = 0 THEN
        V_MSQL := '
        DELETE 
        FROM '||V_ESQUEMA||'.HLD_HISTORICO_LANZA_PER_DETA
        WHERE TRUNC(HLD_FECHA_EJEC) < '''||V_FECHA_REQ||'''
        ';
        EXECUTE IMMEDIATE V_MSQL;

        IF SQL%ROWCOUNT > 0 THEN
            V_REGS := V_REGS+SQL%ROWCOUNT;
            COD_RETORNO := 0;
            DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado '||SQL%ROWCOUNT||' registros en HLD_HISTORICO_LANZA_PER_DETA.');
        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] No se han podido borrar registros en HLD_HISTORICO_LANZA_PER_DETA. Paramos la ejecución.';
            DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
        END IF;
    END IF; 

    --3.2 Borramos en HLP
    IF COD_RETORNO = 0 THEN
        V_MSQL := '
        DELETE 
        FROM '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO
        WHERE TRUNC(HLP_FECHA_EJEC) < '''||V_FECHA_REQ||'''
        ';
        EXECUTE IMMEDIATE V_MSQL;

        IF SQL%ROWCOUNT > 0 THEN
            V_REGS := V_REGS+SQL%ROWCOUNT;
            COD_RETORNO := 0;
            DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado '||SQL%ROWCOUNT||' registros en HLP_HISTORICO_LANZA_PERIODICO.');
        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] No se han podido borrar registros en HLP_HISTORICO_LANZA_PERIODICO. Paramos la ejecución.';
            DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
        END IF;
    END IF; 



--Finalizamos en función del COD_RETORNO
IF COD_RETORNO = 1 THEN
    
    IF V_ERROR_DESC = '' THEN
        V_ERROR_DESC := 'POR ALGUNA RAZÓN NO SE HA ASIGNADO UNA DESCRIPCIÓN A ÉSTE ERROR. REVISAD!';
    END IF;

    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('[ERROR] Procedemos a informar la tabla HLP_HISTORICO_LANZA_PERIODICO.');
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO (
        HLP_SP_CARGA,
        HLP_FECHA_EJEC,
        HLP_RESULTADO_EJEC,
        HLP_CODIGO_REG,
        HLP_REGISTRO_EJEC
    )
    SELECT
        ''SP_EXT_LIMPIEZA_HISTORICOS'',
        SYSDATE,
        1,
        '''||V_NUM_DIAS||''',
        '''||V_ERROR_DESC||'. No se han podido borrar '||V_REGS_CANDIDATOS||' registros candidatos.''
    FROM DUAL
    ';
    EXECUTE IMMEDIATE V_MSQL;
    COMMIT;
    RAISE ERR_NEGOCIO;

ELSE
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Procedemos a informar la tabla HLP_HISTORICO_LANZA_PERIODICO.');
    V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO (
        HLP_SP_CARGA,
        HLP_FECHA_EJEC,
        HLP_RESULTADO_EJEC,
        HLP_CODIGO_REG,
        HLP_REGISTRO_EJEC
    )
    SELECT
        ''SP_EXT_LIMPIEZA_HISTORICOS'',
        SYSDATE,
        0,
        '''||V_NUM_DIAS||''',
        ''[INFO] Se han borrado '||V_REGS||' registros entre HLP_HISTORICO_LANZA_PERIODICO y HLD_HISTORICO_LANZA_PER_DETA.''
    FROM DUAL
    ';
    EXECUTE IMMEDIATE V_MSQL;
    COMMIT;

END IF;

DBMS_OUTPUT.PUT_LINE('[FIN] Procedimiento SP_EXT_LIMPIEZA_HISTORICOS finalizado correctamente!');

EXCEPTION
     WHEN ERR_NEGOCIO THEN
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha abortado el proceso ya que no se cumplía alguno de los requisitos.');
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          COD_RETORNO := 1;
          ROLLBACK;
          RAISE;
     WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE(SQLERRM);
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          COD_RETORNO := 1;
          ROLLBACK;
          RAISE;
END SP_EXT_LIMPIEZA_HISTORICOS;
/
EXIT;
