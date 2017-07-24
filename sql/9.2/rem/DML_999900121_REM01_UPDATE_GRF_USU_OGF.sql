--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20170724
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=Parche 2.0.6-p2
--## INCIDENCIA_LINK=HREOS-2503
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla nueva
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
    
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'DD_GRF_GESTORIA_RECEP_FICH'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    

 -- ## FIN DATOS
 -- ########################################################################################

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);

	
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
                 ' SET USERNAME_GIAADMT = ''ogf02''  , USUARIOMODIFICAR = ''HREOS-2503'' , FECHAMODIFICAR = SYSDATE '||
                 ' WHERE  DD_GRF_CODIGO = ''6'' ';

	        EXECUTE IMMEDIATE V_MSQL;
	
		    DBMS_OUTPUT.PUT_LINE('[INFO] Modificado usuario de OGF a ogf02.');		        
		    
		    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Filas GRF actualizadas correctamente.');

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
