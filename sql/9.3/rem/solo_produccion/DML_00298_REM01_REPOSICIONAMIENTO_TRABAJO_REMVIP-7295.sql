--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200514
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7295
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 char);
    
    V_USUARIO VARCHAR(50 CHAR):= 'REMVIP-7295';
    OFR_NUM_OFERTA NUMBER(16);
    TAP_CODIGO VARCHAR2(50 CHAR);
    ECO_NUM_EXPEDIENTE NUMBER(16);
    TRA_ID NUMBER(16);
	V_TRABAJOS VARCHAR2(5000 CHAR) := '900105600001,
										900397600001,
										900910800001,
										905508400001,
										906270000001,
										906454900001,
										907601200001,
										907601200002,
										909450500001,
										909450500002,
										909478500001,
										909478500002,
										909478500003,
										914054700001,
										915418300001';
BEGIN
    
    DBMS_OUTPUT.put_line('[INICIO]');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET TBJ_FECHA_HORA_CONCRETA = SYSDATE, 
						USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE 
						WHERE TBJ_NUM_TRABAJO IN ('||TRIM(V_TRABAJOS)||') AND BORRADO = 0';
						

	#ESQUEMA#.REPOSICIONAMIENTO_TRABAJO(V_USUARIO, TRIM(V_TRABAJOS), 'T004_ResultadoTarificada');
        
    #ESQUEMA#.ALTA_BPM_INSTANCES(V_USUARIO, PL_OUTPUT); --AQUI DENTRO SE HACE COMMIT
    
    
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
						USING (
							SELECT TRA.TRA_ID,
							PVC.USU_ID
							FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
							INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID
							INNER JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVC_ID = TBJ.PVC_ID
							WHERE TBJ_NUM_TRABAJO IN ('||TRIM(V_TRABAJOS)||') AND TRA.BORRADO = 0 AND PVC.BORRADO = 0 AND TBJ.BORRADO = 0
						) AUX ON (AUX.TRA_ID = TAC.TRA_ID)
						WHEN MATCHED THEN UPDATE SET TAC.USU_ID = AUX.USU_ID 
						WHERE TAC.USUARIOCREAR = '''||V_USUARIO||'''';
   
	COMMIT;
 DBMS_OUTPUT.put_line('[OK]');
 DBMS_OUTPUT.put_line('[FIN]');
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;