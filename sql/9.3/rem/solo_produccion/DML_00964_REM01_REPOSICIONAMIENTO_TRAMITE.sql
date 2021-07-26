--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200413
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10177
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
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

    V_ESQUEMA VARCHAR2(25 CHAR) := 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10177';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.

BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    REM01.AVANCE_TRAMITE('REMVIP-10177','232540','T013_PendienteDevolucion','232540','16',PL_OUTPUT);
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET			
			ECO_FECHA_VENTA = NULL,            
            ECO_FECHA_CONT_PROPIETARIO = NULL,
			USUARIOMODIFICAR = '''||V_USUARIO||''',
			FECHAMODIFICAR = SYSDATE
			WHERE ECO_NUM_EXPEDIENTE = ''232540'' ';
			EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('Modificado expediente');


    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.RES_RESERVAS T1 USING (
                 SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES
                    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID=RES.ECO_ID
                    WHERE RES.BORRADO = 0 AND ECO.BORRADO = 0 AND ECO.ECO_NUM_EXPEDIENTE=232540
                    
                    ) T2
        ON (T1.RES_ID = T2.RES_ID)
        WHEN MATCHED THEN UPDATE SET
        T1.DD_ERE_ID = (SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO=''05''),        
        T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
        T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' ESTADO RESERVA.');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET			
        DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO=''03''),
        USUARIOMODIFICAR = '''||V_USUARIO||''',
        FECHAMODIFICAR = SYSDATE
        WHERE ACT_NUM_ACTIVO = ''6995438'' ';
        EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('Modificado activo');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;

END;
/
EXIT;