--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=version-2.35.3-rem
--## INCIDENCIA_LINK=REMVIP-11465
--## PRODUCTO=NO
--## Finalidad: Permitir la actualización de reservas y ventas vía la llegada de datos externos de Prinex. Una llamada por modificación. Liberbank.
--## Info: https://link-doc.pfsgroup.es/confluence/display/REOS/SP_EXT_PR_ACT_RES_VENTA
--##       Mantengamos la documentación al día. Si subimos de versión, reflejemoslo en el SP.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Control de errores en HLP_HISTORICO_LANZA_PERIODICO
--##        0.3 (20180622) - Marco Munoz - Se soluciona log de error de la HLP para tener siempre el mismo formato.
--##        0.4 (20180724) - Pablo Meseguer - Se deja de utilizar el numero de reserva y se añade tratamiento para los expedientes economicos en "En devolucion"
--##        0.5 (20180920) - Marco Muñoz - Se ajusta el SP para actuar también sobre agrupaciones de activos en los pasos 2.1 y 2.2.
--##        1.02 (20180927) - Ivan Castelló - Añadir estado o en Pendiente de devolución.
--##		1.03 (20181001) - Marco Muñoz - Se añade la actualización de la fecha de devolucion de la reserva del Expediente en la segunda casuistica (FECHA_DEVOLUCION_RESERVA)
--##		1.04 (20190709) - Alejandro Valverde - Se añade comprobacion de la cartera Cerberus y la subcartera Apple para la obtencion de la fecha de firma de la tarea Obtención de contrato de reserva.
--##		1.04 (20190808) - Adrián Molina - Se añade al filtro de la cartera Liberbank, la cartera Cerberus
--##		1.05 (20190827) - Viorel Remus Ovidiu - Se desactiva la actualizacion del estado del expediente a 'RESERVADO'
--##		1.06 (20191007) - Viorel Remus Ovidiu - Se soluciona error de subcartera
--## 		1.07 (20191010) - Jin Li Hu - Se añade el código de la caretra Cajamar para todas la queries donde se filtra por cartera, y se ha modificado una query según la descripción del item - HREOS-7988
--##		1.08 (20191016) - Viorel Remus Ovidiu - Se añadie filtro de borrado en reservas
--##		1.09 (20191107) - Viorel Remus Ovidiu - Se mezclan los cambios de subcartera (1.07) con los filtros de borrado (1.08)
--##		1.08 (20191128) - Viorel Remus Ovidiu - Se añadie filtro de activos Apple para quitar fecha_vencimiento a la hora de devolver la reserva (PASO 3/8, operativa 2)
--##		1.11 (20200120) - Oscar Diestre - Quitada validación para Cajamar
--##		1.12 (2020311) - HREOS-9744 - Incidencia Ventas y Reservas Cajamar
--##		1.13 (2020312) - HREOS-9744 - Incidencia Ventas y Reservas Cajamar añadida condición estado reserva firmada
--##		1.14 (20200422) - REMVIP-7058 - Se añade subcartera 151 y 152 (Divarian para cartera Cerberus)
--##		1.15 (20220210) - Juan alfonso - REMVIP-11136 - Se añade subcartera 70 (Jaguar para cartera cerberus)
--##		1.16 (20220426) - IVAN REPISO - HREOS-17732 - Se añade filtro formalizacion cajamar para estado expediente
--##		1.17 (20220505) - Juan alfonso - REMVIP-11465 - Se añade join con expediente comercial a la hora de tramitar expedientes
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE       #ESQUEMA#.SP_EXT_PR_ACT_RES_VENTA (

    --Parametros de entrada
    NUM_OFERTA                 IN NUMBER,
    FECHA_COBRO_RESERVA         IN VARCHAR2,
    FECHA_DEVOLUCION_RESERVA    IN VARCHAR2,
    IDENTIFICACION_COBRO        IN NUMBER,
    FECHA_COBRO_VENTA           IN VARCHAR2,
    CARTERA                     IN VARCHAR2,

    --Variables de salida
    COD_RETORNO                 OUT VARCHAR2 -- 0 OK / 1 KO

) AS

    --Configuracion
    V_ESQUEMA                       VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER                VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';

    --IDs
    V_RES_ID                        NUMBER(16) := -1;
    V_ECO_ID                        NUMBER(16) := -1;
    V_ACT_ID                        NUMBER(16) := -1;
    V_OFR_ID                        NUMBER(16) := -1;
    V_ERE_ID                        NUMBER(16) := -1;
    V_NUM_RESERVA                   VARCHAR2(16 CHAR);
    V_ID_COBRO                      VARCHAR2(16 CHAR);
	
    --CODIGOS
    V_CARTERA						VARCHAR2(20 CHAR);
    V_SUBCARTERA					VARCHAR2(20 CHAR);
    
    --Info
    V_OP_1_DESC                     VARCHAR2(400 CHAR) := '[OPERATORIA] Para todos los registros con Fecha de Cobro de reserva informada cuyo expediente no esté en los estados ("Reservado", "Firmado","Vendido", "En Devolución", "Anulado").';
    V_OP_2_DESC                     VARCHAR2(400 CHAR) := '[OPERATORIA] Para todos los registros con Fecha de Devolución informada cuyo expediente esté en estado "Reservado".';
    V_OP_3_DESC                     VARCHAR2(400 CHAR) := '[OPERATORIA] Para todos los registros con Identificación de Cobro  y Fecha de Cobro informada cuyo expediente esté en estado distinto a "Anulado" o "Vendido".';

    --Queries
    V_MSQL                          VARCHAR2(4000 CHAR);

    V_COUNT                         VARCHAR2(30 CHAR)   := 'SELECT COUNT(1) ';

    V_OBTIENE_RESERVA               VARCHAR2(2000 CHAR)  := 'SELECT
                                                            CASE
							    WHEN DD_CRA_CODIGO = ''01'' THEN	
                                                            	CASE WHEN EEC.DD_EEC_CODIGO NOT IN (''02'',''08'',''16'') AND ERE.DD_ERE_CODIGO IN (''01'',''02'')
                                                            		THEN 0
                                                            		ELSE 1
								END
							    ELSE
                                                            	CASE WHEN EEC.DD_EEC_CODIGO NOT IN (''02'',''03'',''06'',''08'',''16'') AND ERE.DD_ERE_CODIGO IN (''01'')
                                                            		THEN 0
                                                            		ELSE 1
								END	
                                                            END AS COD,
                                                            RES.RES_ID,
                                                            ECO.ECO_ID,
                                                            ACT.ACT_ID,
                                                            OFR.OFR_ID,
                                                            ECO.DD_EEC_ID ';

    V_OBTIENE_RESERVA_2            VARCHAR2(1000 CHAR)  := 'SELECT
                                                            CASE
                                                              WHEN EEC.DD_EEC_CODIGO IS NULL THEN 1
                                                              WHEN EEC.DD_EEC_CODIGO IN (''06'',''16'',''17'') THEN 0
                                                            ELSE 1
                                                            END AS COD,
                                                            RES.RES_ID,
                                                            ECO.ECO_ID,
                                                            ACT.ACT_ID,
                                                            OFR.OFR_ID,
                                                            ECO.DD_EEC_ID ';

    V_FROM_RESERVA                VARCHAR2(2000 CHAR) := 'FROM REM01.RES_RESERVAS RES
                                                            INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                            ON ECO.ECO_ID = RES.ECO_ID
                                                            INNER JOIN REM01.OFR_OFERTAS OFR
                                                            ON OFR.OFR_ID = ECO.OFR_ID
                                                            INNER JOIN REM01.ACT_OFR OFA
                                                            ON OFA.OFR_ID = OFR.OFR_ID
                                                            INNER JOIN REM01.ACT_ACTIVO ACT
                                                            ON ACT.ACT_ID = OFA.ACT_ID
                                                            INNER JOIN REM01.DD_CRA_CARTERA CAR
                                                            ON CAR.DD_CRA_ID = ACT.DD_CRA_ID
							    INNER JOIN REM01.DD_SCR_SUBCARTERA SCR 
                                                            ON SCR.DD_SCR_ID = ACT.DD_SCR_ID 
                                                            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA ERE
                                                            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
                                                            WHERE (CAR.DD_CRA_CODIGO = ''08'' OR (CAR.DD_CRA_CODIGO = ''07'' AND SCR.DD_SCR_CODIGO IN (''138'',''151'',''152'',''70'')) OR CAR.DD_CRA_CODIGO = ''01'')/*Se anyaden subcarteras de Divarian REMVIP-7058*/
                                                            AND OFR.OFR_NUM_OFERTA = :1 
							    AND RES.BORRADO = 0';
                                                            
    V_FROM_RESERVA2                VARCHAR2(2000 CHAR) := 'FROM REM01.RES_RESERVAS RES
                                                            INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                            ON ECO.ECO_ID = RES.ECO_ID
                                                            INNER JOIN REM01.OFR_OFERTAS OFR
                                                            ON OFR.OFR_ID = ECO.OFR_ID
                                                            INNER JOIN REM01.ACT_OFR OFA
                                                            ON OFA.OFR_ID = OFR.OFR_ID
                                                            INNER JOIN REM01.ACT_ACTIVO ACT
                                                            ON ACT.ACT_ID = OFA.ACT_ID
                                                            INNER JOIN REM01.DD_CRA_CARTERA CAR
                                                            ON CAR.DD_CRA_ID = ACT.DD_CRA_ID 
							    INNER JOIN REM01.DD_SCR_SUBCARTERA SCR 
                                                            ON SCR.DD_SCR_ID = ACT.DD_SCR_ID 
                                                            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA ERE
                                                            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
                                                            WHERE (CAR.DD_CRA_CODIGO = ''08'' OR (CAR.DD_CRA_CODIGO = ''07'' AND SCR.DD_SCR_CODIGO IN (''138'',''151'',''152'',''70'')) OR CAR.DD_CRA_CODIGO = ''01'')/*Se anyaden subcarteras de Divarian REMVIP-7058*/
                                                            AND OFR.OFR_NUM_OFERTA = :1
                                                            AND ROWNUM = 1 
							    AND RES.BORRADO = 0';                                                        

    V_OBTIENE_COBRO               VARCHAR2(1000 CHAR) := 'SELECT
                                                            CASE
                                                              WHEN EEC.DD_EEC_CODIGO IS NULL THEN 1
                                                              WHEN EEC.DD_EEC_CODIGO IN (''02'',''08'') THEN 1
                                                            ELSE 0
                                                            END AS COD,
                                                            ECO.ECO_ID,
                                                            ACT.ACT_ID,
                                                            OFR.OFR_ID,
                                                            ECO.DD_EEC_ID ';
    CURSOR C_OBTIENE_COBRO IS SELECT
                                                            CASE
                                                              WHEN EEC.DD_EEC_CODIGO IS NULL THEN 1
                                                              WHEN EEC.DD_EEC_CODIGO IN ('02','08') THEN 1
                                                            ELSE 0
                                                            END AS COD,
                                                            ECO.ECO_ID,
                                                            ACT.ACT_ID,
                                                            OFR.OFR_ID,
                                                            ECO.DD_EEC_ID FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                            INNER JOIN REM01.OFR_OFERTAS OFR
                                                            ON OFR.OFR_ID = ECO.OFR_ID
                                                            INNER JOIN REM01.ACT_OFR OFA
                                                            ON OFA.OFR_ID = OFR.OFR_ID
                                                            INNER JOIN REM01.ACT_ACTIVO ACT
                                                            ON ACT.ACT_ID = OFA.ACT_ID
                                                            INNER JOIN REM01.DD_CRA_CARTERA CAR
                                                            ON CAR.DD_CRA_ID = ACT.DD_CRA_ID
                                                            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                            WHERE CAR.DD_CRA_CODIGO IN ('08', '07', '01') /*LIBERBANK, CERBERUS Y CAJAMAR*/
                                                            AND OFR.OFR_NUM_OFERTA =  ''||IDENTIFICACION_COBRO||'';
                                                            
    CURSOR ACTIVOS IS SELECT
                                                            ACT.ACT_ID
                                                            FROM REM01.RES_RESERVAS RES
                                                            INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                            ON ECO.ECO_ID = RES.ECO_ID
                                                            INNER JOIN REM01.OFR_OFERTAS OFR
                                                            ON OFR.OFR_ID = ECO.OFR_ID
                                                            INNER JOIN REM01.ACT_OFR OFA
                                                            ON OFA.OFR_ID = OFR.OFR_ID
                                                            INNER JOIN REM01.ACT_ACTIVO ACT
                                                            ON ACT.ACT_ID = OFA.ACT_ID
                                                            INNER JOIN REM01.DD_CRA_CARTERA CAR
                                                            ON CAR.DD_CRA_ID = ACT.DD_CRA_ID
                                                            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA ERE
                                                            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
                                                            WHERE CAR.DD_CRA_CODIGO IN ('08', '07', '01') /*LIBERBANK, CERBERUS Y CAJAMAR*/
                                                            AND OFR.OFR_NUM_OFERTA = ''||IDENTIFICACION_COBRO||'';

    V_FROM_COBRO                    VARCHAR2(2000 CHAR) := 'FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                            INNER JOIN REM01.OFR_OFERTAS OFR
                                                            ON OFR.OFR_ID = ECO.OFR_ID
                                                            INNER JOIN REM01.ACT_OFR OFA
                                                            ON OFA.OFR_ID = OFR.OFR_ID
                                                            INNER JOIN REM01.ACT_ACTIVO ACT
                                                            ON ACT.ACT_ID = OFA.ACT_ID
                                                            INNER JOIN REM01.DD_CRA_CARTERA CAR
                                                            ON CAR.DD_CRA_ID = ACT.DD_CRA_ID
                                                            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                            WHERE CAR.DD_CRA_CODIGO IN (''08'', ''07'', ''01'')
                                                            AND OFR.OFR_NUM_OFERTA = '||IDENTIFICACION_COBRO||'';

    V_LOGAR_HDL                     VARCHAR2(1400 CHAR) := 'HLD_HIST_LANZA_PER_DETA(''SP_EXT_PR_ACT_RES_VENTA'',:1,:2,:3,:4,:5,:6,:7)'; -- 1 HLD_SP_CARGA, 2 HLD_CODIGO_REG, 3 HLD_TABLA_MODIFICAR, 4 HLD_TABLA_MODIFICAR_CLAVE, 5 HLD_TABLA_MODIFICAR_CLAVE_ID, 6 HLD_CAMPO_MODIFICAR, 7 HLD_VALOR_ORIGINAL, 8 HLD_VALOR_ACTUALIZADO
    V_EXEC_ACT_SIT                  VARCHAR2(100 CHAR) := 'BEGIN SP_ASC_ACTUALIZA_SIT_COMERCIAL(:1,1); END;';

    --Utiles
    V_NUM                           NUMBER(16);
    V_NUM2                          NUMBER(16);
    V_OP_1_PASOS                    NUMBER(1) := 4;
    V_OP_2_PASOS                    NUMBER(1) := 8;
    V_OP_3_PASOS                    NUMBER(1) := 2;
    V_PASOS                         NUMBER(3) := 0;
    V_ERROR_DESC                    VARCHAR2(1000 CHAR) := '';
    FECHA_COBRO_RESERVA_DATE        DATE;
    FECHA_DEVOLUCION_RESERVA_DATE   DATE;
    FECHA_COBRO_VENTA_DATE          DATE;
    PARAM1                          VARCHAR2(50 CHAR);
    PARAM2                          VARCHAR2(50 CHAR);
    PARAM3                          VARCHAR2(50 CHAR);
    V_VALOR_ACTUAL                  VARCHAR2(50 CHAR);
    V_VALOR_NUEVO                   VARCHAR2(50 CHAR);
    V_CODIGO_TO_HLP                 VARCHAR2(50 CHAR);
    V_ACTIVO_APPLE 		    NUMBER(16);
    V_ACTIVO_CAJAMAR	NUMBER(16);
    V_FORMALIZACION_CAJAMAR	NUMBER(16);

    --Excepciones
    ERR_NEGOCIO EXCEPTION;

    --Procedure que inserta en HLD_HISTORICO_LANZA_PER_DETA, sin comitear.
    PROCEDURE HLD_HISTORICO_LANZA_PER_DETA (
      HLD_CODIGO_REG                  IN VARCHAR2,
      HLD_TABLA_MODIFICAR             IN VARCHAR2,
      HLD_TABLA_MODIFICAR_CLAVE       IN VARCHAR2,
      HLD_TABLA_MODIFICAR_CLAVE_ID    IN NUMBER,
      HLD_CAMPO_MODIFICAR             IN VARCHAR2,
      HLD_VALOR_ORIGINAL              IN VARCHAR2,
      HLD_VALOR_ACTUALIZADO           IN VARCHAR2
    ) IS

    BEGIN
--v1.14
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
        ''SP_EXT_PR_ACT_RES_VENTA'',
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
        ''SP_EXT_PR_ACT_RES_VENTA'',
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
--v1.14

    COD_RETORNO := 0;
    DBMS_OUTPUT.PUT_LINE('[INICIO] Permitir la actualización de reservas y ventas vía la llegada de datos externos de Prinex. Una llamada por modificación.');
    DBMS_OUTPUT.PUT_LINE('[INICIO] A continuación se mostrarán los parámetros de entrada:');
    DBMS_OUTPUT.PUT_LINE('NUM_RESERVA: '||NUM_OFERTA);
    DBMS_OUTPUT.PUT_LINE('IDENTIFICACION_COBRO: '||IDENTIFICACION_COBRO);
    DBMS_OUTPUT.PUT_LINE('FECHA_COBRO_RESERVA (Se espera yyyyMMdd): '||FECHA_COBRO_RESERVA);
    DBMS_OUTPUT.PUT_LINE('FECHA_DEVOLUCION_RESERVA (Se espera yyyyMMdd): '||FECHA_DEVOLUCION_RESERVA);
    DBMS_OUTPUT.PUT_LINE('FECHA_COBRO_VENTA (Se espera yyyyMMdd): '||FECHA_COBRO_VENTA);
    DBMS_OUTPUT.PUT_LINE('CARTERA: '||CARTERA);

    --Seteamos la descripción del error correspondiente a la imposibilidad de convertir el parametro de entrada a DATE.
    V_ERROR_DESC := '[ERROR] No se ha podido convertir la fecha a DATE, comprobar máscara. Paramos la ejecución.';
    COD_RETORNO := 1;
    IF FECHA_COBRO_RESERVA IS NOT NULL THEN
        FECHA_COBRO_RESERVA_DATE         := to_date(FECHA_COBRO_RESERVA,'yyyyMMdd');
    END IF;
    IF FECHA_DEVOLUCION_RESERVA IS NOT NULL THEN
        FECHA_DEVOLUCION_RESERVA_DATE    := to_date(FECHA_DEVOLUCION_RESERVA,'yyyyMMdd');
    END IF;
    IF FECHA_COBRO_VENTA IS NOT NULL THEN
        FECHA_COBRO_VENTA_DATE           := to_date(FECHA_COBRO_VENTA,'yyyyMMdd');
    END IF;
    --En el caso de que se haya podido convertir satisfactoriamente, reiniciamos la descripcion del error.
    COD_RETORNO := 0;
    V_ERROR_DESC := '';


    --1. Comprobación de los parametros de entrada.
    -------------------------------------------------------
    CASE
        WHEN IDENTIFICACION_COBRO IS NULL
            THEN V_ERROR_DESC := '[ERROR] No se ha informado IDENTIFICACION_COBRO. Por favor, informe el parámetro. Paramos la ejecución.';
                 COD_RETORNO := 1;
        --Desactivamos la validación que nos prohibe actualizar por reserva y por cobro en una misma ejecución.
        /*WHEN NUM_OFERTA IS NOT NULL AND IDENTIFICACION_COBRO IS NOT NULL
            THEN V_ERROR_DESC := '[ERROR] Se ha informado NUM_OFERTA e IDENTIFICACION_COBRO simultáneamente, no es posible realizar dos operativas por ejecución. Por favor, ejecute de manera individual. Paramos la ejecución.';
                 COD_RETORNO := 1;*/
        WHEN FECHA_COBRO_RESERVA IS NULL AND FECHA_DEVOLUCION_RESERVA IS NULL AND FECHA_COBRO_VENTA IS NULL
            THEN V_ERROR_DESC := '[ERROR] No se han informado FECHA_COBRO_RESERVA o FECHA_DEVOLUCION_RESERVA o FECHA_COBRO_VENTA. Por favor, ingrese una de las tres fechas. Paramos la ejecución.';
                 COD_RETORNO := 1;
        WHEN FECHA_COBRO_VENTA IS NULL AND (FECHA_COBRO_RESERVA IS NOT NULL AND FECHA_DEVOLUCION_RESERVA IS NOT NULL)
            THEN V_ERROR_DESC := '[ERROR] Se ha informado FECHA_COBRO_RESERVA y FECHA_DEVOLUCION_RESERVA simultáneamente, no es posible realizar éstas dos operativas por ejecución. Por favor, ejecute de manera individual. Paramos la ejecución.';
                 COD_RETORNO := 1;
        WHEN FECHA_COBRO_VENTA IS NOT NULL AND (FECHA_COBRO_RESERVA IS NOT NULL OR FECHA_DEVOLUCION_RESERVA IS NOT NULL)
            THEN V_ERROR_DESC := '[ERROR] Se ha informado FECHA_COBRO_VENTA y ademas FECHA_COBRO_RESERVA o FECHA_DEVOLUCION_RESERVA. Por favor, revise éstos parámetro. Paramos la ejecución.';
                 COD_RETORNO := 1;
    ELSE
        COD_RETORNO := COD_RETORNO;
    END CASE;
    --IF COD_RETORNO = 1 THEN DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC); END IF;

    --1.1 Comprobación de las tablas donde vamos a escribir.
    -------------------------------------------------------
    IF COD_RETORNO = 0 THEN
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN (''HLP_HISTORICO_LANZA_PERIODICO'',''HLD_HISTORICO_LANZA_PER_DETA'') AND OWNER LIKE '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

        IF V_NUM > 1 AND COD_RETORNO = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Existen las tablas HLP_HISTORICO_LANZA_PERIODICO y HLD_HISTORICO_LANZA_PER_DETA. Continuamos la ejecución.');
        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] NO existe la tabla HLP_HISTORICO_LANZA_PERIODICO ó HLD_HISTORICO_LANZA_PER_DETA. O no existen ambas. Paramos la ejecución.';
            --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
        END IF;
    END IF;

    --2. Analizamos la información de entrada para derivar por uno u otro proceso.
    ------------------------------------------------------------------------------
    --2.1. Para todos los registros con Número de Reserva  y Fecha de Cobro de reserva informada cuyo expediente no esté en los estados ("Reservado", "Firmado","Vendido", "En Devolución", "Anulado")
    IF (FECHA_COBRO_RESERVA IS NOT NULL) AND COD_RETORNO = 0 AND V_PASOS = 0 THEN

        V_ID_COBRO := IDENTIFICACION_COBRO;
        V_NUM_RESERVA := NULL;
        DBMS_OUTPUT.PUT_LINE(V_OP_1_DESC);
        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando el estado del expediente comercial...');

        --Comprobamos la existencia de la reserva para la cartera Liberbank.
        V_MSQL := V_COUNT||V_FROM_RESERVA;
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM USING IDENTIFICACION_COBRO;

        IF V_NUM > 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Existen una oferta para el campo IDENTIFICACION COBRO '||IDENTIFICACION_COBRO||'. Continuamos la ejecución.');

            --Comprobamos que el estado del expediente NO está en los estados "Reservado", "Firmado","Vendido", "En Devolución" ó "Anulado".
            --Si el resultado de la consulta es 0, quiere decir que cumple con la linea de arriba, en caso contrario, devolverá 1.
            V_MSQL := V_OBTIENE_RESERVA||V_FROM_RESERVA2;

            EXECUTE IMMEDIATE V_MSQL INTO V_NUM, V_RES_ID, V_ECO_ID, V_ACT_ID, V_OFR_ID, V_VALOR_ACTUAL USING IDENTIFICACION_COBRO;

            --Llegados a éste punto, o ejecutamos la actualización o pasamos con la siguiente comprobación.
            IF V_NUM > 0 THEN
                FOR row in ACTIVOS
                LOOP
                       DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||row.ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||', DD_EEC_ID > '||V_VALOR_ACTUAL||'.');
                END LOOP;
                --DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||V_ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||', DD_EEC_ID > '||V_VALOR_ACTUAL||'.');
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] El estado del expediente es "Reservado", "Firmado","Vendido", "En Devolución" ó "Anulado", o la reserva no esta en estado "Pendiente de firma" o no existe estado para éste expediente.';
                --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] El estado del expediente NO es "Reservado" (O está reservado pero pertenece a "Cajamar"), "Firmado" (O está firmado pero pertenece a "Cajamar") ,"Vendido", "En Devolución" ó "Anulado" y la reserva esta en estado "Pendiente de firma". Continuamos la ejecución.');
                FOR row in ACTIVOS
                LOOP
                       DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||row.ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||', DD_EEC_ID > '||V_VALOR_ACTUAL||'.');
                END LOOP;
                --DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||V_ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||', DD_EEC_ID > '||V_VALOR_ACTUAL||'.');
		--PASO 1/4 Actualizar el estado del expediente a "Reservado" si no es de Apple

                V_MSQL := '
		SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ACT_ID||') 
		AND DD_SCR_CODIGO IN ( ''138'',''70'')';
                EXECUTE IMMEDIATE V_MSQL INTO V_ACTIVO_APPLE;
                
                V_MSQL := '
		SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ACT_ID||') AND DD_CRA_CODIGO = ''01''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ACTIVO_CAJAMAR;
            
                IF (V_ACTIVO_APPLE = 0 AND V_ACTIVO_CAJAMAR = 0) THEN
           
                    V_MSQL := '
                    SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''06'''; /*RESERVADO*/
                    EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;
    
                    V_MSQL := '
                    UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
                    SET DD_EEC_ID = '||V_VALOR_NUEVO||', /*RESERVADO*/
                    USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ECO_ID = '||V_ECO_ID||'
                    AND OFR_ID = '||V_OFR_ID||'
                    ';
                    EXECUTE IMMEDIATE V_MSQL;
    
                    IF SQL%ROWCOUNT > 0 THEN
                        DBMS_OUTPUT.PUT_LINE('[INFO] PASO 1/4 | El estado del expediente ha pasado a "Reservado" para la OFERTA '||IDENTIFICACION_COBRO||'.');
                        V_PASOS := V_PASOS+1;
                        --Logado en HLD_HIST_LANZA_PER_DETA
                        PARAM1 := 'ECO_EXPEDIENTE_COMERCIAL';
                        PARAM2 := 'ECO_ID';
                        PARAM3 := 'DD_EEC_ED';
                        HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_ECO_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                        --Reseteamos el V_VALOR_NUEVO
                        V_VALOR_NUEVO := '';
    
                    ELSE
                        COD_RETORNO := 1;
                        V_ERROR_DESC := '[ERROR] No se ha podido cambiar el estado del expediente a "Reservado" para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                        --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                    END IF;
          
                ELSE 
                    V_PASOS := V_PASOS+1;
                    --Logado en HLD_HIST_LANZA_PER_DETA
                    PARAM1 := 'ECO_EXPEDIENTE_COMERCIAL';
                    PARAM2 := 'ECO_ID';
                    PARAM3 := 'DD_EEC_ED';
 		    V_VALOR_NUEVO := V_VALOR_ACTUAL;
                    HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_ECO_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                    --Reseteamos el V_VALOR_NUEVO
                    V_VALOR_NUEVO := '';
                    
                END IF;

                IF COD_RETORNO = 0 THEN
                    --PASO 2/4 Actualizar el campo RES_RESERVA.RES_FECHA_FIRMA con el dato de Fecha de Cobro Recibido.--Recuperamos valor actual
                    V_MSQL := '
                    SELECT NVL(TO_CHAR(RES_FECHA_FIRMA,''yyyyMMdd''),''-'') AS RES_FECHA_FIRMA FROM '||V_ESQUEMA||'.RES_RESERVAS WHERE RES_ID = '||V_RES_ID||'
                    ';
                    EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_ACTUAL;

                    IF UPPER(CARTERA) = 'CAM' THEN --Si el parametro de entrada CARTERA es CAM (CAJAMAR)
                        V_MSQL := '
                            UPDATE '||V_ESQUEMA||'.RES_RESERVAS
                            SET RES_FECHA_CONTABILIZACION = '''||FECHA_COBRO_RESERVA_DATE||''',
                            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
                            FECHAMODIFICAR = SYSDATE
                            WHERE RES_ID = '||V_RES_ID||'
                            AND ECO_ID = '||V_ECO_ID||'
                            AND RES_FECHA_CONTABILIZACION IS NULL
                        ';
                        EXECUTE IMMEDIATE V_MSQL;
                    ELSE
                        V_MSQL := '
                            UPDATE '||V_ESQUEMA||'.RES_RESERVAS
                            SET RES_FECHA_FIRMA = '''||FECHA_COBRO_RESERVA_DATE||''',
                            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
                            FECHAMODIFICAR = SYSDATE
                            WHERE RES_ID = '||V_RES_ID||'
                            AND ECO_ID = '||V_ECO_ID||'
                            AND RES_FECHA_FIRMA IS NULL
                        ';
                        EXECUTE IMMEDIATE V_MSQL;
                    END IF;

                    IF SQL%ROWCOUNT > 0 THEN

 			IF UPPER(CARTERA) = 'CAM' THEN --Si el parametro de entrada CARTERA es CAM (CAJAMAR)
                            DBMS_OUTPUT.PUT_LINE('[INFO] PASO 2/4 | Se ha informado el campo RES_FECHA_CONTABILIZACION para la OFERTA '||IDENTIFICACION_COBRO||'.');
                            V_PASOS := V_PASOS+1;
                            --Logado en HLD_HIST_LANZA_PER_DETA

                            V_VALOR_NUEVO := FECHA_COBRO_RESERVA_DATE;

                            PARAM1 := 'RES_RESERVAS';
                            PARAM2 := 'RES_ID';
                            PARAM3 := 'RES_FECHA_CONTABILIZACION';

			ELSE

		                DBMS_OUTPUT.PUT_LINE('[INFO] PASO 2/4 | Se ha informado el campo RES_FECHA_FIRMA para la OFERTA '||IDENTIFICACION_COBRO||'.');
		                V_PASOS := V_PASOS+1;
		                --Logado en HLD_HIST_LANZA_PER_DETA

		                V_VALOR_NUEVO := FECHA_COBRO_RESERVA_DATE;

		                PARAM1 := 'RES_RESERVAS';
		                PARAM2 := 'RES_ID';
		                PARAM3 := 'RES_FECHA_FIRMA';

			END IF;
			
                        HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_RES_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                        --Reseteamos el V_VALOR_NUEVO
                        V_VALOR_NUEVO := '';

                    ELSE
                        COD_RETORNO := 1;

                        IF UPPER(CARTERA) = 'CAM' THEN --Si el parametro de entrada CARTERA es CAM (CAJAMAR)
                            V_ERROR_DESC := '[ERROR] No se ha podido informar el campo RES_FECHA_CONTABILIZACION para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
			ELSE
			    V_ERROR_DESC := '[ERROR] No se ha podido informar el campo RES_FECHA_FIRMA para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                        END IF;
                        --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                    END IF;

                    IF COD_RETORNO = 0 THEN
                    	IF V_ACTIVO_CAJAMAR = 0 THEN
	                        --PASO 3/4 Actualizar el campo RES_RESERVA.DD_ERE_ID al valor "Firmado"
	                        V_MSQL := '
	                        SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''02'''; /*FIRMADA*/
	                        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;
	                        V_MSQL := '
	                        UPDATE '||V_ESQUEMA||'.RES_RESERVAS
	                        SET DD_ERE_ID = '||V_VALOR_NUEVO||', /*FIRMADA*/
	                        USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
	                        FECHAMODIFICAR = SYSDATE
	                        WHERE RES_ID = '||V_RES_ID||'
	                        AND ECO_ID = '||V_ECO_ID||'
	                        ';
	                        EXECUTE IMMEDIATE V_MSQL;
	
	                        IF SQL%ROWCOUNT > 0 THEN
	                            DBMS_OUTPUT.PUT_LINE('[INFO] PASO 3/4 | El estado de la reserva ha pasado a "Firmado" para la OFERTA '||IDENTIFICACION_COBRO||'.');
	                            V_PASOS := V_PASOS+1;
	                            --Logado en HLD_HIST_LANZA_PER_DETA
	                            --Recuperamos valor actual
	                            V_MSQL := '
	                            SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.RES_RESERVAS WHERE RES_ID = '||V_RES_ID||'
	                            ';
	                            EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_ACTUAL;
	
	                            PARAM1 := 'RES_RESERVAS';
	                            PARAM2 := 'RES_ID';
	                            PARAM3 := 'DD_ERE_ID';
	                            HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_RES_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
	                            --Reseteamos el V_VALOR_NUEVO
	                            V_VALOR_NUEVO := '';
	
	                        ELSE
	                            COD_RETORNO := 1;
	                            V_ERROR_DESC := '[ERROR] No se ha podido cambiar el estado de la reserva para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
	                            --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
	                        END IF;
						ELSE
							V_PASOS := V_PASOS+1;
						END IF;
						
                        IF COD_RETORNO = 0 THEN
                            --PASO 4/4 Insertar un registro en ERE_ENTREGAS_RESERVA con el importe de la reserva correspondiente y la fecha recibida en el parámetro FECHA_COBRO_RESERVA
                            V_MSQL := '
                            SELECT '||V_ESQUEMA||'.S_ERE_ENTREGAS_RESERVA.NEXTVAL FROM DUAL
                            ';
                            EXECUTE IMMEDIATE V_MSQL INTO V_ERE_ID;

                            V_MSQL := '
                            INSERT INTO '||V_ESQUEMA||'.ERE_ENTREGAS_RESERVA (
                                ERE_ID,
                                RES_ID,
                                ERE_IMPORTE,
                                ERE_FECHA_ENTREGA,
                                USUARIOCREAR,
                                FECHACREAR
                                )
                            SELECT
                                '||V_ERE_ID||',
                                '||V_RES_ID||',
                                (SELECT NVL(COE_IMPORTE_RESERVA,0) FROM '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE WHERE ECO_ID = '||V_ECO_ID||'),
                                '''||FECHA_COBRO_RESERVA_DATE||''',
                                ''SP_EXT_PR_ACT_RES_VENTA'',
                                SYSDATE
                            FROM DUAL
                            ';
                            EXECUTE IMMEDIATE V_MSQL;

                            IF SQL%ROWCOUNT > 0 THEN
                                DBMS_OUTPUT.PUT_LINE('[INFO] PASO 4/4 | Insertado un registro en ERE_ENTREGAS_RESERVA para la OFERTA '||IDENTIFICACION_COBRO||'.');
                                V_PASOS := V_PASOS+1;
                                --Logado en HLD_HIST_LANZA_PER_DETA

                                V_VALOR_ACTUAL := '-';
                                V_VALOR_NUEVO := '-';

                                PARAM1 := 'ERE_ENTREGAS_RESERVA';
                                PARAM2 := 'ERE_ID';
                                PARAM3 := '-';
                                HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_ERE_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                                --Reseteamos el V_VALOR_NUEVO
                                V_VALOR_NUEVO := '';

                            ELSE
                                COD_RETORNO := 1;
                                V_ERROR_DESC := '[ERROR] No se ha podido insertar un registro en ERE_ENTREGAS_RESERVA para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                                --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                            END IF;

                        END IF;

                    END IF;

                END IF;

            END IF;

            ---------------------
            -- FIN OPERATORIA 1 -- Lanzamos SP_ASC_ACTUALIZA_SIT_COMERCIAL si todos los pasos se han completado
            ---------------------

            IF V_OP_1_PASOS = V_PASOS THEN
                FOR row in ACTIVOS
                LOOP
                        DBMS_OUTPUT.PUT_LINE('[INFO] Lanzando el SP_ASC_ACTUALIZA_SIT_COMERCIAL para el ACT_ID > '||row.ACT_ID||'.');
                        EXECUTE IMMEDIATE V_EXEC_ACT_SIT USING row.ACT_ID;
                END LOOP;   
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución. OPERATORIA 1 PASOS '||V_PASOS||' / '||V_OP_1_PASOS||'.';
                DBMS_OUTPUT.PUT_LINE('[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución. OPERATORIA 1 PASOS '||V_PASOS||' / '||V_OP_1_PASOS||'.');
            END IF;

        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] [OP1] NO existe la oferta con el campo IDENTIFICACION COBRO  '||IDENTIFICACION_COBRO||', o está duplicada. Paramos la ejecución.';
        END IF;

    END IF;

    --2.2. Para todos los registros con Identificacion de Cobro  y Fecha de Devolución informada cuyo expediente esté en estado "Reservado" o "En devolución"
    IF (FECHA_DEVOLUCION_RESERVA IS NOT NULL) AND COD_RETORNO = 0 /*AND V_PASOS = 0*/ THEN --Se ha comentado la comprobación de los pasos, para que no solo haga una operatoria por ejecución, sino todas las necesarias.

        V_ID_COBRO := IDENTIFICACION_COBRO;
        V_NUM_RESERVA := NULL;
        DBMS_OUTPUT.PUT_LINE(V_OP_2_DESC);
        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando el estado del expediente comercial...');

        --Comprobamos la existencia de la reserva para la cartera Liberbank.
        V_MSQL := V_COUNT||V_FROM_RESERVA;
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM USING IDENTIFICACION_COBRO;

        IF V_NUM > 0 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Existen una oferta con el campo IDENTIFICACION COBRO  '||IDENTIFICACION_COBRO||'. Continuamos la ejecución.');

            --Comprobamos que el estado del expediente está en "Reservado" o "En devolución".
            --Si el resultado de la consulta es 0, quiere decir que cumple con la linea de arriba, en caso contrario, devolverá 1.
            V_MSQL := V_OBTIENE_RESERVA_2||V_FROM_RESERVA2;
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM, V_RES_ID, V_ECO_ID, V_ACT_ID, V_OFR_ID, V_VALOR_ACTUAL USING IDENTIFICACION_COBRO;

            --Llegados a éste punto, o ejecutamos la actualización o pasamos con la siguiente comprobación.
            IF V_NUM > 0 THEN
                FOR row in ACTIVOS
                LOOP
                       DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||row.ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||'.');
                END LOOP;
                --DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||V_ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||'.');
                COD_RETORNO := 1;
                V_ERROR_DESC := '[ERROR] El estado del expediente NO es "Reservado" o "En devolución", o no existe estado para éste expediente.';
                --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] El estado del expediente es "Reservado" o "En devolución". Continuamos la ejecución.');
                FOR row in ACTIVOS
                LOOP
                       DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||row.ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||'.');
                END LOOP;
                --DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||V_ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||'.');
                --PASO 1/8 Actualizar el estado del expediente a "Anulado"
                V_MSQL := '
                SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''02'''; /*Anulado*/
                EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;

                V_MSQL := '
                UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
                SET DD_EEC_ID = '||V_VALOR_NUEVO||', /*ANULADO*/
                    ECO_FECHA_DEV_ENTREGAS = '''||FECHA_DEVOLUCION_RESERVA_DATE||''',
					USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
					FECHAMODIFICAR = SYSDATE
                WHERE ECO_ID = '||V_ECO_ID||'
                AND OFR_ID = '||V_OFR_ID||'
                ';
                EXECUTE IMMEDIATE V_MSQL;

                IF SQL%ROWCOUNT > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('[INFO] PASO 1/8 | El estado del expediente a pasado a "ANULADO" para la OFERTA '||IDENTIFICACION_COBRO||'.');
                    V_PASOS := V_PASOS+1;
                    --Logado en HLD_HIST_LANZA_PER_DETA
                    PARAM1 := 'ECO_EXPEDIENTE_COMERCIAL';
                    PARAM2 := 'ECO_ID';
                    PARAM3 := 'DD_EEC_ED';
                    HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_ECO_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                    --Reseteamos el V_VALOR_NUEVO
                    V_VALOR_NUEVO := '';
                    
                    DBMS_OUTPUT.PUT_LINE('[INFO] PASO 1/8 | La fecha de devolución de la reserva del expediente se ha informado para la OFERTA '||IDENTIFICACION_COBRO||'.');
                    V_MSQL := 'SELECT NVL(TO_CHAR(ECO_FECHA_DEV_ENTREGAS,''yyyyMMdd''),''-'') FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_ID = '||V_ECO_ID||' AND OFR_ID = '||V_OFR_ID||''; 
					EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_ACTUAL;
                    V_VALOR_NUEVO := FECHA_DEVOLUCION_RESERVA_DATE;
                    --Logado en HLD_HIST_LANZA_PER_DETA
                    PARAM1 := 'ECO_EXPEDIENTE_COMERCIAL';
                    PARAM2 := 'ECO_ID';
                    PARAM3 := 'ECO_FECHA_DEV_ENTREGAS';
                    HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_ECO_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                    --Reseteamos el V_VALOR_NUEVO
                    V_VALOR_NUEVO := '';

                ELSE
                    COD_RETORNO := 1;
                    V_ERROR_DESC := '[ERROR] No se ha podido cambiar el estado del expediente a "En devolución" para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                    --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                END IF;

                IF COD_RETORNO = 0 THEN
                    --PASO 2/8 Actualizar el campo RES_RESERVA.RES_FECHA_ANULACION con el dato de Fecha de Devolución.
                    --PASO 3/8 Actualizar el campo RES_RESERVA.RES_FECHA_FIRMA a nulos.

                    V_VALOR_NUEVO := FECHA_DEVOLUCION_RESERVA_DATE;
                    V_MSQL := '
                    SELECT NVL(TO_CHAR(RES_FECHA_FIRMA,''yyyyMMdd''),''-'') AS RES_FECHA_FIRMA FROM '||V_ESQUEMA||'.RES_RESERVAS WHERE RES_ID = '||V_RES_ID||' AND ECO_ID = '||V_ECO_ID||'
                    ';
                    EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_ACTUAL;

 		    V_MSQL := '
		    SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ACT_ID||') 
		    AND DD_SCR_CODIGO IN ( ''138'',''70'')';
                    EXECUTE IMMEDIATE V_MSQL INTO V_ACTIVO_APPLE;
            
                    IF V_ACTIVO_APPLE = 1 THEN

		            V_MSQL := '
		            UPDATE '||V_ESQUEMA||'.RES_RESERVAS
		            SET RES_FECHA_ANULACION = '''||V_VALOR_NUEVO||''',
		            RES_FECHA_FIRMA = NULL,
 			    RES_FECHA_VENCIMIENTO = NULL,
		            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
		            FECHAMODIFICAR = SYSDATE
		            WHERE RES_ID = '||V_RES_ID||'
		            AND ECO_ID = '||V_ECO_ID||'
		            AND RES_FECHA_ANULACION IS NULL
		            ';
		            EXECUTE IMMEDIATE V_MSQL;

		    ELSE 

		            V_MSQL := '
		            UPDATE '||V_ESQUEMA||'.RES_RESERVAS
		            SET RES_FECHA_ANULACION = '''||V_VALOR_NUEVO||''',
		            RES_FECHA_FIRMA = NULL,
		            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
		            FECHAMODIFICAR = SYSDATE
		            WHERE RES_ID = '||V_RES_ID||'
		            AND ECO_ID = '||V_ECO_ID||'
		            AND RES_FECHA_ANULACION IS NULL
		            ';
		            EXECUTE IMMEDIATE V_MSQL;

		    END IF;

                    IF SQL%ROWCOUNT > 0 THEN
                        DBMS_OUTPUT.PUT_LINE('[INFO] PASO 2y3/8 | Se ha informado el campo RES_FECHA_ANULACION para la OFERTA '||IDENTIFICACION_COBRO||'. Se ha borrado la RES_FECHA_FIRMA.');
                        --OJO! Aquí sumamos 2 pasos de una ya que en un update hemos avanzado dos.
                        V_PASOS := V_PASOS+1;
                        V_PASOS := V_PASOS+1;
                        --Logado en HLD_HIST_LANZA_PER_DETA
                        --Pasamos valor - en V_VALOR_ACTUAL, ya que el campo debía ser NULO
                        V_VALOR_ACTUAL := '-';
                        PARAM1 := 'RES_RESERVAS';
                        PARAM2 := 'RES_ID';
                        PARAM3 := 'RES_FECHA_ANULACION';
                        HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_RES_ID, PARAM3, '-', V_VALOR_NUEVO);
                        --Reseteamos el V_VALOR_NUEVO
                        V_VALOR_NUEVO := '';

                        --Pasamos valor - en V_VALOR_NUEVO, ya que el campo tiene que ser NULO
                        V_VALOR_NUEVO := '-';
                        --Logado en HLD_HIST_LANZA_PER_DETA
                        PARAM1 := 'RES_RESERVAS';
                        PARAM2 := 'RES_ID';
                        PARAM3 := 'RES_FECHA_FIRMA';
                        HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_RES_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                        --Reseteamos el V_VALOR_NUEVO
                        V_VALOR_NUEVO := '';

                    ELSE
                        COD_RETORNO := 1;
                        V_ERROR_DESC := '[ERROR] No se ha podido informar el campo RES_FECHA_ANULACION para la OFERTA '||IDENTIFICACION_COBRO||', tampoco borrar la RES_FECHA_FIRMA. Paramos la ejecución.';
                        --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                    END IF;

                    IF COD_RETORNO = 0 THEN
                        --PASO 4/8 Actualizar el campo RES_RESERVA.DD_ERE_ID al valor "Resuelta. Importe devuelto".
                        V_MSQL := '
                        SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.RES_RESERVAS WHERE RES_ID = '||V_RES_ID||' AND ECO_ID = '||V_ECO_ID||'';
                        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_ACTUAL;
                        V_MSQL := '
                        SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''06'''; /*RESUELTA. IMPORTE DEVUELTO*/
                        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;

                        V_MSQL := '
                        UPDATE '||V_ESQUEMA||'.RES_RESERVAS
                        SET DD_ERE_ID = '||V_VALOR_NUEVO||', /*RESUELTA. IMPORTE DEVUELTO*/
                        USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
                        FECHAMODIFICAR = SYSDATE
                        WHERE RES_ID = '||V_RES_ID||'
                        AND ECO_ID = '||V_ECO_ID||'
                        ';
                        EXECUTE IMMEDIATE V_MSQL;

                        IF SQL%ROWCOUNT > 0 THEN
                            DBMS_OUTPUT.PUT_LINE('[INFO] PASO 4/8 | El estado de la reserva ha pasado a "Resuelta. Importe devuelto" para la OFERTA '||IDENTIFICACION_COBRO||'.');
                            V_PASOS := V_PASOS+1;
                            --Logado en HLD_HIST_LANZA_PER_DETA
                            PARAM1 := 'RES_RESERVAS';
                            PARAM2 := 'RES_ID';
                            PARAM3 := 'DD_ERE_ID';
                            HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_RES_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                            --Reseteamos el V_VALOR_NUEVO
                            V_VALOR_NUEVO := '';

                        ELSE
                            COD_RETORNO := 1;
                            V_ERROR_DESC := '[ERROR] No se ha podido cambiar el estado de la reserva para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                            --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                        END IF;

                        IF COD_RETORNO = 0 THEN
                            --PASO 5/8 Actualizar el estado de la oferta a "Anulado".
                            V_MSQL := '
                            SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_ID = '||V_OFR_ID||'';
                            EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_ACTUAL;
                            V_MSQL := '
                            SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02'''; /*ANULADA/DENEGADA*/
                            EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;

                            V_MSQL := '
                            UPDATE '||V_ESQUEMA||'.OFR_OFERTAS
                            SET DD_EOF_ID = '||V_VALOR_NUEVO||', /*ANULADA/DENEGADA*/
                            USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
                            FECHAMODIFICAR = SYSDATE
                            WHERE OFR_ID = '||V_OFR_ID||'
                            ';
                            EXECUTE IMMEDIATE V_MSQL;

                            IF SQL%ROWCOUNT > 0 THEN
                                DBMS_OUTPUT.PUT_LINE('[INFO] PASO 5/8 | El estado de la oferta ha pasado a "Anulada/Denegada" para la OFERTA '||IDENTIFICACION_COBRO||'.');
                                V_PASOS := V_PASOS+1;
                                --Logado en HLD_HIST_LANZA_PER_DETA
                                PARAM1 := 'OFR_OFERTAS';
                                PARAM2 := 'OFR_ID';
                                PARAM3 := 'DD_EOF_ID';
                                HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_OFR_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                                --Reseteamos el V_VALOR_NUEVO
                                V_VALOR_NUEVO := '';

                            ELSE
                                COD_RETORNO := 1;
                                V_ERROR_DESC := '[ERROR] No se ha podido cambiar el estado de la oferta ID '||V_OFR_ID||' para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                                --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                            END IF;

                            IF COD_RETORNO = 0 THEN
                                --PASO 6/8 Insertar un registro en ERE_ENTREGAS_RESERVA con el importe de la reserva correspondiente y la fecha recibida en el parámetro FECHA_COBRO_RESERVA
                                V_MSQL := '
                                SELECT '||V_ESQUEMA||'.S_ERE_ENTREGAS_RESERVA.NEXTVAL FROM DUAL
                                ';
                                EXECUTE IMMEDIATE V_MSQL INTO V_ERE_ID;

                                V_MSQL := '
                                INSERT INTO '||V_ESQUEMA||'.ERE_ENTREGAS_RESERVA (
                                    ERE_ID,
                                    RES_ID,
                                    ERE_IMPORTE,
                                    ERE_FECHA_ENTREGA,
                                    USUARIOCREAR,
                                    FECHACREAR
                                    )
                                SELECT
                                    '||V_ERE_ID||',
                                    '||V_RES_ID||',
                                    (SELECT -(NVL(COE_IMPORTE_RESERVA,0)) FROM '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE WHERE ECO_ID = '||V_ECO_ID||'),
                                    '''||FECHA_DEVOLUCION_RESERVA_DATE||''',
                                    ''SP_EXT_PR_ACT_RES_VENTA'',
                                    SYSDATE
                                FROM DUAL
                                ';
                                EXECUTE IMMEDIATE V_MSQL;

                                IF SQL%ROWCOUNT > 0 THEN
                                    DBMS_OUTPUT.PUT_LINE('[INFO] PASO 6/8 | Insertado un registro en ERE_ENTREGAS_RESERVA para la OFERTA '||IDENTIFICACION_COBRO||'.');
                                    V_PASOS := V_PASOS+1;
                                    --Logado en HLD_HIST_LANZA_PER_DETA

                                    V_VALOR_ACTUAL := '-';
                                    V_VALOR_NUEVO := '-';

                                    PARAM1 := 'ERE_ENTREGAS_RESERVA';
                                    PARAM2 := 'ERE_ID';
                                    PARAM3 := '-';
                                    HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_RES_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                                    --Reseteamos el V_VALOR_NUEVO
                                    V_VALOR_NUEVO := '';

                                ELSE
                                    COD_RETORNO := 1;
                                    V_ERROR_DESC := '[ERROR] No se ha podido insertar un registro en ERE_ENTREGAS_RESERVA para la OFERTA '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                                    --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                                END IF;

                                IF COD_RETORNO = 0 THEN
                                    --PASO 7/8 Revivir las tareas pertenecientes a expedientes económicos de ofertas congeladas
                                    V_MSQL := '
                                    UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES
                                    SET BORRADO = 0,
                                    USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
                                    FECHAMODIFICAR = SYSDATE
                                    WHERE TAR_ID IN (
                                        SELECT TAR.TAR_ID
                                        FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                                        INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACT_OFR ON ACT_OFR.OFR_ID = OFR.OFR_ID
                                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACT_OFR.ACT_ID
                                        INNER JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
                                        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                                        INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = ECO.TBJ_ID
                                        INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                                        INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                                        WHERE ACT.ACT_ID in (   
                                                            SELECT
                                                            ACT.ACT_ID
                                                            FROM REM01.RES_RESERVAS RES
                                                            INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                            ON ECO.ECO_ID = RES.ECO_ID
                                                            INNER JOIN REM01.OFR_OFERTAS OFR
                                                            ON OFR.OFR_ID = ECO.OFR_ID
                                                            INNER JOIN REM01.ACT_OFR OFA
                                                            ON OFA.OFR_ID = OFR.OFR_ID
                                                            INNER JOIN REM01.ACT_ACTIVO ACT
                                                            ON ACT.ACT_ID = OFA.ACT_ID
                                                            INNER JOIN REM01.DD_CRA_CARTERA CAR
                                                            ON CAR.DD_CRA_ID = ACT.DD_CRA_ID
                                                            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA ERE
                                                            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
                                                            WHERE CAR.DD_CRA_CODIGO IN (''08'', ''07'', ''01'')
                                                            AND OFR.OFR_NUM_OFERTA = '||IDENTIFICACION_COBRO||'
                                                         )
                                        AND EOF.DD_EOF_CODIGO = ''03''
                                        AND TAR.BORRADO = 1
                                        AND TAR_FECHA_FIN IS NULL
                                    )
                                    ';
                                    EXECUTE IMMEDIATE V_MSQL;

                                    IF SQL%ROWCOUNT > 0 THEN
                                        DBMS_OUTPUT.PUT_LINE('[INFO] PASO 7/8 | Revividas '||SQL%ROWCOUNT||' tareas pertenecientes a expedientes ecomicos de ofertas "Congeladas" para la OFERTA '||IDENTIFICACION_COBRO||'.');
                                        V_PASOS := V_PASOS+1;
                                        --Logado en HLD_HIST_LANZA_PER_DETA

                                        V_VALOR_ACTUAL := '-';
                                        V_VALOR_NUEVO := '-';

                                        PARAM1 := 'TAR_TAREAS_NOTIFICACIONES';
                                        PARAM2 := 'TAR_ID';
                                        PARAM3 := '-';
                                        HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_RES_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                                        --Reseteamos el V_VALOR_NUEVO
                                        V_VALOR_NUEVO := '';

                                    ELSE
                                        V_PASOS := V_PASOS+1;
                                        DBMS_OUTPUT.PUT_LINE('[INFO] PASO 7/8 | No existen tareas pertenecientes a expedientes ecomicos de ofertas "Congeladas" para la OFERTA '||IDENTIFICACION_COBRO||'.');
                                    END IF;

                                    IF COD_RETORNO = 0 THEN
                                        --PASO 8/8 Actualizar ofertas en estado "Congelada" a "Tramitada"
                                        V_MSQL := '
                                        SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''03'''; /*CONGELADA*/
                                        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_ACTUAL;
                                        V_MSQL := '
                                        SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''01'''; /*TRAMITADA*/
                                        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;

                                        V_MSQL := '
                                        UPDATE '||V_ESQUEMA||'.OFR_OFERTAS
                                        SET DD_EOF_ID = '||V_VALOR_NUEVO||', /*TRAMITADA*/
                                        USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
                                        FECHAMODIFICAR = SYSDATE
                                        WHERE OFR_ID IN (
                                            SELECT OFR1.OFR_ID
                                            FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR1
                                            INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACT_OFR1 ON ACT_OFR1.OFR_ID = OFR1.OFR_ID
                                            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT1 ON ACT1.ACT_ID = ACT_OFR1.ACT_ID
                                            INNER JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF1 ON EOF1.DD_EOF_ID = OFR1.DD_EOF_ID
                                            INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR1.OFR_ID AND ECO.BORRADO = 0
                                            WHERE ACT1.ACT_ID in (   
                                                            SELECT
                                                            ACT.ACT_ID
                                                            FROM REM01.RES_RESERVAS RES
                                                            INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                            ON ECO.ECO_ID = RES.ECO_ID
                                                            INNER JOIN REM01.OFR_OFERTAS OFR
                                                            ON OFR.OFR_ID = ECO.OFR_ID
                                                            INNER JOIN REM01.ACT_OFR OFA
                                                            ON OFA.OFR_ID = OFR.OFR_ID
                                                            INNER JOIN REM01.ACT_ACTIVO ACT
                                                            ON ACT.ACT_ID = OFA.ACT_ID
                                                            INNER JOIN REM01.DD_CRA_CARTERA CAR
                                                            ON CAR.DD_CRA_ID = ACT.DD_CRA_ID
                                                            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA ERE
                                                            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
                                                            WHERE CAR.DD_CRA_CODIGO IN (''08'', ''07'', ''01'')
                                                            AND OFR.OFR_NUM_OFERTA = '||IDENTIFICACION_COBRO||'
                                                         )
                                            AND EOF1.DD_EOF_CODIGO = ''03'' /*CONGELADA*/
                                        )
                                        ';
                                        EXECUTE IMMEDIATE V_MSQL;

                                        IF SQL%ROWCOUNT > 0 THEN
                                          DBMS_OUTPUT.PUT_LINE('[INFO] PASO 8/8 | El estado de la ofertas "Congeladas" han pasado a "Tramitadas" para la OFERTA '||IDENTIFICACION_COBRO||'.');
                                          V_PASOS := V_PASOS+1;
                                          --Logado en HLD_HIST_LANZA_PER_DETA
                                          PARAM1 := 'OFR_OFERTAS';
                                          PARAM2 := 'OFR_ID';
                                          PARAM3 := 'DD_EOF_ID';
                                          HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_OFR_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                                          --Reseteamos el V_VALOR_NUEVO
                                          V_VALOR_NUEVO := '';

                                      ELSE
                                          V_PASOS := V_PASOS+1;
                                          DBMS_OUTPUT.PUT_LINE('[INFO] PASO 8/8 | No existen ofertas "Congeladas" para la OFERTA '||IDENTIFICACION_COBRO||'.');
                                      END IF;

                                    END IF;

                                END IF;

                            END IF;

                        END IF;

                    END IF;

                END IF;

            END IF;

            ---------------------
            -- FIN OPERATORIA 2 -- Lanzamos SP_ASC_ACTUALIZA_SIT_COMERCIAL si todos los pasos se han completado
            ---------------------

            IF V_OP_2_PASOS = V_PASOS THEN
                FOR row in ACTIVOS
                LOOP
                        DBMS_OUTPUT.PUT_LINE('[INFO] Lanzando el SP_ASC_ACTUALIZA_SIT_COMERCIAL para el ACT_ID > '||row.ACT_ID||'.');
                        EXECUTE IMMEDIATE V_EXEC_ACT_SIT USING row.ACT_ID;
                END LOOP; 
            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución. OPERATORIA 2 PASOS '||V_PASOS||' / '||V_OP_2_PASOS||'.';
                DBMS_OUTPUT.PUT_LINE('[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución. OPERATORIA 2 PASOS '||V_PASOS||' / '||V_OP_2_PASOS||'.');
            END IF;

        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] [OP2] NO existe la oferta con el campo IDENTIFICACION COBRO  '||IDENTIFICACION_COBRO||', o está duplicada. Paramos la ejecución.';
        END IF;

    END IF;

    --2.3. Para todos los registros con Identificación de Cobro  y Fecha de Cobro informada cuyo expediente esté en estado distinto a "Anulado" o "Vendido".
    DBMS_OUTPUT.PUT_LINE('IDENTIFICACION_COBRO -> '||IDENTIFICACION_COBRO ||'   FECHA_COBRO_VENTA -> ' ||FECHA_COBRO_VENTA||'  COD_RETORNO ->'||COD_RETORNO);
    IF (IDENTIFICACION_COBRO IS NOT NULL AND FECHA_COBRO_VENTA IS NOT NULL) AND COD_RETORNO = 0 /*AND V_PASOS = 0*/ THEN --Se ha comentado la comprobación de los pasos, para que no solo haga una operatoria por ejecución, sino todas las necesarias.

        V_ID_COBRO := IDENTIFICACION_COBRO;
        V_NUM_RESERVA := NULL;
        DBMS_OUTPUT.PUT_LINE(V_OP_3_DESC);
        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando el estado del expediente comercial...');

        --Comprobamos la existencia de la oferta para la cartera Liberbank.
        V_MSQL := V_COUNT||V_FROM_COBRO;
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
        DBMS_OUTPUT.PUT_LINE(V_NUM);
        IF V_NUM > 0 THEN
            V_NUM2 := 0;
            DBMS_OUTPUT.PUT_LINE('[INFO] Existen una oferta para IDENTIFICACION_COBRO '||IDENTIFICACION_COBRO||'. Continuamos la ejecución.');
            --Para todos los registros con Identificación de Cobro y Fecha de Cobro informada cuyo expediente esté en estado distinto a "Anulado" o "Vendido".
            --Si el resultado de la consulta es 0, quiere decir que cumple con la linea de arriba, en caso contrario, devolverá 1.
                OPEN C_OBTIENE_COBRO;
                LOOP
                FETCH C_OBTIENE_COBRO INTO V_NUM, V_ECO_ID, V_ACT_ID, V_OFR_ID, V_VALOR_ACTUAL;
                EXIT WHEN C_OBTIENE_COBRO%NOTFOUND;
                V_NUM2:=V_NUM2+1;
                V_PASOS:=0;

                IF V_NUM <= V_NUM2 THEN
            
                --Llegados a éste punto, o ejecutamos la actualización o pasamos con la siguiente comprobación.
                IF V_NUM > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||V_ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||', DD_EEC_ID > '||V_VALOR_ACTUAL||'.');
                    COD_RETORNO := 1;
                    V_ERROR_DESC := '[ERROR] El estado del expediente es "Vendido" ó "Anulado", o no existe estado para éste expediente.';
                    
                ELSE

                    V_MSQL := 'SELECT COUNT(1) FROM REM01.OFR_OFERTAS OFR
                                JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                                JOIN REM01.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
                                JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
                                JOIN REM01.ACT_TBJ_TRABAJO TRA ON eco.TBJ_ID = TRA.TBJ_ID
                                JOIN REM01.ACT_TRA_TRAMITE ATR ON ATR.TBJ_ID = TRA.TBJ_ID
                                JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID
                                JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                                JOIN REM01.TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID
                                JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID
                                WHERE OFR.BORRADO = 0
                                AND ACT.DD_CRA_ID=1
                                AND TAP.TAP_CODIGO IN (''T013_DocumentosPostVenta'')
                                AND TAR.TAR_TAREA_FINALIZADA = 0
                                AND ECO.ECO_ID = '||V_ECO_ID||'
                                AND OFR.OFR_ID = '||V_OFR_ID||'
                                AND (OFR.CHECK_FORZADO_CAJAMAR = 1 OR (OFR.CHECK_FORM_CAJAMAR = 1 AND OFR.CHECK_FORZADO_CAJAMAR IS NULL))';
                    EXECUTE IMMEDIATE V_MSQL INTO V_FORMALIZACION_CAJAMAR;

                    IF V_FORMALIZACION_CAJAMAR = 0 THEN 
                        DBMS_OUTPUT.PUT_LINE('[INFO] El estado del expediente NO es "Vendido" ó "Anulado". Continuamos la ejecución.');
                        DBMS_OUTPUT.PUT_LINE('[INFO] ACT_ID > '||V_ACT_ID||', ECO_ID > '||V_ECO_ID||', OFR_ID > '||V_OFR_ID||', RES_ID > '||V_RES_ID||', DD_EEC_ID > '||V_VALOR_ACTUAL||'.');
                        --PASO 1/2 Actualizar el estado del expediente a "Vendido"
                        V_MSQL := '
                        SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''08'''; /*VENDIDO*/
                        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_NUEVO;

                        V_MSQL := '
                        UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
                        SET DD_EEC_ID = '||V_VALOR_NUEVO||', /*RESERVADO*/
                        USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
                        FECHAMODIFICAR = SYSDATE
                        WHERE ECO_ID = '||V_ECO_ID||'
                        AND OFR_ID = '||V_OFR_ID||'
                        ';
                        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                        EXECUTE IMMEDIATE V_MSQL;

                        IF SQL%ROWCOUNT > 0 THEN

                            DBMS_OUTPUT.PUT_LINE('[INFO] PASO 1/2 | El estado del expediente a pasado a "Vendido" para IDENTIFICACION_COBRO '||IDENTIFICACION_COBRO||'.');
                            V_PASOS := V_PASOS+1;
                            --Logado en HLD_HIST_LANZA_PER_DETA
                            PARAM1 := 'ECO_EXPEDIENTE_COMERCIAL';
                            PARAM2 := 'ECO_ID';
                            PARAM3 := 'DD_EEC_ED';
                            HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_ECO_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                            --Reseteamos el V_VALOR_NUEVO
                            V_VALOR_NUEVO := '';

                        ELSE
                            COD_RETORNO := 1;
                            V_ERROR_DESC := '[ERROR] No se ha podido cambiar el estado del expediente a "Vendido" para IDENTIFICACION_COBRO '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                            --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                        END IF;

                    ELSE
                        DBMS_OUTPUT.PUT_LINE('[INFO] PASO 1/2 | El estado del expediente NO pasa a "Vendido" para IDENTIFICACION_COBRO '||IDENTIFICACION_COBRO||' por la formalizacion Cajamar.');
                        V_PASOS := V_PASOS+1;
                    END IF;

                    IF COD_RETORNO = 0 THEN
                        --PASO 2/2 Actualizar ECO_EXPEDIENTE_COMERCIAL.ECO_FECHA_CONT_PROPIETARIO con el valor de la fecha de cobro.
                        --Recuperamos valor actual
                        V_MSQL := 'SELECT NVL(TO_CHAR(ECO_FECHA_CONT_PROPIETARIO,''yyyyMMdd''),''-'') AS ECO_FECHA_CONT_PROPIETARIO FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_ID = '||V_ECO_ID||' ';
                        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR_ACTUAL;

                        V_VALOR_NUEVO := FECHA_COBRO_VENTA_DATE;
						
                        EXECUTE IMMEDIATE 'SELECT DD_CRA_CODIGO
									   	   FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA
									   	   JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
									   	   WHERE ACT.ACT_ID = '||V_ACT_ID INTO V_CARTERA;
									   
	                    EXECUTE IMMEDIATE 'SELECT DD_SCR_CODIGO
										   FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR
										   JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.DD_SCR_ID = SCR.DD_SCR_ID 
										   WHERE ACT.ACT_ID = '||V_ACT_ID INTO V_SUBCARTERA;
										   
	                    IF (V_CARTERA = '08' OR (V_CARTERA = '07' AND ( V_SUBCARTERA = '138' OR V_SUBCARTERA = '70' ))) THEN
                        
	                        V_MSQL := '
	                        UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
	                        SET ECO_FECHA_CONT_VENTA = '''||FECHA_COBRO_VENTA_DATE||''',
	                        USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
	                        FECHAMODIFICAR = SYSDATE
	                        WHERE ECO_ID = '||V_ECO_ID||'
	                        AND OFR_ID = '||V_OFR_ID||'
	                        ';
	                    
	                    ELSE
	                    	
	                    	V_MSQL := '
	                        UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
	                        SET ECO_FECHA_CONT_PROPIETARIO = '''||FECHA_COBRO_VENTA_DATE||''',
	                        USUARIOMODIFICAR = ''SP_EXT_PR_ACT_RES_VENTA'',
	                        FECHAMODIFICAR = SYSDATE
	                        WHERE ECO_ID = '||V_ECO_ID||'
	                        AND OFR_ID = '||V_OFR_ID||'
	                        ';
                        
                        END IF;
                        
                        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                        EXECUTE IMMEDIATE V_MSQL;

                        IF SQL%ROWCOUNT > 0 THEN

                            DBMS_OUTPUT.PUT_LINE('[INFO] PASO 2/2 | Se ha informado el campo ECO_FECHA_CONT_PROPIETARIO para IDENTIFICACION_COBRO '||IDENTIFICACION_COBRO||'.');
                            V_PASOS := V_PASOS+1;
                            --Logado en HLD_HIST_LANZA_PER_DETA
                            PARAM1 := 'ECO_EXPEDIENTE_COMERCIAL';
                            PARAM2 := 'ECO_ID';
                            PARAM3 := 'ECO_FECHA_CONT_PROPIETARIO';
                            HLD_HISTORICO_LANZA_PER_DETA (TO_CHAR(IDENTIFICACION_COBRO), PARAM1, PARAM2, V_ECO_ID, PARAM3, V_VALOR_ACTUAL, V_VALOR_NUEVO);
                            --Reseteamos el V_VALOR_NUEVO
                            V_VALOR_NUEVO := '';
                        ELSE
                            COD_RETORNO := 1;
                            V_ERROR_DESC := '[ERROR] No se ha podido informar el campo ECO_FECHA_CONT_PROPIETARIO para IDENTIFICACION_COBRO '||IDENTIFICACION_COBRO||'. Paramos la ejecución.';
                            --DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);
                        END IF;

                    END IF;

                END IF;

            END IF;
              /*  END LOOP;
                CLOSE C_OBTIENE_COBRO;
              */
--END IF;
            ---------------------
            -- FIN OPERATORIA 3 -- Lanzamos SP_ASC_ACTUALIZA_SIT_COMERCIAL si todos los pasos se han completado
            ---------------------
            IF V_OP_3_PASOS = V_PASOS THEN

               DBMS_OUTPUT.PUT_LINE('[INFO] Lanzando el SP_ASC_ACTUALIZA_SIT_COMERCIAL para el ACT_ID -> '||V_ACT_ID||'.');
               EXECUTE IMMEDIATE V_EXEC_ACT_SIT USING V_ACT_ID;

            ELSE
                COD_RETORNO := 1;
                V_ERROR_DESC := V_ERROR_DESC||'[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución. OPERATORIA 3 PASOS '||V_PASOS||' / '||V_OP_3_PASOS||'.';
                DBMS_OUTPUT.PUT_LINE('[ERROR] No se han cumplido todos los pasos de la operatoria. Paramos la ejecución. OPERATORIA 3 PASOS '||V_PASOS||' / '||V_OP_3_PASOS||'.');

            END IF;
        END LOOP;
        CLOSE C_OBTIENE_COBRO;

        ELSE
            COD_RETORNO := 1;
            V_ERROR_DESC := '[ERROR] [OP3] NO existe la oferta con IDENTIFICACION_COBRO '||IDENTIFICACION_COBRO||', o está duplicada. Paramos la ejecución.';
        END IF;

    END IF;
--Finalizamos en función del COD_RETORNO
IF COD_RETORNO = 1 THEN

    IF V_ERROR_DESC = '' THEN
        V_ERROR_DESC := 'POR ALGUNA RAZÓN NO SE HA ASIGNADO UNA DESCRIPCIÓN A ÉSTE ERROR. REVISAD!';
    END IF;

    DBMS_OUTPUT.PUT_LINE(V_ERROR_DESC);

    --aqui ponemos los parametros de entrada
    V_ID_COBRO := IDENTIFICACION_COBRO;

    IF V_ID_COBRO IS NULL THEN
        V_ID_COBRO := -1;
        V_CODIGO_TO_HLP := V_ID_COBRO;
    ELSE
        V_CODIGO_TO_HLP := 'OFR: '||V_ID_COBRO;
    END IF;

    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('[ERROR] Procedemos a informar la tabla HLP_HISTORICO_LANZA_PERIODICO.');
    HLP_HISTORICO_LANZA_PERIODICO (TO_CHAR(V_CODIGO_TO_HLP), 1, V_ERROR_DESC);
    COMMIT;
    --Desactivamos el control de errores de negocio.
    /*RAISE ERR_NEGOCIO;*/

    DBMS_OUTPUT.PUT_LINE('[FIN] Procedimiento SP_EXT_PR_ACT_RES_VENTA finalizado con errores.');

ELSE --(if COD_RETORNO = 0)

    DBMS_OUTPUT.PUT_LINE('[INFO] Procedemos a informar la tabla HLP_HISTORICO_LANZA_PERIODICO.');
    HLP_HISTORICO_LANZA_PERIODICO ('OFR: '||V_ID_COBRO, 0, V_PASOS);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Procedimiento SP_EXT_PR_ACT_RES_VENTA finalizado correctamente!');

END IF;

EXCEPTION
    --Desactivamos el control de errores de negocio.
     /*WHEN ERR_NEGOCIO THEN
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha abortado el proceso ya que no se cumplía alguno de los requisitos.');
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          COD_RETORNO := 1;
          ROLLBACK;
          RAISE;*/
     WHEN OTHERS THEN
		  ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE(SQLERRM);
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          HLP_HISTORICO_LANZA_PERIODICO ('OFR: '||IDENTIFICACION_COBRO, 1, SQLERRM);
          COD_RETORNO := 1;
          COMMIT;
END SP_EXT_PR_ACT_RES_VENTA;
/
EXIT;
