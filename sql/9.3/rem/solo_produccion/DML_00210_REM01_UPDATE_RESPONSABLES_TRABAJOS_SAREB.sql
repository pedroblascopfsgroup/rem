--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200320
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6688'; -- USUARIOCREAR/USUARIOMODIFICAR.

BEGIN
	
	  DBMS_OUTPUT.PUT_LINE('[INICIO] ASIGNAMOS RESPONSABLES TRABAJOS');
  
    	V_MSQL := '
		MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1 
		    USING (SELECT DISTINCT TBJ.TBJ_ID,TBJ.TBJ_NUM_TRABAJO, TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE
		        FROM  '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
		        INNER JOIN  '||V_ESQUEMA||'.ACT_TBJ ACTTBJ ON ACTTBJ.TBJ_ID = TBJ.TBJ_ID
		        INNER JOIN  '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACTTBJ.ACT_ID
		        WHERE TBJ.TBJ_RESPONSABLE_TRABAJO = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''grupgact'')
		        AND ACT.DD_CRA_ID = 2 
		        AND TBJ.BORRADO = 0
		        AND TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE IS NOT NULL
		        AND TBJ.USUARIOMODIFICAR = ''HREOS-9179''
				  ) T2
		    ON (T1.TBJ_ID = T2.TBJ_ID)
		  WHEN MATCHED THEN
		    UPDATE SET T1.USUARIOMODIFICAR = ''REMVIP-6688'',
			       T1.FECHAMODIFICAR = SYSDATE,
			       T1.TBJ_RESPONSABLE_TRABAJO = T2.TBJ_GESTOR_ACTIVO_RESPONSABLE 	 		
         ';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla de ACT_TBJ_TRABAJO.');

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
