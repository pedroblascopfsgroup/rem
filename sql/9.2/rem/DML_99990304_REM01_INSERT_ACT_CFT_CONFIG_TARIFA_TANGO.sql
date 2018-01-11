--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20180111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3648
--## PRODUCTO=NO
--##
--## Finalidad: Script que duplica las cuentas contables y las partidas presupuestarias para el ejercicio 2018
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
	
    V_TEXT_TABLA VARCHAR2(100 CHAR):= 'ACT_CFT_CONFIG_TARIFA';
    V_USUARIO VARCHAR2(100 CHAR):= 'HREOS-3648';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''02'') AND BORRADO  = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS < 1 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, (SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''10'') DD_CRA_ID, 0 CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, 0 VERSION, '''||V_USUARIO||''' USUARIOCREAR, SYSDATE FECHACREAR, 0 BORRADO
					FROM (SELECT * FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''02'') AND BORRADO  = 0);';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;

	COMMIT;
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



   