--/*
--###########################################
--## AUTOR=Pablo Garcia Pallas
--## FECHA_CREACION=20201229
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12632
--## PRODUCTO=NO
--## 
--## Finalidad: Poblar la tabla 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-12632'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'TPD_STR_DOCSUBTBJ';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;

    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(

	T_FUNCION( '14' , '21'),
	T_FUNCION( '15' , '22'),
	T_FUNCION( '16' , '23'),
	T_FUNCION( '17' , '24'),
	T_FUNCION( '86' , '24'),
	T_FUNCION( '87' , '23'),
	T_FUNCION( '88' , '22'),
	T_FUNCION( '89' , '21'),
	T_FUNCION( '12' , '19'),
	T_FUNCION( '91' , '19'),
	T_FUNCION( '11' , '18'),
	T_FUNCION( '24' , '18'),
	T_FUNCION( '25' , '18'),
	T_FUNCION( '84' , '18'),
	T_FUNCION( '85' , '18'),
	T_FUNCION( '92' , '18'),
	T_FUNCION( '118' , '18'),
	T_FUNCION( '160' , '18'),
	T_FUNCION( '158' , '18')
    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_TMP_FUNCION := V_FUNCION(I);
	
		V_SQL := 'SELECT count(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TPD_ID = '''||V_TMP_FUNCION(1)||''' AND DD_STR_ID = '''||V_TMP_FUNCION(2)||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FILA
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||' ...no se modifica nada.');
				
		ELSE
		
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'' ||
						' (TPS_ID, DD_TPD_ID, DD_STR_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL ' ||
						', (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '''||V_TMP_FUNCION(1)||''') ' ||
						',( SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO =  '''||V_TMP_FUNCION(2)||''') ' ||
						',0, '''||V_USUARIO||''', SYSDATE, 0 FROM DUAL';
		    
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA_M||'.'||V_TABLA||' insertados correctamente.');
				
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
