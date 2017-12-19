--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20171005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2941
--## PRODUCTO=NO
--##
--## Finalidad: Actualizamos validación F29
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
    
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'DD_MRG_MOTIVO_RECHAZO_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    

 -- ## FIN DATOS
 -- ########################################################################################

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);

	
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||
                 ' SET QUERY_ITER = ''WHERE AUX.TIPO_OPERACION IN (''''04'''',''''05'''') ''  , USUARIOMODIFICAR = ''HREOS-2941'' , FECHAMODIFICAR = SYSDATE '||
                 ' WHERE  DD_MRG_CODIGO = ''F29'' ';

	        EXECUTE IMMEDIATE V_MSQL;

	    DBMS_OUTPUT.PUT_LINE('Registros actualizados en '||V_TEXT_TABLA||' para validación F29:  '||sql%rowcount); 

		    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Se ha modificado la validación F29.');

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
