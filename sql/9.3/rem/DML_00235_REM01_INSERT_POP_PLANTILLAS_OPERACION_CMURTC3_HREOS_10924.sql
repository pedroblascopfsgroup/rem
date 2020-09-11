--/*
--##########################################
--## AUTOR= Javier Esbri
--## FECHA_CREACION=20200908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10924
--## PRODUCTO=NO
--##
--## Finalidad: Script que para crear la función o funciones especificadas en el array y las asigna a los perfiles de indicados en la misma línea.
--## INSTRUCCIONES: T_FUNCION Contiene: POP_NOMBRE, POP_DIRECTORIO (ruta) Y DD_OPM_CODIGO
--##                V_USUARIO Contiene el usuario que crea, modifica o borra.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    REGISTRO_NO_ENCONTRADO EXCEPTION;
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_TABLA_POP VARCHAR2 (30); -- Vble. para trabajar con la tabla del esquema.
    V_TABLA_OPM VARCHAR(50); --Vble. Nombre de la tabla OPM (Operación Masiva)
    V_USUARIO VARCHAR2(50 CHAR):='HREOS-10924'; -- Vble. que indica el usuario que realiza la operación (USUARIOCREAR)
    V_AUTO_ID NUMBER(16); -- Vble. que indica el siquiente valor de una secuencia.
    V_DD_OPM_ID NUMBER(16); -- Identificador del registro de la tabla de operaciones masivas.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		  T_FUNCION('CARGA_MASIVA_TABLA_CONF3', 'plantillas/plugin/masivo/CARGA_MASIVA_RELLENAR_TABLA_CONF3.xls', 'CMURTC3')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	V_TABLA_POP := 'POP_PLANTILLAS_OPERACION';
    V_TABLA_OPM := 'DD_OPM_OPERACION_MASIVA';
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_POP);
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_POP||' WHERE POP_NOMBRE = '''||V_TMP_FUNCION(1)||'''';
             
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA_POP||'...no se modifica nada.');
			ELSE
                V_SQL := 'SELECT COUNT(DD_OPM_ID) FROM '||V_ESQUEMA||'.'||V_TABLA_OPM||' WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(3)||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                
                IF V_NUM_TABLAS > 0 THEN
                    V_SQL := 'SELECT DD_OPM_ID FROM '||V_ESQUEMA||'.'||V_TABLA_OPM||' WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(3)||'''';
                    EXECUTE IMMEDIATE V_SQL INTO V_DD_OPM_ID;
                    DBMS_OUTPUT.PUT_LINE('Valor: '||V_DD_OPM_ID);
                    V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_POP
                                || ' (POP_ID, POP_NOMBRE, POP_DIRECTORIO, DD_OPM_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)'
                                || ' VALUES ('||V_ESQUEMA||'.S_POP_PLANTILLAS_OPERACION.NEXTVAL,' 
                                ||''''||V_TMP_FUNCION(1)||''','''||V_TMP_FUNCION(2)||''','||V_DD_OPM_ID
                                ||', 0, '''|| V_USUARIO ||''', SYSDATE, 0)';
                    EXECUTE IMMEDIATE V_MSQL_1;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA_POP||' insertados correctamente.');
				ELSE
                    RAISE REGISTRO_NO_ENCONTRADO;
                END IF;
		    END IF;	
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA_POP||' ACTUALIZADO CORRECTAMENTE ');
   

EXCEPTION
     WHEN REGISTRO_NO_ENCONTRADO THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] '||V_TMP_FUNCION(3)||' no localizado correctamente.');
        ROLLBACK;
        RAISE; 
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