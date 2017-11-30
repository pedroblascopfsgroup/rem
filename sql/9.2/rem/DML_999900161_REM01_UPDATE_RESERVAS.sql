--/*
--##########################################
--## AUTOR=RAMON LLINARES 
--## FECHA_CREACION=20171128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3382
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el estado de la reserva a devuelta para todos los expedientes comerciales que estén en estado anulado
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

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);

	
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
                 ' set DD_EDE_ID = (SELECT EDEV.DD_EDE_ID FROM '||V_ESQUEMA||'.DD_EDE_ESTADOS_DEVOLUCION EDEV WHERE EDEV.DD_EDE_CODIGO = ''02'') where   RES_ID IN
				 (
				   SELECT RES.RES_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO 
				   INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID
				   INNER JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID
				   WHERE OFR.DD_EOF_ID=(SELECT EOF.DD_EOF_ID FROM REM01.DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = ''02'')
				   AND RES.DD_ERE_ID=(SELECT ERE.DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE WHERE ERE.DD_ERE_CODIGO = ''02'')
				 )';

	        EXECUTE IMMEDIATE V_MSQL;
	
		    
		    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Filas ACTUALIZADAS correctamente.');

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
