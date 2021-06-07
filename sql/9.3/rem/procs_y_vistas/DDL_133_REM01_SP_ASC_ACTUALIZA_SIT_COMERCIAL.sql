--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20210528
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9845
--## PRODUCTO=NO
--## Finalidad: Stored Procedure que actualiza la situacion comercial de los activos en REM.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-1936 - David Gonzalez
--##        0.2 Segunda version - HREOS-3523 - Vicente Martinez
--##        0.3 Tercera version - REMVIP-3040 - Ivan Castelló
--##	    0.4 Cuarta versión  - REMVIP-3387 - Pier Gotta
--##	    0.5 Cuarta versión  - REMVIP-9845 - Viorel Remus Ovidiu - Cambiada vista a V_ES_CONDICIONADO en vez de V_COND_DISPONIBILIDAD
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE SP_ASC_ACTUALIZA_SIT_COMERCIAL (
      ID_ACTIVO       IN NUMBER DEFAULT 0,
      ACTUALIZAR      IN NUMBER DEFAULT 0,
      PROCESO         IN NUMBER DEFAULT 0
)
AS
--David González
--HREOS-1936
--08-05-2017
--V0.1

--Vicente Martinez
--HREOS-3523
--08-01-2018
--v0.2

--PROCEDIMIENTO ALMACENADO QUE INFORMA O INFORMA/ACTUALIZA LA SITUACION COMERCIAL (ACT_ACTIVO.DD_SCM_ID)
--DE UN ACTIVO PASADO POR PARÁMETRO O DE TODOS LOS ACTIVOS (NO BORRADOS)
--EN LA TABLA TMP_ACT_SCM, Y ADEMÁS, PASANDOLE COMO PARAMETRO ACTUALIZAR = 1,
--ACTUALIZA LA SITUACIÓN EN LA TABLA DEL ACTIVO.

----PARAMETROS
--ID_ACTIVO -> Podemos ejecutar el proceso sobre un Activo en concreto (ACT_ID),
--             o por contra, si no indicamos nada, o indicamos '0', el perímetro se extiende a todos los activos.
--ACTUALIZAR -> Si marcamos '1', ademas de informar la tabla TMP_ACT_SCM, se actualizara la tabla ACT_ACTIVO. Si marcamos '0' solo se informara.
--PROCESO -> Si marcamos '1', es porque el SP se lanza desde un proceso que ya ha rellenado la tabla TMP. Si marcamos '0' el SP se lanza de forma independiente.


--EJEMPLOS DE USO:
----SP_ASC_ACTUALIZA_SIT_COMERCIAL(161,0); | Solo informaria la Situacion Comercial para el ACT_ID 161
----SP_ASC_ACTUALIZA_SIT_COMERCIAL(161);   |
----SP_ASC_ACTUALIZA_SIT_COMERCIAL(161,1); | Informaria y actualizaria la Situacion Comercial para el ACT_ID 161
----SP_ASC_ACTUALIZA_SIT_COMERCIAL(0,0);   | Solo informaria la Situacion Comercial para el todos los Activos
----SP_ASC_ACTUALIZA_SIT_COMERCIAL();      |
----SP_ASC_ACTUALIZA_SIT_COMERCIAL(0,1);   | Informaria y actualizaria la Situacion Comercial para el todos los Activos
--COMO VEMOS, SI EL PARAMETRO QUE QUEREMOS INTRODUCIR ES '0', NO HACE FALTA INDICARLO, YA QUE ESTA DEFAULT, EXCEPTO SI HACEMOS (0,1).

V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_SQL VARCHAR2(4000 CHAR);
V_COUNT NUMBER(16);
V_USUARIO VARCHAR2(30 CHAR) := 'SP_ASC_SCM';

TABLA_APOYO VARCHAR2(30 CHAR) := 'TMP_ACT_SCM';
TABLA_ACTIVO VARCHAR2(30 CHAR) := 'ACT_ACTIVO';
TABLA_APOYO_PRECAL VARCHAR2(30 CHAR) := 'TMP_ACT_SCM_PRECAL';
VISTA_COND VARCHAR2(30 CHAR) := 'V_ES_CONDICIONADO';

--CODIGOS DICCIONARIO
SITCOM_ALQUILER VARCHAR2(2 CHAR) := '07';
SITCOM_VENTA_ALQUILER VARCHAR2(2 CHAR) := '08';
SITCOM_VENTA VARCHAR2(2 CHAR) := '02';
SITCOM_CONDICIONADO VARCHAR2(2 CHAR) := '09';
SITCOM_VENTA_RESERVA VARCHAR2(2 CHAR) := '04';
SITCOM_VENTA_OFERTA VARCHAR2(2 CHAR) := '03';
SITCOM_NO_COMERCIALIZABLE VARCHAR2(2 CHAR) := '01';
SITCOM_VENDIDO VARCHAR2(2 CHAR) := '05';
TIPOCOM_VENTA VARCHAR2(2 CHAR) := '01';
TIPOCOM_ALQUILER_VENTA VARCHAR2(2 CHAR) := '02';
TIPOCOM_ALQUILER VARCHAR2(2 CHAR) := '03';
ESTADORES_FIRMADA VARCHAR2(2 CHAR) := '02';
ESTADOOFE_ACEPTADA VARCHAR2(2 CHAR) := '01';
EXPEDIENTE_ANULADO VARCHAR2(2 CHAR) := '02';

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO DE INFORMACIÓN/ACTUALIZACIÓN DE ESTADOS COMERCIALES.');
  DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------');

 
  IF PROCESO = 0 THEN --IF_0

    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||TABLA_APOYO||'';

    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||TABLA_APOYO_PRECAL||'';

    IF ID_ACTIVO > 0 THEN --IF_1

      EXECUTE IMMEDIATE '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' WHERE ACT_ID = '||ID_ACTIVO||' AND BORRADO = 0
      ' INTO V_COUNT;

      IF V_COUNT > 0 THEN --IF_2

        DBMS_OUTPUT.PUT_LINE('[INFO] Se ejecutará el proceso para el Activo '||ID_ACTIVO||'.');

        EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' (ACT_ID,DD_SCM_ID_OLD,DD_SCM_ID_NEW,FECHA_CALCULO)
          SELECT ACT_ID, DD_SCM_ID, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_VENTA||''')
          , SYSDATE FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' WHERE ACT_ID = '||ID_ACTIVO||' AND BORRADO = 0 ORDER BY ACT_ID DESC
        ';

        EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||TABLA_APOYO_PRECAL||' (ACT_ID,DD_SCM_ID_OLD,DD_SCM_ID_NEW,ES_CONDICIONADO)
          SELECT ACT.ACT_ID,ACT.DD_SCM_ID, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_CONDICIONADO||'''), V.ES_CONDICIONADO 
	    FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
	    JOIN '||V_ESQUEMA||'.'||VISTA_COND||' V ON V.ACT_ID = ACT.ACT_ID WHERE ACT.ACT_ID = '||ID_ACTIVO||' AND ACT.BORRADO = 0 AND V.ES_CONDICIONADO = 1 ORDER BY ACT.ACT_ID DESC
        ';


      ELSE --IF_2

        DBMS_OUTPUT.PUT_LINE('[INFO] No existe el Activo '||ID_ACTIVO||' pasado por parámetros. El proceso finalizará.');

      END IF; --IF_2

    ELSE --IF_1

      DBMS_OUTPUT.PUT_LINE('[INFO] Se informará/actualizará la Situación Comercial para todos los Activos.');

      EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' (ACT_ID,DD_SCM_ID_OLD,DD_SCM_ID_NEW,FECHA_CALCULO)
        SELECT ACT_ID, DD_SCM_ID, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_VENTA||''')
        , SYSDATE FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' WHERE BORRADO = 0 ORDER BY ACT_ID DESC
      ';

      EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.'||TABLA_APOYO_PRECAL||' (ACT_ID,DD_SCM_ID_OLD,DD_SCM_ID_NEW,ES_CONDICIONADO)
        SELECT ACT.ACT_ID,ACT.DD_SCM_ID, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_CONDICIONADO||'''), V.ES_CONDICIONADO 
	FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
	   JOIN '||V_ESQUEMA||'.'||VISTA_COND||' V ON V.ACT_ID = ACT.ACT_ID WHERE ACT.BORRADO = 0 AND V.ES_CONDICIONADO = 1 ORDER BY ACT.ACT_ID DESC
      ';

    END IF; --IF_1
  
  END IF; --IF_0

  IF PROCESO = 1 AND ID_ACTIVO = 0 THEN --IF 2.5

    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||TABLA_APOYO_PRECAL||'';
    
    EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.'||TABLA_APOYO_PRECAL||' (ACT_ID,DD_SCM_ID_OLD,DD_SCM_ID_NEW,ES_CONDICIONADO)
        SELECT ACT.ACT_ID,ACT.DD_SCM_ID, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_CONDICIONADO||'''), V.ES_CONDICIONADO 
	FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
	   JOIN '||V_ESQUEMA||'.'||VISTA_COND||' V ON V.ACT_ID = ACT.ACT_ID WHERE ACT.BORRADO = 0 AND V.ES_CONDICIONADO = 1 ORDER BY ACT.ACT_ID DESC
      ';

  END IF;
  
  EXECUTE IMMEDIATE '
  SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||TABLA_APOYO||'
  ' INTO V_COUNT;

  IF V_COUNT > 0 THEN --IF_3

    IF ACTUALIZAR > 0 THEN --IF_4

      DBMS_OUTPUT.PUT_LINE('[INFO] Existen '||V_COUNT||' Activos que informar. Puede ver los nuevos estados en la tabla '||V_ESQUEMA||'.'||TABLA_APOYO||'. O en la tabla de Activos, donde la Situación Comercial se habrá actualizado.');

    ELSE --IF_4

      DBMS_OUTPUT.PUT_LINE('[INFO] Existen '||V_COUNT||' Activos que informar. Puede ver los nuevos estados en la tabla '||V_ESQUEMA||'.'||TABLA_APOYO||'.');

    END IF; --IF_4

    /*-----------------------*/
    /*SCM_DISPONIBLE_ALQUILER*/
    /*-----------------------*/
    EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
        SELECT ACT.ACT_ID, ACT.DD_SCM_ID AS SIT_ACTUAL, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_ALQUILER||''') AS SIT_NUEVA, ACT.DD_TCO_ID
        FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        ON TMP.ACT_ID = ACT.ACT_ID
        WHERE ACT.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_ALQUILER||''')
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.SIT_NUEVA,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.SIT_NUEVA
      ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Informado SITUACION COMERCIAL -> DISPONIBLE PARA ALQUILER.');

    /*--------------------*/
    /*SCM_DISPONIBLE_VENTA*/
    /*--------------------*/
    EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
        SELECT DISTINCT ACT.ACT_ID, ACT.DD_SCM_ID AS SIT_ACTUAL, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_VENTA||''') AS SIT_NUEVA, ACT.DD_TCO_ID
        FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        ON TMP.ACT_ID = ACT.ACT_ID
        WHERE ACT.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_VENTA||''')
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.SIT_NUEVA,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.SIT_NUEVA
      ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Informado SITUACION COMERCIAL -> DISPONIBLE PARA VENTA.');


    /*-----------------------------*/
    /*SCM_DISPONIBLE_VENTA_ALQUILER*/
    /*-----------------------------*/
    EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
        SELECT DISTINCT ACT.ACT_ID, ACT.DD_SCM_ID AS SIT_ACTUAL, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_VENTA_ALQUILER||''') AS SIT_NUEVA, ACT.DD_TCO_ID
        FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        ON TMP.ACT_ID = ACT.ACT_ID
        WHERE ACT.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||TIPOCOM_ALQUILER_VENTA||''')
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.SIT_NUEVA,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.SIT_NUEVA
      ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Informado SITUACION COMERCIAL -> DISPONIBLE VENTA ALQUILER.');

    /*----------------*/
    /*SCM_CONDICIONADO*/
    /*----------------*/
      --TIRAMOS DE LA VISTA V_COND_DISPONIBILIDAD
      EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
	SELECT DISTINCT ACT_ID, DD_SCM_ID_OLD, DD_SCM_ID_NEW
	FROM '||V_ESQUEMA||'.'||TABLA_APOYO_PRECAL||'
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.DD_SCM_ID_NEW,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.DD_SCM_ID_NEW
      ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Informado SITUACION COMERCIAL -> CONDICIONADO.');

    /*---------------------------*/
    /*SCM_DISPONIBLE_VENTA_OFERTA*/
    /*---------------------------*/
    EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
        SELECT DISTINCT ACT.ACT_ID, ACT.DD_SCM_ID AS SIT_ACTUAL, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_VENTA_OFERTA||''') AS SIT_NUEVA, OFR.DD_EOF_ID
        FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        ON TMP.ACT_ID = ACT.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACTOFR
        ON ACTOFR.ACT_ID = ACT.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
        ON OFR.OFR_ID = ACTOFR.OFR_ID
        AND OFR.BORRADO=0
        WHERE OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '''||ESTADOOFE_ACEPTADA||''')
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.SIT_NUEVA,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.SIT_NUEVA
      ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Informado SITUACION COMERCIAL -> DISPONIBLE PARA VENTA OFERTA.');

    /*----------------------------*/
    /*SCM_DISPONIBLE_VENTA_RESERVA*/
    /*----------------------------*/
    EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
        SELECT DISTINCT ACT.ACT_ID, ACT.DD_SCM_ID AS SIT_ACTUAL, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_VENTA_RESERVA||''') AS SIT_NUEVA, RES.DD_ERE_ID
        FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        ON TMP.ACT_ID = ACT.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACTOFR
        ON ACTOFR.ACT_ID = ACT.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
        ON OFR.OFR_ID = ACTOFR.OFR_ID
        AND OFR.BORRADO=0
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
        ON ECO.OFR_ID = OFR.OFR_ID
        AND ECO.BORRADO=0
        INNER JOIN '||V_ESQUEMA||'.RES_RESERVAS RES
        ON RES.ECO_ID = ECO.ECO_ID
        AND RES.BORRADO=0
        WHERE RES.DD_ERE_ID = (SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = '''||ESTADORES_FIRMADA||''')
        AND ECO.DD_EEC_ID <> (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '''||EXPEDIENTE_ANULADO||''')
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.SIT_NUEVA,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.SIT_NUEVA
      ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Informado SITUACION COMERCIAL -> DISPONIBLE PARA VENTA RESERVA.');

    /*----------------------*/
    /*SCM_NO_COMERCIALIZABLE*/
    /*----------------------*/
    EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
        SELECT DISTINCT ACT.ACT_ID, ACT.DD_SCM_ID AS SIT_ACTUAL, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_NO_COMERCIALIZABLE||''') AS SIT_NUEVA, PAC.PAC_CHECK_COMERCIALIZAR
        FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        ON TMP.ACT_ID = ACT.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
        ON PAC.ACT_ID = ACT.ACT_ID
        AND PAC.BORRADO=0
        WHERE PAC.PAC_CHECK_COMERCIALIZAR = 0
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.SIT_NUEVA,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.SIT_NUEVA
      ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Informado SITUACION COMERCIAL -> NO COMERCIALIZABLE.');

    /*------------*/
    /*SCM_VENDIDO*/
    /*------------*/
    EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
        SELECT DISTINCT ACT.ACT_ID, ACT.DD_SCM_ID AS SIT_ACTUAL, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_VENDIDO||''') AS SIT_NUEVA, ECO.ECO_FECHA_VENTA
        FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        ON TMP.ACT_ID = ACT.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACTOFR
        ON ACTOFR.ACT_ID = ACT.ACT_ID
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
        ON OFR.OFR_ID = ACTOFR.OFR_ID
        AND OFR.BORRADO=0
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
        ON ECO.OFR_ID = ACTOFR.OFR_ID
        AND ECO.BORRADO=0
        WHERE ECO.ECO_FECHA_VENTA IS NOT NULL
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.SIT_NUEVA,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.SIT_NUEVA
      ';
    COMMIT;

    /*-----------*/
    /*SCM_VENDIDO2*/
    /*-----------*/
    EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_APOYO||' ACT USING (
        SELECT DISTINCT ACT.ACT_ID, ACT.DD_SCM_ID AS SIT_ACTUAL, (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||SITCOM_VENDIDO||''') AS SIT_NUEVA, ACT.ACT_VENTA_EXTERNA_FECHA
        FROM '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        ON TMP.ACT_ID = ACT.ACT_ID
        WHERE ACT.ACT_VENTA_EXTERNA_FECHA IS NOT NULL
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID_NEW = TMP.SIT_NUEVA,
      ACT.FECHA_CALCULO = SYSDATE
      WHERE ACT.DD_SCM_ID_NEW != TMP.SIT_NUEVA
      ';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO] Informado SITUACION COMERCIAL -> VENDIDO.');

    EXECUTE IMMEDIATE '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TABLA_APOYO||' WHERE DD_SCM_ID_OLD != DD_SCM_ID_NEW OR DD_SCM_ID_OLD IS NULL AND BORRADO = 0
    ' INTO V_COUNT;

    IF V_COUNT > 0 THEN --IF_5

      DBMS_OUTPUT.PUT_LINE('[INFO] La Situación Comercial ha cambiado para '||V_COUNT||' Activos.');

    ELSE --IF_5

      DBMS_OUTPUT.PUT_LINE('[INFO] La Situación Comercial no ha cambiado.');

    END IF; --IF_5

    IF ACTUALIZAR = 1 AND V_COUNT > 0 THEN --IF_6

      DBMS_OUTPUT.PUT_LINE('[INFO] Se va a proceder a ACTUALIZAR la Situación Comercial en la tabla de Activos.');

      EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT USING (
        SELECT DISTINCT TMP.ACT_ID, TMP.DD_SCM_ID_NEW AS SIT_NUEVA
        FROM '||V_ESQUEMA||'.'||TABLA_APOYO||' TMP
        INNER JOIN '||V_ESQUEMA||'.'||TABLA_ACTIVO||' ACT
        ON TMP.ACT_ID = ACT.ACT_ID
        WHERE (TMP.DD_SCM_ID_NEW != TMP.DD_SCM_ID_OLD
        OR TMP.DD_SCM_ID_OLD IS NULL)
        AND TMP.BORRADO = 0
        and act.borrado = 0
      ) TMP
      ON (ACT.ACT_ID = TMP.ACT_ID)
      WHEN MATCHED THEN UPDATE SET
      ACT.DD_SCM_ID = TMP.SIT_NUEVA,
      ACT.USUARIOMODIFICAR = '''||V_USUARIO||''',
      ACT.FECHAMODIFICAR = SYSDATE
      WHERE ACT.DD_SCM_ID IS NULL
      OR ACT.DD_SCM_ID != TMP.SIT_NUEVA
      ';
      V_COUNT := SQL%ROWCOUNT;
      COMMIT;

      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_COUNT||' Activos actualizados.');

    END IF; --IF_6

  ELSE --IF_3

    DBMS_OUTPUT.PUT_LINE('[INFO] No hay activos que informar/actualizar.');

  END IF; --IF_3

  DBMS_OUTPUT.PUT_LINE('[OK] - PROCESO FINALIZADO.');

EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;

END SP_ASC_ACTUALIZA_SIT_COMERCIAL;
/
EXIT
