--/*
--##########################################
--## AUTOR=SIMEON NIKOLAEV SHOPOV
--## FECHA_CREACION=20171114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3191
--## PRODUCTO=SI
--##
--## Finalidad: UPDATEAR GDE_PRINCIPAL_SUJETO PARA QUE NO ESTE A 0.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(8000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GDE_GASTOS_DETALLE_ECONOMICO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.  
    
BEGIN	
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE(GDE_PRINCIPAL_SUJETO = 0 OR GDE_PRINCIPAL_SUJETO IS NULL) AND GDE_PRINCIPAL_NO_SUJETO <> 0
        AND GDE_PRINCIPAL_NO_SUJETO IS NOT NULL';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS > 0 THEN
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET GDE_PRINCIPAL_SUJETO = GDE_PRINCIPAL_NO_SUJETO, USUARIOMODIFICAR = ''HREOS-3191'', FECHAMODIFICAR = SYSDATE WHERE (GDE_PRINCIPAL_SUJETO = 0 OR GDE_PRINCIPAL_SUJETO IS NULL) AND GDE_PRINCIPAL_NO_SUJETO <> 0
            AND GDE_PRINCIPAL_NO_SUJETO IS NOT NULL';
            
            EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso de actualizacion de la tabla '''||V_ESQUEMA||'''.'''||V_TEXT_TABLA||''', '||SQL%ROWCOUNT||' FILAS ACTUALIZADAS');
            
            COMMIT;
		ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ningun registro que actualizar, ninguna fila actualizada');
        END IF;
        
        
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