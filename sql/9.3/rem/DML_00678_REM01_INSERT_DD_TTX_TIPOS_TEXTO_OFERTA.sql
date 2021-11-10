--/*
--######################################### 
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20211026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16049
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
	V_USU VARCHAR2(30 CHAR) := 'HREOS-16049';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'DD_TTX_TIPOS_TEXTO_OFERTA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_NUM_TABLAS NUMBER(16);
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TEXT_TABLA);

	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION: TIPO TEXTO ''Importe inicial''');

	V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTX_DESCRIPCION = ''Importe inicial'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN

		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_TTX_ID, DD_TTX_CODIGO, DD_TTX_DESCRIPCION, DD_TTX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
					SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,''10'',''Importe inicial'',''Importe inicial'','''||V_USU||''',SYSDATE FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO: TIPO TEXTO ''Importe inicial''');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL TIPO DE TEXTO ''Importe inicial''');

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