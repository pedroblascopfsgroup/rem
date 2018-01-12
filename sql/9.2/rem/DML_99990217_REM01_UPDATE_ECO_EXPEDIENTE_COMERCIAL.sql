--/*
--##########################################
--## AUTOR=JUANJO ARBONA
--## FECHA_CREACION=20180111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3516
--## PRODUCTO=NO
--##
--## Finalidad: Poner fecha de anulacion a todos los expedientes que no tienen.
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
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: SE VA A MODIFICAR LA FECHA DE ANULACION DE LOS EXPEDIENTES CON FECHA MODIFICACION ');
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO 
	SET USUARIOMODIFICAR = ''HREOS-3516'', ECO_FECHA_ANULACION = ECO.FECHAMODIFICAR 
	WHERE ECO.ECO_FECHA_ANULACION IS NULL
	AND ECO.DD_EEC_ID = (SELECT EEC.DD_EEC_ID
				FROM  DD_EEC_EST_EXP_COMERCIAL EEC
				WHERE EEC.DD_EEC_CODIGO = ''02'')
	AND ECO.FECHAMODIFICAR IS NOT NULL';
	EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: SE VA A MODIFICAR LA FECHA DE ANULACION DE LOS EXPEDIENTES SIN FECHA MODIFICACION');
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO 
	SET USUARIOMODIFICAR = ''HREOS-3516'', ECO_FECHA_ANULACION = ECO.FECHACREAR 
	WHERE ECO.ECO_FECHA_ANULACION IS NULL
	AND ECO.DD_EEC_ID = (SELECT EEC.DD_EEC_ID
				FROM  DD_EEC_EST_EXP_COMERCIAL EEC
				WHERE EEC.DD_EEC_CODIGO = ''02'')
	AND ECO.FECHAMODIFICAR IS NULL';
	EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: LA TABLA ECO_EXPEDIENTE_COMERCIAL SE HA MODIFICADO CORRECTAMENTE ');
   

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
