--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.15.3-rem
--## INCIDENCIA_LINK=HREOS-11761
--## PRODUCTO=NO
--## Finalidad: Permitir la actualización de reservas y ventas vía la llegada de datos externos de Prinex. Una llamada por modificación. Liberbank.
--## Info: https://link-doc.pfsgroup.es/confluence/display/REOS/SP_EXT_PR_ACT_GASTOS
--##       Mantengamos la documentación al día. Si subimos de versión, reflejemoslo en el SP, en el comentario tras el BEGIN
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1  Versión inicial
--##        0.2  Control de errores en HLP_HISTORICO_LANZA_PERIODICO
--##        1.01 Se elimina la restricción para los gastos con iva. Ahora pueden actualizar la fecha de contabilización.
--##	    1.02 Se añaden modificaciones segun el item REMVIP-1698.
--##	    1.03 Se añaden modificaciones según el ítem REMVIP-2891.
--##	    1.04 Se añaden modificaciones según el ítem REMVIP-5417.
--##	    1.05 Se añaden modificaciones según el ítem HREOS-10666.
--##        1.06 Se añaden modificaciones según el ítem HREOS-11761.
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
    GLD_CCC_VALOR               IN VARCHAR2,
    GLD_CPP_VALOR               IN VARCHAR2,
    DD_STG_CODIGO				IN VARCHAR2,
    DD_TIT_CODIGO				IN VARCHAR2,
    GLD_IMP_IND_TIPO_IMPOSITIVO IN VARCHAR2,
    DD_TIM_CODIGO				IN VARCHAR2,
    PRO_CODIGO_ENTIDAD          IN VARCHAR2,
    GPV_REF_EMISOR              IN VARCHAR2,
    PVE_COD_ORIGEN              IN VARCHAR2,

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
    V_GLD_ID                        NUMBER(16) := -1;
    V_GGE_ID                        NUMBER(16) := -1;
    V_EJE_ID                        NUMBER(16) := -1;
    V_FEC_CONTABILIZACION           VARCHAR2(10 CHAR) := '';
    V_FECHA_PAGO                    VARCHAR2(10 CHAR) := '';
    V_CUENTA_CONTABLE               VARCHAR2(50 CHAR) := '';
    V_COL_CUENTA_CONTABLE           VARCHAR2(50 CHAR) := '';
    V_PTDA_PRESUPESTARIA            VARCHAR2(50 CHAR) := '';
    V_COL_PTDA_PRESUPESTARIA        VARCHAR2(50 CHAR) := '';
    V_GPV_NUM_GASTO_HAYA            VARCHAR2(16 CHAR);
    V_DD_STG_CODIGO                 VARCHAR2(20 CHAR);
    V_DD_TIT_CODIGO                 VARCHAR2(20 CHAR);
    V_DD_TIM_CODIGO                 VARCHAR2(20 CHAR);
    V_GLD_IMP_IND_TIPO_IMPOSITIVO   VARCHAR2(4 CHAR);
    DD_DEG_ID                       NUMBER(16) := -1;
    DD_DEG_ID_CONTABILIZA           NUMBER(16) := -1;
    DD_EAP_ID_ANTERIOR              NUMBER(16) := -1;
    DD_EAP_ID_NUEVO                 NUMBER(16) := -1;
    DD_EAH_ID_ANTERIOR              NUMBER(16) := -1;
    DD_EAH_ID_NUEVO                 NUMBER(16) := -1;
    V_GASTO_BBVA                    NUMBER(1)  := 0;
    V_GPV_NUMERO_FACTURA            VARCHAR2(256);
    V_CC_PP                         NUMBER(1)  := 0;

    --Info
    V_OP_1_DESC                     VARCHAR2(400 CHAR) := '[OPERATORIA] Para todos los registros con FECHA DE CONTABILIZACION relacionado con un gasto cuyo estado no sea "Rechazado administración","Contabilizado","Pagado" "Rechazado propietario" o "Anulado".';
    V_OP_2_DESC                     VARCHAR2(400 CHAR) := '[OPERATORIA] Para todos los registros con FECHA DE PAGO relacionado con un gasto cuyo estado no sea "Rechazado administración","Pagado" "Rechazado propietario" o "Anulado".';

    --Queries
    V_MSQL                          VARCHAR2(4000 CHAR);

    V_COUNT                         VARCHAR2(30 CHAR)   := 'SELECT COUNT(1) ';

    V_SELECT_GASTO                  VARCHAR2(2000 CHAR)  := 'SELECT
                                                            GPV.GPV_ID,
                                                            GLD.DD_TIT_ID,
                                                            EGA.DD_EGA_CODIGO,
                                                            EGA.DD_EGA_ID,
                                                            GPV.GPV_NUMERO_FACTURA_UVEM,
                                                            GIC.GIC_FECHA_CONTABILIZACION,
                                                            GIC.EJE_ID,
                                                            CASE WHEN ''BAS'' = TIM_CODIGO OR TIM_CODIGO IS NULL THEN GLD.GLD_CCC_BASE
                                                                WHEN ''TAS'' = TIM_CODIGO THEN GLD.GLD_CCC_TASAS
                                                                WHEN ''REC'' = TIM_CODIGO THEN GLD.GLD_CCC_RECARGO
                                                                WHEN ''INT'' = TIM_CODIGO THEN GLD.GLD_CCC_INTERESES
                                                            END GLD_CCC_VALOR,
                                                            CASE WHEN ''BAS'' = TIM_CODIGO OR TIM_CODIGO IS NULL THEN GLD.GLD_CPP_BASE
                                                                WHEN ''TAS'' = TIM_CODIGO THEN GLD.GLD_CPP_TASAS
                                                                WHEN ''REC'' = TIM_CODIGO THEN GLD.GLD_CPP_RECARGO
                                                                WHEN ''INT'' = TIM_CODIGO THEN GLD.GLD_CPP_INTERESES
                                                            END GLD_CPP_VALOR,
                                                            GDE.GDE_FECHA_PAGO,
                                                            GIC.GIC_ID,
                                                            GDE.GDE_ID,
                                                            GLD.GLD_ID ';

    V_FROM_GASTO                    VARCHAR2(2000 CHAR) := 'FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                                                            LEFT JOIN REM01.GLD_GASTOS_LINEA_DETALLE GLD
                                                                ON GLD.GPV_ID = GPV.GPV_ID
                                                            LEFT JOIN REM01.GDE_GASTOS_DETALLE_ECONOMICO GDE
                                                                ON GDE.GPV_ID = GPV.GPV_ID
                                                            LEFT JOIN REM01.GIC_GASTOS_INFO_CONTABILIDAD GIC
                                                                ON GIC.GPV_ID = GPV.GPV_ID
                                                            LEFT JOIN REM01.DD_EGA_ESTADOS_GASTO EGA
                                                                ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                                                            WHERE GPV.GPV_NUM_GASTO_HAYA = :1
                                                                AND GLD.BORRADO = 0';

    V_DD_STG_FROM                   VARCHAR2(2000 CHAR) := ' AND GLD.DD_STG_ID = (SELECT DD_STG_ID FROM REM01.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = :2)';

    V_DD_TIT_FROM                   VARCHAR2(2000 CHAR) := ' AND GLD.DD_TIT_ID = (SELECT DD_TIT_ID FROM REM01.DD_TIT_TIPOS_IMPUESTO WHERE DD_TIT_CODIGO = :3)';

    V_DD_IMP_FROM                   VARCHAR2(2000 CHAR) := ' AND GLD.GLD_IMP_IND_TIPO_IMPOSITIVO = :4';

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
    DBMS_OUTPUT.PUT_LINE('GLD_CCC_VALOR: '||GLD_CCC_VALOR);
    DBMS_OUTPUT.PUT_LINE('GLD_CPP_VALOR: '||GLD_CPP_VALOR);
    DBMS_OUTPUT.PUT_LINE('DD_STG_CODIGO: '||DD_STG_CODIGO);
    DBMS_OUTPUT.PUT_LINE('DD_TIT_CODIGO: '||DD_TIT_CODIGO);
    DBMS_OUTPUT.PUT_LINE('GLD_IMP_IND_TIPO_IMPOSITIVO: '||GLD_IMP_IND_TIPO_IMPOSITIVO);
    DBMS_OUTPUT.PUT_LINE('DD_TIM_CODIGO: '||DD_TIM_CODIGO);
    DBMS_OUTPUT.PUT_LINE('PRO_CODIGO_ENTIDAD: '||PRO_CODIGO_ENTIDAD);
    DBMS_OUTPUT.PUT_LINE('GPV_REF_EMISOR: '||GPV_REF_EMISOR);
    DBMS_OUTPUT.PUT_LINE('PVE_COD_ORIGEN: '||PVE_COD_ORIGEN);

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
    IF GPV_NUM_GASTO_HAYA IS NULL THEN

        V_MSQL := 'SELECT COUNT(1)
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                AND PRO.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR
                AND PVE.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND GPV.GPV_REF_EMISOR = '''||GPV_REF_EMISOR||'''
                AND PRO.PRO_CODIGO_ENTIDAD = '''||PRO_CODIGO_ENTIDAD||'''
                AND PVE.PVE_COD_ORIGEN = '''||PVE_COD_ORIGEN||'''';

        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

        IF V_NUM = 1 THEN

            V_MSQL := 'SELECT GPV_NUM_GASTO_HAYA
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                AND PRO.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = GPV.PVE_ID_EMISOR
                AND PVE.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND GPV.GPV_REF_EMISOR = '''||GPV_REF_EMISOR||'''
                AND PRO.PRO_CODIGO_ENTIDAD = '''||PRO_CODIGO_ENTIDAD||'''
                AND PVE.PVE_COD_ORIGEN = '''||PVE_COD_ORIGEN||'''';

            EXECUTE IMMEDIATE V_MSQL INTO V_GPV_NUM_GASTO_HAYA;

            V_MSQL := 'SELECT COUNT(1)
                FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                    AND PRO.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                    AND CRA.BORRADO = 0
                WHERE GPV.BORRADO = 0
                    AND CRA.DD_CRA_CODIGO = ''16''
                    AND GPV.GPV_NUM_GASTO_HAYA = '''||V_GPV_NUM_GASTO_HAYA||'''';

            EXECUTE IMMEDIATE V_MSQL INTO V_GASTO_BBVA;
            
        ELSE
        
            DBMS_OUTPUT.PUT_LINE('QUERY: '||V_MSQL);
            
        END IF;

    END IF;

    IF GLD_CCC_VALOR IS NOT NULL OR GLD_CPP_VALOR IS NOT NULL THEN

        V_CC_PP := 1;

        IF DD_STG_CODIGO IS NULL THEN

            V_ERROR_DESC := '[ERROR] No se ha informado DD_STG_CODIGO o no se encuentra. Por favor, informe éste parámetro. Paramos la ejecución.';
            COD_RETORNO := 1;

        END IF;

    END IF;

    -------------------------------------------------------
    --Aquí comenzamos directamente con el CASE, ya que al ser el inicio, está claro que COD_RETORNO = 0.
    CASE
        --1. NO SE INSERTA O ENCUENTRA GPV_NUM_GASTO_HAYA
        WHEN GPV_NUM_GASTO_HAYA IS NULL AND V_GPV_NUM_GASTO_HAYA IS NULL
            THEN V_ERROR_DESC := '[ERROR] No se ha informado GPV_NUM_GASTO_HAYA o no se encuentra. Por favor, informe éste parámetro. Paramos la ejecución.';
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

        IF V_GPV_NUM_GASTO_HAYA IS NULL THEN

            V_GPV_NUM_GASTO_HAYA            := GPV_NUM_GASTO_HAYA;

        END IF;

        V_DD_STG_CODIGO                 := DD_STG_CODIGO;
        V_DD_TIT_CODIGO                 := DD_TIT_CODIGO;
        V_GLD_IMP_IND_TIPO_IMPOSITIVO   := GLD_IMP_IND_TIPO_IMPOSITIVO;

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
        DBMS_OUTPUT.PUT_LINE('V_DD_STG_CODIGO: '||V_DD_STG_CODIGO);
        DBMS_OUTPUT.PUT_LINE('V_DD_TIT_CODIGO: '||V_DD_TIT_CODIGO);
        DBMS_OUTPUT.PUT_LINE('V_GLD_IMP_IND_TIPO_IMPOSITIVO: '||V_GLD_IMP_IND_TIPO_IMPOSITIVO);
        
        IF V_DD_STG_CODIGO IS NULL THEN
        
            V_MSQL := V_COUNT||V_FROM_GASTO;
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM USING V_GPV_NUM_GASTO_HAYA;
            
        ELSIF V_DD_STG_CODIGO IS NOT NULL AND V_DD_TIT_CODIGO IS NULL AND V_GLD_IMP_IND_TIPO_IMPOSITIVO IS NULL THEN
        
            V_MSQL := V_COUNT||V_FROM_GASTO||V_DD_STG_FROM;
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM USING V_GPV_NUM_GASTO_HAYA, V_DD_STG_CODIGO;
            
        ELSIF V_DD_STG_CODIGO IS NOT NULL AND V_DD_TIT_CODIGO IS NOT NULL AND V_GLD_IMP_IND_TIPO_IMPOSITIVO IS NULL THEN
        
            V_MSQL := V_COUNT||V_FROM_GASTO||V_DD_STG_FROM||V_DD_TIT_FROM;
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM USING V_GPV_NUM_GASTO_HAYA, V_DD_STG_CODIGO, V_DD_TIT_CODIGO;

        ELSIF V_DD_STG_CODIGO IS NOT NULL AND V_DD_TIT_CODIGO IS NULL AND V_GLD_IMP_IND_TIPO_IMPOSITIVO IS NOT NULL THEN
        
            V_MSQL := V_COUNT||V_FROM_GASTO||V_DD_STG_FROM||V_DD_IMP_FROM;
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM USING V_GPV_NUM_GASTO_HAYA, V_DD_STG_CODIGO, V_GLD_IMP_IND_TIPO_IMPOSITIVO;

        ELSIF V_DD_STG_CODIGO IS NOT NULL AND V_DD_TIT_CODIGO IS NOT NULL AND V_GLD_IMP_IND_TIPO_IMPOSITIVO IS NOT NULL THEN
        
            V_MSQL := V_COUNT||V_FROM_GASTO||V_DD_STG_FROM||V_DD_TIT_FROM||V_DD_IMP_FROM;
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM USING V_GPV_NUM_GASTO_HAYA, V_DD_STG_CODIGO, V_DD_TIT_CODIGO, V_GLD_IMP_IND_TIPO_IMPOSITIVO;

        END IF;

        IF DD_TIM_CODIGO = 'BAS' OR DD_TIM_CODIGO IS NULL THEN
            V_COL_CUENTA_CONTABLE := 'GLD_CCC_BASE';
            V_COL_PTDA_PRESUPESTARIA := 'GLD_CPP_BASE';
        ELSIF DD_TIM_CODIGO = 'TAS' THEN
            V_COL_CUENTA_CONTABLE := 'GLD_CCC_TASAS';
            V_COL_PTDA_PRESUPESTARIA := 'GLD_CPP_TASAS';
        ELSIF DD_TIM_CODIGO = 'REC' THEN
            V_COL_CUENTA_CONTABLE := 'GLD_CCC_RECARGO';
            V_COL_PTDA_PRESUPESTARIA := 'GLD_CPP_RECARGO';
        ELSIF DD_TIM_CODIGO = 'INT' THEN
            V_COL_CUENTA_CONTABLE := 'GLD_CCC_INTERESES';
            V_COL_PTDA_PRESUPESTARIA := 'GLD_CPP_INTERESES';
        END IF;

        IF V_NUM > 0 AND V_DD_STG_CODIGO IS NULL THEN
            V_MSQL := REPLACE(V_SELECT_GASTO, 'TIM_CODIGO', ''''||DD_TIM_CODIGO||'''')||V_FROM_GASTO;
            EXECUTE IMMEDIATE V_MSQL
            INTO V_GPV_ID, V_TIT_ID, V_EGA_CODIGO, V_EGA_ID, V_NUM_FACTUR_UVEM, V_FEC_CONTABILIZACION, V_EJE_ID, V_CUENTA_CONTABLE, V_PTDA_PRESUPESTARIA, V_FECHA_PAGO, V_GIC_ID, V_GDE_ID, V_GLD_ID
            USING V_GPV_NUM_GASTO_HAYA;
        ELSIF V_NUM > 0 AND V_DD_STG_CODIGO IS NOT NULL AND V_DD_TIT_CODIGO IS NULL AND V_GLD_IMP_IND_TIPO_IMPOSITIVO IS NULL THEN
            V_MSQL := REPLACE(V_SELECT_GASTO, 'TIM_CODIGO', ''''||DD_TIM_CODIGO||'''')||V_FROM_GASTO||V_DD_STG_FROM;
            EXECUTE IMMEDIATE V_MSQL
            INTO V_GPV_ID, V_TIT_ID, V_EGA_CODIGO, V_EGA_ID, V_NUM_FACTUR_UVEM, V_FEC_CONTABILIZACION, V_EJE_ID, V_CUENTA_CONTABLE, V_PTDA_PRESUPESTARIA, V_FECHA_PAGO, V_GIC_ID, V_GDE_ID, V_GLD_ID
            USING V_GPV_NUM_GASTO_HAYA;
        ELSIF V_NUM > 0 AND V_DD_STG_CODIGO IS NOT NULL AND V_DD_TIT_CODIGO IS NOT NULL AND V_GLD_IMP_IND_TIPO_IMPOSITIVO IS NULL THEN
            V_MSQL := REPLACE(V_SELECT_GASTO, 'TIM_CODIGO', ''''||DD_TIM_CODIGO||'''')||V_FROM_GASTO||V_DD_STG_FROM||V_DD_TIT_FROM;
            EXECUTE IMMEDIATE V_MSQL
            INTO V_GPV_ID, V_TIT_ID, V_EGA_CODIGO, V_EGA_ID, V_NUM_FACTUR_UVEM, V_FEC_CONTABILIZACION, V_EJE_ID, V_CUENTA_CONTABLE, V_PTDA_PRESUPESTARIA, V_FECHA_PAGO, V_GIC_ID, V_GDE_ID, V_GLD_ID
            USING V_GPV_NUM_GASTO_HAYA, V_DD_STG_CODIGO, V_DD_TIT_CODIGO;
        ELSIF V_NUM > 0 AND V_DD_STG_CODIGO IS NOT NULL AND V_DD_TIT_CODIGO IS NULL AND V_GLD_IMP_IND_TIPO_IMPOSITIVO IS NOT NULL THEN
            V_MSQL := REPLACE(V_SELECT_GASTO, 'TIM_CODIGO', ''''||DD_TIM_CODIGO||'''')||V_FROM_GASTO||V_DD_STG_FROM||V_DD_IMP_FROM;
            EXECUTE IMMEDIATE V_MSQL
            INTO V_GPV_ID, V_TIT_ID, V_EGA_CODIGO, V_EGA_ID, V_NUM_FACTUR_UVEM, V_FEC_CONTABILIZACION, V_EJE_ID, V_CUENTA_CONTABLE, V_PTDA_PRESUPESTARIA, V_FECHA_PAGO, V_GIC_ID, V_GDE_ID, V_GLD_ID
            USING V_GPV_NUM_GASTO_HAYA, V_DD_STG_CODIGO, V_GLD_IMP_IND_TIPO_IMPOSITIVO;
        ELSIF V_NUM > 0 AND V_DD_STG_CODIGO IS NOT NULL AND V_DD_TIT_CODIGO IS NOT NULL AND V_GLD_IMP_IND_TIPO_IMPOSITIVO IS NOT NULL THEN
            V_MSQL := REPLACE(V_SELECT_GASTO, 'TIM_CODIGO', ''''||DD_TIM_CODIGO||'''')||V_FROM_GASTO||V_DD_STG_FROM||V_DD_TIT_FROM||V_DD_IMP_FROM;
            EXECUTE IMMEDIATE V_MSQL
            INTO V_GPV_ID, V_TIT_ID, V_EGA_CODIGO, V_EGA_ID, V_NUM_FACTUR_UVEM, V_FEC_CONTABILIZACION, V_EJE_ID, V_CUENTA_CONTABLE, V_PTDA_PRESUPESTARIA, V_FECHA_PAGO, V_GIC_ID, V_GDE_ID, V_GLD_ID
            USING V_GPV_NUM_GASTO_HAYA, V_DD_STG_CODIGO, V_DD_TIT_CODIGO, V_GLD_IMP_IND_TIPO_IMPOSITIVO;
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
            --¿El estado del gasto es "Contabilizado" ó "Pagado"?
            IF V_EGA_CODIGO IN ('04','05') THEN
                --KO
                COD_RETORNO := 1;
                V_ERROR_DESC := '[INFO] El gasto '||V_GPV_NUM_GASTO_HAYA||' tiene un estado "Contabilizado" ó "Pagado". Paramos la ejecución.';
            ELSE
                --OK
                DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||V_GPV_NUM_GASTO_HAYA||' NO TIENE un estado "Contabilizado" ó "Pagado". Continuamos la ejecución.');
            END IF;

        --Si hemos llegado hasta aquí, ejecutamos la operatoria 1.
        --------------
        -- PASO 1/7 --
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
        -- PASO 2/7 --
        --------------
        IF COD_RETORNO = 0 AND NUM_GASTO_DESTINATARIO IS NOT NULL THEN
            --PASO 2/6 Actualizar la referencia de la factura (GPV_GASTOS_PROVEEDOR.GPV_NUMERO_FACTURA_UVEM) con el número de gasto del destinatario.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := NUM_GASTO_DESTINATARIO;
            --Realizamos actuación
            IF V_GASTO_BBVA = 1 THEN
                V_GPV_NUMERO_FACTURA := 'NUM_GASTO_DESTINATARIO';
            ELSE
                V_GPV_NUMERO_FACTURA := 'GPV_NUMERO_FACTURA_UVEM';
            END IF;

            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
            SET '||V_GPV_NUMERO_FACTURA||' = '''||V_VALOR_NUEVO||''',
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
                PARAM3 := V_GPV_NUMERO_FACTURA;
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GPV_ID, PARAM3, V_NUM_FACTUR_UVEM, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la referencia de la factura para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||' a '||V_VALOR_NUEVO||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 3/7 --
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

            --Comprobamos si el gasto pertenece a la cartera Liberbank. REMVIP-5417
            EXECUTE IMMEDIATE 'SELECT COUNT(*)
                FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC.GPV_ID
                JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                WHERE GIC.GIC_ID = '||V_GIC_ID||'
                AND CRA.DD_CRA_CODIGO = ''08''' INTO V_NUM;

            IF V_NUM = 1 THEN
                V_MSQL := '
                UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
                SET DD_DEG_ID_CONTABILIZA = '||DD_DEG_ID||',
                USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
                FECHAMODIFICAR = SYSDATE
                WHERE GIC_ID = '||V_GIC_ID||'
                ';
                EXECUTE IMMEDIATE V_MSQL;           
            END IF;         

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
        -- PASO 4/7 -- 
        --------------
        EXECUTE IMMEDIATE 'SELECT GGE_ID FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION WHERE GPV_ID = '||V_GPV_ID||' AND ROWNUM = 1' INTO V_GGE_ID;
        EXECUTE IMMEDIATE 'SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION WHERE GPV_ID = '||V_GPV_ID||' AND ROWNUM = 1' INTO DD_EAH_ID_ANTERIOR;
            EXECUTE IMMEDIATE 'SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03'' ' INTO DD_EAH_ID_NUEVO;
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION
            SET DD_EAH_ID = '||DD_EAH_ID_NUEVO||',
            GGE_FECHA_EAH = SYSDATE,
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID = '||V_GPV_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha informado el campo DD_EAH_ID para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GGE_GASTOS_GESTION';
                PARAM2 := 'GGE_ID';
                PARAM3 := 'DD_EAH_ID';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GGE_ID, PARAM3, DD_EAH_ID_ANTERIOR, DD_EAH_ID_NUEVO);
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido informar el campo DD_EAH_ID para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
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
        IF GLD_CCC_VALOR IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 5/6 Actualizar la cuenta contable (GLD_GASTOS_LINEA_DETALLE.GLD_CCC_*) con el dato de Cuenta Contable si llega informado.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := GLD_CCC_VALOR;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE
            SET '||V_COL_CUENTA_CONTABLE||' = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GLD_ID = '||V_GLD_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la cuenta contable a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GLD_GASTOS_LINEA_DETALLE';
                PARAM2 := 'GLD_ID';
                PARAM3 := ''||V_COL_CUENTA_CONTABLE||'';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GLD_ID, PARAM3, V_CUENTA_CONTABLE, V_VALOR_NUEVO);
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
        IF GLD_CPP_VALOR IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 6/6 Actualizar la partida presupuestaria (GLD_GASTOS_LINEA_DETALLE.GLD_CPP_*) con el dato de Partida Presupuestaria si llega informado.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := GLD_CPP_VALOR;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE
            SET '||V_COL_PTDA_PRESUPESTARIA||' = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GLD_ID = '||V_GLD_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la partida presupuestaria a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GLD_GASTOS_LINEA_DETALLE';
                PARAM2 := 'GLD_ID';
                PARAM3 := ''||V_COL_PTDA_PRESUPESTARIA||'';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GLD_ID, PARAM3, V_PTDA_PRESUPESTARIA, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';

            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la partida presupuestaria a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
        END IF;

        DBMS_OUTPUT.PUT_LINE('[INFO] Pasos ejecutados: '||V_PASOS||'.');
        ----------------------
        -- FIN OPERATORIA 1 --
        ----------------------
        --Comprobamos que hemos dado todos los pasos de la operatoria.
        IF COD_RETORNO = 0 THEN
            CASE
                --Si hemos informado los 6/7 parámetros (Nunca pueden ser 7 ya que informamos FECHA_PAGO o FECHA_CONTABILIZACION).
                WHEN V_GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL OR FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GLD_CCC_VALOR IS NOT NULL AND GLD_CPP_VALOR IS NOT NULL
                THEN IF V_OP_1_PASOS != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 5/7 parámetros.
                WHEN V_GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL OR FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GLD_CCC_VALOR IS NOT NULL AND GLD_CPP_VALOR IS NULL
                THEN IF (V_OP_1_PASOS-1) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 4/7 parámetros.
                WHEN V_GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL OR FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GLD_CCC_VALOR IS NULL AND GLD_CPP_VALOR IS NULL
                THEN IF (V_OP_1_PASOS-2) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 3/7 parámetros.
                WHEN V_GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL OR FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NULL AND GLD_CCC_VALOR IS NULL AND GLD_CPP_VALOR IS NULL
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
    IF ((V_GPV_ID IS NOT NULL AND FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) OR (V_GPV_ID IS NOT NULL AND V_EGA_CODIGO IN ('04') AND FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NULL)) AND COD_RETORNO = 0 /*AND V_PASOS = 0*/ THEN

        --Mostramos la descripción de la operatoria en ejecución
        DBMS_OUTPUT.PUT_LINE(V_OP_2_DESC);
        DBMS_OUTPUT.PUT_LINE('V_EGA_CODIGO: '||V_EGA_CODIGO);

        -----------------
        -- PASO PREVIO --
        -----------------
        --¿El estado es "Rechazado administración","Pagado" "Rechazado propietario" o "Anulado"?
        IF V_EGA_CODIGO IN ('05') THEN
            --KO
            COD_RETORNO := 1;
            V_ERROR_DESC := '[INFO] El gasto '||V_GPV_NUM_GASTO_HAYA||' tiene un estado "Pagado". Paramos la ejecución.';
        ELSE
            --OK
            DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||V_GPV_NUM_GASTO_HAYA||' NO TIENE un estado "Pagado". Continuamos la ejecución.');
        END IF;

        --Si hemos llegado hasta aquí, ejecutamos la operatoria 1.
        --------------
        -- PASO 1/8 --
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
        -- PASO 2/8 --
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
        -- PASO 3/8 -- OPCIONAL
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

            --Comprobamos si el gasto pertenece a la cartera Liberbank. REMVIP-5417
            EXECUTE IMMEDIATE 'SELECT COUNT(*)
                FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC.GPV_ID
                JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                WHERE GIC.GIC_ID = '||V_GIC_ID||'
                AND CRA.DD_CRA_CODIGO = ''08''' INTO V_NUM;

            IF V_NUM = 1 THEN
                V_MSQL := '
                UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
                SET DD_DEG_ID_CONTABILIZA = '||DD_DEG_ID||',
                USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
                FECHAMODIFICAR = SYSDATE
                WHERE GIC_ID = '||V_GIC_ID||'
                ';
                EXECUTE IMMEDIATE V_MSQL; 
            END IF;           

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
        -- PASO 4/8 -- 
        --------------

        EXECUTE IMMEDIATE 'SELECT GGE_ID FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION WHERE GPV_ID = '||V_GPV_ID||' AND ROWNUM = 1' INTO V_GGE_ID;
        EXECUTE IMMEDIATE 'SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION WHERE GPV_ID = '||V_GPV_ID||' AND ROWNUM = 1' INTO DD_EAH_ID_ANTERIOR;
            EXECUTE IMMEDIATE 'SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03'' ' INTO DD_EAH_ID_NUEVO;
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION
            SET DD_EAH_ID = '||DD_EAH_ID_NUEVO||',
            GGE_FECHA_EAH = SYSDATE,
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID = '||V_GPV_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha informado el campo DD_EAH_ID para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GGE_GASTOS_GESTION';
                PARAM2 := 'GGE_ID';
                PARAM3 := 'DD_EAH_ID';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GGE_ID, PARAM3, DD_EAH_ID_ANTERIOR, DD_EAH_ID_NUEVO);
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido informar el campo DD_EAH_ID para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;

        --------------
        -- PASO 5/8 -- OPCIONAL
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
        -- PASO 6/8 -- OPCIONAL
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
        -- PASO 7/8 -- OPCIONAL
        --------------
        IF GLD_CCC_VALOR IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 5/6 Actualizar la cuenta contable (GLD_GASTOS_LINEA_DETALLE.GLD_CCC_*) con el dato de Cuenta Contable si llega informado.
            --Recuperamos el NUEVO valor
            V_VALOR_NUEVO := GLD_CCC_VALOR;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE
            SET '||V_COL_CUENTA_CONTABLE||' = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GLD_ID = '||V_GLD_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la cuenta contable a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GLD_GASTOS_LINEA_DETALLE';
                PARAM2 := 'GLD_ID';
                PARAM3 := ''||V_COL_CUENTA_CONTABLE||'';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GLD_ID, PARAM3, V_CUENTA_CONTABLE, V_VALOR_NUEVO);
                --Reseteamos el V_VALOR_NUEVO
                V_VALOR_NUEVO := '';

            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] No se ha podido actualizar la cuenta contable a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Paramos la ejecución.';
            END IF;
        END IF;
        --------------
        -- PASO 8/8 -- OPCIONAL
        --------------
        IF GLD_CPP_VALOR IS NOT NULL AND COD_RETORNO = 0 THEN
            --PASO 6/6 Actualizar la partida presupuestaria (GLD_GASTOS_LINEA_DETALLE.GLD_CPP_*) con el dato de Partida Presupuestaria si llega informado.
            --Recuperamos el NUEVO valor
            /*V_VALOR_NUEVO := GLD_CPP_VALOR;
            --Realizamos la actuación
            V_MSQL := '
            UPDATE '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE
            SET '||V_COL_PTDA_PRESUPESTARIA||' = '''||V_VALOR_NUEVO||''',
            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_GASTOS'',
            FECHAMODIFICAR = SYSDATE
            WHERE GLD_ID = '||V_GLD_ID||'
            ';
            EXECUTE IMMEDIATE V_MSQL;
            --Comprobamos si se ha actualizado o no
            IF SQL%ROWCOUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la partida presupuestaria a '||V_VALOR_NUEVO||' para el NÚMERO DE GASTO '||V_GPV_NUM_GASTO_HAYA||'. Continuamos la ejecución.');
                V_PASOS := V_PASOS+1;
                --Logado en HLD_HIST_LANZA_PER_DETA
                PARAM1 := 'GLD_GASTOS_LINEA_DETALLE';
                PARAM2 := 'GLD_ID';
                PARAM3 := ''||V_COL_PTDA_PRESUPESTARIA||'';
                HLD_HIST_LANZA_PER_DETA (TO_CHAR(V_GPV_NUM_GASTO_HAYA), PARAM1, PARAM2, V_GLD_ID, PARAM3, V_PTDA_PRESUPESTARIA, V_VALOR_NUEVO);
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
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GLD_CCC_VALOR IS NOT NULL AND GLD_CPP_VALOR IS NOT NULL
                THEN IF V_OP_2_PASOS != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 6/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GLD_CCC_VALOR IS NOT NULL AND GLD_CPP_VALOR IS NULL
                THEN IF (V_OP_2_PASOS-1) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 5/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NOT NULL AND GLD_CCC_VALOR IS NULL AND GLD_CPP_VALOR IS NULL
                THEN IF (V_OP_2_PASOS-2) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 4/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NOT NULL) AND EJERCICIO IS NULL AND GLD_CCC_VALOR IS NULL AND GLD_CPP_VALOR IS NULL
                THEN IF (V_OP_2_PASOS-3) != V_PASOS THEN
                        COD_RETORNO := 1;
                        V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución.';
                     END IF;
                --Si informamos 3/7 parámetros.
                WHEN GPV_NUM_GASTO_HAYA IS NOT NULL AND NUM_GASTO_DESTINATARIO IS NOT NULL AND (FECHA_PAGO IS NOT NULL AND FECHA_CONTABILIZACION IS NULL) AND EJERCICIO IS NULL AND GLD_CCC_VALOR IS NULL AND GLD_CPP_VALOR IS NULL
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
          RAISE;
END SP_EXT_PR_ACT_GASTOS;
/
EXIT;
