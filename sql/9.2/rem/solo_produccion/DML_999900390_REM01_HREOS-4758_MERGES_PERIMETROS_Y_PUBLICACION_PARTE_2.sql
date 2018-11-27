--/*
--#########################################
--## AUTOR=marco.munoz@pfsgroup.es
--## FECHA_CREACION=20181114
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4758
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_MMC_NO_COMERCIALIZABLES' y merges parte 2.
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

TABLE_COUNT NUMBER(1,0) := 0;
OWNER_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; 
V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
V_TABLA VARCHAR2(40 CHAR) := 'AUX_MMC_NO_COMERCIALIZABLES';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso...');

--1º: Pasamos todos los activos con expediente "Vendido" a situación comercial igual a ------> "Vendido".
----------------------------------------------------------------------------------------------------------------
MERGE INTO REM01.ACT_ACTIVO T1
USING (
        SELECT DISTINCT ACT.ACT_ID AS ACT_ID
        FROM REM01.ACT_ACTIVO                           ACT
        JOIN REM01.ACT_OFR                              AOF
        ON AOF.ACT_ID = ACT.ACT_ID
        JOIN REM01.OFR_OFERTAS                          OFR
        ON OFR.OFR_ID = AOF.OFR_ID
        LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL        ECO
        ON ECO.OFR_ID = OFR.OFR_ID
        LEFT JOIN REM01.RES_RESERVAS                    RES
        ON RES.ECO_ID = ECO.ECO_ID
        LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA          ERE
        ON ERE.DD_ERE_ID = RES.DD_ERE_ID
        LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL        EEC
        ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
        LEFT JOIN REM01.DD_EOF_ESTADOS_OFERTA           EOF
        ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
        LEFT JOIN  REM01.DD_SCM_SITUACION_COMERCIAL     SCM
        ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
        LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION    TCO
        ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
        WHERE SCM.DD_SCM_CODIGO IN ('01')
          AND EEC.DD_EEC_CODIGO IN ('08')
) T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
    T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO IN ('05')),
    T1.USUARIOMODIFICAR = 'HREOS-4758',
    T1.FECHAMODIFICAR = SYSDATE
;
DBMS_OUTPUT.PUT_LINE('[INFO] Se pasan '||SQL%ROWCOUNT||' activos a Vendidos.'); 


--2º: Creamos tabla auxiliar (AUX_MMC_NO_COMERCIALIZABLES) para guardar los activos que vamos a modificar.
----------------------------------------------------------------------------------------------------------------
SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA_1||'.'||V_TABLA||' ya existente. se procede a borrar y crear de nuevo.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';  
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
		AS (
                SELECT DISTINCT ACT.ACT_ID AS ACT_ID, ACT.ACT_NUM_ACTIVO AS ACT_NUM_ASCTIVO, SCM.DD_SCM_DESCRIPCION AS SITUACION_COMERCIAL, TCO.DD_TCO_DESCRIPCION AS DESTINO_COMERCIAL, OFR.OFR_ID, 
                                EOF.DD_EOF_DESCRIPCION AS ESTADO_OFERTA, ECO.ECO_ID,EEC.DD_EEC_DESCRIPCION AS ESTADO_EXPEDIENTE, RES.RES_ID,ERE.DD_ERE_DESCRIPCION AS ESTADO_RESERVA
                FROM REM01.ACT_ACTIVO                           ACT
                JOIN REM01.ACT_OFR                              AOF
                ON AOF.ACT_ID = ACT.ACT_ID
                JOIN REM01.OFR_OFERTAS                          OFR
                ON OFR.OFR_ID = AOF.OFR_ID
                LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL        ECO
                ON ECO.OFR_ID = OFR.OFR_ID
                LEFT JOIN REM01.RES_RESERVAS                    RES
                ON RES.ECO_ID = ECO.ECO_ID
                LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA          ERE
                ON ERE.DD_ERE_ID = RES.DD_ERE_ID
                LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL        EEC
                ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                LEFT JOIN REM01.DD_EOF_ESTADOS_OFERTA           EOF
                ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
                LEFT JOIN  REM01.DD_SCM_SITUACION_COMERCIAL     SCM
                ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
                LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION    TCO
                ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
                WHERE SCM.DD_SCM_CODIGO IN (''01'')
        )
';
DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA_1||'.'||V_TABLA||' creada correctamente.');  

SELECT COUNT(DISTINCT OWNER) INTO OWNER_COUNT FROM ALL_TABLES WHERE OWNER IN (''''||V_ESQUEMA_2||'''');

IF (OWNER_COUNT > 0) AND (V_ESQUEMA_2 != V_ESQUEMA_1) THEN
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] Permisos sobre la tabla '||V_ESQUEMA_1||'.'||V_TABLA||' otorgados al esquema '||V_ESQUEMA_2||''); 
END IF;

SELECT COUNT(DISTINCT OWNER) INTO OWNER_COUNT FROM ALL_TABLES WHERE OWNER IN (''''||V_ESQUEMA_3||'''');

IF (OWNER_COUNT > 0) AND (V_ESQUEMA_3 != V_ESQUEMA_1) THEN
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] Permisos sobre la tabla '||V_ESQUEMA_1||'.'||V_TABLA||' otorgados al esquema '||V_ESQUEMA_3||''); 
END IF;

SELECT COUNT(DISTINCT OWNER) INTO OWNER_COUNT FROM ALL_TABLES WHERE OWNER IN (''''||V_ESQUEMA_4||'''');

IF (OWNER_COUNT > 0) AND (V_ESQUEMA_4 != V_ESQUEMA_1) THEN
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] Permisos sobre la tabla '||V_ESQUEMA_1||'.'||V_TABLA||' otorgados al esquema '||V_ESQUEMA_4||''); 
END IF;



--3º: TODOS LOS ACTIVOS DE LA TABLA AUXILIAR CUYO DESTINO COMERCIAL SEA "Alquiler" ------> "Disponible para alquiler".
----------------------------------------------------------------------------------------------------------------
MERGE INTO REM01.ACT_ACTIVO T1
USING (
            SELECT DISTINCT ACT.ACT_ID AS ACT_ID
            FROM AUX_MMC_NO_COMERCIALIZABLES                AUX
            JOIN REM01.ACT_ACTIVO                           ACT
            ON AUX.ACT_ID = ACT.ACT_ID
            JOIN REM01.ACT_OFR                              AOF
            ON AOF.ACT_ID = ACT.ACT_ID
            JOIN REM01.OFR_OFERTAS                          OFR
            ON OFR.OFR_ID = AOF.OFR_ID
            LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL        ECO
            ON ECO.OFR_ID = OFR.OFR_ID
            LEFT JOIN REM01.RES_RESERVAS                    RES
            ON RES.ECO_ID = ECO.ECO_ID
            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA          ERE
            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL        EEC
            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
            LEFT JOIN REM01.DD_EOF_ESTADOS_OFERTA           EOF
            ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
            LEFT JOIN  REM01.DD_SCM_SITUACION_COMERCIAL     SCM
            ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
            LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION    TCO
            ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
            WHERE TCO.DD_TCO_CODIGO IN ('03')
) T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
       T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO IN ('07')),
       T1.USUARIOMODIFICAR = 'HREOS-4758',
       T1.FECHAMODIFICAR = SYSDATE
;
DBMS_OUTPUT.PUT_LINE('[INFO] Se pasan '||SQL%ROWCOUNT||' activos a Disponible para alquiler.');



--4º: TODOS LOS ACTIVOS DE LA TABLA AUXILIAR CUYO DESTINO COMERCIAL SEA "Alquiler y venta" ------> "Disponible para venta y alquiler".
----------------------------------------------------------------------------------------------------------------
MERGE INTO REM01.ACT_ACTIVO T1
USING (
            SELECT DISTINCT ACT.ACT_ID AS ACT_ID
            FROM AUX_MMC_NO_COMERCIALIZABLES                AUX
            JOIN REM01.ACT_ACTIVO                           ACT
            ON AUX.ACT_ID = ACT.ACT_ID
            JOIN REM01.ACT_OFR                              AOF
            ON AOF.ACT_ID = ACT.ACT_ID
            JOIN REM01.OFR_OFERTAS                          OFR
            ON OFR.OFR_ID = AOF.OFR_ID
            LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL        ECO
            ON ECO.OFR_ID = OFR.OFR_ID
            LEFT JOIN REM01.RES_RESERVAS                    RES
            ON RES.ECO_ID = ECO.ECO_ID
            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA          ERE
            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL        EEC
            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
            LEFT JOIN REM01.DD_EOF_ESTADOS_OFERTA           EOF
            ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
            LEFT JOIN  REM01.DD_SCM_SITUACION_COMERCIAL     SCM
            ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
            LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION    TCO
            ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
            WHERE TCO.DD_TCO_CODIGO IN ('02')
) T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
       T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO IN ('08')),
       T1.USUARIOMODIFICAR = 'HREOS-4758',
       T1.FECHAMODIFICAR = SYSDATE
;
DBMS_OUTPUT.PUT_LINE('[INFO] Se pasan '||SQL%ROWCOUNT||' activos a Disponible para venta y alquiler.');


--5º: TODOS LOS ACTIVOS DE LA TABLA AUXILIAR CUYO DESTINO COMERCIAL SEA "Venta" ------> "Disponible para la venta".
----------------------------------------------------------------------------------------------------------------
MERGE INTO REM01.ACT_ACTIVO T1
USING (
            SELECT DISTINCT ACT.ACT_ID AS ACT_ID
            FROM AUX_MMC_NO_COMERCIALIZABLES                AUX
            JOIN REM01.ACT_ACTIVO                           ACT
            ON AUX.ACT_ID = ACT.ACT_ID
            JOIN REM01.ACT_OFR                              AOF
            ON AOF.ACT_ID = ACT.ACT_ID
            JOIN REM01.OFR_OFERTAS                          OFR
            ON OFR.OFR_ID = AOF.OFR_ID
            LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL        ECO
            ON ECO.OFR_ID = OFR.OFR_ID
            LEFT JOIN REM01.RES_RESERVAS                    RES
            ON RES.ECO_ID = ECO.ECO_ID
            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA          ERE
            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL        EEC
            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
            LEFT JOIN REM01.DD_EOF_ESTADOS_OFERTA           EOF
            ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
            LEFT JOIN  REM01.DD_SCM_SITUACION_COMERCIAL     SCM
            ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
            LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION    TCO
            ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
            WHERE TCO.DD_TCO_CODIGO IN ('01')
) T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
       T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO IN ('02')),
       T1.USUARIOMODIFICAR = 'HREOS-4758',
       T1.FECHAMODIFICAR = SYSDATE
;
DBMS_OUTPUT.PUT_LINE('[INFO] Se pasan '||SQL%ROWCOUNT||' activos a Disponible para la venta.');


--6º: TODOS LOS ACTIVOS DE LA TABLA AUXILIAR CON OFERTA TRAMITADA ------> "Disponible para la venta con oferta".
----------------------------------------------------------------------------------------------------------------
MERGE INTO REM01.ACT_ACTIVO T1
USING (
            SELECT DISTINCT  ACT.ACT_ID AS ACT_ID
            FROM AUX_MMC_NO_COMERCIALIZABLES                AUX
            JOIN REM01.ACT_ACTIVO                           ACT
            ON AUX.ACT_ID = ACT.ACT_ID
            JOIN REM01.ACT_OFR                              AOF
            ON AOF.ACT_ID = ACT.ACT_ID
            JOIN REM01.OFR_OFERTAS                          OFR
            ON OFR.OFR_ID = AOF.OFR_ID
            LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL        ECO
            ON ECO.OFR_ID = OFR.OFR_ID
            LEFT JOIN REM01.RES_RESERVAS                    RES
            ON RES.ECO_ID = ECO.ECO_ID
            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA          ERE
            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL        EEC
            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
            LEFT JOIN REM01.DD_EOF_ESTADOS_OFERTA           EOF
            ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
            LEFT JOIN  REM01.DD_SCM_SITUACION_COMERCIAL     SCM
            ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
            LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION    TCO
            ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
            WHERE EOF.DD_EOF_CODIGO IN ('01')
) T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
       T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO IN ('03')),
       T1.USUARIOMODIFICAR = 'HREOS-4758',
       T1.FECHAMODIFICAR = SYSDATE
;
DBMS_OUTPUT.PUT_LINE('[INFO] Se pasan '||SQL%ROWCOUNT||' activos a Disponible para la venta con oferta.');


--7º: TODOS LOS ACTIVOS DE LA TABLA AUXILIAR CON RESERVA FIRMADA ------> "Disponible para la venta con reserva".
----------------------------------------------------------------------------------------------------------------
MERGE INTO REM01.ACT_ACTIVO T1
USING (
            SELECT DISTINCT  ACT.ACT_ID AS ACT_ID
            FROM AUX_MMC_NO_COMERCIALIZABLES                AUX
            JOIN REM01.ACT_ACTIVO                           ACT
            ON AUX.ACT_ID = ACT.ACT_ID
            JOIN REM01.ACT_OFR                              AOF
            ON AOF.ACT_ID = ACT.ACT_ID
            JOIN REM01.OFR_OFERTAS                          OFR
            ON OFR.OFR_ID = AOF.OFR_ID
            LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL        ECO
            ON ECO.OFR_ID = OFR.OFR_ID
            LEFT JOIN REM01.RES_RESERVAS                    RES
            ON RES.ECO_ID = ECO.ECO_ID
            LEFT JOIN REM01.DD_ERE_ESTADOS_RESERVA          ERE
            ON ERE.DD_ERE_ID = RES.DD_ERE_ID
            LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL        EEC
            ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
            LEFT JOIN REM01.DD_EOF_ESTADOS_OFERTA           EOF
            ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
            LEFT JOIN  REM01.DD_SCM_SITUACION_COMERCIAL     SCM
            ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
            LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION    TCO
            ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
            WHERE ERE.DD_ERE_CODIGO IN ('02')
) T2
ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
       T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO IN ('04')),
       T1.USUARIOMODIFICAR = 'HREOS-4758',
       T1.FECHAMODIFICAR = SYSDATE
;
DBMS_OUTPUT.PUT_LINE('[INFO] Se pasan '||SQL%ROWCOUNT||' activos a Disponible para la venta con reserva.');


DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso.');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT;
