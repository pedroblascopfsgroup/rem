--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20171228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3243
--## PRODUCTO=NO
--##
--## Finalidad: Poner la fecha ejecucion a null a 3 trabajos, para que el proveedor pueda modificar la pestaña de gestion economica
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
    
   
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] PROCESO DE ACTUALIZACIÓN DE ACT_TBJ_TRABAJO');
	
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO IN (9000032459, 9000030634, 9000029986)
	AND TBJ_FECHA_EJECUTADO IS NOT NULL' INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET TBJ_FECHA_EJECUTADO = NULL where TBJ_NUM_TRABAJO IN (9000032459, 9000030634, 9000029986)';
		DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS EN ACT_TBJ_TRABAJO');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] NINGUN REGISTRO CUMPLE LA CONDICION, YA TIENEN LA FECHA NULL O NO EXISTEN ');
	END IF;

    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
