--/*
--##########################################
--## AUTOR= Gabriel De Toni
--## FECHA_CREACION=20191210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8565
--## PRODUCTO=NO
--##
--## Finalidad: 
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
	
    V_ITEM VARCHAR2(30 CHAR) := 'HREOS-8565'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		  T_FUNCION('CARGA_MASIVA_DIRECCIONES_COMERCIALES', 'plantillas/plugin/masivo/CARGA_MASIVA_DIRECCIONES_COMERCIALES.xls', 'CMDC')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN POP_PLANTILLAS_OPERACION] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION WHERE POP_NOMBRE = '''||TRIM(V_TMP_FUNCION(1))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION...no se modifica nada.');
				
			ELSE
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION' ||
							' (POP_ID, POP_NOMBRE, POP_DIRECTORIO, DD_OPM_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT '||V_ESQUEMA||'.S_POP_PLANTILLAS_OPERACION.NEXTVAL,' ||
							' '''||TRIM(V_TMP_FUNCION(1))||''','''||TRIM(V_TMP_FUNCION(2))||''','||
							' (SELECT DD_OPM_ID FROM '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = '''||TRIM(V_TMP_FUNCION(3))||'''), '||
							' 0, '''||TRIM(V_ITEM)||''', SYSDATE, 0 FROM DUAL';
		    	
				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.POP_PLANTILLAS_OPERACION insertados correctamente.');
				
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: POP_PLANTILLAS_OPERACION ACTUALIZADO CORRECTAMENTE ');
   

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
