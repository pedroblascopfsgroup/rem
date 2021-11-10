--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210831
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14969
--## PRODUCTO=NO
--##
--## FINALIDAD: Script que inserta la plantilla de la carga masiva
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_TABLA VARCHAR2 (30):= 'POP_PLANTILLAS_OPERACION'; -- Vble. para trabajar con la tabla del esquema.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-14969'; -- Vble. que indica el usuario que realiza la operación (USUARIOCREAR)
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		  T_FUNCION('MASIVO_CONFIG_RECOMENDACION', 'plantillas/plugin/masivo/MASIVO_CONFIG_RECOMENDACION.xls', 'CFGREC')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA);
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE POP_NOMBRE = '''||V_TMP_FUNCION(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||'...no se modifica nada.');
				
			ELSE
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
                  (POP_ID, POP_NOMBRE, POP_DIRECTORIO, DD_OPM_ID, USUARIOCREAR, FECHACREAR) 
                  SELECT '||V_ESQUEMA||'.S_POP_PLANTILLAS_OPERACION.NEXTVAL,
                  '''||V_TMP_FUNCION(1)||''','''||V_TMP_FUNCION(2)||''',
                  (SELECT DD_OPM_ID FROM '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(3)||'''),
                  '''|| V_USUARIO ||''', SYSDATE FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' insertados correctamente.');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
EXIT;
