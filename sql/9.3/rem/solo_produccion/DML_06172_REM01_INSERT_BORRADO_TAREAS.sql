--/*
--######################################### 
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221027
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-18893
--## PRODUCTO=NO
--## 
--## Finalidad: Cerrar tramites en venta.
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18797] - PIER GOTTA
--##        0.2 Correción estados BC y añadir estados Haya - [HREOS-18893] - Alejandra García
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de ID

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] COMIENZA EL PROCESO DE FINALIZACIÓN DE TRAMITES.');

    DBMS_OUTPUT.PUT_LINE('[INFO] Cerramos la tarea Cierre económico para la condicion Ventas ANTERIORES al 15/03/2020.');
    DBMS_OUTPUT.PUT_LINE('[INFO] Cerrando tareas...');
    V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR USING(
	SELECT DISTINCT AUX.TAR_ID_ANTERIOR FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
	INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE ATR ON /*ATR.ACT_ID = ACT.ACT_ID AND */ATR.TBJ_ID=ECO.TBJ_ID
	INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID
	INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
	INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID
	INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID
	INNER JOIN '||V_ESQUEMA||'.APR_AUX_HREOS_18797_2 AUX ON AUX.NUM_OFERTA = OFR.OFR_NUM_OFERTA
	) AUX ON (AUX.TAR_ID_ANTERIOR = TAR.TAR_ID)
	WHEN MATCHED THEN UPDATE SET
	TAR.TAR_FECHA_FIN = SYSDATE,
	TAR.TAR_TAREA_FINALIZADA = 1,
	TAR.USUARIOMODIFICAR = ''HREOS-18893'',
	TAR.FECHAMODIFICAR = SYSDATE';
	
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS.');

    DBMS_OUTPUT.PUT_LINE('[INFO] Dando de baja tramites...');
    
        V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA USING(
	SELECT DISTINCT ATR.TRA_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
	INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE ATR ON /*ATR.ACT_ID = ACT.ACT_ID AND */ATR.TBJ_ID=ECO.TBJ_ID
	INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID
	INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
	INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID
	INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID
	INNER JOIN '||V_ESQUEMA||'.APR_AUX_HREOS_18797_2 AUX ON AUX.NUM_OFERTA = OFR.OFR_NUM_OFERTA AND AUX.TAREA_ANTIGUA_TRAMITE = ''T018_CierreContrato''
	) AUX ON (AUX.TRA_ID = TRA.TRA_ID)
	WHEN MATCHED THEN UPDATE SET
	TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''05''),
	TRA.USUARIOMODIFICAR = ''HREOS-18893'',
	TRA.FECHAMODIFICAR = SYSDATE';
	
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS.');
    
    V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA USING(
	SELECT DISTINCT ATR.TRA_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
	INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
	INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE ATR ON /*ATR.ACT_ID = ACT.ACT_ID AND */ATR.TBJ_ID=ECO.TBJ_ID
	INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID
	INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
	INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID
	INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID
	INNER JOIN '||V_ESQUEMA||'.APR_AUX_HREOS_18797_2 AUX ON AUX.NUM_OFERTA = OFR.OFR_NUM_OFERTA AND AUX.TAREA_NUEVA_TRAMITE IS NOT NULL
	) AUX ON (AUX.TRA_ID = TRA.TRA_ID)
	WHEN MATCHED THEN UPDATE SET
	TRA.TRA_PROCESS_BPM = NULL,
	TRA.USUARIOMODIFICAR = ''HREOS-18893'',
	TRA.FECHAMODIFICAR = SYSDATE';
	
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS.');
    
    
        V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO USING(
	SELECT DISTINCT ECO.ECO_ID, 
	CASE 
		WHEN AUX.TAREA_ANTIGUA_TRAMITE = ''T018_TrasladarOfertaCliente'' OR AUX.TAREA_ANTIGUA_TRAMITE = ''T018_RevisionBcYCondiciones'' THEN  ''020''
		WHEN AUX.TAREA_ANTIGUA_TRAMITE = ''T018_AgendarYFirmar'' AND TOA.DD_TOA_CODIGO = ''SUB''  THEN ''020''
		WHEN AUX.TAREA_ANTIGUA_TRAMITE = ''T018_AgendarYFirmar'' AND TOA.DD_TOA_CODIGO != ''SUB'' THEN ''055''
		WHEN AUX.TAREA_ANTIGUA_TRAMITE = ''T018_CierreContrato'' THEN ''020''
    END AS DD_EEB_CODIGO , 
	CASE 
		WHEN AUX.TAREA_ANTIGUA_TRAMITE = ''T018_TrasladarOfertaCliente'' OR AUX.TAREA_ANTIGUA_TRAMITE = ''T018_RevisionBcYCondiciones'' THEN  ''03''
		WHEN AUX.TAREA_ANTIGUA_TRAMITE = ''T018_AgendarYFirmar'' AND TOA.DD_TOA_CODIGO = ''SUB''  THEN ''03''
		WHEN AUX.TAREA_ANTIGUA_TRAMITE = ''T018_AgendarYFirmar'' AND TOA.DD_TOA_CODIGO != ''SUB'' THEN ''48''
		WHEN AUX.TAREA_ANTIGUA_TRAMITE = ''T018_CierreContrato'' THEN ''03''
    END AS DD_EEC_CODIGO 	
	FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
    	JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
    	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_TOA_TIPO_OFR_ALQUILER TOA ON TOA.DD_TOA_ID = OFR.DD_TOA_ID
	JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
	JOIN '||V_ESQUEMA||'.APR_AUX_HREOS_18797_2 AUX ON AUX.NUM_OFERTA = OFR.OFR_NUM_OFERTA)
	AUX ON (AUX.ECO_ID = ECO.ECO_ID)
	WHEN MATCHED THEN UPDATE SET
	ECO.DD_EEB_ID = (SELECT DD_EEB_ID FROM '||V_ESQUEMA||'.DD_EEB_ESTADO_EXPEDIENTE_BC WHERE DD_EEB_CODIGO = AUX.DD_EEB_CODIGO),
	ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = AUX.DD_EEC_CODIGO),
	ECO.USUARIOMODIFICAR = ''HREOS-18893'',
	ECO.FECHAMODIFICAR = SYSDATE
';
                   
        	EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN] .');


EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(V_MSQL);    
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
