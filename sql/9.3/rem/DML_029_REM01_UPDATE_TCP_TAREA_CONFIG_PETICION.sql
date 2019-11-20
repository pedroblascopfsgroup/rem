--/*
--##########################################
--## AUTOR=Juan Angel Sánchez
--## FECHA_CREACION=20190619
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6708
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza en TCP_TAREA_CONFIG_PETICION los datos añadidos en T_ARRAY_DATA.
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(30):= 'TAP_TAREA_PROCEDIMIENTO';
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	  T_FUNCION('T004_ResultadoNoTarificada'),
	  T_FUNCION('T004_ResultadoTarificada'),
	  T_FUNCION('T013_PosicionamientoYFirma')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBACIONES PREVIAS');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
            DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBACION SI EXISTE CODIGO');
            V_MSQL_1:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = '''||V_TMP_FUNCION(1)||'''';
			EXECUTE IMMEDIATE V_MSQL_1 INTO V_ID;
			-- Si existe el TAP_CODIGO 	
			IF V_ID = 1 THEN  
				DBMS_OUTPUT.PUT_LINE('[INFO]: COMPROBACION SI EXISTE EN LA TABLA');
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TCP_TAREA_CONFIG_PETICION WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = '''||V_TMP_FUNCION(1)||''')';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la tarea
				IF V_NUM_TABLAS > 1 THEN	  
					DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.TCP_TAREA_CONFIG_PETICION...no se modifica nada.');
				
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: REALIZAMOS EL UPDATE');
					V_MSQL_1 := 'UPDATE '||V_ESQUEMA||'.TCP_TAREA_CONFIG_PETICION SET USUARIOMODIFICAR = ''HREOS-6708'', FECHAMODIFICAR = SYSDATE, TCP_PERMITIDA = 1 WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = '''||V_TMP_FUNCION(1)||''')';
		    	
					EXECUTE IMMEDIATE V_MSQL_1;
					DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.TCP_TAREA_CONFIG_PETICION actualizados correctamente.');
				
		   	 	END IF;
		   	END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TCP_TAREA_CONFIG_PETICION ACTUALIZADO CORRECTAMENTE ');
   

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
