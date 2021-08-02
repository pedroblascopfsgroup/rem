--/*
--##########################################
--## AUTOR= Carlos Santos Vílchez
--## FECHA_CREACION=20210610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-9923
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ZON_PEF_USU los datos añadidos en T_ARRAY_FUNCION.
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
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de un registro.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9923';

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --			USU_USERNAME			CODIGO PERFIL
      T_FUNCION( 'jsanchezv', 	'HAYASUPCOM'  ),
      T_FUNCION( 'jsanchezv', 	'HAYAGESTPORTMAN'  )
    );
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%'; 
    V_MSQL_1 VARCHAR2(4000 CHAR);

BEGIN	        

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN ZON_PEF_USU] ');
  
  FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
  LOOP
    V_TMP_FUNCION := V_FUNCION(I);
  
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
    
    IF V_NUM_REGISTRO < 1 THEN
      
      DBMS_OUTPUT.PUT_LINE('[INFO] No existe usuario en en la tabla '||V_ESQUEMA_M||'..USU_USUARIOS ...no se modifica nada.');
    
    ELSE
    
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||V_TMP_FUNCION(2)||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTRO;
      
      IF V_NUM_REGISTRO < 1 THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] No existe perfil en en la tabla '||V_ESQUEMA||'..PEF_PERFILES ...no se modifica nada.');
      
      ELSE
    
        V_TMP_FUNCION := V_FUNCION(I);
            
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID = 
              (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||''') 
                AND USU_ID = 
                  (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(1))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN	  
          
          DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ZON_PEF_USU...no se modifica nada.');
  
        ELSE
          
          V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU' ||
                ' (ZPU_ID, ZON_ID, PEF_ID, USU_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
                ' SELECT '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL,' ||
                ' (SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION WHERE ZON_DESCRIPCION = ''REM''),' ||
                ' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||'''),' ||
                ' (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_FUNCION(1))||'''),' ||
                ' '''|| V_USUARIO ||''' ,SYSDATE,0 FROM DUAL';
            
          EXECUTE IMMEDIATE V_MSQL_1;
          DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.ZON_PEF_USU insertados correctamente.');
          
        END IF;	

      END IF;

    END IF;

  END LOOP;

  COMMIT;

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