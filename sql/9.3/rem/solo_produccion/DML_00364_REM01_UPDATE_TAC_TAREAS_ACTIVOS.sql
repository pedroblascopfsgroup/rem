--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200701
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7504
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza en TAC_TAREAS_ACTIVOS 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAC_TAREAS_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'REMVIP-7504';

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 
    -- LOOP para actualizar los valores en TAC_TAREAS_ACTIVOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN TAC_TAREAS_ACTIVOS');
    
        --Modificamos los valores
		    V_MSQL := 'MERGE INTO TAC_TAREAS_ACTIVOS TAC USING(
			SELECT TAC.TRA_ID, TAC.TAR_ID, PVC.USU_ID FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
			JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
			JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID
			JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON TBJ.PVC_ID = PVC.PVC_ID 
			WHERE TAC.USUARIOCREAR = ''REMVIP-7504'' AND TBJ.TBJ_NUM_TRABAJO NOT IN  (148982,
			158799,
			166725,
			168139,
			166701)) AUX ON  (AUX.TRA_ID = TAC.TRA_ID AND AUX.TAR_ID = TAC.TAR_ID)
			WHEN MATCHED THEN UPDATE SET
			TAC.USU_ID = AUX.USU_ID,
			TAC.FECHAMODIFICAR = SYSDATE,
			TAC.USUARIOMODIFICAR = ''REMVIP-7504''';

    EXECUTE IMMEDIATE V_MSQL;
COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAC_TAREAS_ACTIVOS MODIFICADA CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
