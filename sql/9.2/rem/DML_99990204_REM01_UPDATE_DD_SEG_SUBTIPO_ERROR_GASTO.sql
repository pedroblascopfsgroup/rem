--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20180119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3724
--## PRODUCTO=NO
--##
--## Finalidad: Script que ACTUALIZA en DD_SEG_SUBTIPO_ERROR_GASTO.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'DD_SEG_SUBTIPO_ERROR_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(3 CHAR) := 'SEG'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-3724'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
   
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||V_TEXT_CHARS||'1 '||
			  'SET DD_'||V_TEXT_CHARS||'_CODIGO = (SELECT REGEXP_SUBSTR(DD_'||V_TEXT_CHARS||'_DESCRIPCION, ''[^ -]+'', 1, 1) FROM '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||V_TEXT_CHARS||'2 WHERE '||V_TEXT_CHARS||'1.DD_'||V_TEXT_CHARS||'_ID = '||V_TEXT_CHARS||'2.DD_'||V_TEXT_CHARS||'_ID)'||
			  ', USUARIOMODIFICAR = '|| V_USU_MODIFICAR ||' , FECHAMODIFICAR = SYSDATE '||
			  'WHERE DD_TEG_ID = 6 AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS MODIFICADOS CORRECTAMENTE');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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