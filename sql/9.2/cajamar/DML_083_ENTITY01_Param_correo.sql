--/*
--##########################################
--## AUTOR=Rachel
--## FECHA_CREACION=20160413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-3077
--## PRODUCTO=NO
--## Finalidad: DML
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

    --Insertando valores en PEN_PARAM_ENTIDAD
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('AnotacionesEmailFrom','Recovery_Concursal@cajamar.int','Anotaciones: email FROM'),
      T_FUNCION('AnotacionesMailSmtpUser','Recovery_Concursal@cajamar.int','Anotaciones: email USER'),
      T_FUNCION('AnotacionesPwdCorreo','d+FdXekOWgxOecgdAw9DDg==24476784','Anotaciones: email PWD')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN


-- LOOP Modificando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD... Empezando a modificar datos en el diccionario');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
  			V_SQL := ' SELECT COUNT(1) FROM ' || V_ESQUEMA || '.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = '''||V_TMP_FUNCION(1)||''' AND PEN_VALOR = '''||V_TMP_FUNCION(2)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PEN_PARAM_ENTIDAD... El parámetro ya está bien configurado '''|| TRIM(V_TMP_FUNCION(2))||'''');
			ELSE		
						
				V_MSQL := 'UPDATE ' || V_ESQUEMA || '.PEN_PARAM_ENTIDAD SET PEN_VALOR='''||V_TMP_FUNCION(2)||''' WHERE PEN_PARAM = '''||V_TMP_FUNCION(1)||'''';
				
				DBMS_OUTPUT.PUT_LINE('MODIFICANDO: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD... Datos del diccionario modificados');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

