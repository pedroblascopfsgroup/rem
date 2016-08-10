--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160423
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en USD_USUARIOS_DESPACHOS los datos añadidos en T_ARRAY_FUNCION
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(30 CHAR) := 'GRU_GRUPOS_USUARIOS';
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM  NUMBER(16); 
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('SUPER','jpoyatos'),
    	T_TIPO_DATA('SUPER','ccompany'),
    	T_TIPO_DATA('SUPER','hvictor')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
	
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	--INSERTAMOS EL PADRE DEL GRUPO, DEL QUE COLGARÁN LOS OTROS USUARIOS
    V_SQL := '
    SELECT COUNT(*) FROM '||V_ESQUEMA_MASTER||'.'||V_TABLA||'
    WHERE USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS WHERE USU_USERNAME = ''SUPER'')
    '
    ;
    
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM != 0 THEN 
    
		DBMS_OUTPUT.PUT_LINE('[INFO] EL USUARIO ''SUPER'' YA ESTÁ DADO DE ALTA EN GRU_GRUPOS_USUARIOS.');
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] SE PROCEDE A DAR DE ALTA EL USUARIO ''SUPER'' EN GRU_GRUPOS_USUARIOS.');
		
		V_SQL := '
		INSERT INTO '||V_ESQUEMA_MASTER||'.'||V_TABLA||' (
		GRU_ID,
		USU_ID_GRUPO,
		USU_ID_USUARIO,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
		)
		SELECT
		'||V_ESQUEMA_MASTER||'.S_'||V_TABLA||'.NEXTVAL		GRU_ID,
		(SELECT USU_ID 
		FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS
		WHERE USU_USERNAME = ''SUPER'')						USU_ID_GRUPO,
		(SELECT USU_ID 
		FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS
		WHERE USU_USERNAME = ''SUPER'')						USU_ID_USUARIO,
		0,
		''DML'',
		SYSDATE,
		0
		FROM DUAL
		'
		;
		EXECUTE IMMEDIATE V_SQL;
		
		COMMIT;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] USUARIO ''SUPER'' DADO DE ALTA EN GRU_GRUPOS_USUARIOS.');
	
	END IF;
	
	--DAMOS DE ALTA LOS USUARIOS QUE CUELGAN DE SUPER
	
	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := '
        SELECT COUNT(1) 
        FROM '||V_ESQUEMA_MASTER||'.'||V_TABLA||' 
        WHERE USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
        AND USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''')
        ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO] EL USUARIO YA ESTÁ DADO DE ALTA PARA EL GRUPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO] SE PROCEDE A DAR DE ALTA EL USUARIO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' EN GRU_GRUPOS_USUARIOS. PARA EL GRUPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''.');
          
          V_SQL := '
			INSERT INTO '||V_ESQUEMA_MASTER||'.'||V_TABLA||' (
			GRU_ID,
			USU_ID_GRUPO,
			USU_ID_USUARIO,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			BORRADO
			)
			SELECT
			'||V_ESQUEMA_MASTER||'.S_'||V_TABLA||'.NEXTVAL		GRU_ID,
			(SELECT USU_ID 
			FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS
			WHERE USU_USERNAME = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')						USU_ID_GRUPO,
			(SELECT USU_ID 
			FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS
			WHERE USU_USERNAME = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''')						USU_ID_USUARIO,
			0,
			''DML'',
			SYSDATE,
			0
			FROM DUAL
			'
			;
			EXECUTE IMMEDIATE V_SQL;
          
          DBMS_OUTPUT.PUT_LINE('[INFO] USUARIO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' DADO DE ALTA EN GRU_GRUPOS_USUARIOS. PARA EL GRUPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''.');
        
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



   
