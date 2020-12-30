--/*
--######################################### 
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200910
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8052
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_TABLA VARCHAR2(30 CHAR) := 'CPS_CONFIG_SUBPTDAS_PRE';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8052';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    				-- CPS_PARTIDA_PRESUPUESTARIA, 	CPS_DESCRIPCION, CPS_CUENTA_CONTABLE		
	T_TIPO_DATA('PP072', 'FEES VENTAS', '6230100020')
	
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;  
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en CPS_CONFIG_SUBPTDAS_PRE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPS_CONFIG_SUBPTDAS_PRE] ');
        
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CPS_PARTIDA_PRESUPUESTARIA = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND CPS_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
       --Si no existe, lo insertamos
        IF V_NUM_TABLAS = 0 THEN            
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
						CPS_PARTIDA_PRESUPUESTARIA, CPS_DESCRIPCION, CPS_CUENTA_CONTABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
						VALUES ('''||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, '''||V_USUARIO||''', SYSDATE, 0)';
						
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CPS_PARTIDA_PRESUPUESTARIA = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' CPS_CUENTA_CONTABLE = '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' INSERTADO CORRECTAMENTE');
          
        
        ELSE 
          V_MSQL := 'UPDATE  '|| V_ESQUEMA ||'.'|| V_TABLA ||' 
			SET
				CPS_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
				USUARIOMODIFICAR = '''|| V_USUARIO ||''', 
				FECHAMODIFICAR = SYSDATE,
				BORRADO = 0  			
			WHERE CPS_PARTIDA_PRESUPUESTARIA = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' AND CPS_CUENTA_CONTABLE = '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'''';
			
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CPS_PARTIDA_PRESUPUESTARIA = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' CPS_CUENTA_CONTABLE = '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' ACTUALIZADO CORRECTAMENTE');
          
       END IF;
      END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado correctamente');
    
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/
EXIT
