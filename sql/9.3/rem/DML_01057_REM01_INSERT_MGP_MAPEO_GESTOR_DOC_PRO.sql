--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20220302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17289
--## PRODUCTO=NO
--##
--## Finalidad: Se añaden datos a la tabla MGP_MAPEO_GESTOR_DOC_PRO
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
    V_TABLA_MGP VARCHAR2(25 CHAR):='MGP_MAPEO_GESTOR_DOC_PRO';
    V_TABLA_PRO VARCHAR2(25 CHAR):='ACT_PRO_PROPIETARIO';
    V_USUARIO VARCHAR2(25 CHAR):='HREOS-17289';
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	  T_FUNCION('A16948200', 'MACC Marina')

    );          
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    V_FILTRO VARCHAR2(50 CHAR);
                
BEGIN	        
	            
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	            
    -- LOOP para insertar los valores en MGP_MAPEO_GESTOR_DOC_PRO --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_MGP||'] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);

			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MGP||' WHERE BORRADO = 0 AND PRO_ID IN 
						(SELECT PRO.PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PRO||' PRO WHERE PRO.PRO_DOCIDENTIF = '''||(V_TMP_FUNCION(1))||''' AND PRO.BORRADO = 0)';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA_MGP||' se actualizan');

                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_MGP||' SET
                    CLIENTE_GD = '''||(V_TMP_FUNCION(2))||''',
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE
					WHERE PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PRO||' WHERE PRO_DOCIDENTIF = '''||(V_TMP_FUNCION(1))||''' AND BORRADO = 0)
                    AND BORRADO = 0 ';
	            EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA_MGP||' modificado correctamente. '''||(V_TMP_FUNCION(1))||''' - '''||(V_TMP_FUNCION(2))||''' ');
				
			ELSE

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_MGP||' (' ||
					'MGP_ID, PRO_ID, CLIENTE_GD, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
					' SELECT '||V_ESQUEMA||'.S_'||V_TABLA_MGP||'.NEXTVAL, PRO.PRO_ID,'''|| (V_TMP_FUNCION(2)) ||''','''||V_USUARIO||''',
                    SYSDATE,0 FROM '||V_ESQUEMA||'.'||V_TABLA_PRO||' PRO where PRO.PRO_DOCIDENTIF = '''|| (V_TMP_FUNCION(1)) ||''' AND PRO.BORRADO = 0 ';
		    	
				EXECUTE IMMEDIATE V_MSQL;
                
                V_MSQL := NULL;
                V_FILTRO := NULL;
                
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA_MGP||' insertados correctamente  '''|| (V_TMP_FUNCION(1)) ||''' - '''|| (V_TMP_FUNCION(2)) ||'''   . ');
				
		    END IF;	
        
      END LOOP;
      COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA_MGP||' ACTUALIZADA CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          DBMS_OUTPUT.put_line(V_NUM_TABLAS);
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT



  