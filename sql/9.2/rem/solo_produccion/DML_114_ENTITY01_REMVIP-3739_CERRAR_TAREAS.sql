/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190401
--## ARTEFACTO=ONLINE
--## VERSION_ARTEFACTO=9.4
--## INCIDENCIA_LINK=REMVIP-3739
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema

    V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REG NUMBER;
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TICKET VARCHAR2(4000 CHAR) := 'REMVIP-3739';


BEGIN

 V_SQL := '
	MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
        USING (

		SELECT TAR.TAR_ID
		FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
		INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = ECO.TBJ_ID
		INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
		INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
		WHERE ECO.ECO_NUM_EXPEDIENTE IN ( 
                                  			150807	,
                                  			151063	,
                                  			146019	,
                                  			150716	,
                                  			148743	,
                                  			144702	,
                                  			125553	,
                                  			135013	,
                                  			139438	,
                                  			138538	,
                                  			123892	,
                                  			153968	,
                                  			152203	,
                                  			151412	,
                                  			141684	,
                                  			151409	,
                                  			128737	,
                                  			131952	,
                                  			124819	,
                                  			133616	,
                                  			125558	,
                                  			124652	,
                                  			145215	,
                                  			133038	,
                                  			144045	,
                                  			130283	,
                                  			128444	,
                                  			130418	,
                                  			123259	,
                                  			133047	,
                                  			133051	,
                                  			125380	,
                                  			125381	,
                                  			125592	,
                                  			138954	,
                                  			150764	,
                                  			128304	,
                                  			131063	,
                                  			125383	,
                                  			135015	,
                                  			134191	,
                                  			138953	,
                                  			125554	,
                                  			134508	,
                                  			136133	,
                                  			146277	,
                                  			123155	,
                                  			123637	,
                                  			143621	,
                                  			144731	,
                                  			144760	,
                                  			139456	,
                                  			144764	,
                                  			139816	,
                                  			144452	,
                                  			144766	,
                                  			129376	,
                                  			132059	,
                                  			138982	,
                                  			133715	,
                                  			138915	,
                                  			127136	,
                                  			141322	,
                                  			122835	,
                                  			143637	,
                                  			132856	,
                                  			150243	,
                                  			144768	,
                                  			154702	,
                                  			127577	,
                                  			135354	,
                                  			144448	,
                                  			144499	,
                                  			152447	,
                                  			123157	,
                                  			131361	,
                                  			130291	,
                                  			129100	,
                                  			123041	,
                                  			141832	,
                                  			129682	,
                                  			125271	,
                                  			132121	,
                                  			139454	,
                                  			128724	,
                                  			123156	,
                                  			154458	,
                                  			144736	,
                                  			150320	,
                                  			150260	,
                                  			150266	,
                                  			150267	,
                                  			154464	        
                              			)
		AND TAR_TAREA = ''Cierre económico''
		AND TAR.BORRADO = 0

	      ) T2
        ON (T1.TAR_ID = T2.TAR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.TAR_FECHA_FIN = SYSDATE, 
	    T1.TAR_TAREA_FINALIZADA = 1, 
	    T1.BORRADO = 1,
            T1.USUARIOBORRAR = '''||V_TICKET||''', 
	    T1.FECHABORRAR = SYSDATE
        WHERE T1.TAR_FECHA_FIN IS NULL';

	DBMS_OUTPUT.PUT_LINE( 'SE PROCEDE A ACTUALIZAR LAS TAREAS ' );

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('SE HA ACTUALIZADO '||sql%rowcount||' FILA/S');


    COMMIT;

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
