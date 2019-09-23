--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5159
--## PRODUCTO=NO
--##
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
    V_EXIST_USU NUMBER(16); -- Vble. para validar la existencia de una usuario.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --			DD_ECV_CODIGO		DD_ECV_DESCRIPCION_TRADUCIDA
	  T_FUNCION('01', 'Very good'),
		T_FUNCION('02', 'Good'),
		T_FUNCION('03', 'Regular'),
		T_FUNCION('04', 'Bad'),
		T_FUNCION('05', 'Very bad')

    );
    V_TMP_FUNCION T_FUNCION;

BEGIN	        

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = '''||V_TMP_FUNCION(1)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS > 0 THEN
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION SET DD_ECV_DESCRIPCION_TRADUCIDA = '''||V_TMP_FUNCION(2)||''', USUARIOMODIFICAR = ''REMVIP-5159'', FECHAMODIFICAR = SYSDATE WHERE DD_ECV_CODIGO = '''||V_TMP_FUNCION(1)||'''';
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
			
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL);
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
