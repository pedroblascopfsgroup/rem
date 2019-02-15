--/*
--######################################### 
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2837
--## PRODUCTO=NO
--## Finalidad:
--##      
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE SP_EXT_ACTUALIZA_PERIMETRO (
    ACT_NUM_ACTIVO IN REM01.ACT_ACTIVO.ACT_NUM_ACTIVO%TYPE,
    PAC_INCLUIDO IN REM01.ACT_PAC_PERIMETRO_ACTIVO.PAC_INCLUIDO%TYPE,
    COD_RETORNO OUT NUMBER
)
IS

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar
    V_COUNT NUMBER(16);
	V_NOTABLES NUMBER(1) := 0;
	HLP_REGISTRO_EJEC VARCHAR2(1024 CHAR) := '';
    
    V_TABLA_HLP VARCHAR2(30 CHAR) := 'HLP_HISTORICO_LANZA_PERIODICO';
	V_TABLA_HLD VARCHAR2(30 CHAR) := 'HLD_HISTORICO_LANZA_PER_DETA';
    V_TABLA_PAC VARCHAR2(30 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO';
    V_TABLA_ACT VARCHAR2(30 CHAR) := 'ACT_ACTIVO';

    BEGIN
        
        --v0.1
	    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
        
        COD_RETORNO := 0;
        
        /*****************************************************************
        1.- Miramos que el parámetro obligatorio del SP (ACT_NUM_ACTIVO) venga informado
        ******************************************************************/
        IF COD_RETORNO = 0 AND ACT_NUM_ACTIVO IS NULL THEN
            HLP_REGISTRO_EJEC := '[ERROR] El ACT_NUM_ACTIVO indicado como parámetro de entrada es obligatorio y no se ha ingresado. Por favor ingrese un valor válido para este campo.';
            COD_RETORNO := 1;
        END IF;
        
        /*****************************************************************
        2.- Miramos que el parámetro obligatorio del SP (PAC_INCLUIDO) venga informado
        ******************************************************************/
        IF COD_RETORNO = 0 AND PAC_INCLUIDO IS NULL THEN
            HLP_REGISTRO_EJEC := '[ERROR] El PAC_INCLUIDO indicado como parámetro de entrada es obligatorio y no se ha ingresado. Por favor ingrese un valor válido para este campo.';
            COD_RETORNO := 1;
        END IF;
        
        /*****************************************************************
        3.- Miramos que el activo exista en la ACT_ACTIVO.
        ******************************************************************/
        IF COD_RETORNO = 0 THEN
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO = '''||ACT_NUM_ACTIVO||''' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
            IF V_COUNT = 0 THEN
                    HLP_REGISTRO_EJEC := '[ERROR] El activo '||ACT_NUM_ACTIVO||' no existe.';
                    COD_RETORNO := 1;
            END IF;
        END IF;
        
        /*****************************************************************
        4.- Comprobamos que las tablas donde vamos a escribir (HLP y HLD) existan.
        ******************************************************************/
        IF COD_RETORNO = 0 THEN
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN ('''|| V_TABLA_HLP ||''','''|| V_TABLA_HLD ||''') AND OWNER LIKE '''||V_ESQUEMA||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
            
            IF V_COUNT < 2 THEN
                HLP_REGISTRO_EJEC := '[ERROR] No existe la tabla HLP_HISTORICO_LANZA_PERIODICO ó la HLD_HISTORICO_LANZA_PER_DETA. O no existen ambas. Paramos la ejecución.';
                DBMS_OUTPUT.PUT_LINE(HLP_REGISTRO_EJEC);
                COD_RETORNO := 1;
                V_NOTABLES := 1;
            END IF;
        END IF;
        
        /*****************************************************************
        5.- Actualizamos la ACT_PAC_PERIMETRO_ACTIVO.
        ******************************************************************/
        --Si no ha habido errores y existen las tablas HLP y HLD
        IF COD_RETORNO = 0 AND V_NOTABLES = 0 THEN
        
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLD||' (
                HLD_SP_CARGA,
                HLD_FECHA_EJEC,
                HLD_CODIGO_REG,
                HLD_TABLA_MODIFICAR,
                HLD_TABLA_MODIFICAR_CLAVE,
                HLD_TABLA_MODIFICAR_CLAVE_ID,
                HLD_CAMPO_MODIFICAR,
                HLD_VALOR_ORIGINAL,
                HLD_VALOR_ACTUALIZADO
             )
             SELECT
                 ''SP_EXT_ACTUALIZA_PERIMETRO'',
                 SYSDATE,
                 '||ACT_NUM_ACTIVO||',
                 '''||V_TABLA_PAC||''',
                 ''ACT_ID'',
                 PAC.ACT_ID,
                 ''PAC_INCLUIDO'',
                 PAC.PAC_INCLUIDO,
                 '''||PAC_INCLUIDO||'''
             FROM '||V_ESQUEMA||'.'||V_TABLA_PAC||' PAC WHERE PAC.ACT_ID = (
                SELECT ACT_ID
                FROM '|| V_ESQUEMA ||'.'|| V_TABLA_ACT ||'
                WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
                )
             ';
             EXECUTE IMMEDIATE V_MSQL;
            
             V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'|| V_TABLA_PAC ||'
                    SET PAC_INCLUIDO  = '||PAC_INCLUIDO||'
                        ,USUARIOMODIFICAR = ''SP_EXT_ACTUALIZA_PERIMETRO''
                        ,FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = (
	                    SELECT ACT_ID
	                    FROM '|| V_ESQUEMA ||'.'|| V_TABLA_ACT ||'
	                    WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
	                    )
                  ';
             EXECUTE IMMEDIATE V_MSQL;
            
             V_COUNT := SQL%ROWCOUNT;
            
             V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
                 HLP_SP_CARGA,
                 HLP_FECHA_EJEC,
                 HLP_RESULTADO_EJEC,
                 HLP_CODIGO_REG,
                 HLP_REGISTRO_EJEC
             )VALUES(
                 ''SP_EXT_ACTUALIZA_PERIMETRO'',
                 SYSDATE,
                 0,
                 '||ACT_NUM_ACTIVO||',
                 '||TO_CHAR(V_COUNT)||'
             )';
             EXECUTE IMMEDIATE V_MSQL;
            
             COD_RETORNO := 0;
    
        END IF;
    
        /*****************************************************************
        6.- Si ha habido algún error, insertamos 1 registro en la HLP con el error
        ******************************************************************/
        IF COD_RETORNO = 1 AND V_NOTABLES = 0 THEN
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
                ''SP_EXT_ACTUALIZA_PROVEEDOR'',
                SYSDATE,
                1,
                NVL('''||ACT_NUM_ACTIVO||''',''-1''),
                '''||HLP_REGISTRO_EJEC||'''
            FROM DUAL
            ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] - Ha habido errores. Se inserta '||SQL%ROWCOUNT||' registro en la HLP_HISTORICO_LANZA_PERIODICO.');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('[FIN]');
	COMMIT;

	EXCEPTION
	  WHEN OTHERS THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
        
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_HLP||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    
        IF V_COUNT > 0 THEN
    
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
                HLP_SP_CARGA,
                HLP_FECHA_EJEC,
                HLP_RESULTADO_EJEC,
                HLP_CODIGO_REG,
                HLP_REGISTRO_EJEC
            )VALUES(
            ''SP_EXT_ACTUALIZA_PROMOCION'',
             SYSDATE,
             1,
             '||ACT_NUM_ACTIVO||',
             '''||SQLERRM||'''
             )';
              EXECUTE IMMEDIATE V_MSQL;
    
            COMMIT;
        END IF;
        COD_RETORNO := 1;
	    RAISE;

END SP_EXT_ACTUALIZA_PERIMETRO;

/
EXIT;