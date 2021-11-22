--/*
--######################################### 
--## AUTOR=Daniel Gallego
--## FECHA_CREACION=20210818
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14912
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PRO_PROPIETARIO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14912';


    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
             --DD_CRA_CODIGO    --PRO_NOMBRE
            T_TIPO_DATA('17','BFA')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
  
    	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_EAC_ESTADO_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN ACT_PRO_PROPIETARIO ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        -- Comprobamos si existe la tabla   
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN 
        
          --Comprobamos el dato a insertar
          V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE PRO_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          --Si existe modificamos los valores
          IF V_NUM_TABLAS > 0 THEN
	    DBMS_OUTPUT.PUT_LINE('SE ACTUALIZA la cartera: ' || TRIM(V_TMP_TIPO_DATA(1)));
            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET
             DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
             ,USUARIOMODIFICAR = '''||V_USUARIO||''' 
            ,FECHAMODIFICAR = SYSDATE
            WHERE PRO_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
            EXECUTE IMMEDIATE V_MSQL;            
          END IF;       
        END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_PRO_PROPIETARIO MODIFICADA CORRECTAMENTE ');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
