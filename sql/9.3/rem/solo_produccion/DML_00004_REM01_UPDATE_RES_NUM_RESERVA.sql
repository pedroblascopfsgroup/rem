--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191024
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5574
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
	
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-5574';
    V_SQL VARCHAR2(4000 CHAR);

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');	

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.RES_RESERVAS T1
				USING (
					SELECT RES.RES_ID, ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY 1) + (SELECT MAX(RES_NUM_RESERVA) FROM '||V_ESQUEMA||'.RES_RESERVAS) NEW_NUM_RESERVA
					FROM '||V_ESQUEMA||'.RES_RESERVAS RES
					JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID
					JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
					WHERE OFR_NUM_OFERTA IN (
						90211469,
						90213863,
						90214582,
						90216265,
						90216269,
						90216290,
						90217407,
						90216290,
						90216269,
						90217407,
						90210625,
						90214582,
						90216265,
						90216269,
						90216290,
						90217407,
						90217796,
						90218905,
						90221118
					)
				) T2
				ON (T1.RES_ID = T2.RES_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.RES_NUM_RESERVA = T2.NEW_NUM_RESERVA
					,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
					,T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han eliminado '||SQL%ROWCOUNT||' registros');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
