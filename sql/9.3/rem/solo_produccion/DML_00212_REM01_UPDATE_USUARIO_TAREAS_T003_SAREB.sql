--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200324
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6688
--## PRODUCTO=SI
--##
--## Finalidad: Script que borra las valoraciones caducadas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6688_TAR'; -- USUARIOCREAR/USUARIOMODIFICAR.

BEGIN
	
	  DBMS_OUTPUT.PUT_LINE('[INICIO] ASIGNAMOS usuarios tareas');
  
    	V_MSQL := '
		MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1 
		    USING (SELECT
                        C.TRA_ID,
                        C.TAR_ID,
                        C.ACT_ID,
                        C.USU_PROVEEDOR
                    FROM
                        (
                            SELECT
                                TAP.TAP_DESCRIPCION,
                                TAP.TAP_CODIGO,
                                ACT.ACT_NUM_ACTIVO,
                                TRA.TRA_ID,
                                TRA.TRA_PROCESS_BPM,
                                TAR.TAR_ID,
                                TRA.DD_EPR_ID,
                                TAR.TAR_TAREA_FINALIZADA,
                                TEX.TEX_ID,
                                TEX.TEX_TOKEN_ID_BPM,
                                TEX.BORRADO,
                                TAR.BORRADO,
                                TAR.USUARIOBORRAR,
                                TBJ.TBJ_NUM_TRABAJO,
                                TBJ.TBJ_ID,
                                TAC.ACT_ID,
                                PVC.USU_ID AS USU_PROVEEDOR,
                                TAC.USU_ID AS USU_TAP_ID,
                                TAC.SUP_ID AS SUP_TAP_ID,
                                TAR.TAR_TAREA,
                                STR.DD_STR_DESCRIPCION,
                                TTR.DD_TTR_DESCRIPCION,
                                TAC.USUARIOMODIFICAR,
                                USU.USU_USERNAME,
                                ROW_NUMBER() OVER( PARTITION BY TRA.TRA_ID ORDER BY TAR.TAR_ID DESC ) AS RN
                            FROM
                                '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
                                INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TAP.TAP_ID = TEX.TAP_ID
                                INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID
                                INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID
                                INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID
                                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID
                                INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID
                                INNER JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID = TBJ.DD_STR_ID
                                INNER JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID
                                INNER JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON TBJ.PVC_ID = PVC.PVC_ID
                                INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
                                INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.DD_TGE_ID = 362 AND GEE.BORRADO = 0
                                INNER JOIN REMMASTER.USU_USUARIOS USU ON USU.USU_ID = TAC.USU_ID
                            WHERE TAC.USU_ID = 87960
                                AND   ACT.DD_CRA_ID = 2
                                AND   TRA.DD_EPR_ID = 30
                                AND   TRA.BORRADO = 0
                                AND   TBJ.BORRADO = 0
                                AND   TAP.TAP_CODIGO IN (''T003_EmisionCertificado'',''T003_ObtencionEtiqueta'',''T003_SolicitudEtiqueta'')
                                ) C
                    WHERE
                        RN = 1
                        AND   C.TAR_TAREA_FINALIZADA = 0
				  ) T2
		    ON (T1.TRA_ID = T2.TRA_ID AND T1.TAR_ID = T2.TAR_ID AND T1.ACT_ID = T2.ACT_ID)
		  WHEN MATCHED THEN UPDATE SET 
			       T1.USUARIOMODIFICAR = ''REMVIP-6688'',
			       T1.FECHAMODIFICAR = SYSDATE,
			       T1.USU_ID = T2.USU_PROVEEDOR	
         ';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' usuarios de tareas.');

	DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
