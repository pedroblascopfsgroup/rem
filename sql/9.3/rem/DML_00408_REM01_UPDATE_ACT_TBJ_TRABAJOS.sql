--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12223
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica es estado de los trabajos antiguo al nuevo modelo
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
    V_USR VARCHAR2(25 CHAR) := 'HREOS-12223';
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                USING(
                SELECT TRANSICION.TBJ_ID, EST_FINAL.DD_EST_ID
                FROM(SELECT 
                DISTINCT TBJ.TBJ_ID
                , EST.DD_EST_CODIGO ANTERIOR
                , DECODE(EST.DD_EST_CODIGO
                , ''03'', ''CAN''
                , ''11'', ''13''
                , ''12'', ''13''
                , ''07'', ''13''
                , ''09'', ''FIN''
                , ''08'', ''REJ''
                , ''10'', ''FIN''
                ) NUEVO
                FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON TBJ.DD_EST_ID = EST.DD_EST_ID AND EST.BORRADO = 0
                WHERE TBJ.BORRADO = 0 AND EST.FLAG_ACTIVO = 0) TRANSICION
                LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_FINAL ON TRANSICION.NUEVO = EST_FINAL.DD_EST_CODIGO AND EST_FINAL.BORRADO = 0 
                WHERE TRANSICION.NUEVO IS NOT NULL
                ) AUX
                ON (TBJ.TBJ_ID = AUX.TBJ_ID)
                WHEN MATCHED THEN
                    UPDATE SET 
                TBJ.DD_EST_ID = AUX.DD_EST_ID
                , TBJ.USUARIOMODIFICAR = '''||V_USR||'''
                , TBJ.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Estados de trabajos nuevos: ' || SQL%ROWCOUNT || ' registros actualizados');
	      
  	DBMS_OUTPUT.PUT_LINE(' [INFO] REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] TABLA ACTUALIZADA CORRECTAMENTE ');

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
