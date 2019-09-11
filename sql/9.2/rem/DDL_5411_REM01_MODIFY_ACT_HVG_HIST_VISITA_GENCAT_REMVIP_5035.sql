--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar los copropietarios de los activos.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NULLABLE NUMBER(16); -- Vble. para validar si es nulable o no
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INFO]  Se modifica ACT_HVG_HIST_VISITA_GENCAT para que VIS_ID pueda ser nulo');
	
	-- Es nullable ya ?

    	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''ACT_HVG_HIST_VISITA_GENCAT'' AND COLUMN_NAME = ''VIS_ID'' AND NULLABLE = ''N'' ';

    	EXECUTE IMMEDIATE V_SQL INTO V_NULLABLE;

    	-- Si no es nulable se realiza la modificación
    	IF V_NULLABLE = '1' THEN 

		V_MSQL := ' ALTER TABLE ' ||V_ESQUEMA||'.ACT_HVG_HIST_VISITA_GENCAT
			    MODIFY VIS_ID NULL
	   	  ';
		EXECUTE IMMEDIATE V_MSQL;
	
		DBMS_OUTPUT.PUT_LINE('[FIN] Modificación realizada ');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[FIN] No se ha actualizado la tabla. El campo era nulable ');

	END IF;

	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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
