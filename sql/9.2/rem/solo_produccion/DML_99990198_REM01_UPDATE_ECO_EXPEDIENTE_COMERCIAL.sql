--/*
--##########################################
--## AUTOR=Isidro Sotoca
--## FECHA_CREACION=20171212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3443
--## PRODUCTO=NO
--##
--## Finalidad: Modifica el expediente 85423. Se cambia su estado a "Aprobado" y cambia el estado de su reserva a "Pendiente de firma".
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
    DBMS_OUTPUT.PUT_LINE('[INFO]: SE VA A MODIFICAR EL EXPEDIENTE 85423 ');
    DBMS_OUTPUT.PUT_LINE('[INFO]: SE CAMBIARÁ SU ESTADO A APROBADO ');
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO 
	SET USUARIOMODIFICAR = ''HREOS-3443'', FECHAMODIFICAR = SYSDATE, DD_EEC_ID = (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''11'')  
	WHERE ECO.ECO_NUM_EXPEDIENTE = 85423 ';
	EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: SE VA A MODIFICAR EL ESTADO DE SU RESERVA A PENDIENTE DE FIRMA ');
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.RES_RESERVAS RES 
	SET USUARIOMODIFICAR = ''HREOS-3443'', FECHAMODIFICAR = SYSDATE, DD_ERE_ID = (SELECT DD_ERE_ID FROM DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''01'')  
	WHERE RES.ECO_ID = (SELECT ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = 85423) ';
	EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: EL EXPEDIENTE 85423 SE HA MODIFICADO CORRECTAMENTE ');
   

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