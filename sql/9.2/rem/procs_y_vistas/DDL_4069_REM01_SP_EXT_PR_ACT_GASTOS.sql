--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180904
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=HREOS-4197
--## PRODUCTO=NO
--## Finalidad: Permitir la actualización de reservas y ventas vía la llegada de datos externos de Prinex. Una llamada por modificación. Liberbank.
--## Info: https://link-doc.pfsgroup.es/confluence/display/REOS/SP_EXT_PR_ACT_RES_VENTA
--##       Mantengamos la documentación al día. Si subimos de versión, reflejemoslo en el SP, en el comentario tras el BEGIN
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1  Versión inicial
--##        0.2  Control de errores en HLP_HISTORICO_LANZA_PERIODICO
--##        1.01 Se elimina la restricción para los gastos con iva. Ahora pueden actualizar la fecha de contabilización.
--##		1.02 Se añaden modificaciones segun el item REMVIP-1698.
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE #ESQUEMA#.SP_EXT_PR_ACT_GASTOS (

    --Parametros de entrada
    GPV_NUM_GASTO_HAYA          IN VARCHAR2,   --Obligatorio
    NUM_GASTO_DESTINATARIO      IN VARCHAR2,
    FECHA_PAGO                  IN VARCHAR2,   --Obligatorio Opcion1
    FECHA_CONTABILIZACION       IN VARCHAR2,   --Obligatorio Opcion2
    EJERCICIO                   IN VARCHAR2,   --Formato YYYY
    GIC_CUENTA_CONTABLE         IN VARCHAR2,
    GIC_PTDA_PRESUPUESTARIA     IN VARCHAR2,

    --Variables de salida
    COD_RETORNO                 OUT VARCHAR2 -- 0 OK / 1 KO

) AS

    --Configuracion
    V_ESQUEMA                       VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER                VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';

    --IDs
    V_ACT_ID                        NUMBER(16) := -1;
    V_GPV_ID                        NUMBER(16) := -1;
    V_GIC_ID                        NUMBER(16) := -1;
    V_TIT_ID                        NUMBER(16) := -1;
    V_EGA_ID                        NUMBER(16) := -1;
    V_EGA_CODIGO                    VARCHAR2(10 CHAR) := '';
    V_NUM_FACTUR_UVEM               VARCHAR2(20 CHAR) := '';
    V_GDE_ID                        NUMBER(16) := -1;
    V_GGE_ID                        NUMBER(16) := -1;
    V_EJE_ID                        NUMBER(16) := -1;
    V_FEC_CONTABILIZACION           VARCHAR2(10 CHAR) := '';
    V_FECHA_PAGO                    VARCHAR2(10 CHAR) := '';
    V_CUENTA_CONTABLE               VARCHAR2(50 CHAR) := '';
    V_PTDA_PRESUPESTARIA            VARCHAR2(50 CHAR) := '';
    V_GPV_NUM_GASTO_HAYA            VARCHAR2(16 CHAR);
    DD_DEG_ID 						NUMBER(16) := -1;
    DD_DEG_ID_CONTABILIZA 			NUMBER(16) := -1;
    DD_EAP_ID_ANTERIOR				NUMBER(16) := -1;
    DD_EAP_ID_NUEVO					NUMBER(16) := -1;

    --Info
    V_OP_1_DESC                     VARCHAR2(400 CHAR) := '[OPERATORIA] Para todos los registros con FECHA DE CONTABILIZACION relacionado con un gasto cuyo estado no sea "Rechazado administración","Contabilizado","Pagado" "Rechazado propietario" o "Anulado".';
    V_OP_2_DESC                     VARCHAR2(400 CHAR) := '[OPERATORIA] Para todos los registros con FECHA DE PAGO relacionado con un gasto cuyo estado no sea "Rechazado administración","Pagado" "Rechazado propietario" o "Anulado".';

    --Queries
    V_MSQL                          VARCHAR2(4000 CHAR);

    V_COUNT                         VARCHAR2(30 CHAR)   := 'SELECT COUNT(1) ';

    V_SELECT_GASTO                  VARCHAR2(1000 CHAR)  := 'SELECT
                                                            GPV.GPV_ID,
                                                            GDE.DD_TIT_ID,
                                                            EGA.DD_EGA_CODIGO,
                                                            EGA.DD_EGA_ID,
                                                            GPV.GPV_NUMERO_FACTURA_UVEM,
                                                            GIC.GIC_FECHA_CONTABILIZACION,
                                                            GIC.EJE_ID,
                                                            GIC.GIC_CUENTA_CONTABLE,
                                                            GIC.GIC_PTDA_PRESUPUESTARIA,
                                                            GDE.GDE_FECHA_PAGO,
                                                            GIC.GIC_ID,
                                                            GDE.GDE_ID ';

    V_FROM_GASTO                    VARCHAR2(2000 CHAR) := 'FROM #ESQUEMA#.GPV_GASTOS_PROVEEDOR GPV
                                                            LEFT JOIN #ESQUEMA#.GDE_GASTOS_DETALLE_ECONOMICO GDE
                                                                ON GDE.GPV_ID = GPV.GPV_ID
                                                            LEFT JOIN #ESQUEMA#.GIC_GASTOS_INFO_CONTABILIDAD GIC
                                                                ON GIC.GPV_ID = GPV.GPV_ID
                                                            LEFT JOIN #ESQUEMA#.DD_EGA_ESTADOS_GASTO EGA
                                                                ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                                                            WHERE GPV.GPV_NUM_GASTO_HAYA = :1';

    V_LOGAR_HDL                     VARCHAR2(1400 CHAR) := 'HLD_HIST_LANZA_PER_DETA(''SP_EXT_PR_ACT_GASTOS'',:1,:2,:3,:4,:5,:6,:7)'; -- 1 HLD_SP_CARGA, 2 HLD_CODIGO_REG, 3 HLD_TABLA_MODIFICAR, 4 HLD_TABLA_MODIFICAR_CLAVE, 5 HLD_TABLA_MODIFICAR_CLAVE_ID, 6 HLD_CAMPO_MODIFICAR, 7 HLD_VALOR_ORIGINAL, 8 HLD_VALOR_ACTUALIZADO

    --Utiles
    V_NUM                           NUMBER(16);
    V_OP_1_PASOS                    NUMBER(1) := 6;
    V_OP_2_PASOS                    NUMBER(1) := 7;
    V_PASOS                         NUMBER(3) := 0;
    V_ERROR_DESC                    VARCHAR2(1000 CHAR) := '';
    FECHA_PAGO_DATE                 DATE;
    FECHA_CONTABILIZACION_DATE      DATE;
    PARAM1                          VARCHAR2(50 CHAR);
    PARAM2                          VARCHAR2(50 CHAR);
    PARAM3                          VARCHAR2(50 CHAR);
    V_VALOR_ACTUAL                  VARCHAR2(50 CHAR);
    V_VALOR_NUEVO                   VARCHAR2(50 CHAR);

    --Excepciones
    ERR_NEGOCIO EXCEPTION;

    --Procedure que inserta en HLD_HISTORICO_LANZA_PER_DETA, sin comitear.
    PROCEDURE HLD_HIST_LANZA_PER_DETA (
      HLD_CODIGO_REG                  IN VARCHAR2,
      HLD_TABLA_MODIFICAR             IN VARCHAR2,
      HLD_TABLA_MODIFICAR_CLAVE       IN VARCHAR2,
      HLD_TABLA_MODIFICAR_CLAVE_ID    IN NUMBER,
      HLD_CAMPO_MODIFICAR             IN VARCHAR2,
      HLD_VALOR_ORIGINAL              IN VARCHAR2,
      HLD_VALOR_ACTUALIZADO           IN VARCHAR2
    ) IS

    BEGIN

    V_MSQL := '
      INSERT INTO '||V_ESQUEMA||'.HLD_HISTORICO_LANZA_PER_DETA (
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
        ''SP_EXT_PR_ACT_GASTOS'',
        SYSDATE,
        TO_NUMBER('''||HLD_CODIGO_REG||'''),
        '''||HLD_TABLA_MODIFICAR||''',
        '''||HLD_TABLA_MODIFICAR_CLAVE||''',
        '||HLD_TABLA_MODIFICAR_CLAVE_ID||',
        '''||HLD_CAMPO_MODIFICAR||''',
        '''||HLD_VALOR_ORIGINAL||''',
        '''||HLD_VALOR_ACTUALIZADO||'''
      FROM DUAL
      ';
      EXECUTE IMMEDIATE V_MSQL;

      IF SQL%ROWCOUNT = 1 THEN
         DBMS_OUTPUT.PUT_LINE('[INFO] HLD_HISTORICO_LANZA_PER_DETA | Registro insertado correctamente, no comiteado.');
      ELSE
         DBMS_OUTPUT.PUT_LINE('[ERROR] HLD_HISTORICO_LANZA_PER_DETA | No se ha podido insertar el registro correctamente.');
      END IF;

    END;

    --Procedure que inserta en HLP_HISTORICO_LANZA_PERIODICO, sin comitear.
    PROCEDURE HLP_HISTORICO_LANZA_PERIODICO (
      HLP_CODIGO_REG                  IN VARCHAR2,
      HLP_RESULTADO_EJEC              IN NUMBER,
      HLP_REGISTRO_EJEC               IN VARCHAR2
    ) IS

    BEGIN

    V_MSQL := '
      INSERT INTO '||V_ESQUEMA||'.HLP_HISTORICO_LANZA_PERIODICO (
        HLP_SP_CARGA,
        HLP_FECHA_EJEC,
        HLP_RESULTADO_EJEC,
        HLP_CODIGO_REG,
        HLP_REGISTRO_EJEC
      )
      SELECT
        ''SP_EXT_PR_ACT_GASTOS'',
        SYSDATE,
        '||HLP_RESULTADO_EJEC||',
        '''||HLP_CODIGO_REG||''',
        '''||HLP_REGISTRO_EJEC||'''
      FROM DUAL
      ';
      EXECUTE IMMEDIATE V_MSQL;
      

      IF SQL%ROWCOUNT = 1 THEN
         DBMS_OUTPUT.PUT_LINE('[INFO] HLP_HISTORICO_LANZA_PERIODICO | Registro insertado correctamente, no comiteado.');
      ELSE
         DBMS_OUTPUT.PUT_LINE('[ERROR] HLP_HISTORICO_LANZA_PERIODICO | No se ha podido insertar el registro correctamente.');
      END IF;

    END;

BEGIN
--Version : 1.01

    --Iniciamos con COD_RETORNO = 0.
    COD_RETORNO := 0;
    --Mostramos todos los parámetros que hemos ingresado en la entrada.
    DBMS_OUTPUT.PUT_LINE('[INICIO] Permitir la actualización de gastos vía la llegada de datos externos de Prinex. Una llamada por modificación.');
    DBMS_OUTPUT.PUT_LINE('[INFO] A continuación se mostrarán los parámetros de entrada:');
    DBMS_OUTPUT.PUT_LINE('GPV_NUM_GASTO_HAYA: '||GPV_NUM_GASTO_HAYA);
    DBMS_OUTPUT.PUT_LINE('NUM_GASTO_DESTINATARIO: '||NUM_GASTO_DESTINATARIO);
    DBMS_OUTPUT.PUT_LINE('FECHA_PAGO (Se espera yyyyMMdd): '||FECHA_PAGO);
    DBMS_OUTPUT.PUT_LINE('FECHA_CONTABILIZACION (Se espera yyyyMMdd): '||FECHA_CONTABILIZACION);
    DBMS_OUTPUT.PUT_LINE('EJERCICIO: '||EJERCICIO);
    DBMS_OUTPUT.PUT_LINE('GIC_CUENTA_CONTABLE: '||GIC_CUENTA_CONTABLE);
    DBMS_OUTPUT.PUT_LINE('GIC_PTDA_PRESUPUESTARIA: '||GIC_PTDA_PRESUPUESTARIA);

    --Seteamos la descripción del error correspondiente a la imposibilidad de convertir el parametro de entrada a DATE.
    V_ERROR_DESC := '[ERROR] No se ha podido convertir la fecha a DATE, comprobar máscara. Paramos la ejecución.';
    COD_RETORNO := 1;
    IF FECHA_PAGO IS NOT NULL THEN
        FECHA_PAGO_DATE                 := to_date(FECHA_PAGO,'yyyyMMdd');
    END IF;
    IF FECHA_CONTABILIZACION IS NOT NULL THEN
        FECHA_CONTABILIZACION_DATE      := to_date(FECHA_CONTABILIZACION,'yyyyMMdd');
    END IF;
    --En el caso de que se haya podido convertir satisfactoriamente, reiniciamos la descripcion del error.
    COD_RETORNO := 0;
    V_ERROR_DESC := '';

    --1. Comprobación de los parametros de ENTRADA.
    -------------------------------------------------------
    --Aquí comenzamos directamente con el CASE, ya que al ser el inicio, está claro que COD_RETORNO = 0.
    CASE
        --1. NO SE INSERTA GPV_NUM_GASTO_HAYA
        WHEN GPV_NUM_GASTO_HAYA IS NULL
            THEN V_ERROR_DESC := '[ERROR] No se ha informado GPV_NUM_GASTO_HAYA. Por favor, informe éste parámetro. Paramos la ejecución.';
                 COD_RETORNO := 1;
        --2. NO SE INSERTA FECHA_PAGO NI FECHA_CONTABILIZACION
        WHEN FECHA_PAGO IS NULL AND FECHA_CONTABILIZACION IS NULL
            THEN V_ERROR_DESC := '[ERROR] No se ha informado ni FECHA_PAGO ni FECHA_CONTABILIZACION. Por favor, informe una de éstas fechas. Paramos la ejecución.';
                 COD_RETORNO := 1;
        /*--3. SE INSERTA FECHA_PAGO Y FECHA_CONTABILIZACION
        WHEN FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL
            THEN V_ERROR_DESC := '[ERROR] Se ha informado FECHA_PAGO y FECHA_CONTABILIZACION simultaneamente. Por favor, informe solo una de éstas fechas. Paramos la ejecución.';
                 COD_RETORNO := 1;*/

    ELSE
        COD_RETORNO := 0;
        V_GPV_NUM_GASTO_HAYA := GPV_NUM_GASTO_HAYA;
    END CASE;

    --1.1 Comprobación de las TABLAS donde vamos a escribir.
    -------------------------------------------------------
    --A partir de aquí, para cada paso que demos, antes vamos a comprobar que COD_RETORNO = 0.
    IF COD_RETORNO = 0 THEN
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN (''HLP_HISTORICO_LANZA_PERIODICO'',''HLD_HISTORICO_LANZA_PER_DETA'') AND OWNER LIKE '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
        IF V_NUM > 1 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Existen las tablas HLP_HISTORICO_LANZA_PERIODICO y HLD_HISTORICO_LANZA_PER_DETA. Continuamos la ejecución.');
        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] NO existe la tabla HLP_HISTORICO_LANZA_PERIODICO ó HLD_HISTORICO_LANZA_PER_DETA. O no existen ambas. Paramos la ejecución.';
        END IF;
    END IF;

    --2. Analizamos la información de entrada para derivar por uno u otro proceso.
    ------------------------------------------------------------------------------
    --Obtenemos todos los datos de valor.
    IF COD_RETORNO = 0 THEN
        DBMS_OUTPUT.PUT_LINE('V_GPV_NUM_GASTO_HAYA: '||V_GPV_NUM_GASTO_HAYA);
        V_MSQL := V_COUNT||V_FROM_GASTO;
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM USING V_GPV_NUM_GASTO_HAYA;

        IF V_NUM > 0 THEN
            V_MSQL := V_SELECT_GASTO||V_FROM_GASTO;
            EXECUTE IMMEDIATE V_MSQL
            INTO V_GPV_ID, V_TIT_ID, V_EGA_CODIGO, V_EGA_ID, V_NUM_FACTUR_UVEM, V_FEC_CONTABILIZACION, V_EJE_ID, V_CUENTA_CONTABLE, V_PTDA_PRESUPESTARIA, V_FECHA_PAGO, V_GIC_ID, V_GDE_ID
            USING V_GPV_NUM_GASTO_HAYA;
        ELSE
            --Si no existe el gasto, asignamos COD_RETORNO = 1 para finalizar el proceso.
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] NO existe gasto con el NÚMERO DE GASTO HAYA '||GPV_NUM_GASTO_HAYA||', o está duplicado. Paramos la ejecución.';
        END IF;

    END IF;

    --2.1. Para todos los registros con FECHA DE CONTABILIZACION relacionado con un gasto SIN IVA cuyo estado no sea "Rechazado administración","Contabilizado","Pagado" "Rechazado propietario" o "Anulado".
    --Comprobamos que tenemos el gasto, y que viene informada la fecha de contabilización. Adicinalmente comprobamos que no hay errores, y que no se ha ejecutado ningún paso con anterioridad.
    ------------------
    -- OPERATORIA 1 --
    ------------------
    IF (V_GPV_ID IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL AND FECHA_PAGO IS NULL) AND COD_RETORNO = 0 /*AND V_PASOS = 0*/ THEN

        --Mostramos la descripción de la operatoria en ejecución
        DBMS_OUTPUT.PUT_LINE(V_OP_1_DESC);
        -----------------
        -- PASO PREVIO --
        -----------------
            --¿El estado del gasto es "Rechazado administración","Contabilizado","Pagado" "Rechazado propietario" o "Anulado"?
            IF V_EGA_CODIGO IN ('02','04','05','06','08') THEN
                --KO
                COD_RETORNO := 1;
                V_ERROR_DESC := '[INFO] El gasto '||V_GPV_NUM_GASTO_HAYA||' tiene un estado "Rechazado administración","Contabilizado","Pagado", "Rechazado propietario" o "Anulado". Paramos la ejecución.';
            ELSE
                --OK
                DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||V_GPV_NUM_GASTO_HAYA||' NO TIENE un estado "Rechazado administración","Contabilizado","Pagado", "Rechazado propietario" o "Anulado". Continuamos la ejecución.');
            END IF;

        --Si hemos llegado hasta aquí, ejecutamos la operatoria 1.
        --------------
        -- PASO 1/6 --
        --------------
        IF COD_RETORNO = 0 THEN
            --PASO 1/6 Actualizar el estado del gasto (GPV_GASTOS_PROVEEDOR.DD_EGA_ID ) a "Contabilizado".
            --Recuperamos el NUEVO valor
            V_MSQL := '
            SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04'''; /*CONTABILIZADO*/
            EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
            SET DD_EGA_ID = '||V_VALOR_NUEVO||', /*CONTABILIZADO*/
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID = '||V_GPV_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] El estado del gasto ha pasado a "Contabilizado" para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Avanzamos un paso
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GPV_GASTOS_PROVEEDOR';
                PARAM2 := 'GPV_ID';
                PARAM3 := 'DD_EGA_ID';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GPV_ID, PARAM3, V_EGA_ID, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido cambiar el estado del gasto a "Contabilizado" para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 2/6 --
        --------------
        IF COD_RETORNO = 0 AND NUM_GASTO_DESTINATARIO IS NOT NULL THEN
            --PASO 2/6 Actualizar la referencia de la factura (GPV_GASTOS_PROVEEDOR.GPV_NUMERO_FACTURA_UVEM) con el número de gasto del destinatario.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := NUM_GASTO_DESTINATARIO;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
            SET GPV_NUMERO_FACTURA_UVEM = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID = '||V_GPV_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la referencia de la factura para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||' a '||V_VALOR_NUEVO||'. Continuamos la ejecución.');
                --Avanzamos un paso
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GPV_GASTOS_PROVEEDOR';
                PARAM2 := 'GPV_ID';
                PARAM3 := 'GPV_NUMERO_FACTURA_UVEM';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GPV_ID, PARAM3, V_NUM_FACTUR_UVEM, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la referencia de la factura para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||' a '||V_VALOR_NUEVO||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 3/6 --
        --------------
        IF COD_RETORNO = 0 AND FECHA_CONTABILIZACION_DATE IS NOT NULL THEN
            --PASO 3/6 Actualizar la fecha de contabilización (GIC_GASTOS_INFO_CONTABILIDAD.GIC_FECHA_CONTABILIZACION) con el dato de Fecha de Contabilización.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := FECHA_CONTABILIZACION_DATE;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
            SET GIC_FECHA_CONTABILIZACION = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GIC_ID = '||V_GIC_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha informado el campo GIC_FECHA_CONTABILIZACION para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Avanzamos un paso
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                PARAM2 := 'GIC_ID';
                PARAM3 := 'GIC_FECHA_CONTABILIZACION';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, V_FEC_CONTABILIZACION, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido informar el campo GIC_FECHA_CONTABILIZACION para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
            
            ------------------------------------------------------------
            -----MODIFICACIONES NUEVAS -- REMVIP-1698
            ------------------------------------------------------------       
            EXECUTE IMMEDIATE 'SELECT DD_DEG_ID_CONTABILIZA FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD WHERE GIC_ID = '||V_GIC_ID INTO DD_DEG_ID_CONTABILIZA;
            EXECUTE IMMEDIATE 'SELECT DD_DEG_ID FROM '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO WHERE DD_DEG_CODIGO = ''03'' ' INTO DD_DEG_ID;
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
            SET DD_DEG_ID_CONTABILIZA = '||DD_DEG_ID||',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GIC_ID = '||V_GIC_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL; 
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha informado el campo DD_DEG_ID_CONTABILIZA para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                PARAM2 := 'GIC_ID';
                PARAM3 := 'DD_DEG_ID_CONTABILIZA';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, DD_DEG_ID_CONTABILIZA, DD_DEG_ID);
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido informar el campo DD_DEG_ID_CONTABILIZA para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
    
			EXECUTE IMMEDIATE 'SELECT GGE_ID FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION WHERE GPV_ID = '||V_GPV_ID||' AND ROWNUM = 1' INTO V_GGE_ID;
			EXECUTE IMMEDIATE 'SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION WHERE GPV_ID = '||V_GPV_ID||' AND ROWNUM = 1' INTO DD_EAP_ID_ANTERIOR;
            EXECUTE IMMEDIATE 'SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''07'' ' INTO DD_EAP_ID_NUEVO;
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION
            SET DD_EAP_ID = '||DD_EAP_ID_NUEVO||',
			GGE_FECHA_EAP = SYSDATE,
			USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
			FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID = '||V_GPV_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha informado el campo DD_EAP_ID para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GGE_GASTOS_GESTION';
                PARAM2 := 'GGE_ID';
                PARAM3 := 'DD_EAP_ID';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GGE_ID, PARAM3, DD_EAP_ID_ANTERIOR, DD_EAP_ID_NUEVO);
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido informar el campo DD_EAP_ID para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
                 
        END IF;
        --------------
        -- PASO 4/6 -- OPCIONAL
        --------------
        --Aparte de que no haya errores, comprobamos que esté informado el campo EJERCICIO, y que éste tiene formato YYYY.
        IF EJERCICIO IS NOT NULL AND COD_RETORNO = 0 THEN
            --Recuperamos el NUEVO valor
            --Comprobamos que existe el ejercicio con el parametro introducido.
            V_MSQL := '
            SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||EJERCICIO||'''
            ';
            EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;

            IF V_VALOR_NUEVO IS NOT NULL THEN
                --PASO 4/6 Actualizar el ejercicio (GIC_GASTOS_INFO_CONTABILIDAD.EJE_ID) con el dato de Ejercicio si llega informado.
                --Realizamos la actuación
                V_MSQL := '
                UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
                SET EJE_ID = '||V_VALOR_NUEVO||',
                USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
                FECHAMODIFICAR = SYSDATE
                WHERE GIC_ID = '||V_GIC_ID||'
                ';
                EXECUTE IMMEDIATE V_MSQL;
                --Comprobamos si se ha actualizado o no
                IF SQL%ROWCOUNT > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el ejercicio a '||EJERCICIO||'. Continuamos la ejecución.');
                    --Avanzamos un paso
                    V_PASOS := V_PASOS+1;
                    --Logado en HLD_HIST_LANZA_PER_DETA
                    PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                    PARAM2 := 'GIC_ID';
                    PARAM3 := 'EJE_ID';
                    HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, V_EJE_ID, V_VALOR_NUEVO);
                    --Reseteamos el V_VALOR_NUEVO
                    V_VALOR_NUEVO := '';

                ELSE
                    COD_RETORNO := 1;
                    V_ERROR_DESC := '[ERROR] No se ha podido actualizar el ejercicio a '||EJERCICIO||'. Paramos la ejecución.';
                END IF;
            ELSE
                --El ejercicio informado no existe
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] El ejercicio informado: '||EJERCICIO||', no existe. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 5/6 -- OPCIONAL
        --------------
        IF GIC_CUENTA_CONTABLE IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 5/6 Actualizar la cuenta contable (GIC_GASTOS_INFO_CONTABILIDAD.GIC_CUENTA_CONTABLE) con el dato de Cuenta Contable si llega informado.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := GIC_CUENTA_CONTABLE;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
            SET GIC_CUENTA_CONTABLE = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GIC_ID = '||V_GIC_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la cuenta contable a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                PARAM2 := 'GIC_ID';
                PARAM3 := 'GIC_CUENTA_CONTABLE';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, V_CUENTA_CONTABLE, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';

            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la cuenta contable a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 6/6 -- OPCIONAL
        --------------
        IF GIC_PTDA_PRESUPUESTARIA IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 6/6 Actualizar la partida presupuestaria (GIC_GASTOS_INFO_CONTABILIDAD.GIC_PTDA_PRESUPUESTARIA) con el dato de Partida Presupuestaria si llega informado.
            --Recuperamos el NUEVO valor
            /*
            V_VALOR_NUEVO := GIC_PTDA_PRESUPUESTARIA;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
            SET GIC_PTDA_PRESUPUESTARIA = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GIC_ID = '||V_GIC_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la partida presupuestaria a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                PARAM2 := 'GIC_ID';
                PARAM3 := 'GIC_PTDA_PRESUPUESTARIA';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, V_PTDA_PRESUPESTARIA, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';

            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la partida presupuestaria a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
            */---> COMENTAMOS ESTE CÓDIGO POR LA MIGRACION DE LIBERBANK - 04-09-2018
            V_PASOS := V_PASOS+1;
        END IF;

        ----------------------
        -- FIN OPERATORIA 1 --
        ----------------------
        --Comprobamos que hemos dado todos los pasos de la operatoria.
        IF COD_RETORNO = 0 THEN
            CASE
                --Si hemos informado los 6/7 parámetros (Nunca pueden ser 7 ya que informamos FECHA_PAGO o FECHA_CONTABILIZACION).
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL OR FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GIC_CUENTA_CONTABLE IS NOT NULL AND GIC_PTDA_PRESUPUESTARIA IS NOT NULL
                THEN IF V_OP_1_PASOS != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 5/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL OR FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GIC_CUENTA_CONTABLE IS NOT NULL AND GIC_PTDA_PRESUPUESTARIA IS NULL
                THEN IF (V_OP_1_PASOS-1) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 4/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL OR FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GIC_CUENTA_CONTABLE IS NULL AND GIC_PTDA_PRESUPUESTARIA IS NULL
                THEN IF (V_OP_1_PASOS-2) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 3/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL OR FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NULL AND GIC_CUENTA_CONTABLE IS NULL AND GIC_PTDA_PRESUPUESTARIA IS NULL
                THEN IF (V_OP_1_PASOS-3) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
            ELSE
                COD_RETORNO := 0;
            END CASE;
        END IF;

    END IF;



    --2.2. Para todos los registros con FECHA DE PAGO relacionado con un gasto cuyo estado (GPV_GASTOS_PROVEEDOR.DD_EGA_ID) no sea "Rechazado administración","Pagado" "Rechazado propietario" o "Anulado".
    ------------------
    -- OPERATORIA 2 --
    ------------------
    IF (V_GPV_ID IS NOT NULL AND FECHA_PAGO IS NOT NULL) AND COD_RETORNO = 0 /*AND V_PASOS = 0*/ THEN

        --Mostramos la descripción de la operatoria en ejecución
        DBMS_OUTPUT.PUT_LINE(V_OP_2_DESC);
        DBMS_OUTPUT.PUT_LINE('V_EGA_CODIGO: '||V_EGA_CODIGO);

        -----------------
        -- PASO PREVIO --
        -----------------
        --¿El estado es "Rechazado administración","Pagado" "Rechazado propietario" o "Anulado"?
        IF V_EGA_CODIGO IN ('02','05','06','08') THEN
            --KO
            COD_RETORNO := 1;
            V_ERROR_DESC := '[INFO] El gasto '||V_GPV_NUM_GASTO_HAYA||' tiene un estado "Rechazado administración","Pagado" "Rechazado propietario" o "Anulado". Paramos la ejecución.';
        ELSE
            --OK
            DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||V_GPV_NUM_GASTO_HAYA||' NO TIENE un estado "Rechazado administración","Pagado" "Rechazado propietario" o "Anulado". Continuamos la ejecución.');
        END IF;

        --Si hemos llegado hasta aquí, ejecutamos la operatoria 1.
        --------------
        -- PASO 1/7 --
        --------------
        IF COD_RETORNO = 0 THEN
            --PASO 1/7 Actualizar el estado del gasto (GPV_GASTOS_PROVEEDOR.DD_EGA_ID ) a "Pagado".
            --Recuperamos el NUEVO valor
            V_MSQL := '
            SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'''; /*PAGADO*/
            EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
            SET DD_EGA_ID = '||V_VALOR_NUEVO||', /*PAGADO*/
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID = '||V_GPV_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] El estado del gasto ha pasado a "Pagado" para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Avanzamos un paso
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GPV_GASTOS_PROVEEDOR';
                PARAM2 := 'GPV_ID';
                PARAM3 := 'DD_EGA_ID';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GPV_ID, PARAM3, V_EGA_ID, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido cambiar el estado del gasto a "Pagado" para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 2/7 --
        --------------
        IF COD_RETORNO = 0 AND NUM_GASTO_DESTINATARIO IS NOT NULL THEN
            --PASO 2/7 Actualizar la referencia de la factura (GPV_GASTOS_PROVEEDOR.GPV_NUMERO_FACTURA_UVEM) con el número de gasto del destinatario.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := NUM_GASTO_DESTINATARIO;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
            SET GPV_NUMERO_FACTURA_UVEM = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID = '||V_GPV_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la referencia de la factura para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||' a '||V_VALOR_NUEVO||'. Continuamos la ejecución.');
                --Avanzamos un paso
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GPV_GASTOS_PROVEEDOR';
                PARAM2 := 'GPV_ID';
                PARAM3 := 'GPV_NUMERO_FACTURA_UVEM';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GPV_ID, PARAM3, V_NUM_FACTUR_UVEM, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la referencia de la factura para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||' a '||V_VALOR_NUEVO||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 3/7 -- OPCIONAL
        --------------
        IF FECHA_CONTABILIZACION IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 3/7 Actualizar la fecha de contabilización (GIC_GASTOS_INFO_CONTABILIDAD.GIC_FECHA_CONTABILIZACION) con el dato de Fecha de Contabilización si llega informado.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := FECHA_CONTABILIZACION_DATE;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
            SET GIC_FECHA_CONTABILIZACION = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GIC_ID = '||V_GIC_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha informado el campo GIC_FECHA_CONTABILIZACION para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Avanzamos un paso
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                PARAM2 := 'GIC_ID';
                PARAM3 := 'GIC_FECHA_CONTABILIZACION';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, V_FEC_CONTABILIZACION, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido informar el campo GIC_FECHA_CONTABILIZACION para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
            
            ------------------------------------------------------------
            -----MODIFICACIONES NUEVAS -- REMVIP-1698
            ------------------------------------------------------------       
            EXECUTE IMMEDIATE 'SELECT DD_DEG_ID_CONTABILIZA FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD WHERE GIC_ID = '||V_GIC_ID INTO DD_DEG_ID_CONTABILIZA;
            EXECUTE IMMEDIATE 'SELECT DD_DEG_ID FROM '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO WHERE DD_DEG_CODIGO = ''03'' ' INTO DD_DEG_ID;
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
            SET DD_DEG_ID_CONTABILIZA = '||DD_DEG_ID||',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GIC_ID = '||V_GIC_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL; 
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha informado el campo DD_DEG_ID_CONTABILIZA para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                PARAM2 := 'GIC_ID';
                PARAM3 := 'DD_DEG_ID_CONTABILIZA';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, DD_DEG_ID_CONTABILIZA, DD_DEG_ID);
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido informar el campo DD_DEG_ID_CONTABILIZA para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
    
			EXECUTE IMMEDIATE 'SELECT GGE_ID FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION WHERE GPV_ID = '||V_GPV_ID||' AND ROWNUM = 1' INTO V_GGE_ID;
			EXECUTE IMMEDIATE 'SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION WHERE GPV_ID = '||V_GPV_ID||' AND ROWNUM = 1' INTO DD_EAP_ID_ANTERIOR;
            EXECUTE IMMEDIATE 'SELECT DD_EAP_ID FROM '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''07'' ' INTO DD_EAP_ID_NUEVO;
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION
            SET DD_EAP_ID = '||DD_EAP_ID_NUEVO||',
			GGE_FECHA_EAP = SYSDATE,
			USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
			FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID = '||V_GPV_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha informado el campo DD_EAP_ID para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GGE_GASTOS_GESTION';
                PARAM2 := 'GGE_ID';
                PARAM3 := 'DD_EAP_ID';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GGE_ID, PARAM3, DD_EAP_ID_ANTERIOR, DD_EAP_ID_NUEVO);
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido informar el campo DD_EAP_ID para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
            
        END IF;
        --------------
        -- PASO 4/7 -- OPCIONAL
        --------------
        IF COD_RETORNO = 0 AND FECHA_PAGO_DATE IS NOT NULL THEN
            --PASO 4/7 Actualizar la fecha de pago (GDE_GASTOS_DETALLE_ECONOMICO.GDE_FECHA_PAGO) con el dato de Fecha de Pago.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := FECHA_PAGO_DATE;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO
            SET GDE_FECHA_PAGO = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GDE_ID = '||V_GDE_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la fecha de pago a '||V_VALOR_NUEVO||'. Continuamos la ejecución.');
                --Avanzamos un paso
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GDE_GASTOS_DETALLE_ECONOMICO';
                PARAM2 := 'GDE_ID';
                PARAM3 := 'GDE_FECHA_PAGO';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GDE_ID, PARAM3, V_FECHA_PAGO, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';

            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la fecha de pago a '||V_VALOR_NUEVO||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 5/7 -- OPCIONAL
        --------------
        --Aparte de que no haya errores, comprobamos que esté informado el campo EJERCICIO, y que éste tiene formato YYYY.
        IF EJERCICIO IS NOT NULL AND COD_RETORNO = 0 THEN
            --Recuperamos el NUEVO valor
            --Comprobamos que existe el ejercicio con el parametro introducido.
            V_MSQL := '
            SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||EJERCICIO||'''
            ';
            EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;

            IF V_VALOR_NUEVO IS NOT NULL THEN
                --PASO 4/6 Actualizar el ejercicio (GIC_GASTOS_INFO_CONTABILIDAD.EJE_ID) con el dato de Ejercicio si llega informado.
                --Realizamos la actuación
                V_MSQL := '
                UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
                SET EJE_ID = '||V_VALOR_NUEVO||',
                USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
                FECHAMODIFICAR = SYSDATE
                WHERE GIC_ID = '||V_GIC_ID||'
                ';
                EXECUTE IMMEDIATE V_MSQL;
                --Comprobamos si se ha actualizado o no
                IF SQL%ROWCOUNT > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el ejercicio a '||EJERCICIO||'. Continuamos la ejecución.');
                    --Avanzamos un paso
                    V_PASOS := V_PASOS+1;
                    --Logado en HLD_HIST_LANZA_PER_DETA
                    PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                    PARAM2 := 'GIC_ID';
                    PARAM3 := 'EJE_ID';
                    HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, V_EJE_ID, V_VALOR_NUEVO);
                    --Reseteamos el V_VALOR_NUEVO
                    V_VALOR_NUEVO := '';

                ELSE
                    COD_RETORNO := 1;
                    V_ERROR_DESC := '[ERROR] No se ha podido actualizar el ejercicio a '||EJERCICIO||'. Paramos la ejecución.';
                END IF;
            ELSE
                --El ejercicio informado no existe
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] El ejercicio informado: '||EJERCICIO||', no existe. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 6/7 -- OPCIONAL
        --------------
        IF GIC_CUENTA_CONTABLE IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 5/6 Actualizar la cuenta contable (GIC_GASTOS_INFO_CONTABILIDAD.GIC_CUENTA_CONTABLE) con el dato de Cuenta Contable si llega informado.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := GIC_CUENTA_CONTABLE;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
            SET GIC_CUENTA_CONTABLE = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GIC_ID = '||V_GIC_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la cuenta contable a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                PARAM2 := 'GIC_ID';
                PARAM3 := 'GIC_CUENTA_CONTABLE';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, V_CUENTA_CONTABLE, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';

            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la cuenta contable a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 7/7 -- OPCIONAL
        --------------
        IF GIC_PTDA_PRESUPUESTARIA IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 6/6 Actualizar la partida presupuestaria (GIC_GASTOS_INFO_CONTABILIDAD.GIC_PTDA_PRESUPUESTARIA) con el dato de Partida Presupuestaria si llega informado.
            --Recuperamos el NUEVO valor
            /*V_VALOR_NUEVO := GIC_PTDA_PRESUPUESTARIA;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
            SET GIC_PTDA_PRESUPUESTARIA = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GIC_ID = '||V_GIC_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la partida presupuestaria a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GIC_GASTOS_INFO_CONTABILIDAD';
                PARAM2 := 'GIC_ID';
                PARAM3 := 'GIC_PTDA_PRESUPUESTARIA';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GIC_ID, PARAM3, V_PTDA_PRESUPESTARIA, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';

            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la partida presupuestaria a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
            */---> COMENTAMOS ESTE CÓDIGO POR LA MIGRACION DE LIBERBANK - 04-09-2018
            V_PASOS := V_PASOS+1;
        END IF;

        ----------------------
        -- FIN OPERATORIA 2 --
        ----------------------
        --Comprobamos que hemos dado todos los pasos de la operatoria.
        IF COD_RETORNO = 0 THEN
            CASE
                --Si hemos informado los 7/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GIC_CUENTA_CONTABLE IS NOT NULL AND GIC_PTDA_PRESUPUESTARIA IS NOT NULL
                THEN IF V_OP_2_PASOS != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 6/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GIC_CUENTA_CONTABLE IS NOT NULL AND GIC_PTDA_PRESUPUESTARIA IS NULL
                THEN IF (V_OP_2_PASOS-1) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 5/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GIC_CUENTA_CONTABLE IS NULL AND GIC_PTDA_PRESUPUESTARIA IS NULL
                THEN IF (V_OP_2_PASOS-2) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 4/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NULL AND GIC_CUENTA_CONTABLE IS NULL AND GIC_PTDA_PRESUPUESTARIA IS NULL
                THEN IF (V_OP_2_PASOS-3) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 3/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NULL) AND EJERCICIO IS NULL AND GIC_CUENTA_CONTABLE IS NULL AND GIC_PTDA_PRESUPUESTARIA IS NULL
                THEN IF (V_OP_2_PASOS-4) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
            ELSE
                COD_RETORNO := 0;
            END CASE;
        END IF;

    END IF;

DBMS_OUTPUT.PUT_LINE(' -----------------');
DBMS_OUTPUT.PUT_LINE('| COD_RETORNO = '||COD_RETORNO||' |');
DBMS_OUTPUT.PUT_LINE(' -----------------');

--Finalizamos en función del COD_RETORNO
IF COD_RETORNO = 1 THEN

    IF V_ERROR_DESC = '' THEN
        V_ERROR_DESC := 'POR ALGUNA RAZÓN NO SE HA ASIGNADO UNA DESCRIPCIÓN A ÉSTE ERROR. REVISAD!';
    END IF;

    DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);

    V_GPV_NUM_GASTO_HAYA := GPV_NUM_GASTO_HAYA;

    IF V_GPV_NUM_GASTO_HAYA IS NULL THEN
        V_GPV_NUM_GASTO_HAYA := '-1';
    END IF;

    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('[ERROR] Procedemos a informar la tabla HLP_HISTORICO_LANZA_PERIODICO.');
    HLP_HISTORICO_LANZA_PERIODICO (TO_CHAR(V_GPV_NUM_GASTO_HAYA), 1, V_ERROR_DESC);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Procedimiento SP_EXT_PR_ACT_GASTOS finalizado con errores.');

ELSE

    DBMS_OUTPUT.PUT_LINE('[INFO] Procedemos a informar la tabla HLP_HISTORICO_LANZA_PERIODICO.');
    HLP_HISTORICO_LANZA_PERIODICO (TO_CHAR(V_GPV_NUM_GASTO_HAYA), 0, V_PASOS);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Procedimiento SP_EXT_PR_ACT_GASTOS finalizado correctamente!');

END IF;

EXCEPTION
     WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE(SQLERRM);
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          COD_RETORNO := 1;          
          HLP_HISTORICO_LANZA_PERIODICO (TO_CHAR(V_GPV_NUM_GASTO_HAYA), 1, SQLERRM);
          COMMIT;
END SP_EXT_PR_ACT_GASTOS;
/
EXIT;
