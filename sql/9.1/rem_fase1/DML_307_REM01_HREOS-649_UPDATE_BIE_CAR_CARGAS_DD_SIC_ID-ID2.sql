--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-649
--## PRODUCTO=NO
--## Finalidad: Updatear BIE_CAR_CARGAS, DD_SIC_ID, DD_SIC_ID2.
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
    V_COUNTER NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'BIE_CAR_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
	
	--COMPROBAMOS CUANTOS REGISTROS EXISTEN QUE NO SE CORRESPONDAN CON LOS QUE DEBE HABER
	V_MSQL := '
	SELECT COUNT(1) 
	FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CAR
	INNER JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA SIC
		ON SIC.DD_SIC_ID = CAR.DD_SIC_ID
	WHERE DD_SIC_CODIGO NOT IN (''VIG'', ''NCN'', ''CAN'', ''SAN'')
	'
	;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	V_COUNTER := V_NUM;
	
	V_MSQL := '
	SELECT COUNT(1) 
	FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CAR
	INNER JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA SIC
		ON SIC.DD_SIC_ID = CAR.DD_SIC_ID2
	WHERE DD_SIC_CODIGO NOT IN (''VIG'', ''NCN'', ''CAN'', ''SAN'')
	'
	;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	V_COUNTER := V_COUNTER + V_NUM;
	
	
	IF V_NUM > 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] EXISTEN '||V_COUNTER||' CÓDIGOS DE DICCIONARIO INCORRECTOS EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_SIC_ID Y DD_SIC_ID2, SE PROCEDERA A SU ACTUALIZACIÓN.');
		
		V_MSQL := '
		UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		SET DD_SIC_ID = (SELECT DD_SIC_ID FROM '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA WHERE DD_SIC_CODIGO = ''VIG''),
		USUARIOMODIFICAR = ''HREOS-649'',
		FECHAMODIFICAR = SYSDATE
		WHERE DD_SIC_ID = 22
		'
		;
		EXECUTE IMMEDIATE V_MSQL; 
		
		V_MSQL := '
		UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		SET DD_SIC_ID = (SELECT DD_SIC_ID FROM '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA WHERE DD_SIC_CODIGO = ''CAN''),
		USUARIOMODIFICAR = ''HREOS-649'',
		FECHAMODIFICAR = SYSDATE
		WHERE DD_SIC_ID = 21
		'
		;
		EXECUTE IMMEDIATE V_MSQL; 
		
		V_MSQL := '
		UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		SET DD_SIC_ID2 = (SELECT DD_SIC_ID FROM '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA WHERE DD_SIC_CODIGO = ''VIG''),
		USUARIOMODIFICAR = ''HREOS-649'',
		FECHAMODIFICAR = SYSDATE
		WHERE DD_SIC_ID2 = 22
		'
		;
		EXECUTE IMMEDIATE V_MSQL; 
		
		V_MSQL := '
		UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
		SET DD_SIC_ID2 = (SELECT DD_SIC_ID FROM '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA WHERE DD_SIC_CODIGO = ''CAN''),
		USUARIOMODIFICAR = ''HREOS-649'',
		FECHAMODIFICAR = SYSDATE
		WHERE DD_SIC_ID2 = 21
		'
		;
		EXECUTE IMMEDIATE V_MSQL; 
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTEN CÓDIGOS DE DICCIONARIO INCORRECTOS EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_SIC_ID Y DD_SIC_ID2.');
		
	END IF;
	
	V_MSQL := '
	SELECT COUNT(1) 
	FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CAR
	INNER JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA SIC
		ON SIC.DD_SIC_ID = CAR.DD_SIC_ID
	WHERE DD_SIC_CODIGO NOT IN (''VIG'', ''NCN'', ''CAN'', ''SAN'')
	'
	;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	V_COUNTER := V_NUM;
	
	V_MSQL := '
	SELECT COUNT(1) 
	FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CAR
	INNER JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA SIC
		ON SIC.DD_SIC_ID = CAR.DD_SIC_ID2
	WHERE DD_SIC_CODIGO NOT IN (''VIG'', ''NCN'', ''CAN'', ''SAN'')
	'
	;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
	V_COUNTER := V_COUNTER + V_NUM;
	
	IF V_COUNTER > 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] NO SE HA PODIDO ACTUALIZAR '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_SIC_ID Y DD_SIC_ID2.');
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTEN CÓDIGOS DE DICCIONARIO INCORRECTOS EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_SIC_ID Y DD_SIC_ID2.');
		
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
