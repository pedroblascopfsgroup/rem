--/*
--#########################################
--## AUTOR=JESUS JATIVA
--## FECHA_CREACION=20220209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11118
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

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(10 CHAR) := '#ESQUEMA_MASTER#';
V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-11118';
PL_OUTPUT VARCHAR2(32000 CHAR);
V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN 
 

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
 
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS T1 USING(
					SELECT OFR.OFR_ID, CAST(TO_TIMESTAMP( aux.fechapendiente,''YYYY-MM-DD HH24:MI:SS.FF'') AS DATE) as fecha_pendiente 
						FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                        JOIN '||V_ESQUEMA||'.AUX_REMVIP_11118 AUX on ofr.ofr_num_oferta = aux.numoferta
						WHERE OFR.BORRADO = 0
                        AND ofr.ofr_fecha_oferta_pendiente IS NULL) T2 
				ON (T1.OFR_ID = T2.OFR_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.ofr_fecha_oferta_pendiente = T2.fecha_pendiente,
				T1.FECHAMODIFICAR = SYSDATE,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||'''';
                
	EXECUTE IMMEDIATE V_MSQL;
  
  	DBMS_OUTPUT.PUT_LINE('[INFO] - INFORMADO ofr_fecha_oferta_pendiente EN '||SQL%ROWCOUNT||' OFERTAS.');
  
  	COMMIT;
  

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
