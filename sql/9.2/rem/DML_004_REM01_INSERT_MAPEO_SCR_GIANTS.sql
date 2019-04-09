--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190328
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.7
--## INCIDENCIA_LINK=HREOS-5955
--## PRODUCTO=NO
--##
--## Finalidad: 
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      --DD_SCR_CODIGO	 ID_CARTERA_HAYA
  	  T_FUNCION('33',	'16'),
      T_FUNCION('34', '17'),
      T_FUNCION('35', '18'),
  	  T_FUNCION('36', '19')    
      );
    V_TMP_FUNCION T_FUNCION;
    V_MSQL_1 VARCHAR2(4000 CHAR);

BEGIN	        

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN MAPEO_SCR_GIANTS] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MAPEO_SCR_GIANTS WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_FUNCION(1))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el código de subcartera '||TRIM(V_TMP_FUNCION(1))||' en la tabla '||V_ESQUEMA||'.MAPEO_SCR_GIANTS...no se modifica nada.');

			ELSE
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.MAPEO_SCR_GIANTS (DD_SCR_CODIGO, ID_CARTERA_HAYA) 
        VALUES ('''||TRIM(V_TMP_FUNCION(1))||''','''||TRIM(V_TMP_FUNCION(2))||''')';
				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.MAPEO_SCR_GIANTS insertados correctamente.');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: MAPEO_SCR_GIANTS ACTUALIZADO CORRECTAMENTE ');


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
