--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8731
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar tipo texto
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-8731';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'DD_TTX_TIPOS_TEXTO_OFERTA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_NUM_TABLAS NUMBER(16);
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TEXT_TABLA);

	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO TEXTO ''Descuento respecto a precio publicado''');

	V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTX_DESCRIPCION = ''Descuento respecto a precio publicado'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_TTX_ID, DD_TTX_CODIGO, DD_TTX_DESCRIPCION, DD_TTX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
					SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,''07'',''Descuento respecto a precio publicado'',''Descuento respecto a precio publicado'','''||V_USU||''',SYSDATE FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO TEXTO ''Descuento respecto a precio publicado''');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL TIPO DE TEXTO ''Descuento respecto a precio publicado''');

	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO TEXTO ''Justificación del API''');

	V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTX_DESCRIPCION = ''Justificación del API'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_TTX_ID, DD_TTX_CODIGO, DD_TTX_DESCRIPCION, DD_TTX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
					SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,''08'',''Justificación del API'',''Justificación del API'','''||V_USU||''',SYSDATE FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO TEXTO ''Justificación del API''');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL TIPO DE TEXTO ''Justificación del API''');

	END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;