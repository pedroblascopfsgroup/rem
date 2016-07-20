--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-649
--## PRODUCTO=NO
--## Finalidad: Eliminar registros de DD_SIC_SITUACION_CARGA.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM NUMBER(16); 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SIC_SITUACION_CARGA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
	
	--COMPROBAMOS CUANTOS REGISTROS EXISTEN QUE NO SE CORRESPONDAN CON LOS QUE DEBE HABER
	V_MSQL := '
	SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_SIC_CODIGO NOT IN (''VIG'', ''NCN'', ''CAN'', ''SAN'')
	'
	;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM > 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] EXISTEN '||V_NUM||' CÓDIGOS DE DICCIONARIO INCORRECTOS EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'. SE PROCEDERA A SU ELIMINACIÓN.');
		
		V_MSQL := '
		DELETE FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_SIC_CODIGO IN (
			SELECT DD_SIC_CODIGO FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_SIC_CODIGO NOT IN (''VIG'', ''NCN'', ''CAN'', ''SAN'')
		)
		'
		;
		EXECUTE IMMEDIATE V_MSQL; 
		
	END IF;
	
	--COMPROBAMOS CUANTOS REGISTROS EXISTEN QUE NO SE CORRESPONDAN CON LOS QUE DEBE HABER
	V_MSQL := '
	SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_SIC_CODIGO NOT IN (''VIG'', ''NCN'', ''CAN'', ''SAN'')
	'
	;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	IF V_NUM = 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS INCORRECTOS ELIMINADOS EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.');
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] NO SE HAN PODIDO ELIMINAR REGISTROS INCORRECTOS EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||' Ó ESTOS NO EXISTEN.');
		
	END IF;
	
	COMMIT;
	
EXCEPTION

     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
