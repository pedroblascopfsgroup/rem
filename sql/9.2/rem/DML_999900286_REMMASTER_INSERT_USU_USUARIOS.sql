--/*
--##########################################
--## AUTOR=ISIDRO SOTOCA
--## FECHA_CREACION=20180618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4207
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en USU_USUARIOS los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'USU_USUARIOS';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID2 NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	         --  USERNAME   PASS   NOMBRE                                GRUPO
      	T_TIPO_DATA('gestalq',	'1234','Gestor de Alquileres', 					1),
	    T_TIPO_DATA('supalq',	'1234','Supervisor de Alquileres',              1),
    	T_TIPO_DATA('gestedi',	'1234','Gestor de Edificaciones',               1),
    	T_TIPO_DATA('supedi',	'1234','Supervisor de Edificaciones', 			1),
	    T_TIPO_DATA('gestsue',	'1234','Gestor de Suelos',                 		1),
    	T_TIPO_DATA('supsue',	'1234','Supervisor de Suelos',                 	1)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Insertar usuario en la tabla:'||V_ESQUEMA_M||'.'||V_TEXT_TABLA||'.');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN				         
  		    
          DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el usuario '||TRIM(V_TMP_TIPO_DATA(1))||' en la tabla.');

        ELSE
          	
          V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
           
          V_MSQL := '
            INSERT INTO '|| V_ESQUEMA_M ||'.'||V_TEXT_TABLA||' (
              USU_ID,
              ENTIDAD_ID,
              USU_USERNAME,
              USU_PASSWORD,
              USU_NOMBRE,
              USU_GRUPO,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO) 
            SELECT 
              '|| V_ID || ',
              1,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              0,
              ''HREOS-4207'',
              SYSDATE,
              0
            FROM DUAL'
          ;
                      
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Registro INSERTADO para el USU_USERNAME: '||TRIM(V_TMP_TIPO_DATA(1))||'.');
        
        END IF;

      END LOOP;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' actualizada correctamente.');
   

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



   
