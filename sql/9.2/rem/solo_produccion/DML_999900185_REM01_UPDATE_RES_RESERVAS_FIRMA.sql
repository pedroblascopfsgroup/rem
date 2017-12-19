--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20171212
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3458
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el estado de la reserva a firmada en caso de que tenga fecha de firma y el expediente comercial esté en estado Reservado, Bloqueo Adm, Firmado o Vendido
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
    
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'RES_RESERVAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.



BEGIN

    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.RES_RESERVAS RES 
		    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID
		    WHERE ECO.DD_EEC_ID IN (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN (''03'', ''05'', ''06'', ''08''))
		    AND RES.DD_ERE_ID <> (SELECT DD_ERE_ID FROM DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''02'')
		    AND RES.RES_FECHA_FIRMA IS NOT NULL' INTO V_NUM_TABLAS;
		    
		    
	IF V_NUM_TABLAS > 0 THEN
		   
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		 
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET DD_ERE_ID = (SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''02'')
			WHERE RES_ID IN (
			    SELECT RES.RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS RES 
			    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = RES.ECO_ID
			    WHERE ECO.DD_EEC_ID IN (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN (''03'', ''05'', ''06'', ''08''))
			    AND RES.DD_ERE_ID <> (SELECT DD_ERE_ID FROM DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''02'')
			    AND RES.RES_FECHA_FIRMA IS NOT NULL
			    )';
				 
	        EXECUTE IMMEDIATE V_MSQL;
	        
	        DBMS_OUTPUT.PUT_LINE('[SUCCESS] Se han actualizado '||SQL%ROWCOUNT||' registros en '||V_TEXT_TABLA);

	ELSE
		DBMS_OUTPUT.PUT_LINE('[WARNING] No se encontró ningun expediente que cumpla el criterio');
	END IF;
		    
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

